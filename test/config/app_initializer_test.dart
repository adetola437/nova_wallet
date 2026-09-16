import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/di/app_initializer.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/fake/fake_server_controls.dart';
import 'package:nova_wallet/features/auth/cubit/auth_cubit.dart';
import 'package:nova_wallet/features/auth/cubit/auth_state.dart';
import 'package:nova_wallet/features/auth/cubit/login_cubit.dart';
import 'package:nova_wallet/features/beneficiaries/cubit/beneficiaries_cubit.dart';
import 'package:nova_wallet/features/savings/cubit/savings_cubit.dart';
import 'package:nova_wallet/features/send_money/cubit/send_money_cubit.dart';
import 'package:nova_wallet/features/sync/cubit/sync_cubit.dart';
import 'package:nova_wallet/features/wallet/cubit/wallet_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/eventually.dart';
import '../support/fake_biometric_gate.dart';
import '../support/fake_network_info.dart';
import '../support/fake_sync_notifier.dart';
import '../support/in_memory_secure_storage.dart';
import '../support/isar_test_db.dart';

Future<void> boot(String dir) async {
  SharedPreferences.setMockInitialValues({});
  await AppInitializer.init(
    directory: dir,
    networkInfo: FakeNetworkInfo(),
    secureStorage: InMemorySecureStorage(),
    biometricGate: FakeBiometricGate(),
    notifier: FakeSyncNotifier(),
    preferences: await SharedPreferences.getInstance(),
    controls: FakeServerControls(minLatency: Duration.zero, maxLatency: Duration.zero),
    backend: 'fake',
  );
}

void main() {
  setUpAll(() async => openTestDb(directory: await newTempDir(), tag: 'core-warmup').then((db) => db.close()));
  tearDown(() => AppInitializer.dispose());

  test('the container wires the whole graph and bootstraps to onboarding', () async {
    await boot(await newTempDir());

    expect(sl<AuthCubit>().state.status, AuthStatus.needsOnboarding);
    expect(sl<SyncCubit>(), same(sl<SyncCubit>()), reason: 'singleton');
    expect(sl<SendMoneyCubit>(), isNot(same(sl<SendMoneyCubit>())), reason: 'factory per send');
    expect(sl<WalletCubit>(), isNotNull);
    expect(sl<BeneficiariesCubit>(), isNotNull);
    expect(sl<SavingsCubit>(), isNotNull);
  });

  test('signing in starts the session-scoped cubits; signing out clears them', () async {
    await boot(await newTempDir());

    final login = LoginCubit(repository: sl(), authCubit: sl<AuthCubit>());
    await login.submit(identifier: AppConstants.demoPhone, password: AppConstants.demoPassword);
    await login.close();
    expect(sl<AuthCubit>().state.status, AuthStatus.authenticated);

    await eventually(() => sl<WalletCubit>().state.overview.ledgerKobo == AppConstants.demoOpeningBalanceKobo,
        reason: 'wallet loaded the demo balance');
    await eventually(() => sl<BeneficiariesCubit>().state.length == 4, reason: 'beneficiaries cached');
    await eventually(() => sl<SavingsCubit>().state.length == 1, reason: 'seeded goal loaded');

    await sl<AuthCubit>().signOut();
    await AppInitializer.settled;
    expect(sl<WalletCubit>().state.overview.ledgerKobo, 0);
    expect(sl<SavingsCubit>().state, isEmpty);
    expect(sl<BeneficiariesCubit>().state, isEmpty);
  });
}
