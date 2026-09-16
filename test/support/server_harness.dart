import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/fake/entities/server_entities.dart';
import 'package:nova_wallet/core/api/fake/fake_nova_server.dart';
import 'package:nova_wallet/core/api/fake/fake_server_controls.dart';
import 'package:nova_wallet/core/auth/secret_hasher.dart';
import 'package:nova_wallet/core/network/backend_reachability.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/core/storage/isar_db.dart';

import 'fake_network_info.dart';
import 'isar_test_db.dart';

/// The fake backend on a real Isar instance, with scriptable connectivity.
class ServerHarness {
  ServerHarness._(this.db, this.network, this.controls, this.reachability, this.server);

  final IsarDb db;
  final FakeNetworkInfo network;
  final FakeServerControls controls;
  final Reachability reachability;
  final FakeNovaServer server;

  static Future<ServerHarness> open({
    required String directory,
    required String tag,
    FakeNetworkInfo? network,
    FakeServerControls? controls,
  }) async {
    final db = await openTestDb(directory: directory, tag: tag);
    final net = network ?? FakeNetworkInfo();
    final ctl = controls ?? FakeServerControls(minLatency: Duration.zero, maxLatency: Duration.zero);
    final reach = Reachability(networkInfo: net, controls: ctl, backend: const AlwaysReachable());
    final server = FakeNovaServer(db: db.server, reachability: reach, controls: ctl, hasher: SecretHasher());
    await server.ensureSeeded();
    return ServerHarness._(db, net, ctl, reach, server);
  }

  Future<String> demoToken() async => (await server.login(
        identifier: AppConstants.demoPhone,
        password: AppConstants.demoPassword,
      ))
          .fold((f) => throw StateError(f.message), (s) => s.token);

  Future<int> balanceOf(String phone) async =>
      (await db.server.serverAccounts.getByPhone(phone))!.balanceKobo;

  Future<void> close({bool deleteFromDisk = false}) => db.close(deleteFromDisk: deleteFromDisk);
}
