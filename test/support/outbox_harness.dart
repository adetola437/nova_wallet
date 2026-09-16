import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/auth/secret_hasher.dart';
import 'package:nova_wallet/core/storage/entities/wallet_snapshot_entity.dart';
import 'package:nova_wallet/core/storage/isar_db.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/core/storage/session_store.dart';
import 'package:nova_wallet/features/auth/repository/auth_repository_impl.dart';
import 'package:nova_wallet/features/sync/repository/outbox_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_network_info.dart';
import 'in_memory_secure_storage.dart';
import 'server_harness.dart';

/// Client-side wiring for outbox/sync tests: a real Isar client DB, the fake
/// server, a real auth repository (so PIN checks work) and a signed-in session.
class OutboxHarness {
  OutboxHarness._(this.server, this.session, this.outbox, this.secure, this.authRepository);

  final ServerHarness server;
  final SessionStore session;
  final OutboxRepositoryImpl outbox;
  final InMemorySecureStorage secure;
  final AuthRepositoryImpl authRepository;

  IsarDb get db => server.db;
  FakeNetworkInfo get network => server.network;

  static Future<OutboxHarness> open({
    required String directory,
    required String tag,
    InMemorySecureStorage? secureStorage,
    FakeNetworkInfo? network,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final serverHarness = await ServerHarness.open(directory: directory, tag: tag, network: network);
    final secure = secureStorage ?? InMemorySecureStorage();
    final session = SessionStore(secureStorage: secure, hasher: SecretHasher());
    final outbox = OutboxRepositoryImpl(db: serverHarness.db, api: serverHarness.server, session: session);
    final auth = AuthRepositoryImpl(
      remote: serverHarness.server,
      session: session,
      db: serverHarness.db,
      localStorage: LocalStorageImpl(prefs: prefs),
      hasher: SecretHasher(),
    );
    return OutboxHarness._(serverHarness, session, outbox, secure, auth);
  }

  /// Logs in as the demo account, so the token AND the demo PIN hash are on the
  /// device, then seeds the local ledger.
  Future<void> signIn() async {
    await authRepository.login(identifier: AppConstants.demoPhone, password: AppConstants.demoPassword);
    await setLedger(AppConstants.demoOpeningBalanceKobo);
  }

  Future<void> setLedger(int kobo) => db.client.writeTxn(() => db.client.walletSnapshotEntitys.put(
        WalletSnapshotEntity()
          ..id = 0
          ..ledgerBalanceKobo = kobo
          ..lastSyncedAt = DateTime(2026, 9, 16),
      ));

  Future<int> ledger() async => (await db.client.walletSnapshotEntitys.get(0))!.ledgerBalanceKobo;

  Future<void> close({bool deleteFromDisk = false}) => server.close(deleteFromDisk: deleteFromDisk);
}
