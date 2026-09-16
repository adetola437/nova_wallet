import 'package:isar_community/isar.dart';

import '../../models/outbox_item.dart';

part 'outbox_item_entity.g.dart';

@collection
class OutboxItemEntity {
  /// Auto-increment ids are monotonic, so ascending id is the FIFO order.
  Id id = Isar.autoIncrement;

  /// Unique: two rows can never share a key, even under a bug.
  @Index(unique: true)
  late String idempotencyKey;

  @Enumerated(EnumType.name)
  late OutboxType type;

  @Index()
  @Enumerated(EnumType.name)
  late OutboxStatus status;

  late int amountKobo;
  int feeKobo = 0;
  late String payloadJson;

  @Index()
  String? goalClientId;

  String? counterpartyName;
  String? counterpartyBank;
  String? maskedAccount;
  String? narration;

  int attempts = 0;
  DateTime? nextAttemptAt;
  late DateTime createdAt;
  DateTime? lastAttemptAt;
  DateTime? completedAt;

  String? serverRef;
  String? failureCode;
  String? failureMessage;
  bool queuedWhileOffline = false;
  String? biometricSignature;

  /// Mirrors [OutboxItem.debitKobo]: a move to wallet holds nothing.
  @ignore
  int get debitKobo => type == OutboxType.moveToWallet ? 0 : amountKobo + feeKobo;

  OutboxItem toModel() => OutboxItem(
    id: id,
    idempotencyKey: idempotencyKey,
    type: type,
    status: status,
    amountKobo: amountKobo,
    feeKobo: feeKobo,
    payloadJson: payloadJson,
    goalClientId: goalClientId,
    counterpartyName: counterpartyName,
    counterpartyBank: counterpartyBank,
    maskedAccount: maskedAccount,
    narration: narration,
    attempts: attempts,
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
}
