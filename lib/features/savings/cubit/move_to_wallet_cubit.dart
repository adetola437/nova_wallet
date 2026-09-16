import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/models/goal_view.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/money/fees.dart';
import '../../../core/money/kobo_parser.dart';
import '../../auth/repository/auth_repository.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../sync/cubit/outcome_watcher.dart';
import '../../sync/cubit/sync_cubit.dart';
import '../../sync/repository/outbox_repository.dart';
import 'move_to_wallet_state.dart';

/// One "Move to wallet" attempt (factory, one per sheet).
///
/// The user decides when a goal is done: contributions stay open past the
/// target, and savings can come back to the wallet at any time. The move is
/// queued like everything else, so it works offline and settles exactly once.
class MoveToWalletCubit extends Cubit<MoveToWalletState> with OutboxOutcomeWatcher {
  MoveToWalletCubit({
    required this.goal,
    required this.outbox,
    required this.auth,
    required this.sync,
    required this.connectivity,
    this.outcomeWait = AppConstants.sendOutcomeWait,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now,
       super(const MoveToWalletState());

  final GoalView goal;
  final IOutboxRepository outbox;
  final IAuthRepository auth;
  final SyncCubit sync;
  final ConnectivityCubit connectivity;
  final Duration outcomeWait;
  final DateTime Function() _clock;

  /// Free once the target amount or the target date is reached.
  bool get isMatured => Fees.goalIsMatured(
    savedKobo: goal.savedKobo,
    targetKobo: goal.targetKobo,
    targetDate: goal.targetDate,
    now: _clock(),
  );

  StreamSubscription<OutboxItem?>? _itemSub;

  void amountChanged(String value) {
    KoboParser.parse(value).fold(
      (error) => emit(
        state.copyWith(
          amountText: value,
          clearAmount: true,
          validation: error == KoboParseError.empty
              ? null
              : const ValidationFailure(ValidationCode.invalidInput, 'Enter a valid amount.'),
          clearValidation: error == KoboParseError.empty,
        ),
      ),
      (kobo) {
        Failure? error;
        if (kobo <= 0) {
          error = const ValidationFailure(ValidationCode.amountTooSmall, 'Enter an amount above zero.');
        } else if (kobo > goal.movableKobo) {
          // Confirmed savings only: contributions still queued aren't there yet.
          error = const ValidationFailure(ValidationCode.insufficientAvailable, 'This goal does not hold that much.');
        }
        final fee = Fees.goalBreakFeeKobo(
          amountKobo: kobo,
          savedKobo: goal.savedKobo,
          targetKobo: goal.targetKobo,
          targetDate: goal.targetDate,
          now: _clock(),
        );
        emit(
          state.copyWith(
            amountText: value,
            amountKobo: kobo,
            feeKobo: fee,
            validation: error,
            clearValidation: error == null,
          ),
        );
      },
    );
  }

  /// "Move all" — the whole confirmed amount.
  void moveAll() => amountChanged(KoboParser.toInputText(goal.movableKobo));

  Future<void> submit(String pin) async {
    if (!state.canSubmit || state.stage == MoveStage.submitting) return;

    if (!await auth.verifyPin(pin)) {
      emit(state.copyWith(pinError: true));
      return;
    }
    emit(state.copyWith(stage: MoveStage.submitting, pinError: false));

    final result = await outbox.enqueueMoveToWallet(
      draft: MoveToWalletDraft(
        goalClientId: goal.clientId,
        goalName: goal.name,
        amountKobo: state.amountKobo!,
        breakFeeKobo: state.feeKobo,
      ),
      online: connectivity.isOnline,
    );
    if (isClosed) return;

    await result.fold((failure) async => emit(state.copyWith(stage: MoveStage.editing, validation: failure)), (
      item,
    ) async {
      emit(state.copyWith(item: item));
      unawaited(sync.drain());
      if (!connectivity.isOnline) {
        _finish(item, MoveOutcome.pending);
        return;
      }
      final settled = await awaitOutcome(outbox: outbox, id: item.id, timeout: outcomeWait);
      if (isClosed) return;
      _finish(settled, _outcomeFor(settled));
    });
  }

  MoveOutcome _outcomeFor(OutboxItem item) => switch (item.status) {
    OutboxStatus.succeeded => MoveOutcome.moved,
    OutboxStatus.failed => MoveOutcome.failed,
    _ => connectivity.isOnline ? MoveOutcome.processing : MoveOutcome.pending,
  };

  void _finish(OutboxItem item, MoveOutcome outcome) {
    emit(state.copyWith(stage: MoveStage.done, item: item, outcome: outcome));
    _itemSub?.cancel();
    _itemSub = outbox.watchItem(item.id).listen((latest) {
      if (latest == null || isClosed) return;
      emit(state.copyWith(item: latest, outcome: _outcomeFor(latest)));
    }, onError: (Object _) {});
  }

  @override
  Future<void> close() async {
    await _itemSub?.cancel();
    return super.close();
  }
}
