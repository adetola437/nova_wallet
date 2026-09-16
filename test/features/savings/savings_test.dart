import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/models/goal_view.dart';
import 'package:nova_wallet/core/network/backend_reachability.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';
import 'package:nova_wallet/features/savings/cubit/contribute_cubit.dart';
import 'package:nova_wallet/features/savings/cubit/contribute_state.dart';
import 'package:nova_wallet/features/savings/cubit/create_goal_cubit.dart';
import 'package:nova_wallet/features/savings/repository/savings_repository_impl.dart';
import 'package:nova_wallet/features/sync/cubit/sync_cubit.dart';
import 'package:nova_wallet/features/wallet/cubit/wallet_cubit.dart';
import 'package:nova_wallet/features/wallet/repository/wallet_repository_impl.dart';

import '../../support/fake_sync_notifier.dart';
import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

void main() {
  late OutboxHarness h;
  late ConnectivityCubit connectivity;
  late SyncCubit sync;
  late SavingsRepositoryImpl savings;
  late WalletCubit wallet;

  ContributeCubit contributeTo(GoalView goal) => ContributeCubit(
        goal: goal,
        outbox: h.outbox,
        auth: h.authRepository,
        wallet: wallet,
        sync: sync,
        connectivity: connectivity,
        outcomeWait: const Duration(milliseconds: 300),
      );

  Future<void> goOffline() async {
    h.network.connected = false;
    await connectivity.recheck();
  }

  Future<void> goOnlineAndSync() async {
    h.network.connected = true;
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sync.drain();
    await pumpEventQueue();
  }

  setUp(() async {
    h = await OutboxHarness.open(directory: await newTempDir(), tag: 'savings');
    await h.signIn();
    connectivity = ConnectivityCubit(
      reachability: Reachability(
          networkInfo: h.network, controls: h.server.controls, backend: const AlwaysReachable()),
      onlineDebounce: const Duration(milliseconds: 10),
    );
    await connectivity.start();
    sync = SyncCubit(
        outbox: h.outbox,
        connectivity: connectivity,
        notifier: FakeSyncNotifier(),
        backoff: (_) => const Duration(milliseconds: 20));
    savings = SavingsRepositoryImpl(db: h.db, api: h.server.server, session: h.session);
    wallet = WalletCubit(
      repository: WalletRepositoryImpl(db: h.db, api: h.server.server, session: h.session),
      sync: sync,
    );
    await wallet.start();
    await sync.start();
  });

  tearDown(() async {
    await wallet.close();
    await sync.close();
    await connectivity.close();
    await h.close(deleteFromDisk: true);
  });

  test('refresh brings the seeded goal down with 35% progress', () async {
    expect((await savings.refresh()).isRight(), isTrue);
    final goals = await savings.watchGoals().first;
    expect(goals.single.name, 'Rent — December');
    expect(goals.single.savedBps, 3500);
    expect(goals.single.syncState, GoalSyncState.synced);
  });

  test('a goal created offline appears immediately as pending, then syncs', () async {
    await goOffline();
    final create = CreateGoalCubit(outbox: h.outbox, sync: sync, connectivity: connectivity);
    create.nameChanged('Laptop');
    create.targetChanged('800,000');
    create.dateChanged(DateTime(2027, 3, 1));
    await create.submit();
    expect(create.state.failure, isNull);

    var goals = await savings.watchGoals().first;
    final created = goals.firstWhere((g) => g.name == 'Laptop');
    expect(created.syncState, GoalSyncState.pending);
    expect(created.targetKobo, 80000000);

    await goOnlineAndSync();

    goals = await savings.watchGoals().first;
    expect(goals.firstWhere((g) => g.name == 'Laptop').syncState, GoalSyncState.synced);
    await create.close();
  });

  test('create goal validation: name, target floor and a future date', () async {
    final create = CreateGoalCubit(outbox: h.outbox, sync: sync, connectivity: connectivity);
    await create.submit();
    expect((create.state.failure! as ValidationFailure).code, ValidationCode.invalidInput);

    create.nameChanged('Laptop');
    create.targetChanged('500');
    create.dateChanged(DateTime(2027, 3, 1));
    await create.submit();
    expect((create.state.failure! as ValidationFailure).code, ValidationCode.amountTooSmall);
    await create.close();
  });

  test('the weekly hint is computed from the target and date, never hard-coded', () async {
    final create = CreateGoalCubit(
        outbox: h.outbox, sync: sync, connectivity: connectivity, clock: () => DateTime(2026, 9, 16));
    create.targetChanged('600,000');
    create.dateChanged(DateTime(2026, 12, 20));
    // 95 days → 14 weeks → ₦42,857.15 (rounded UP so the goal is reachable).
    expect(create.state.suggestedWeeklyKobo, 4285715);
    await create.close();
  });

  test('a contribution queued offline shows as pending progress, not saved progress', () async {
    await savings.refresh();
    final goal = (await savings.watchGoals().first).single;
    await goOffline();

    final contribute = contributeTo(goal);
    contribute.amountChanged('5,000');
    await contribute.submit(AppConstants.demoPin);

    expect(contribute.state.outcome, ContributeOutcome.pending);
    final pending = (await savings.watchGoals().first).single;
    expect(pending.savedKobo, 21000000);
    expect(pending.pendingKobo, 500000);
    expect(pending.projectedBps, 3583);

    await goOnlineAndSync();

    final synced = (await savings.watchGoals().first).single;
    expect(synced.savedKobo, 21500000);
    expect(synced.pendingKobo, 0);
    await contribute.close();
  });

  test('the wrong PIN never queues anything', () async {
    await savings.refresh();
    final goal = (await savings.watchGoals().first).single;
    final contribute = contributeTo(goal);
    contribute.amountChanged('5,000');
    await contribute.submit('9999');
    expect(contribute.state.pinError, isTrue);
    expect(await h.outbox.activeItems(), isEmpty);
    await contribute.close();
  });
}
