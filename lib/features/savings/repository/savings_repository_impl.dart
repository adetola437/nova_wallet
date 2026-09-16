import 'package:dartz/dartz.dart';
import 'package:isar_community/isar.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/api/service/mappers.dart';
import '../../../core/api/service/nova_api_service.dart';
import '../../../core/models/activity_item.dart';
import '../../../core/models/goal_view.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/storage/entities/goal_entity.dart';
import '../../../core/storage/entities/outbox_item_entity.dart';
import '../../../core/storage/entities/transaction_entity.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/session_store.dart';
import '../../../core/utils/streams.dart';
import 'savings_repository.dart';

class SavingsRepositoryImpl implements ISavingsRepository {
  SavingsRepositoryImpl({required this.db, required this.api, required this.session});

  final IsarDb db;
  final NovaApiService api;
  final SessionStore session;

  Isar get _isar => db.client;

  /// Queued/sending contributions AND moves to wallet: both change a goal.
  Query<OutboxItemEntity> get _activeGoalItems => _isar.outboxItemEntitys
      .filter()
      .group((q) => q.typeEqualTo(OutboxType.contribute).or().typeEqualTo(OutboxType.moveToWallet))
      .and()
      .group((q) => q.statusEqualTo(OutboxStatus.queued).or().statusEqualTo(OutboxStatus.sending))
      .build();

  int _sumFor(String clientId, OutboxType type, List<OutboxItemEntity> items) =>
      items.where((i) => i.goalClientId == clientId && i.type == type).fold<int>(0, (sum, i) => sum + i.amountKobo);

  @override
  Stream<List<GoalView>> watchGoals() => combineLatest2(
    _isar.goalEntitys.where().sortByCreatedAtDesc().watch(fireImmediately: true),
    _activeGoalItems.watch(fireImmediately: true),
    (List<GoalEntity> goals, List<OutboxItemEntity> pending) => [
      for (final goal in goals)
        goal.toView(
          pendingKobo: _sumFor(goal.clientId, OutboxType.contribute, pending),
          movingKobo: _sumFor(goal.clientId, OutboxType.moveToWallet, pending),
        ),
    ],
  );

  @override
  Stream<GoalView?> watchGoal(String clientId) => watchGoals().map((goals) {
    for (final goal in goals) {
      if (goal.clientId == clientId) return goal;
    }
    return null;
  });

  @override
  Stream<List<ActivityItem>> watchContributions(String clientId) => combineLatest2(
    _isar.outboxItemEntitys
        .filter()
        .goalClientIdEqualTo(clientId)
        .and()
        .group(
          (q) => q
              .statusEqualTo(OutboxStatus.queued)
              .or()
              .statusEqualTo(OutboxStatus.sending)
              .or()
              .statusEqualTo(OutboxStatus.failed),
        )
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true),
    _isar.transactionEntitys.filter().goalClientIdEqualTo(clientId).sortByCreatedAtDesc().watch(fireImmediately: true),
    (List<OutboxItemEntity> pending, List<TransactionEntity> settled) => [
      for (final item in pending)
        if (item.type == OutboxType.contribute || item.type == OutboxType.moveToWallet)
          ActivityItem(
            id: 'outbox:${item.id}',
            status: switch (item.status) {
              OutboxStatus.sending => ActivityStatus.sending,
              OutboxStatus.failed => ActivityStatus.failed,
              _ => ActivityStatus.pending,
            },
            kind: item.type == OutboxType.moveToWallet ? ActivityKind.goalWithdrawal : ActivityKind.contribution,
            direction: item.type == OutboxType.moveToWallet ? ActivityDirection.credit : ActivityDirection.debit,
            amountKobo: item.type == OutboxType.moveToWallet ? item.amountKobo - item.feeKobo : item.amountKobo,
            feeKobo: item.type == OutboxType.moveToWallet ? item.feeKobo : 0,
            title: item.counterpartyName ?? 'NovaSave',
            createdAt: item.createdAt,
            outboxId: item.id,
            failureMessage: item.failureMessage,
            goalClientId: item.goalClientId,
          ),
      for (final txn in settled) txn.toActivity(),
    ],
  );

  @override
  Future<Either<Failure, Unit>> refresh() async {
    final token = await session.readToken();
    if (token == null) {
      return left(const BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.'));
    }
    final result = await api.getGoals(token: token);
    return result.fold(left, (goals) async {
      await _isar.writeTxn(() async {
        await _isar.goalEntitys.putAll(goals.map(goalEntityFromDto).toList());
      });
      return right(unit);
    });
  }
}
