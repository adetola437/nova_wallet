import 'package:equatable/equatable.dart';

enum OutboxType { send, createGoal, contribute, moveToWallet }

enum OutboxStatus { queued, sending, succeeded, failed }

/// Immutable view of one persisted user intent in the outbox.
class OutboxItem extends Equatable {
  const OutboxItem({
    required this.id,
    required this.idempotencyKey,
    required this.type,
    required this.status,
    required this.amountKobo,
    required this.payloadJson,
    required this.createdAt,
    this.feeKobo = 0,
    this.goalClientId,
    this.counterpartyName,
    this.counterpartyBank,
    this.maskedAccount,
    this.narration,
    this.attempts = 0,
    this.nextAttemptAt,
    this.lastAttemptAt,
    this.completedAt,
    this.serverRef,
    this.failureCode,
    this.failureMessage,
    this.queuedWhileOffline = false,
    this.biometricSignature,
  });

  final int id;
  final String idempotencyKey;
  final OutboxType type;
  final OutboxStatus status;
  final int amountKobo;
  final int feeKobo;
  final String payloadJson;
  final String? goalClientId;
  final String? counterpartyName;
  final String? counterpartyBank;
  final String? maskedAccount;
  final String? narration;
  final int attempts;
  final DateTime? nextAttemptAt;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  final DateTime? completedAt;
  final String? serverRef;
  final String? failureCode;
  final String? failureMessage;
  final bool queuedWhileOffline;
  final String? biometricSignature;

  /// What this item holds from the wallet's available balance. Moving money
  /// OUT of a goal holds nothing: the wallet only gains once the server confirms.
  int get debitKobo => type == OutboxType.moveToWallet ? 0 : amountKobo + feeKobo;
  bool get isActive => status == OutboxStatus.queued || status == OutboxStatus.sending;
  bool get isTerminal => status == OutboxStatus.succeeded || status == OutboxStatus.failed;

  OutboxItem copyWith({OutboxStatus? status, int? attempts}) => OutboxItem(
    id: id,
    idempotencyKey: idempotencyKey,
    type: type,
    status: status ?? this.status,
    amountKobo: amountKobo,
    feeKobo: feeKobo,
    payloadJson: payloadJson,
    goalClientId: goalClientId,
    counterpartyName: counterpartyName,
    counterpartyBank: counterpartyBank,
    maskedAccount: maskedAccount,
    narration: narration,
    attempts: attempts ?? this.attempts,
    nextAttemptAt: nextAttemptAt,
    createdAt: createdAt,
    lastAttemptAt: lastAttemptAt,
    completedAt: completedAt,
    serverRef: serverRef,
    failureCode: failureCode,
    failureMessage: failureMessage,
    queuedWhileOffline: queuedWhileOffline,
    biometricSignature: biometricSignature,
  );

  @override
  List<Object?> get props => [
    id,
    idempotencyKey,
    type,
    status,
    amountKobo,
    feeKobo,
    payloadJson,
    goalClientId,
    counterpartyName,
    counterpartyBank,
    maskedAccount,
    narration,
    attempts,
    nextAttemptAt,
    createdAt,
    lastAttemptAt,
    completedAt,
    serverRef,
    failureCode,
    failureMessage,
    queuedWhileOffline,
    biometricSignature,
  ];
}
