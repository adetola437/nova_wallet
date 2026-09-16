import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/auth/secret_hasher.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/core/storage/session_store.dart';
import 'package:nova_wallet/features/auth/cubit/auth_cubit.dart';
import 'package:nova_wallet/features/auth/cubit/auth_state.dart';
import 'package:nova_wallet/features/auth/cubit/login_cubit.dart';
import 'package:nova_wallet/features/auth/cubit/signup_cubit.dart';
import 'package:nova_wallet/features/auth/cubit/signup_state.dart';
import 'package:nova_wallet/features/auth/cubit/unlock_cubit.dart';
import 'package:nova_wallet/features/auth/repository/auth_repository_impl.dart';
import 'package:nova_wallet/features/settings/repository/settings_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/fake_biometric_gate.dart';
import '../../support/in_memory_secure_storage.dart';
import '../../support/isar_test_db.dart';
import '../../support/server_harness.dart';

void main() {
  late ServerHarness h;
  late AuthRepositoryImpl repo;
  late SettingsRepositoryImpl settings;
  late AuthCubit auth;
  late FakeBiometricGate gate;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    h = await ServerHarness.open(directory: await newTempDir(), tag: 'authcubit');
    final local = LocalStorageImpl(prefs: await SharedPreferences.getInstance());
    repo = AuthRepositoryImpl(
      remote: h.server,
      session: SessionStore(secureStorage: InMemorySecureStorage(), hasher: SecretHasher()),
      db: h.db,
      localStorage: local,
      hasher: SecretHasher(),
    );
    settings = SettingsRepositoryImpl(localStorage: local);
    auth = AuthCubit(repository: repo, settings: settings);
    gate = FakeBiometricGate();
  });

  tearDown(() async {
    await auth.close();
    await h.close(deleteFromDisk: true);
  });

  test('bootstrap: first launch needs onboarding, then unauthenticated', () async {
    await auth.bootstrap();
    expect(auth.state.status, AuthStatus.needsOnboarding);
    await auth.completeOnboarding();
    expect(auth.state.status, AuthStatus.unauthenticated);
  });

  test('bootstrap with a stored session goes to locked, not authenticated', () async {
    await repo.login(identifier: AppConstants.demoPhone, password: AppConstants.demoPassword);
    await auth.bootstrap();
    expect(auth.state.status, AuthStatus.locked);
    expect(auth.state.profile!.firstName, 'Tolu');
  });

  test('login cubit signs in through AuthCubit', () async {
    final login = LoginCubit(repository: repo, authCubit: auth);
    await login.submit(identifier: AppConstants.demoPhone, password: 'wrong');
    expect(login.state.failure, isNotNull);
    expect(auth.state.status, isNot(AuthStatus.authenticated));
    await login.submit(identifier: AppConstants.demoPhone, password: AppConstants.demoPassword);
    expect(auth.state.status, AuthStatus.authenticated);
    await login.close();
  });

  test('login cubit passes an email through untouched and rejects junk', () async {
    final login = LoginCubit(repository: repo, authCubit: auth);
    await login.submit(identifier: 'not a phone', password: 'x');
    expect((login.state.failure! as ValidationFailure).code, ValidationCode.invalidInput);
    // The fake backend is phone-based, so an email reaches it and is refused
    // there — proving the cubit did not try to normalise it.
    await login.submit(identifier: AppConstants.demoEmail, password: AppConstants.demoPassword);
    expect(login.state.failure, isA<BusinessFailure>());
    await login.close();
  });

  test('signup walks phone → otp → details → bvn → pin and ends authenticated', () async {
    final signup = SignupCubit(repository: repo, authCubit: auth);
    await signup.submitPhone('09031234567');
    expect(signup.state.step, SignupStep.otp);
    await signup.submitOtp('000000');
    expect(signup.state.failure, isNotNull);
    await signup.submitOtp(AppConstants.fakeOtp);
    expect(signup.state.step, SignupStep.details);
    await signup.submitDetails(fullName: 'Tolu Ade', email: 't@x.com', password: 'Secret#123');
    expect(signup.state.step, SignupStep.bvn);
    await signup.submitBvn('22123456789');
    expect(signup.state.step, SignupStep.pin);
    await signup.submitPin('1357');
    expect(signup.state.step, SignupStep.done);
    expect(auth.state.status, AuthStatus.authenticated);
    expect(auth.state.profile!.tier, 2);
    expect(await repo.verifyPin('1357'), isTrue);
    await signup.close();
  });

  test('unlock: wrong PIN cools down after 3 and signs out after 5', () async {
    await repo.login(identifier: AppConstants.demoPhone, password: AppConstants.demoPassword);
    await auth.bootstrap();
    var now = DateTime(2026, 9, 16, 9);
    final unlock = UnlockCubit(
        repository: repo, settings: settings, biometricGate: gate, authCubit: auth, clock: () => now);

    for (var i = 0; i < 3; i++) {
      await unlock.unlockWithPin('0000');
    }
    expect(unlock.state.failedAttempts, 3);
    expect(unlock.state.isLocked, isTrue);
    expect(auth.state.status, AuthStatus.locked);

    // While cooling down, an attempt is refused without counting.
    await unlock.unlockWithPin('0000');
    expect(unlock.state.failedAttempts, 3);

    // After the cooldown the remaining attempts count, and the 5th signs out.
    now = now.add(const Duration(seconds: 31));
    await unlock.unlockWithPin('0000');
    expect(unlock.state.failedAttempts, 4);
    now = now.add(const Duration(seconds: 31));
    await unlock.unlockWithPin('0000');
    expect(auth.state.status, AuthStatus.unauthenticated);
    await unlock.close();
  });

  test('unlock with biometrics works offline', () async {
    await repo.login(identifier: AppConstants.demoPhone, password: AppConstants.demoPassword);
    await auth.bootstrap();
    await settings.setBiometricEnabled(true);
    h.controls.simulateOffline = true;

    final unlock = UnlockCubit(repository: repo, settings: settings, biometricGate: gate, authCubit: auth);
    expect(await unlock.biometricAvailable(), isTrue);
    await unlock.unlockWithBiometric();
    expect(auth.state.status, AuthStatus.authenticated);
    expect(gate.confirmCalls, 1);
    await unlock.close();
  });
}
