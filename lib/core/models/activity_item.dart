import 'package:equatable/equatable.dart';

enum ActivityStatus { pending, sending, failed, completed }

enum ActivityKind { transfer, contribution, credit, goalCreated, goalWithdrawal }

enum ActivityDirection { debit, credit }

/// One row in a transaction list: a settled server transaction or an
/// unfinished outbox item.
class ActivityItem extends Equatable {
  const ActivityItem({
    required this.id,
    required this.status,
    required this.kind,
    required this.direction,
    required this.amountKobo,
    required this.title,
    required this.createdAt,
    this.feeKobo = 0,
    this.subtitle,
    this.narration,
    this.outboxId,
    this.serverRef,
    this.failureMessage,
    this.goalClientId,
  });

  final String id;
  final ActivityStatus status;
  final ActivityKind kind;
  final ActivityDirection direction;
  final int amountKobo;
  final int feeKobo;
  final String title;
  final String? subtitle;
  final String? narration;
  final DateTime createdAt;
  final int? outboxId;
  final String? serverRef;
  final String? failureMessage;
  final String? goalClientId;

  /// Negative for money leaving the wallet (amount + fee), positive otherwise.
  int get signedKobo => direction == ActivityDirection.debit ? -(amountKobo + feeKobo) : amountKobo;

  @override
  List<Object?> get props => [
    id,
    status,
    kind,
    direction,
    amountKobo,
    feeKobo,
    title,
    subtitle,
    narration,
    createdAt,
    outboxId,
    serverRef,
    failureMessage,
    goalClientId,
  ];
}
