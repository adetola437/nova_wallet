import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/outbox_item.dart';

enum MoveStage { editing, submitting, done }

enum MoveOutcome { moved, pending, processing, failed }

class MoveToWalletState extends Equatable {
  const MoveToWalletState({
    this.stage = MoveStage.editing,
    this.amountText = '',
    this.amountKobo,
    this.feeKobo = 0,
    this.validation,
    this.pinError = false,
    this.item,
    this.outcome,
  });

  final MoveStage stage;
  final String amountText;
  final int? amountKobo;

  /// Early-break fee for [amountKobo] right now (zero once the goal matured).
  final int feeKobo;
  final Failure? validation;
  final bool pinError;
  final OutboxItem? item;
  final MoveOutcome? outcome;

  bool get canSubmit => amountKobo != null && validation == null;

  /// What lands in the wallet.
  int get receiveKobo => (amountKobo ?? 0) - feeKobo;

  MoveToWalletState copyWith({
    MoveStage? stage,
    String? amountText,
    int? amountKobo,
    int? feeKobo,
    Failure? validation,
    bool? pinError,
    OutboxItem? item,
    MoveOutcome? outcome,
    bool clearAmount = false,
    bool clearValidation = false,
  }) => MoveToWalletState(
    stage: stage ?? this.stage,
    amountText: amountText ?? this.amountText,
    amountKobo: clearAmount ? null : (amountKobo ?? this.amountKobo),
    feeKobo: clearAmount ? 0 : (feeKobo ?? this.feeKobo),
    validation: clearValidation ? null : (validation ?? this.validation),
    pinError: pinError ?? this.pinError,
    item: item ?? this.item,
    outcome: outcome ?? this.outcome,
  );

  @override
  List<Object?> get props => [stage, amountText, amountKobo, feeKobo, validation, pinError, item, outcome];
}
