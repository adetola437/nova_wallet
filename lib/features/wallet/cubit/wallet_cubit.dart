import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/models/activity_item.dart';
import '../../../core/models/wallet_overview.dart';
import '../../../core/notifications/sync_notifier.dart';
import '../../sync/cubit/sync_cubit.dart';
import '../../sync/cubit/sync_state.dart';
import '../repository/wallet_repository.dart';
import 'wallet_state.dart';

/// Home screen state. Session-scoped: [start] on sign-in, [reset] on sign-out.
class WalletCubit extends Cubit<WalletState> {
  WalletCubit({required this.repository, required this.sync, this.notifier}) : super(const WalletState());

  final IWalletRepository repository;
  final SyncCubit sync;

  /// Told about money that arrived since the last refresh.
  final SyncNotifier? notifier;

  StreamSubscription<WalletOverview>? _overviewSub;
  StreamSubscription<List<ActivityItem>>? _activitySub;
  StreamSubscription<SyncState>? _syncSub;
  int _lastSettledCount = 0;

  /// The refresh currently in flight, if any. [reset] and [close] wait for it,
  /// so a response that lands after sign-out can never write the previous
  /// user's balance back into a freshly wiped database.
  Future<void>? _refreshing;

  int get availableKobo => state.overview.availableKobo;

  Future<void> start() async {
    if (_overviewSub != null) return;
    emit(state.copyWith(status: WalletStatus.loading));
    _overviewSub = repository.watchOverview().listen((overview) {
      if (!isClosed) emit(state.copyWith(overview: overview, status: WalletStatus.ready));
    });
    _subscribeActivity();
    // Every settled item changes the server-side truth; re-read it quietly.
    _lastSettledCount = sync.state.settledCount;
    _syncSub = sync.stream.listen((syncState) {
      if (syncState.settledCount == _lastSettledCount) return;
      _lastSettledCount = syncState.settledCount;
      unawaited(_quietRefresh());
    });
    await refresh();
  }

  void _subscribeActivity() {
    _activitySub?.cancel();
    _activitySub = repository.watchActivity(limit: state.limit).listen((activity) {
      if (!isClosed) emit(state.copyWith(activity: activity));
    });
  }

  /// Pull-to-refresh: send what's queued first, then read the balance.
  Future<void> refresh() async {
    if (isClosed) return;
    emit(state.copyWith(isRefreshing: true, clearFailure: true));
    await sync.drain();
    await _quietRefresh();
    if (!isClosed) emit(state.copyWith(isRefreshing: false));
  }

  Future<void> _quietRefresh() {
    // Coalesce: one refresh at a time is enough, and it is what reset/close await.
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  Future<void> _doRefresh() async {
    if (_overviewSub == null) return; // reset or closed before we started
    // Under the sync lock: a balance fetched mid-send must never overwrite the
    // balance that send is about to apply.
    final result = await sync.lock.synchronized(repository.refresh);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          lastRefreshFailure: failure,
          status: state.status == WalletStatus.loading ? WalletStatus.ready : state.status,
        ),
      ),
      (newCredits) {
        emit(state.copyWith(status: WalletStatus.ready, clearFailure: true));
        for (final credit in newCredits) {
          unawaited(notifier?.paymentReceived(credit).catchError((Object _) {}));
        }
      },
    );
  }

  /// Stops new work, then waits for work already running.
  Future<void> _stop() async {
    await _syncSub?.cancel();
    await _overviewSub?.cancel();
    await _activitySub?.cancel();
    _syncSub = null;
    _overviewSub = null;
    _activitySub = null;
    try {
      await _refreshing;
    } catch (_) {
      // A refresh that failed on the way out has nothing left to report to.
    }
  }

  /// Re-reads the balance without draining the outbox or showing a spinner —
  /// on app resume, and after the developer panel credits the account.
  Future<void> checkForUpdates() => _quietRefresh();

  Future<void> loadMore() async {
    emit(state.copyWith(limit: state.limit + AppConstants.pageSize));
    _subscribeActivity();
  }

  Future<void> reset() async {
    await _stop();
    if (!isClosed) emit(const WalletState());
  }

  @override
  Future<void> close() async {
    await _stop();
    return super.close();
  }
}
