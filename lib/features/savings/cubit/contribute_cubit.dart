import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/models/goal_view.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/money/kobo_parser.dart';
import '../../auth/repository/auth_repository.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../sync/cubit/outcome_watcher.dart';
import '../../sync/cubit/sync_cubit.dart';
import '../../sync/repository/outbox_repository.dart';
import '../../wallet/cubit/wallet_cubit.dart';
import 'contribute_state.dart';

/// One contribution attempt (registered as a factory).
class ContributeCubit extends Cubit<ContributeState> with OutboxOutcomeWatcher {
  ContributeCubit({
    required this.goal,
    required this.outbox,
    required this.auth,
    required this.wallet,
    required this.sync,
    required this.connectivity,
    this.outcomeWait = AppConstants.sendOutcomeWait,
  }) : super(const ContributeState());

  final GoalView goal;
  final IOutboxRepository outbox;
  final IAuthRepository auth;
  final WalletCubit wallet;
  final SyncCubit sync;
  final ConnectivityCubit connectivity;
  final Duration outcomeWait;

  StreamSubscription<OutboxItem?>? _itemSub;

  void amountChanged(String value) {
    final parsed = KoboParser.parse(value);
    parsed.fold(
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
        if (kobo < AppConstants.minContributionKobo) {
          error = const ValidationFailure(ValidationCode.amountTooSmall, 'The smallest contribution is ₦100.00.');
        } else if (kobo > wallet.availableKobo) {
          // Available, not ledger: money already held for queued items is spoken for.
          error = const ValidationFailure(
            ValidationCode.insufficientAvailable,
            'This is more than your available balance.',
          );
        }
        emit(state.copyWith(amountText: value, amountKobo: kobo, validation: error, clearValidation: error == null));
      },
    );
  }

  Future<void> submit(String pin) async {
    if (!state.canSubmit || state.stage == ContributeStage.submitting) return;

    if (!await auth.verifyPin(pin)) {
      emit(state.copyWith(pinError: true));
      return;
    }
    emit(state.copyWith(stage: ContributeStage.submitting, pinError: false));

    final result = await outbox.enqueueContribute(
      draft: ContributeDraft(goalClientId: goal.clientId, goalName: goal.name, amountKobo: state.amountKobo!),
      online: connectivity.isOnline,
    );
    if (isClosed) return;

    await result.fold((failure) async => emit(state.copyWith(stage: ContributeStage.editing, validation: failure)), (
      item,
    ) async {
      emit(state.copyWith(item: item));
      unawaited(sync.drain());
      if (!connectivity.isOnline) {
        // Queued: the sync engine will send it when the network returns.
        _finish(item, ContributeOutcome.pending);
        return;
      }
      final settled = await awaitOutcome(outbox: outbox, id: item.id, timeout: outcomeWait);
      if (isClosed) return;
      _finish(settled, _outcomeFor(settled));
    });
  }

  ContributeOutcome _outcomeFor(OutboxItem item) => switch (item.status) {
    OutboxStatus.succeeded => ContributeOutcome.saved,
    OutboxStatus.failed => ContributeOutcome.failed,
    _ => connectivity.isOnline ? ContributeOutcome.processing : ContributeOutcome.pending,
  };

  void _finish(OutboxItem item, ContributeOutcome outcome) {
    emit(state.copyWith(stage: ContributeStage.done, item: item, outcome: outcome));
    // Keep the result screen honest if the item settles while it is open.
    _itemSub?.cancel();
    _itemSub = outbox.watchItem(item.id).listen((latest) {
      if (latest == null || isClosed) return;
      emit(state.copyWith(item: latest, outcome: _outcomeFor(latest)));
    });
  }

  @override
  Future<void> close() async {
    await _itemSub?.cancel();
    return super.close();
  }
}
