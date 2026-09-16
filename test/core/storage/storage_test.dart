import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:nova_wallet/core/auth/secret_hasher.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/storage/entities/outbox_item_entity.dart';
import 'package:nova_wallet/core/storage/isar_db.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/core/storage/session_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_secure_storage.dart';
import '../../support/isar_test_db.dart';

void main() {
  late IsarDb db;

  setUp(() async => db = await openTestDb(directory: await newTempDir(), tag: 'storage'));
  tearDown(() => db.close(deleteFromDisk: true));

  OutboxItemEntity item(String key) => OutboxItemEntity()
    ..idempotencyKey = key
    ..type = OutboxType.send
    ..status = OutboxStatus.queued
    ..amountKobo = 100
    ..payloadJson = '{}'
    ..createdAt = DateTime(2026, 9, 15);

  test('idempotency keys are unique at the database level', () async {
    await db.client.writeTxn(() => db.client.outboxItemEntitys.put(item('k1')));
    expect(
      () => db.client.writeTxn(() => db.client.outboxItemEntitys.put(item('k1'))),
      throwsA(isA<IsarError>()),
    );
  });

  test('reopening the same directory keeps data (restart)', () async {
    final dir = await newTempDir();
    var first = await openTestDb(directory: dir, tag: 'restart');
    await first.client.writeTxn(() => first.client.outboxItemEntitys.put(item('persisted')));
    await first.close();
    first = await openTestDb(directory: dir, tag: 'restart');
    expect(await first.client.outboxItemEntitys.getByIdempotencyKey('persisted'), isNotNull);
    await first.close(deleteFromDisk: true);
  });

  test('SessionStore keeps token + PIN hash in secure storage only', () async {
    final secure = InMemorySecureStorage();
    final hasher = SecretHasher();
    final store = SessionStore(secureStorage: secure, hasher: hasher);
    final salt = hasher.newSalt();
    await store.saveToken('tok');
    await store.savePinHash(hash: hasher.hash('1234', salt), salt: salt);
    expect(await store.readToken(), 'tok');
    expect(await store.hasPin(), isTrue);
    expect(await store.verifyPin('1234'), isTrue);
    expect(await store.verifyPin('0000'), isFalse);
    expect(secure.values.values, isNot(contains('1234')));
    await store.clear();
    expect(await store.readToken(), isNull);
    expect(await store.hasPin(), isFalse);
  });

  test('LocalStorage round-trips non-sensitive prefs', () async {
    SharedPreferences.setMockInitialValues({});
    final local = LocalStorageImpl(prefs: await SharedPreferences.getInstance());
    expect(await local.getOnboardingSeen(), isFalse);
    await local.saveOnboardingSeen(true);
    await local.saveLocaleCode('yo');
    await local.saveBiometricEnabled(true);
    await local.saveSimulateOffline(true);
    await local.saveLatencyMs(900);
    expect(await local.getOnboardingSeen(), isTrue);
    expect(await local.getLocaleCode(), 'yo');
    expect(await local.getSimulateOffline(), isTrue);
    expect(await local.getLatencyMs(), 900);
    await local.clearSessionScoped();
    expect(await local.getBiometricEnabled(), isFalse);
    expect(await local.getOnboardingSeen(), isTrue);
  });
}
