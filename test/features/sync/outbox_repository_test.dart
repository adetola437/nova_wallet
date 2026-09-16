import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/models/beneficiary.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/storage/entities/goal_entity.dart';
import 'package:nova_wallet/core/storage/entities/transaction_entity.dart';
import 'package:nova_wallet/features/sync/repository/outbox_repository.dart';

import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

const ada = Beneficiary(
    accountNumber: '0248214821', bankCode: '058', bankName: 'GTBank', verifiedName: 'ADAEZE OKAFOR');

SendDraft send(int amountKobo, {int feeKobo = 2688}) =>
    SendDraft(beneficiary: ada, amountKobo: amountKobo, feeKobo: feeKobo);

OutboxItem unwrap(Either<Failure, OutboxItem> either) =>
    either.fold((f) => fail('expected Right, got $f'), (r) => r);

void main() {
  late String dir;
  late OutboxHarness h;

  setUp(() async {
    dir = await newTempDir();
    h = await OutboxHarness.open(directory: dir, tag: 'outbox');
    await h.signIn();
  });
  tearDown(() => h.close(deleteFromDisk: true));

  test('enqueue persists a unique key, holds the funds, and is queued', () async {
    final item = unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: false));
    expect(item.status, OutboxStatus.queued);
    expect(item.idempotencyKey, isNotEmpty);
    expect(item.debitKobo, 2502688);
    expect(item.queuedWhileOffline, isTrue);
    expect((await h.outbox.activeItems()).single.id, item.id);
  });

  test('available balance is checked inside the transaction, so holds cannot be overspent', () async {
    await h.setLedger(5000000);
    unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: true));
    final second = await h.outbox.enqueueSend(draft: send(2500000), online: true);
    expect(second.isLeft(), isTrue);
    expect((second.swap().getOrElse(() => throw StateError('x')) as ValidationFailure).code,
        ValidationCode.insufficientAvailable);
    expect((await h.outbox.activeItems()).length, 1);
  });

  test('two rapid confirms racing for the same money: exactly one wins', () async {
    await h.setLedger(3000000);
    final results = await Future.wait([
      h.outbox.enqueueSend(draft: send(2500000), online: true),
      h.outbox.enqueueSend(draft: send(2500000), online: true),
    ]);
    expect(results.where((r) => r.isRight()).length, 1);
    expect((await h.outbox.activeItems()).length, 1);
  });

  test('claimNext is FIFO and refuses to claim while another item is sending', () async {
    final first = unwrap(await h.outbox.enqueueSend(draft: send(100000, feeKobo: 1075), online: true));
    final second = unwrap(await h.outbox.enqueueSend(draft: send(200000, feeKobo: 1075), online: true));
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    expect(claimed!.id, first.id);
    expect(claimed.status, OutboxStatus.sending);
    expect(claimed.attempts, 1);
    expect(await h.outbox.claimNext(DateTime(2026, 9, 16, 10)), isNull, reason: 'one in flight');
    expect((await h.outbox.byId(second.id))!.status, OutboxStatus.queued);
  });

  test('success applies the server balance, saves the transaction and releases the hold', () async {
    final item = unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: true));
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    final result = (await h.outbox.dispatch(claimed!)).getOrElse(() => throw StateError('dispatch failed'));
    await h.outbox.markSucceeded(item.id, result, DateTime(2026, 9, 16, 10));

    final stored = (await h.outbox.byId(item.id))!;
    expect(stored.status, OutboxStatus.succeeded);
    expect(stored.serverRef, result.ref);
    expect(await h.ledger(), AppConstants.demoOpeningBalanceKobo - 2502688);
    expect(await h.outbox.activeItems(), isEmpty);
    expect(await h.db.client.transactionEntitys.count(), 1);
  });

  test('business rejection is terminal and releases the hold', () async {
    await h.setLedger(99000000); // client thinks it has more than the server does
    final item = unwrap(await h.outbox.enqueueSend(draft: send(90000000, feeKobo: 5375), online: true));
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    final failure = (await h.outbox.dispatch(claimed!)).swap().getOrElse(() => throw StateError('x'));
    await h.outbox.markFailed(item.id, failure as BusinessFailure, DateTime(2026, 9, 16, 10));

    final stored = (await h.outbox.byId(item.id))!;
    expect(stored.status, OutboxStatus.failed);
    expect(stored.failureCode, BusinessCode.insufficientFunds.name);
    expect(await h.outbox.activeItems(), isEmpty);
  });

  test('retry keeps the key, schedules backoff, and clearBackoff makes it due', () async {
    final item = unwrap(await h.outbox.enqueueSend(draft: send(100000, feeKobo: 1075), online: true));
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    final due = DateTime(2026, 9, 16, 10, 0, 4);
    await h.outbox.markRetry(claimed!.id, message: 'timeout', nextAttemptAt: due);

    final retried = (await h.outbox.byId(item.id))!;
    expect(retried.status, OutboxStatus.queued);
    expect(retried.idempotencyKey, item.idempotencyKey);
    expect(retried.attempts, 1);
    expect(await h.outbox.claimNext(DateTime(2026, 9, 16, 10, 0, 1)), isNull);
    expect(await h.outbox.headRetryAt(), due);
    await h.outbox.clearBackoff();
    expect((await h.outbox.claimNext(DateTime(2026, 9, 16, 10, 0, 1)))!.id, item.id);
  });

  test('an attempt that never reached the network is not counted', () async {
    unwrap(await h.outbox.enqueueSend(draft: send(100000, feeKobo: 1075), online: true));
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    expect(claimed!.attempts, 1);
    await h.outbox.markRetry(claimed.id, message: 'offline', countAttempt: false);
    expect((await h.outbox.byId(claimed.id))!.attempts, 0);
  });

  test('CRASH AFTER ACCEPT: server applied it, app died before marking — replay debits once', () async {
    final item = unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: true));
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    // The server applies the transfer...
    final firstResult = (await h.outbox.dispatch(claimed!)).getOrElse(() => throw StateError('x'));
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688);
    // ...and the app dies here, before markSucceeded. Restart:
    await h.close();
    h = await OutboxHarness.open(directory: dir, tag: 'outbox');
    await h.session.saveToken(await h.server.demoToken());

    expect(await h.outbox.recoverInterrupted(), 1);
    final recovered = (await h.outbox.byId(item.id))!;
    expect(recovered.status, OutboxStatus.queued);
    expect(recovered.idempotencyKey, item.idempotencyKey);

    final reclaimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10, 5));
    final replay = (await h.outbox.dispatch(reclaimed!)).getOrElse(() => throw StateError('x'));
    await h.outbox.markSucceeded(item.id, replay, DateTime(2026, 9, 16, 10, 5));

    expect(replay.ref, firstResult.ref, reason: 'same key returns the original response');
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688,
        reason: 'debited exactly once');
    expect((await h.outbox.byId(item.id))!.status, OutboxStatus.succeeded);
  });

  test('creating a goal writes a local goal in the same transaction', () async {
    final draft = CreateGoalDraft(
        clientId: 'goal-x', name: 'Laptop', targetKobo: 80000000, targetDate: DateTime(2027, 3, 1));
    unwrap(await h.outbox.enqueueCreateGoal(draft: draft, online: false));
    final goal = await h.db.client.goalEntitys.getByClientId('goal-x');
    expect(goal, isNotNull);
    expect(goal!.savedKobo, 0);
  });
}
