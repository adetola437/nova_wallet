import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:nova_wallet/config/di/app_initializer.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/fake/entities/server_entities.dart';
import 'package:nova_wallet/core/api/fake/fake_server_controls.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/storage/isar_db.dart';
import 'package:nova_wallet/features/auth/cubit/auth_cubit.dart';
import 'package:nova_wallet/features/auth/cubit/auth_state.dart';
import 'package:nova_wallet/features/auth/cubit/login_cubit.dart';
import 'package:nova_wallet/features/beneficiaries/cubit/beneficiaries_cubit.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';
import 'package:nova_wallet/features/savings/cubit/contribute_cubit.dart';
import 'package:nova_wallet/features/savings/cubit/contribute_state.dart';
import 'package:nova_wallet/features/savings/cubit/savings_cubit.dart';
import 'package:nova_wallet/features/send_money/cubit/send_money_cubit.dart';
import 'package:nova_wallet/features/send_money/cubit/send_money_state.dart';
import 'package:nova_wallet/features/sync/cubit/sync_cubit.dart';
import 'package:nova_wallet/features/sync/repository/outbox_repository.dart';
import 'package:nova_wallet/features/wallet/cubit/wallet_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'eventually.dart';
import 'fake_biometric_gate.dart';
import 'fake_network_info.dart';
import 'fake_sync_notifier.dart';
import 'in_memory_secure_storage.dart';

/// The scenario the brief grades: queue while offline, kill the app, start it
/// again, reconnect, and confirm each action reached the server EXACTLY once.
///
/// [secure] and [preferences] survive the "restart", exactly as the keychain
/// and SharedPreferences do on a real device. Everything else is rebuilt.
Future<void> runOfflineRestartScenario({
  required String directory,
  required FakeNetworkInfo network,
  required InMemorySecureStorage secure,
  required SharedPreferences preferences,
  required FakeSyncNotifier notifier,
}) async {
  Future<void> boot() => AppInitializer.init(
        directory: directory,
        networkInfo: network,
        secureStorage: secure,
        biometricGate: FakeBiometricGate(available: false),
        notifier: notifier,
        preferences: preferences,
        controls: FakeServerControls(minLatency: Duration.zero, maxLatency: Duration.zero),
        backend: 'fake',
      );

  const transferDebit = 2502688; // ₦25,000.00 + ₦26.88 fee
  const contribution = 500000; //   ₦5,000.00, no fee
  const opening = AppConstants.demoOpeningBalanceKobo;

  // ── 1. Sign in while online ───────────────────────────────────────────────
  network.connected = true;
  await boot();
  final login = LoginCubit(repository: sl(), authCubit: sl<AuthCubit>());
  await login.submit(identifier: AppConstants.demoPhone, password: AppConstants.demoPassword);
  await login.close();
  expect(sl<AuthCubit>().state.status, AuthStatus.authenticated);

  await eventually(() => sl<WalletCubit>().state.overview.ledgerKobo == opening, reason: 'balance loaded');
  await eventually(() => sl<BeneficiariesCubit>().state.isNotEmpty, reason: 'recipients cached');
  await eventually(() => sl<SavingsCubit>().state.isNotEmpty, reason: 'goal loaded');
  final recipient = sl<BeneficiariesCubit>().state.first;
  final goal = sl<SavingsCubit>().state.first;

  // ── 2. Go offline; queue a transfer and a contribution ───────────────────
  network.connected = false;
  await sl<ConnectivityCubit>().recheck();
  expect(sl<ConnectivityCubit>().isOnline, isFalse);

  final send = sl<SendMoneyCubit>()
    ..selectRecipient(recipient)
    ..amountChanged('25,000');
  await send.continueToReview();
  await send.authoriseWithPin(AppConstants.demoPin);
  expect(send.state.outcome, SendOutcome.pending, reason: 'offline send must be Pending, not lost');
  await send.close();

  final contribute = ContributeCubit(
    goal: goal,
    outbox: sl(),
    auth: sl(),
    wallet: sl<WalletCubit>(),
    sync: sl<SyncCubit>(),
    connectivity: sl(),
  )..amountChanged('5,000');
  await contribute.submit(AppConstants.demoPin);
  expect(contribute.state.outcome, ContributeOutcome.pending);
  await contribute.close();

  final queued = await sl<IOutboxRepository>().activeItems();
  expect(queued.length, 2);
  await eventually(() => sl<WalletCubit>().state.overview.availableKobo == opening - transferDebit - contribution,
      reason: 'both amounts held from the available balance');
  expect(await _serverBalance(), opening, reason: 'nothing has reached the server yet');

  final keys = queued.map((i) => i.idempotencyKey).toList();

  // ── 3. Kill the app while still offline, then start it again ─────────────
  await AppInitializer.dispose();
  await boot();
  expect(sl<AuthCubit>().state.status, AuthStatus.locked, reason: 'the session survived the restart');

  final afterRestart = await sl<IOutboxRepository>().activeItems();
  expect(afterRestart.length, 2, reason: 'the queue survived the restart');
  expect(afterRestart.map((i) => i.idempotencyKey).toList(), keys, reason: 'same keys, never regenerated');
  expect(afterRestart.every((i) => i.status == OutboxStatus.queued), isTrue);
  expect(await _serverBalance(), opening, reason: 'still nothing sent while offline');

  // ── 4. Reconnect on a flapping connection, with two replays racing ───────
  network.connected = true;
  network.connected = false;
  network.connected = true;
  await eventually(() => sl<ConnectivityCubit>().isOnline, reason: 'back online after the debounce');
  await Future.wait([sl<SyncCubit>().drain(), sl<SyncCubit>().drain()]);
  await eventually(() async => (await sl<IOutboxRepository>().activeItems()).isEmpty,
      timeout: const Duration(seconds: 10), reason: 'queue drained');

  // ── 5. Exactly once ──────────────────────────────────────────────────────
  final server = sl<IsarDb>().server;
  for (final key in keys) {
    expect(await server.processedRequests.getByIdempotencyKey(key), isNotNull, reason: 'key $key processed');
    expect(await server.serverTransactions.filter().idempotencyKeyEqualTo(key).count(), 1,
        reason: 'key $key produced exactly one transaction');
  }
  expect(await _serverBalance(), opening - transferDebit - contribution, reason: 'debited exactly once each');
  expect(notifier.succeeded.length, 2, reason: 'both queued actions notified the user');
  expect(notifier.failed, isEmpty);

  await AppInitializer.dispose();
}

Future<int> _serverBalance() async =>
    (await sl<IsarDb>().server.serverAccounts.getByPhone(AppConstants.demoPhone))!.balanceKobo;
