import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:nova_wallet/core/storage/isar_db.dart';

bool _coreReady = false;

Future<String> newTempDir() async =>
    (await Directory.systemTemp.createTemp('nova_test')).path;

/// Opens client + server Isar in [directory]. Reopening with the same [tag]
/// and directory reads the same data back, which is how tests simulate a restart.
Future<IsarDb> openTestDb({required String directory, required String tag}) async {
  if (!_coreReady) {
    await Isar.initializeIsarCore(download: true);
    _coreReady = true;
  }
  return IsarDb.open(directory: directory, clientName: 'client_$tag', serverName: 'server_$tag');
}
