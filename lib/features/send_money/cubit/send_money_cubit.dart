import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/auth/biometric_gate.dart';
import '../../../core/auth/biometric_signer.dart';
import '../../../core/models/beneficiary.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/money/fees.dart';
import '../../../core/money/kobo_parser.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/repository/auth_repository.dart';
import '../../beneficiaries/repository/beneficiary_repository.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../settings/repository/settings_repository.dart';
import '../../sync/cubit/outcome_watcher.dart';
import '../../sync/cubit/sync_cubit.dart';
import '../../sync/repository/outbox_repository.dart';
import '../../wallet/cubit/wallet_cubit.dart';
import 'send_money_state.dart';

/// One send attempt (registered as a factory, so two flows never share state).
///
/// The cubit never talks to the network. It validates, authorises, and puts the
/// intent in the outbox; [SyncCubit] owns everything after that.
class SendMoneyCubit extends Cubit<SendMoneyState> with OutboxOutcomeWatcher {
  SendMoneyCubit({
    required this.outbox,
    required this.auth,
    required this.settings,
    required this.beneficiaries,
    required this.session,
    required this.wallet,
    required this.sync,
    required this.connectivity,
    required this.biometricGate,
    this.outcomeWait = AppConstants.sendOutcomeWait,
  }) : super(const SendMoneyState());

  final IOutboxRepository outbox;
  final IAuthRepository auth;
  final ISettingsRepository settings;
  final IBeneficiaryRepository beneficiaries;
  final AuthCubit session;
  final WalletCubit wallet;
  final SyncCubit sync;
  final ConnectivityCubit connectivity;
  final BiometricGate biometricGate;
  final Duration outcomeWait;

  StreamSubscription<OutboxItem?>? _itemSub;

  int get _capKobo => session.profile?.singleSendCapKobo ?? AppConstants.tier1SingleSendCapKobo;

  void selectRecipient(Beneficiary beneficiary) =>
      emit(state.copyWith(recipient: beneficiary, stage: SendStage.amount));

  void narrationChanged(String value) =>
      emit(state.copyWith(narration: value.length > 50 ? value.substring(0, 50) : value));

  void amountChanged(String value) {
    final parsed = KoboParser.parse(value);
    parsed.fold(
      (error) => emit(
        state.copyWith(
          amountText: value,
          clearAmount: true,
          feeKobo: 0,
          amountError: error == KoboParseError.empty
              ? null
              : const ValidationFailure(ValidationCode.invalidInput, 'Enter a valid amount.'),
          clearAmountError: error == KoboParseError.empty,
        ),
      ),
      (kobo) {
        final fee = Fees.transferFeeKobo(kobo, bankCode: state.recipient?.bankCode);
        final debit = kobo + fee;
        Failure? error;
        if (kobo < AppConstants.minSendKobo) {
          error = const ValidationFailure(ValidationCode.amountTooSmall, 'The smallest transfer is ₦100.00.');
        } else if (kobo > _capKobo) {
          error = const ValidationFailure(
            ValidationCode.tierLimitExceeded,
            'This is above your transfer limit. Verify your BVN to raise it.',
          );
        } else if (debit > wallet.availableKobo) {
          error = const ValidationFailure(
            ValidationCode.insufficientAvailable,
            'This is more than your available balance.',
          );
        }
        emit(
          state.copyWith(
            amountText: value,
            amountKobo: kobo,
            feeKobo: fee,
            amountError: error,
            clearAmountError: error == null,
          ),
        );
      },
    );
  }

  Future<void> continueToReview() async {
    if (!state.canContinue) return;
    final needsBiometric =
        state.amountKobo! >= AppConstants.biometricThresholdKobo &&
        await settings.biometricEnabled() &&
        await biometricGate.isAvailable();
    if (isClosed) return;
    emit(
      state.copyWith(
        stage: SendStage.review,
        requiresBiometric: needsBiometric,
        needsPinFallback: false,
        pinError: false,
        clearSubmitFailure: true,
      ),
    );
  }

  void backToAmount() => emit(state.copyWith(stage: SendStage.amount));

  Future<void> authoriseWithPin(String pin) async {
    if (state.stage != SendStage.review) return;
    if (!await auth.verifyPin(pin)) {
      emit(state.copyWith(pinError: true));
      return;
    }
    emit(state.copyWith(pinError: false));
    await _submit();
  }

  Future<void> authoriseWithBiometric() async {
    if (state.stage != SendStage.review) return;
    final result = await biometricGate.confirm(
      // Signing the amount and recipient ties the approval to THIS transfer.
      payload: 'send|${state.recipient!.bankCode}|${state.recipient!.accountNumber}|${state.debitKobo}',
      reason: 'Approve this transfer',
    );
    if (isClosed) return;
    await result.fold((error) async {
      if (error == BiometricSignerError.canceled) return; // routine, stay put
      // Nothing usable on this device: let the user pay with the PIN instead.
      emit(state.copyWith(needsPinFallback: true, requiresBiometric: false));
    }, (signature) => _submit(biometricSignature: signature));
  }

  Future<void> _submit({String? biometricSignature}) async {
    emit(state.copyWith(stage: SendStage.submitting, clearSubmitFailure: true));

    final recipient = state.recipient!;
    final result = await outbox.enqueueSend(
      draft: SendDraft(
        beneficiary: recipient,
        amountKobo: state.amountKobo!,
        feeKobo: state.feeKobo,
        narration: state.narration.isEmpty ? null : state.narration,
      ),
      online: connectivity.isOnline,
      biometricSignature: biometricSignature,
    );
    if (isClosed) return;

    await result.fold((failure) async => emit(state.copyWith(stage: SendStage.review, submitFailure: failure)), (
      item,
    ) async {
      await beneficiaries.touch(recipient);
      unawaited(sync.drain());
      if (!connectivity.isOnline) {
        _finish(item, SendOutcome.pending);
        return;
      }
      final settled = await awaitOutcome(outbox: outbox, id: item.id, timeout: outcomeWait);
      if (isClosed) return;
      _finish(settled, _outcomeFor(settled));
    });
  }

  SendOutcome _outcomeFor(OutboxItem item) => switch (item.status) {
    OutboxStatus.succeeded => SendOutcome.sent,
    OutboxStatus.failed => SendOutcome.failed,
    _ => connectivity.isOnline ? SendOutcome.processing : SendOutcome.pending,
  };

  void _finish(OutboxItem item, SendOutcome outcome) {
    emit(state.copyWith(stage: SendStage.result, item: item, outcome: outcome));
    // A Pending screen that is still open when the queue drains should say Sent.
    _itemSub?.cancel();
    _itemSub = outbox.watchItem(item.id).listen((latest) {
      if (latest == null || isClosed) return;
      emit(state.copyWith(item: latest, outcome: _outcomeFor(latest)));
    });
  }

  /// "Try again" after a rejection: a NEW intent, so the next submit gets a new
  /// idempotency key (spec A1).
  void retry() {
    _itemSub?.cancel();
    _itemSub = null;
    emit(state.copyWith(stage: SendStage.review, clearItem: true, pinError: false, clearSubmitFailure: true));
  }

  @override
  Future<void> close() async {
    await _itemSub?.cancel();
    return super.close();
  }
}
