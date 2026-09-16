import 'package:isar_community/isar.dart';

import '../../config/flavor/app_constants.dart';
import '../api/fake/entities/server_entities.dart';
import 'entities/beneficiary_entity.dart';
import 'entities/goal_entity.dart';
import 'entities/outbox_item_entity.dart';
import 'entities/profile_entity.dart';
import 'entities/transaction_entity.dart';
import 'entities/wallet_snapshot_entity.dart';

/// Owns the two Isar instances: the app's own data (`client`) and the fake
/// backend's data (`server`). Keeping them separate means wiping the device
/// (sign-out) never wipes the "remote", just like reality.
class IsarDb {
  IsarDb._(this.client, this.server);

  final Isar client;
  final Isar server;

  static final List<CollectionSchema<dynamic>> clientSchemas = [
    OutboxItemEntitySchema,
    WalletSnapshotEntitySchema,
    ProfileEntitySchema,
    TransactionEntitySchema,
    BeneficiaryEntitySchema,
    GoalEntitySchema,
  ];

  static final List<CollectionSchema<dynamic>> serverSchemas = [
    ServerAccountSchema,
    ServerSessionSchema,
    ServerTransactionSchema,
    ServerGoalSchema,
    ServerBeneficiarySchema,
    ProcessedRequestSchema,
  ];

  static Future<IsarDb> open({
    required String directory,
    String clientName = AppConstants.clientDbName,
    String serverName = AppConstants.serverDbName,
  }) async {
    final client =
        Isar.getInstance(clientName) ?? await Isar.open(clientSchemas, directory: directory, name: clientName);
    final server =
        Isar.getInstance(serverName) ?? await Isar.open(serverSchemas, directory: directory, name: serverName);
    return IsarDb._(client, server);
  }

  Future<void> clearClient() => client.writeTxn(() => client.clear());
  Future<void> clearServer() => server.writeTxn(() => server.clear());

  Future<void> close({bool deleteFromDisk = false}) async {
    if (client.isOpen) await client.close(deleteFromDisk: deleteFromDisk);
    if (server.isOpen) await server.close(deleteFromDisk: deleteFromDisk);
  }
}
