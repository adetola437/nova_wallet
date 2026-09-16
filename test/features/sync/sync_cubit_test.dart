import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/api/fake/entities/server_entities.dart';
import 'package:nova_wallet/core/models/beneficiary.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/network/backend_reachability.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/core/storage/entities/goal_entity.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';
import 'package:nova_wallet/features/sync/cubit/sync_cubit.dart';
import 'package:nova_wallet/features/sync/repository/outbox_repository.dart';

import '../../support/fake_sync_notifier.dart';
import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

const ada = Beneficiary(
    accountNumber: '0248214821', bankCode: '058', bankName: 'GTBank', verifiedName: 'ADAEZE OKAFOR');
const nobody = Beneficiary(
    accountNumber: '0001112223', bankCode: '058', bankName: 'GTBank', verifiedName: 'NO ONE');

SendDraft send(int amountKobo, {Beneficiary to = ada, int feeKobo = 2688}) =>
    SendDraft(beneficiary: to, amountKobo: amountKobo, feeKobo: feeKobo);

OutboxItem unwrap(Either<Failure, OutboxItem> e) =>
    e.fold((f) => fail('expected Right, got $f'), (r) => r);

void main() {
  late OutboxHarness h;
  late ConnectivityCubit connectivity;
  late FakeSyncNotifier notifier;
  late SyncCubit sync;

  setUp(() async {
    h = await OutboxHarness.open(directory: await newTempDir(), tag: 'sync');
    await h.signIn();
    connectivity = ConnectivityCubit(
      reachability: Reachability(
          networkInfo: h.network, controls: h.server.controls, backend: const AlwaysReachable()),
      onlineDebounce: const Duration(milliseconds: 10),
    );
    await connectivity.start();
    notifier = FakeSyncNotifier();
    sync = SyncCubit(
      outbox: h.outbox,
      connectivity: connectivity,
      notifier: notifier,
      backoff: (attempts) => const Duration(milliseconds: 20),
    );
  });

  tearDown(() async {
    await sync.close();
    await connectivity.close();
    await h.close(deleteFromDisk: true);
  });

  test('offline: nothing is sent and the item stays queued', () async {
    h.network.connected = false;
    await connectivity.recheck();
    final item = unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: false));
    await sync.start();
    await sync.drain();
    await pumpEventQueue();

    expect((await h.outbox.byId(item.id))!.status, OutboxStatus.queued);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo);
    expect(sync.state.pendingCount, 1);
    expect(sync.state.pendingDebitKobo, 2502688);
  });

  test('reconnecting drains the queue and notifies once', () async {
    h.network.connected = false;
    await connectivity.recheck();
    final item = unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: false));
    await sync.start();

    h.network.connected = true;
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sync.drain();

    expect((await h.outbox.byId(item.id))!.status, OutboxStatus.succeeded);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688);
    expect(await h.ledger(), AppConstants.demoOpeningBalanceKobo - 2502688);
    expect(notifier.succeeded.length, 1);
    await pumpEventQueue();
    expect(sync.state.pendingCount, 0);
  });

  test('SINGLE FLIGHT: five concurrent drains produce one debit', () async {
    unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: true));
    await sync.start();

    await Future.wait([sync.drain(), sync.drain(), sync.drain(), sync.drain(), sync.drain()]);

    expect(await h.db.server.processedRequests.count(), 1);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688);
  });

  test('RESTART RECOVERY: an item left sending is replayed with the same key, once', () async {
    final item = unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: true));
    // Claim + dispatch, then "crash" before marking: the server has applied it.
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    await h.outbox.dispatch(claimed!);
    expect((await h.outbox.byId(item.id))!.status, OutboxStatus.sending);

    await sync.start(); // start() recovers stuck items, then drains
    await sync.drain();

    expect((await h.outbox.byId(item.id))!.status, OutboxStatus.succeeded);
    expect(await h.db.server.processedRequests.count(), 1);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688);
  });

  test('LOST RESPONSE: timeout requeues with the same key; the replay debits nothing extra', () async {
    final item = unwrap(await h.outbox.enqueueSend(draft: send(1000000, feeKobo: 2688), online: true));
    h.server.controls.loseNextResponse = true;
    await sync.start();
    await sync.drain();

    final afterTimeout = (await h.outbox.byId(item.id))!;
    expect(afterTimeout.status, isNot(OutboxStatus.failed));
    expect(afterTimeout.idempotencyKey, item.idempotencyKey);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 1002688);

    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sync.drain();

    expect((await h.outbox.byId(item.id))!.status, OutboxStatus.succeeded);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 1002688);
    expect(await h.ledger(), AppConstants.demoOpeningBalanceKobo - 1002688);
    expect(await h.db.server.processedRequests.count(), 1);
  });

  test('a rejected item fails terminally and the next item still goes out (FIFO)', () async {
    final bad = unwrap(await h.outbox.enqueueSend(draft: send(500000, to: nobody, feeKobo: 1075), online: true));
    final good = unwrap(await h.outbox.enqueueSend(draft: send(500000, feeKobo: 1075), online: true));
    await sync.start();
    await sync.drain();

    expect((await h.outbox.byId(bad.id))!.status, OutboxStatus.failed);
    expect((await h.outbox.byId(bad.id))!.failureCode, BusinessCode.invalidAccount.name);
    expect((await h.outbox.byId(good.id))!.status, OutboxStatus.succeeded);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 501075);
  });

  test('a queued goal is created before the contribution that depends on it', () async {
    final goal = unwrap(await h.outbox.enqueueCreateGoal(
        draft: CreateGoalDraft(
            clientId: 'goal-1', name: 'Laptop', targetKobo: 80000000, targetDate: DateTime(2027, 3, 1)),
        online: false));
    final contribution = unwrap(await h.outbox.enqueueContribute(
        draft: const ContributeDraft(goalClientId: 'goal-1', goalName: 'Laptop', amountKobo: 500000),
        online: false));

    await sync.start();
    await sync.drain();

    expect((await h.outbox.byId(goal.id))!.status, OutboxStatus.succeeded);
    expect((await h.outbox.byId(contribution.id))!.status, OutboxStatus.succeeded);
    expect((await h.db.client.goalEntitys.getByClientId('goal-1'))!.savedKobo, 500000);
  });
}
