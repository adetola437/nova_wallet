import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/fake/entities/server_entities.dart';
import 'package:nova_wallet/core/auth/biometric_signer.dart';
import 'package:nova_wallet/core/storage/entities/transaction_entity.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/features/auth/cubit/auth_cubit.dart';
import 'package:nova_wallet/features/auth/cubit/auth_state.dart';
import 'package:nova_wallet/features/developer/cubit/developer_cubit.dart';
import 'package:nova_wallet/features/developer/repository/developer_repository_impl.dart';
import 'package:nova_wallet/features/settings/cubit/biometric_settings_cubit.dart';
import 'package:nova_wallet/features/settings/repository/settings_repository_impl.dart';
import 'package:nova_wallet/features/wallet/repository/wallet_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/fake_biometric_gate.dart';
import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

void main() {
  late OutboxHarness h;
  late DeveloperCubit dev;
  late AuthCubit auth;
  late LocalStorageImpl local;

  DeveloperRepositoryImpl repo() => DeveloperRepositoryImpl(
        localStorage: local,
        controls: h.server.controls,
        outbox: h.outbox,
        admin: h.server.server,
        db: h.db,
      );

  setUp(() async {
    h = await OutboxHarness.open(directory: await newTempDir(), tag: 'dev');
    await h.signIn();
    local = LocalStorageImpl(prefs: await SharedPreferences.getInstance());
    auth = AuthCubit(repository: h.authRepository, settings: SettingsRepositoryImpl(localStorage: local));
    dev = DeveloperCubit(repository: repo(), authCubit: auth);
  });

  tearDown(() async {
    await dev.close();
    await auth.close();
    await h.close(deleteFromDisk: true);
  });

  test('simulate-offline is persisted and survives a restart', () async {
    await dev.load();
    expect(dev.state.simulateOffline, isFalse);
    await dev.setSimulateOffline(true);
    expect(h.server.controls.simulateOffline, isTrue);
    expect(dev.state.simulateOffline, isTrue);

    // A fresh repository (as after a restart) restores the switch.
    h.server.controls.simulateOffline = false;
    final restored = await repo().load();
    expect(restored.simulateOffline, isTrue);
    expect(h.server.controls.simulateOffline, isTrue);
  });

  test('latency and lose-next-response reach the controls', () async {
    await dev.load();
    await dev.setLatency(900);
    expect(h.server.controls.maxLatency.inMilliseconds, 900);
    dev.setLoseNextResponse(true);
    expect(h.server.controls.loseNextResponse, isTrue);
  });

  test('reset demo data wipes local and backend data, reseeds, and signs out', () async {
    await WalletRepositoryImpl(db: h.db, api: h.server.server, session: h.session).refresh();
    expect(await h.db.client.transactionEntitys.count(), 60);

    await dev.load();
    await dev.resetDemoData();

    expect(await h.db.client.transactionEntitys.count(), 0);
    expect(await h.db.server.processedRequests.count(), 0);
    // The demo account is seeded again so the next login works.
    expect(await h.db.server.serverAccounts.getByPhone(AppConstants.demoPhone), isNotNull);
    expect(auth.state.status, AuthStatus.unauthenticated);
  });

  group('biometric settings', () {
    test('enabling creates the key even though it was unavailable beforehand', () async {
      final gate = FakeBiometricGate(available: false);
      final settings = SettingsRepositoryImpl(localStorage: local);
      final cubit = BiometricSettingsCubit(settings: settings, gate: gate);
      await cubit.load();
      expect(cubit.state.enabled, isFalse);

      await cubit.toggle(true);
      expect(cubit.state.enabled, isTrue);
      expect(await settings.biometricEnabled(), isTrue);

      await cubit.toggle(false);
      expect(cubit.state.enabled, isFalse);
      expect(gate.available, isFalse);
      await cubit.close();
    });

    test('a failed enrolment leaves biometrics off and reports why', () async {
      final gate = FakeBiometricGate(available: false)..nextError = BiometricSignerError.notEnrolled;
      final settings = SettingsRepositoryImpl(localStorage: local);
      final cubit = BiometricSettingsCubit(settings: settings, gate: gate);
      await cubit.toggle(true);
      expect(cubit.state.enabled, isFalse);
      expect(cubit.state.error, BiometricSignerError.notEnrolled);
      expect(await settings.biometricEnabled(), isFalse);
      await cubit.close();
    });
  });
}
