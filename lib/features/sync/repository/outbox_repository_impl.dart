import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/api/service/dto.dart';
import '../../../core/api/service/mappers.dart';
import '../../../core/api/service/nova_api_service.dart';
import '../../../core/models/goal_view.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/storage/entities/goal_entity.dart';
import '../../../core/storage/entities/outbox_item_entity.dart';
import '../../../core/storage/entities/transaction_entity.dart';
import '../../../core/storage/entities/wallet_snapshot_entity.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/session_store.dart';
import 'outbox_repository.dart';

class OutboxRepositoryImpl implements IOutboxRepository {
  OutboxRepositoryImpl({
    required this.db,
    required this.api,
    required this.session,
    Uuid? uuid,
    DateTime Function()? clock,
  }) : _uuid = uuid ?? const Uuid(),
       _clock = clock ?? DateTime.now;

  final IsarDb db;
  final NovaApiService api;
  final SessionStore session;
  final Uuid _uuid;
  final DateTime Function() _clock;

  Isar get _isar => db.client;
  IsarCollection<OutboxItemEntity> get _items => _isar.outboxItemEntitys;

  // ── Enqueue ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, OutboxItem>> enqueueSend({
    required SendDraft draft,
    required bool online,
    String? biometricSignature,
  }) {
    final b = draft.beneficiary;
    final entity = OutboxItemEntity()
      ..idempotencyKey = _uuid.v4()
      ..type = OutboxType.send
      ..status = OutboxStatus.queued
      ..amountKobo = draft.amountKobo
      ..feeKobo = draft.feeKobo
      ..payloadJson = jsonEncode(
        TransferRequest(
          bankCode: b.bankCode,
          bankName: b.bankName,
          accountNumber: b.accountNumber,
          recipientName: b.verifiedName,
          amountKobo: draft.amountKobo,
          narration: draft.narration,
        ).toJson(),
      )
      ..counterpartyName = b.verifiedName
      ..counterpartyBank = b.bankName
      ..maskedAccount = b.maskedAccount
      ..narration = draft.narration
      ..queuedWhileOffline = !online
      ..biometricSignature = biometricSignature
      ..createdAt = _clock();
    return _enqueue(entity, requiresFunds: true);
  }

  @override
  Future<Either<Failure, OutboxItem>> enqueueCreateGoal({required CreateGoalDraft draft, required bool online}) {
    final now = _clock();
    final entity = OutboxItemEntity()
      ..idempotencyKey = _uuid.v4()
      ..type = OutboxType.createGoal
      ..status = OutboxStatus.queued
      ..amountKobo = 0
      ..payloadJson = jsonEncode(
        CreateGoalRequest(
          clientId: draft.clientId,
          name: draft.name,
          targetKobo: draft.targetKobo,
          targetDate: draft.targetDate,
        ).toJson(),
      )
      ..goalClientId = draft.clientId
      ..counterpartyName = draft.name
      ..queuedWhileOffline = !online
      ..createdAt = now;

    // The local goal is written in the SAME transaction, so a contribution can
    // reference it before it has ever reached the server.
    return _enqueue(
      entity,
      requiresFunds: false,
      alsoWrite: () => _isar.goalEntitys.put(
        GoalEntity()
          ..clientId = draft.clientId
          ..name = draft.name
          ..targetKobo = draft.targetKobo
          ..targetDate = draft.targetDate
          ..savedKobo = 0
          ..syncState = GoalSyncState.pending
          ..createdAt = now,
      ),
    );
  }

  @override
  Future<Either<Failure, OutboxItem>> enqueueContribute({required ContributeDraft draft, required bool online}) {
    final entity = OutboxItemEntity()
      ..idempotencyKey = _uuid.v4()
      ..type = OutboxType.contribute
      ..status = OutboxStatus.queued
      ..amountKobo = draft.amountKobo
      ..payloadJson = jsonEncode(
        ContributeRequest(goalClientId: draft.goalClientId, amountKobo: draft.amountKobo).toJson(),
      )
      ..goalClientId = draft.goalClientId
      ..counterpartyName = draft.goalName
      ..queuedWhileOffline = !online
      ..createdAt = _clock();
    return _enqueue(entity, requiresFunds: true);
  }

  @override
  Future<Either<Failure, OutboxItem>> enqueueMoveToWallet({
    required MoveToWalletDraft draft,
    required bool online,
  }) async {
    final entity = OutboxItemEntity()
      ..idempotencyKey = _uuid.v4()
      ..type = OutboxType.moveToWallet
      ..status = OutboxStatus.queued
      ..amountKobo = draft.amountKobo
      ..feeKobo = draft.breakFeeKobo
      ..payloadJson = jsonEncode(
        MoveToWalletRequest(
          goalClientId: draft.goalClientId,
          amountKobo: draft.amountKobo,
          agreedFeeKobo: draft.breakFeeKobo,
        ).toJson(),
      )
      ..goalClientId = draft.goalClientId
      ..counterpartyName = draft.goalName
      ..queuedWhileOffline = !online
      ..createdAt = _clock();
    try {
      final accepted = await _isar.writeTxn<bool>(() async {
        // Same idea as the wallet hold: checked inside the write transaction,
        // so two quick moves can't both spend the same savings.
        final goal = await _isar.goalEntitys.getByClientId(draft.goalClientId);
        final alreadyMoving = (await _activeEntities())
            .where((i) => i.type == OutboxType.moveToWallet && i.goalClientId == draft.goalClientId)
            .fold<int>(0, (sum, i) => sum + i.amountKobo);
        if (goal == null || draft.amountKobo > goal.savedKobo - alreadyMoving) return false;
        await _items.put(entity);
        return true;
      });
      if (!accepted) {
        return left(
          const ValidationFailure(ValidationCode.insufficientAvailable, 'This goal does not hold that much.'),
        );
      }
      return right(entity.toModel());
    } on IsarError catch (e) {
      return left(StorageFailure(e.message));
    }
  }

  Future<Either<Failure, OutboxItem>> _enqueue(
    OutboxItemEntity entity, {
    required bool requiresFunds,
    Future<void> Function()? alsoWrite,
  }) async {
    try {
      final accepted = await _isar.writeTxn<bool>(() async {
        if (requiresFunds) {
          final snapshot = await _isar.walletSnapshotEntitys.get(0);
          final ledger = snapshot?.ledgerBalanceKobo ?? 0;
          final held = (await _activeEntities()).fold<int>(0, (sum, i) => sum + i.debitKobo);
          // Inside the write transaction, so two rapid confirms serialise and
          // the second sees the first one's hold.
          if (entity.debitKobo > ledger - held) return false;
        }
        await _items.put(entity);
        if (alsoWrite != null) await alsoWrite();
        return true;
      });
      if (!accepted) {
        return left(
          const ValidationFailure(ValidationCode.insufficientAvailable, 'This is more than your available balance.'),
        );
      }
      return right(entity.toModel());
    } on IsarError catch (e) {
      return left(StorageFailure(e.message));
    }
  }

  Future<List<OutboxItemEntity>> _activeEntities() =>
      _items.filter().statusEqualTo(OutboxStatus.queued).or().statusEqualTo(OutboxStatus.sending).findAll();

  // ── Claim / dispatch / settle ───────────────────────────────────────────

  @override
  Future<int> recoverInterrupted() => _isar.writeTxn<int>(() async {
    final stuck = await _items.filter().statusEqualTo(OutboxStatus.sending).findAll();
    for (final item in stuck) {
      item
        ..status = OutboxStatus.queued
        ..nextAttemptAt = null;
    }
    await _items.putAll(stuck);
    return stuck.length;
  });

  @override
  Future<OutboxItem?> claimNext(DateTime now) => _isar.writeTxn<OutboxItem?>(() async {
    // Never two in flight, whatever called us.
    final inFlight = await _items.filter().statusEqualTo(OutboxStatus.sending).count();
    if (inFlight > 0) return null;

    // Ascending id == FIFO. A later send must not overtake an earlier one.
    final head = await _items.filter().statusEqualTo(OutboxStatus.queued).findFirst();
    if (head == null) return null;
    final due = head.nextAttemptAt;
    if (due != null && due.isAfter(now)) return null;

    head
      ..status = OutboxStatus.sending
      ..attempts += 1
      ..lastAttemptAt = now
      ..nextAttemptAt = null;
    await _items.put(head);
    return head.toModel();
  });

  @override
  Future<Either<Failure, MutationResultDto>> dispatch(OutboxItem item) async {
    final token = await session.readToken();
    if (token == null) {
      return left(const BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.'));
    }
    final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
    switch (item.type) {
      case OutboxType.send:
        return api.transfer(
          token: token,
          idempotencyKey: item.idempotencyKey,
          request: TransferRequest.fromJson(payload),
        );
      case OutboxType.createGoal:
        return api.createGoal(
          token: token,
          idempotencyKey: item.idempotencyKey,
          request: CreateGoalRequest.fromJson(payload),
        );
      case OutboxType.contribute:
        return api.contribute(
          token: token,
          idempotencyKey: item.idempotencyKey,
          request: ContributeRequest.fromJson(payload),
        );
      case OutboxType.moveToWallet:
        return api.moveToWallet(
          token: token,
          idempotencyKey: item.idempotencyKey,
          request: MoveToWalletRequest.fromJson(payload),
        );
    }
  }

  @override
  Future<void> markSucceeded(int id, MutationResultDto result, DateTime now) => _isar.writeTxn(() async {
    final item = await _items.get(id);
    if (item == null) return;
    item
      ..status = OutboxStatus.succeeded
      ..serverRef = result.ref
      ..completedAt = now
      ..nextAttemptAt = null
      ..failureCode = null
      ..failureMessage = null;
    await _items.put(item);

    // Ledger and item settle together: the hold disappears exactly as the
    // new balance lands, so available can never jump.
    final snapshot =
        await _isar.walletSnapshotEntitys.get(0) ??
        (WalletSnapshotEntity()
          ..id = 0
          ..ledgerBalanceKobo = 0);
    snapshot
      ..ledgerBalanceKobo = result.balanceAfterKobo
      ..lastSyncedAt = now;
    await _isar.walletSnapshotEntitys.put(snapshot);

    final txn = result.transaction;
    if (txn != null) await _isar.transactionEntitys.put(transactionEntityFromDto(txn));

    final goal = result.goal;
    if (goal != null) await _isar.goalEntitys.put(goalEntityFromDto(goal));
  });

  @override
  Future<void> markFailed(int id, BusinessFailure failure, DateTime now) => _isar.writeTxn(() async {
    final item = await _items.get(id);
    if (item == null) return;
    item
      ..status = OutboxStatus.failed
      ..completedAt = now
      ..nextAttemptAt = null
      ..failureCode = failure.code.name
      ..failureMessage = failure.message;
    await _items.put(item);

    // A goal whose creation was rejected must not look real.
    final goalId = item.goalClientId;
    if (item.type == OutboxType.createGoal && goalId != null) {
      final goal = await _isar.goalEntitys.getByClientId(goalId);
      if (goal != null) {
        goal.syncState = GoalSyncState.failed;
        await _isar.goalEntitys.put(goal);
      }
    }
  });

  @override
  Future<void> markRetry(int id, {required String message, DateTime? nextAttemptAt, bool countAttempt = true}) =>
      _isar.writeTxn(() async {
        final item = await _items.get(id);
        if (item == null) return;
        item
          ..status = OutboxStatus.queued
          ..nextAttemptAt = nextAttemptAt
          ..failureMessage = message;
        if (!countAttempt && item.attempts > 0) item.attempts -= 1;
        await _items.put(item);
      });

  @override
  Future<void> clearBackoff() => _isar.writeTxn(() async {
    final waiting = await _items.filter().statusEqualTo(OutboxStatus.queued).nextAttemptAtIsNotNull().findAll();
    for (final item in waiting) {
      item.nextAttemptAt = null;
    }
    await _items.putAll(waiting);
  });

  @override
  Future<DateTime?> headRetryAt() async {
    final head = await _items.filter().statusEqualTo(OutboxStatus.queued).findFirst();
    return head?.nextAttemptAt;
  }

  // ── Reads ───────────────────────────────────────────────────────────────

  @override
  Future<OutboxItem?> byId(int id) async => (await _items.get(id))?.toModel();

  @override
  Stream<OutboxItem?> watchItem(int id) => _items.watchObject(id, fireImmediately: true).map((e) => e?.toModel());

  @override
  Stream<List<OutboxItem>> watchActive() => _items
      .filter()
      .statusEqualTo(OutboxStatus.queued)
      .or()
      .statusEqualTo(OutboxStatus.sending)
      .watch(fireImmediately: true)
      .map((rows) => rows.map((e) => e.toModel()).toList());

  @override
  Stream<List<OutboxItem>> watchAll({int limit = 100}) => _items
      .where()
      .sortByCreatedAtDesc()
      .limit(limit)
      .watch(fireImmediately: true)
      .map((rows) => rows.map((e) => e.toModel()).toList());

  @override
  Future<List<OutboxItem>> activeItems() async => (await _activeEntities()).map((e) => e.toModel()).toList();
}
