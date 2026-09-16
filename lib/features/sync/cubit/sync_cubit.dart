import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/notifications/sync_notifier.dart';
import '../../../core/utils/async_mutex.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../repository/outbox_repository.dart';
import 'sync_state.dart';

/// Replays the outbox. The ONLY place that sends a queued action.
///
/// Guarantees, in the order they matter:
/// 1. one replay at a time ([drain] joins an in-flight pass);
/// 2. strict FIFO, one item at a time;
/// 3. an item is claimed (`sending`) before the network call, and recovered to
///    `queued` on the next start if the app died mid-flight;
/// 4. a transport failure NEVER fails the item — it is retried with the same
///    idempotency key, which the server deduplicates;
/// 5. a business rejection is terminal, releases the hold and tells the user.
class SyncCubit extends Cubit<SyncState> {
  SyncCubit({
    required this.outbox,
    required this.connectivity,
    required this.notifier,
    DateTime Function()? clock,
    Duration Function(int attempts)? backoff,
  }) : _clock = clock ?? DateTime.now,
       _backoff = backoff ?? defaultBackoff,
       super(const SyncState());

  final IOutboxRepository outbox;
  final ConnectivityCubit connectivity;
  final SyncNotifier notifier;
  final DateTime Function() _clock;
  final Duration Function(int attempts) _backoff;

  /// Held for a whole pass. A wallet refresh takes it too, so a balance read
  /// can never interleave with a send that is settling.
  final AsyncMutex lock = AsyncMutex();

  bool appInForeground = true;

  Future<void>? _inFlight;
  bool _rerun = false;
  Timer? _retryTimer;
  StreamSubscription<List<OutboxItem>>? _activeSub;
  StreamSubscription<ConnectivityStatus>? _connSub;

  /// 2s, 4s, 8s … capped at 60s.
  static Duration defaultBackoff(int attempts) =>
      Duration(seconds: min(AppConstants.maxBackoffSeconds, 1 << attempts.clamp(1, 6)));

  Future<void> start() async {
    if (_activeSub != null) return;
    // Anything the last run left in flight goes back in the queue, same key.
    await outbox.recoverInterrupted();
    _activeSub = outbox.watchActive().listen(_onActive);
    _connSub = connectivity.stream.listen((status) async {
      if (status != ConnectivityStatus.online) return;
      // Back online: don't sit out a backoff that was scheduled while offline.
      await outbox.clearBackoff();
      unawaited(drain());
    });
    if (connectivity.isOnline) unawaited(drain());
  }

  Future<void> reset() async {
    await _stop();
    _safeEmit(const SyncState());
  }

  /// Stops new passes, then waits for the one already running, so no item is
  /// settled into a database that is about to be wiped or closed.
  Future<void> _stop() async {
    _retryTimer?.cancel();
    await _connSub?.cancel();
    await _activeSub?.cancel();
    _connSub = null;
    _activeSub = null;
    await _inFlight;
  }

  /// App resumed/paused. Resuming is a replay trigger.
  void setForeground(bool value) {
    appInForeground = value;
    if (value && connectivity.isOnline) unawaited(drain());
  }

  /// Runs a replay pass, or joins the one already running.
  Future<void> drain() {
    final running = _inFlight;
    if (running != null) {
      _rerun = true; // something new arrived; do one more pass afterwards
      return running;
    }
    final completer = Completer<void>();
    _inFlight = completer.future;
    unawaited(() async {
      try {
        do {
          _rerun = false;
          await lock.synchronized(_pass);
        } while (_rerun && connectivity.isOnline);
      } catch (_) {
        // A pass must never take the app down; failures are recorded per item.
      } finally {
        _inFlight = null;
        completer.complete();
      }
    }());
    return completer.future;
  }

  Future<void> _pass() async {
    if (!connectivity.isOnline) return;
    _safeEmit(state.copyWith(isSyncing: true));
    try {
      while (connectivity.isOnline) {
        final item = await outbox.claimNext(_clock());
        if (item == null) break;

        final result = await outbox.dispatch(item);
        final keepGoing = await result.fold((failure) => _handleFailure(item, failure), (success) async {
          await outbox.markSucceeded(item.id, success, _clock());
          final settled = (await outbox.byId(item.id)) ?? item;
          await _notify(settled, succeeded: true);
          _safeEmit(state.copyWith(settledCount: state.settledCount + 1));
          return true;
        });
        if (!keepGoing) break;
      }
    } finally {
      _safeEmit(state.copyWith(isSyncing: false, lastSyncedAt: _clock()));
      await _scheduleRetry();
    }
  }

  /// Returns whether the pass should continue with the next item.
  Future<bool> _handleFailure(OutboxItem item, Failure failure) async {
    // An expired session is not the item's fault: keep it queued.
    final retryable =
        failure is NetworkFailure ||
        failure is StorageFailure ||
        (failure is BusinessFailure && failure.code == BusinessCode.unauthorized);

    if (!retryable && failure is BusinessFailure) {
      await outbox.markFailed(item.id, failure, _clock());
      final settled = (await outbox.byId(item.id)) ?? item;
      await _notify(settled, succeeded: false);
      _safeEmit(state.copyWith(settledCount: state.settledCount + 1));
      return true; // a rejection blocks nobody else
    }

    // Unknown outcome. Same key, later.
    final wentOffline = !connectivity.isOnline;
    await outbox.markRetry(
      item.id,
      message: failure.message,
      nextAttemptAt: wentOffline ? null : _clock().add(_backoff(item.attempts)),
      countAttempt: !wentOffline,
    );
    return false; // FIFO: don't let the next item overtake the head
  }

  /// Every settled item is a major event (a send, a goal, a save), so the user
  /// always gets a notification — including a receipt for one they watched go
  /// through. A notifier error never interrupts the pass.
  Future<void> _notify(OutboxItem item, {required bool succeeded}) async {
    try {
      if (succeeded) {
        await notifier.syncSucceeded(item);
      } else {
        await notifier.syncFailed(item);
      }
    } catch (_) {}
  }

  Future<void> _scheduleRetry() async {
    _retryTimer?.cancel();
    if (!connectivity.isOnline) return;
    final at = await outbox.headRetryAt();
    if (at == null) return;
    final delay = at.difference(_clock());
    _retryTimer = Timer(delay.isNegative ? Duration.zero : delay, () => unawaited(drain()));
  }

  void _onActive(List<OutboxItem> items) {
    _safeEmit(
      state.copyWith(
        pendingCount: items.length,
        pendingDebitKobo: items.fold<int>(0, (sum, i) => sum + i.debitKobo),
        troubleCount: items.where((i) => i.attempts >= AppConstants.troubleAttemptThreshold).length,
      ),
    );
  }

  void _safeEmit(SyncState next) {
    if (!isClosed) emit(next);
  }

  @override
  Future<void> close() async {
    await _stop();
    return super.close();
  }
}
