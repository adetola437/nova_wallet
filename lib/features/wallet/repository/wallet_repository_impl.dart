import 'package:dartz/dartz.dart';
import 'package:isar_community/isar.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/api/service/mappers.dart';
import '../../../core/api/service/nova_api_service.dart';
import '../../../core/models/activity_item.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/models/wallet_overview.dart';
import '../../../core/storage/entities/outbox_item_entity.dart';
import '../../../core/storage/entities/profile_entity.dart';
import '../../../core/storage/entities/transaction_entity.dart';
import '../../../core/storage/entities/wallet_snapshot_entity.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/session_store.dart';
import '../../../core/utils/streams.dart';
import 'wallet_repository.dart';

class WalletRepositoryImpl implements IWalletRepository {
  WalletRepositoryImpl({required this.db, required this.api, required this.session, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final IsarDb db;
  final NovaApiService api;
  final SessionStore session;
  final DateTime Function() _clock;

  Isar get _isar => db.client;

  /// Unsettled items: queued and sending hold money; failed ones are shown so
  /// the user can see what went wrong.
  Query<OutboxItemEntity> get _unsettled => _isar.outboxItemEntitys
      .filter()
      .statusEqualTo(OutboxStatus.queued)
      .or()
      .statusEqualTo(OutboxStatus.sending)
      .or()
      .statusEqualTo(OutboxStatus.failed)
      .sortByCreatedAtDesc()
      .build();

  WalletOverview _overview(WalletSnapshotEntity? snapshot, List<OutboxItemEntity> unsettled) {
    final active = unsettled.where((i) => i.status != OutboxStatus.failed).toList();
    return WalletOverview(
      ledgerKobo: snapshot?.ledgerBalanceKobo ?? 0,
      heldKobo: active.fold<int>(0, (sum, i) => sum + i.debitKobo),
      pendingCount: active.length,
      lastSyncedAt: snapshot?.lastSyncedAt,
    );
  }

  @override
  Stream<WalletOverview> watchOverview() => combineLatest2(
    _isar.walletSnapshotEntitys.watchObject(0, fireImmediately: true),
    _unsettled.watch(fireImmediately: true),
    _overview,
  );

  @override
  Future<WalletOverview> currentOverview() async =>
      _overview(await _isar.walletSnapshotEntitys.get(0), await _unsettled.findAll());

  @override
  Stream<List<ActivityItem>> watchActivity({int limit = AppConstants.pageSize}) => combineLatest2(
    _unsettled.watch(fireImmediately: true),
    _isar.transactionEntitys.where().sortByCreatedAtDesc().limit(limit).watch(fireImmediately: true),
    (List<OutboxItemEntity> pending, List<TransactionEntity> settled) => [
      for (final item in pending) _activityFromOutbox(item),
      for (final txn in settled) txn.toActivity(),
    ].take(limit).toList(),
  );

  ActivityItem _activityFromOutbox(OutboxItemEntity item) => ActivityItem(
    id: 'outbox:${item.id}',
    status: switch (item.status) {
      OutboxStatus.sending => ActivityStatus.sending,
      OutboxStatus.failed => ActivityStatus.failed,
      _ => ActivityStatus.pending,
    },
    kind: switch (item.type) {
      OutboxType.contribute => ActivityKind.contribution,
      OutboxType.createGoal => ActivityKind.goalCreated,
      OutboxType.send => ActivityKind.transfer,
      OutboxType.moveToWallet => ActivityKind.goalWithdrawal,
    },
    direction: item.type == OutboxType.moveToWallet ? ActivityDirection.credit : ActivityDirection.debit,
    // A move to wallet shows what will land (amount less any break fee).
    amountKobo: item.type == OutboxType.moveToWallet ? item.amountKobo - item.feeKobo : item.amountKobo,
    feeKobo: item.feeKobo,
    title: item.counterpartyName ?? 'NovaPay',
    subtitle: item.counterpartyBank == null
        ? item.maskedAccount
        : '${item.counterpartyBank} · ${item.maskedAccount ?? ''}'.trim(),
    narration: item.narration,
    createdAt: item.createdAt,
    outboxId: item.id,
    failureMessage: item.failureMessage,
    goalClientId: item.goalClientId,
  );

  @override
  Future<Either<Failure, List<ActivityItem>>> refresh() async {
    final token = await session.readToken();
    if (token == null) {
      return left(const BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.'));
    }

    final walletResult = await api.getWallet(token: token);
    return walletResult.fold(left, (wallet) async {
      final txnResult = await api.getTransactions(token: token);
      return txnResult.fold(left, (transactions) async {
        final entities = transactions.map(transactionEntityFromDto).toList();
        final newCredits = <ActivityItem>[];
        await _isar.writeTxn(() async {
          final previous = await _isar.walletSnapshotEntitys.get(0);
          if (previous?.lastSyncedAt != null) {
            final credits = entities.where((t) => t.direction == ActivityDirection.credit).toList();
            final known = await _isar.transactionEntitys.getAllByServerRef(credits.map((t) => t.serverRef).toList());
            for (var i = 0; i < credits.length; i++) {
              if (known[i] == null) newCredits.add(credits[i].toActivity());
            }
          }
          await _isar.walletSnapshotEntitys.put(
            WalletSnapshotEntity()
              ..id = 0
              ..ledgerBalanceKobo = wallet.balanceKobo
              ..lastSyncedAt = _clock(),
          );
          await _isar.profileEntitys.put(ProfileEntity.fromModel(wallet.profile.toModel()));
          await _isar.transactionEntitys.putAll(entities);
        });
        return right(newCredits);
      });
    });
  }
}
