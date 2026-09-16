import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/models/activity_item.dart';
import 'package:nova_wallet/core/models/beneficiary.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/network/backend_reachability.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/core/storage/entities/transaction_entity.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';
import 'package:nova_wallet/features/sync/cubit/sync_cubit.dart';
import 'package:nova_wallet/features/sync/repository/outbox_repository.dart';
import 'package:nova_wallet/features/wallet/cubit/wallet_cubit.dart';
import 'package:nova_wallet/features/wallet/repository/wallet_repository_impl.dart';

import '../../support/fake_sync_notifier.dart';
import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

const ada = Beneficiary(
    accountNumber: '0248214821', bankCode: '058', bankName: 'GTBank', verifiedName: 'ADAEZE OKAFOR');

OutboxItem unwrap(Either<Failure, OutboxItem> e) =>
    e.fold((f) => fail('expected Right, got $f'), (r) => r);

void main() {
  late OutboxHarness h;
  late WalletRepositoryImpl wallet;

  setUp(() async {
    h = await OutboxHarness.open(directory: await newTempDir(), tag: 'wallet');
    await h.signIn();
    wallet = WalletRepositoryImpl(db: h.db, api: h.server.server, session: h.session);
  });
  tearDown(() => h.close(deleteFromDisk: true));

  test('refresh pulls the balance, profile and history into Isar', () async {
    await h.setLedger(0);
    expect((await wallet.refresh()).isRight(), isTrue);
    final overview = await wallet.currentOverview();
    expect(overview.ledgerKobo, AppConstants.demoOpeningBalanceKobo);
    expect(overview.availableKobo, AppConstants.demoOpeningBalanceKobo);
    expect(await h.db.client.transactionEntitys.count(), 60);
  });

  test('refresh while offline keeps cached data and reports the failure', () async {
    await wallet.refresh();
    h.server.controls.simulateOffline = true;
    final result = await wallet.refresh();
    expect(result.swap().getOrElse(() => throw StateError('x')), isA<NetworkFailure>());
    expect((await wallet.currentOverview()).ledgerKobo, AppConstants.demoOpeningBalanceKobo);
    expect(await h.db.client.transactionEntitys.count(), 60);
  });

  test('available balance subtracts pending holds as soon as an item is queued', () async {
    await wallet.refresh();
    final overviews = <int>[];
    final sub = wallet.watchOverview().listen((o) => overviews.add(o.availableKobo));
    await pumpEventQueue();

    unwrap(await h.outbox.enqueueSend(
        draft: const SendDraft(beneficiary: ada, amountKobo: 2500000, feeKobo: 2688), online: false));
    await pumpEventQueue();

    expect(overviews.first, AppConstants.demoOpeningBalanceKobo);
    expect(overviews.last, AppConstants.demoOpeningBalanceKobo - 2502688);
    final current = await wallet.currentOverview();
    expect(current.heldKobo, 2502688);
    expect(current.pendingCount, 1);
    await sub.cancel();
  });

  test('SIGN-OUT RACE: reset waits for an in-flight refresh, so nothing writes after the wipe', () async {
    final connectivity = ConnectivityCubit(
      reachability: Reachability(
          networkInfo: h.network, controls: h.server.controls, backend: const AlwaysReachable()),
      onlineDebounce: const Duration(milliseconds: 10),
    );
    await connectivity.start();
    final sync = SyncCubit(outbox: h.outbox, connectivity: connectivity, notifier: FakeSyncNotifier());
    // Slow server, so the refresh is genuinely still in flight when we reset.
    h.server.controls.setLatencyMs(100);
    final cubit = WalletCubit(repository: wallet, sync: sync);
    unawaited(cubit.start());
    await Future<void>.delayed(const Duration(milliseconds: 30));

    await cubit.reset(); // must not return until the refresh has landed
    await h.db.clearClient(); // what sign-out does next

    // The refresh makes two ~100 ms calls. Wait well past both, so a late write
    // (the bug) has every chance to land before we look.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    expect(await h.db.client.transactionEntitys.count(), 0,
        reason: 'a refresh that landed after the wipe would have re-inserted history');

    await cubit.close();
    await sync.close();
    await connectivity.close();
  });

  test('activity shows pending items above settled history', () async {
    await wallet.refresh();
    unwrap(await h.outbox.enqueueSend(
        draft: const SendDraft(beneficiary: ada, amountKobo: 2500000, feeKobo: 2688), online: false));
    final activity = await wallet.watchActivity(limit: 10).first;

    expect(activity.first.status, ActivityStatus.pending);
    expect(activity.first.title, 'ADAEZE OKAFOR');
    expect(activity.first.signedKobo, -2502688);
    expect(activity.skip(1).every((a) => a.status == ActivityStatus.completed), isTrue);
    expect(activity.length, 10);
  });
}
