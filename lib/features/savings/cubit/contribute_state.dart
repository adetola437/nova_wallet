import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/outbox_item.dart';

enum ContributeStage { editing, submitting, done }

enum ContributeOutcome { saved, pending, processing, failed }

class ContributeState extends Equatable {
  const ContributeState({
    this.stage = ContributeStage.editing,
    this.amountText = '',
    this.amountKobo,
    this.validation,
    this.pinError = false,
    this.item,
    this.outcome,
  });

  final ContributeStage stage;
  final String amountText;
  final int? amountKobo;
  final Failure? validation;
  final bool pinError;
  final OutboxItem? item;
  final ContributeOutcome? outcome;

  bool get canSubmit => amountKobo != null && validation == null;

  ContributeState copyWith({
    ContributeStage? stage,
    String? amountText,
    int? amountKobo,
    Failure? validation,
    bool? pinError,
    OutboxItem? item,
    ContributeOutcome? outcome,
    bool clearAmount = false,
    bool clearValidation = false,
  }) => ContributeState(
    stage: stage ?? this.stage,
    amountText: amountText ?? this.amountText,
    amountKobo: clearAmount ? null : (amountKobo ?? this.amountKobo),
    validation: clearValidation ? null : (validation ?? this.validation),
    pinError: pinError ?? this.pinError,
    item: item ?? this.item,
    outcome: outcome ?? this.outcome,
  );

  @override
  List<Object?> get props => [stage, amountText, amountKobo, validation, pinError, item, outcome];
}
