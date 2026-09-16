import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/beneficiary.dart';
import '../../../core/models/outbox_item.dart';

enum SendStage { recipient, amount, review, submitting, result }

enum SendOutcome {
  /// Confirmed by the server while the user waited.
  sent,

  /// Queued because the device is offline.
  pending,

  /// Online but still in flight when the wait elapsed.
  processing,

  /// The server rejected it.
  failed,
}

class SendMoneyState extends Equatable {
  const SendMoneyState({
    this.stage = SendStage.recipient,
    this.recipient,
    this.amountText = '',
    this.amountKobo,
    this.feeKobo = 0,
    this.narration = '',
    this.amountError,
    this.requiresBiometric = false,
    this.needsPinFallback = false,
    this.pinError = false,
    this.item,
    this.outcome,
    this.submitFailure,
  });

  final SendStage stage;
  final Beneficiary? recipient;
  final String amountText;
  final int? amountKobo;
  final int feeKobo;
  final String narration;
  final Failure? amountError;

  /// Amount ≥ ₦50,000.00 AND biometrics enabled and usable.
  final bool requiresBiometric;

  /// The biometric attempt could not run; show the PIN sheet instead.
  final bool needsPinFallback;
  final bool pinError;
  final OutboxItem? item;
  final SendOutcome? outcome;
  final Failure? submitFailure;

  int get debitKobo => (amountKobo ?? 0) + feeKobo;
  bool get canContinue => amountKobo != null && amountError == null && recipient != null;

  SendMoneyState copyWith({
    SendStage? stage,
    Beneficiary? recipient,
    String? amountText,
    int? amountKobo,
    int? feeKobo,
    String? narration,
    Failure? amountError,
    bool? requiresBiometric,
    bool? needsPinFallback,
    bool? pinError,
    OutboxItem? item,
    SendOutcome? outcome,
    Failure? submitFailure,
    bool clearAmount = false,
    bool clearAmountError = false,
    bool clearItem = false,
    bool clearSubmitFailure = false,
  }) => SendMoneyState(
    stage: stage ?? this.stage,
    recipient: recipient ?? this.recipient,
    amountText: amountText ?? this.amountText,
    amountKobo: clearAmount ? null : (amountKobo ?? this.amountKobo),
    feeKobo: feeKobo ?? this.feeKobo,
    narration: narration ?? this.narration,
    amountError: clearAmountError ? null : (amountError ?? this.amountError),
    requiresBiometric: requiresBiometric ?? this.requiresBiometric,
    needsPinFallback: needsPinFallback ?? this.needsPinFallback,
    pinError: pinError ?? this.pinError,
    item: clearItem ? null : (item ?? this.item),
    outcome: clearItem ? null : (outcome ?? this.outcome),
    submitFailure: clearSubmitFailure ? null : (submitFailure ?? this.submitFailure),
  );

  @override
  List<Object?> get props => [
    stage,
    recipient,
    amountText,
    amountKobo,
    feeKobo,
    narration,
    amountError,
    requiresBiometric,
    needsPinFallback,
    pinError,
    item,
    outcome,
    submitFailure,
  ];
}
