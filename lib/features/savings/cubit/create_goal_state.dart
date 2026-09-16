import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/outbox_item.dart';

class CreateGoalState extends Equatable {
  const CreateGoalState({
    this.name = '',
    this.targetText = '',
    this.targetDate,
    this.isSubmitting = false,
    this.failure,
    this.created,
    this.suggestedWeeklyKobo,
  });

  final String name;
  final String targetText;
  final DateTime? targetDate;
  final bool isSubmitting;
  final Failure? failure;
  final OutboxItem? created;

  /// "Save about ₦X a week to reach this by …" — whole kobo, rounded up.
  final int? suggestedWeeklyKobo;

  CreateGoalState copyWith({
    String? name,
    String? targetText,
    DateTime? targetDate,
    bool? isSubmitting,
    Failure? failure,
    OutboxItem? created,
    int? suggestedWeeklyKobo,
    bool clearFailure = false,
  }) => CreateGoalState(
    name: name ?? this.name,
    targetText: targetText ?? this.targetText,
    targetDate: targetDate ?? this.targetDate,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    failure: clearFailure ? null : (failure ?? this.failure),
    created: created ?? this.created,
    suggestedWeeklyKobo: suggestedWeeklyKobo ?? this.suggestedWeeklyKobo,
  );

  @override
  List<Object?> get props => [name, targetText, targetDate, isSubmitting, failure, created, suggestedWeeklyKobo];
}
