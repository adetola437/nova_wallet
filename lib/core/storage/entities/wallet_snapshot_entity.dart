import 'package:isar_community/isar.dart';

part 'wallet_snapshot_entity.g.dart';

/// Single row (id 0): the last server-confirmed balance.
@collection
class WalletSnapshotEntity {
  Id id = 0;
  late int ledgerBalanceKobo;
  DateTime? lastSyncedAt;
}
