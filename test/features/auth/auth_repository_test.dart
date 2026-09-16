import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/api/fake/entities/server_entities.dart';
import 'package:nova_wallet/core/auth/secret_hasher.dart';
import 'package:nova_wallet/core/models/activity_item.dart';
import 'package:nova_wallet/core/storage/entities/transaction_entity.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/core/storage/session_store.dart';
import 'package:nova_wallet/features/auth/repository/auth_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_secure_storage.dart';
import '../../support/isar_test_db.dart';
import '../../support/server_harness.dart';

void main() {
  late ServerHarness h;
  late AuthRepositoryImpl repo;
  late InMemorySecureStorage secure;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    h = await ServerHarness.open(directory: await newTempDir(), tag: 'auth');
    secure = InMemorySecureStorage();
    repo = AuthRepositoryImpl(
      remote: h.server,
      session: SessionStore(secureStorage: secure, hasher: SecretHasher()),
      db: h.db,
      localStorage: LocalStorageImpl(prefs: await SharedPreferences.getInstance()),
      hasher: SecretHasher(),
    );
  });
  tearDown(() => h.close(deleteFromDisk: true));

  test('login stores the token in secure storage and caches the profile', () async {
    final profile = (await repo.login(identifier: AppConstants.demoPhone, password: AppConstants.demoPassword))
        .getOrElse(() => throw StateError('login failed'));
    expect(profile.firstName, 'Tolu');
    expect(await repo.hasSession(), isTrue);
    expect(secure.values[SecureKeys.sessionToken], startsWith('nova_'));
    expect((await repo.cachedProfile())!.phone, AppConstants.demoPhone);
    // The demo account already has a PIN, so login carries its hash down.
    expect(await repo.hasPin(), isTrue);
    expect(await repo.verifyPin(AppConstants.demoPin), isTrue);
    expect(await repo.verifyPin('9999'), isFalse);
  });

  test('wrong password leaves no session', () async {
    final result = await repo.login(identifier: AppConstants.demoPhone, password: 'wrong');
    expect(result.isLeft(), isTrue);
    expect(await repo.hasSession(), isFalse);
  });

  test('register then createPin: PIN verifies offline afterwards', () async {
    final profile = (await repo.register(
            phone: '09031234567', fullName: 'Tolu Ade', email: 't@x.com', password: 'Secret#123'))
        .getOrElse(() => throw StateError('register failed'));
    expect(profile.tier, 1);
    expect(await repo.hasPin(), isFalse);
    expect((await repo.createPin('1357')).isRight(), isTrue);
    expect(await repo.verifyPin('1357'), isTrue);

    final upgraded = (await repo.verifyBvn('22123456789')).getOrElse(() => throw StateError('bvn failed'));
    expect(upgraded.tier, 2);
    expect((await repo.cachedProfile())!.tier, 2);
  });

  test('signOut clears session, PIN and all client data (server keeps its own)', () async {
    await repo.login(identifier: AppConstants.demoPhone, password: AppConstants.demoPassword);
    await h.db.client.writeTxn(() => h.db.client.transactionEntitys.put(TransactionEntity()
      ..serverRef = 'x'
      ..kind = ActivityKind.transfer
      ..direction = ActivityDirection.debit
      ..amountKobo = 1
      ..title = 't'
      ..createdAt = DateTime(2026, 9, 15)));
    await repo.signOut();
    expect(await repo.hasSession(), isFalse);
    expect(await repo.hasPin(), isFalse);
    expect(await repo.cachedProfile(), isNull);
    expect(await h.db.client.transactionEntitys.count(), 0);
    expect(await h.db.server.serverAccounts.count(), greaterThan(0));
  });

  test('offline register surfaces a NetworkFailure', () async {
    h.controls.simulateOffline = true;
    final result = await repo.register(phone: '09031234567', fullName: 'T', email: 't@x.com', password: 'Secret#123');
    expect(result.swap().getOrElse(() => throw StateError('expected failure')), isA<NetworkFailure>());
  });
}
