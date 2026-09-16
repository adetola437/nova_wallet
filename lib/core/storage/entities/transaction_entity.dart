import 'package:isar_community/isar.dart';

import '../../models/activity_item.dart';

part 'transaction_entity.g.dart';

/// Local cache of settled server transactions.
@collection
class TransactionEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String serverRef;

  @Enumerated(EnumType.name)
  late ActivityKind kind;

  @Enumerated(EnumType.name)
  late ActivityDirection direction;

  late int amountKobo;
  int feeKobo = 0;
  late String title;
  String? subtitle;
  String? narration;

  @Index()
  String? goalClientId;

  String? idempotencyKey;

  @Index()
  late DateTime createdAt;

  ActivityItem toActivity() => ActivityItem(
    id: 'txn:$serverRef',
    status: ActivityStatus.completed,
    kind: kind,
    direction: direction,
    amountKobo: amountKobo,
    feeKobo: feeKobo,
    title: title,
    subtitle: subtitle,
    narration: narration,
    createdAt: createdAt,
    serverRef: serverRef,
    goalClientId: goalClientId,
  );
}
