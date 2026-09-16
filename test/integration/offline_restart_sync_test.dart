import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_network_info.dart';
import '../support/fake_sync_notifier.dart';
import '../support/in_memory_secure_storage.dart';
import '../support/isar_test_db.dart';
import '../support/offline_restart_scenario.dart';

/// Host-side run of the graded scenario (fast; runs with `flutter test`).
/// The same scenario runs on a device from `integration_test/`.
void main() {
  test('offline queue survives an app restart and syncs exactly once', () async {
    // Loads the Isar native core for host tests.
    final warmup = await openTestDb(directory: await newTempDir(), tag: 'scenario-warmup');
    await warmup.close(deleteFromDisk: true);

    SharedPreferences.setMockInitialValues({});
    await runOfflineRestartScenario(
      directory: await newTempDir(),
      network: FakeNetworkInfo(),
      secure: InMemorySecureStorage(),
      preferences: await SharedPreferences.getInstance(),
      notifier: FakeSyncNotifier(),
    );
  }, timeout: const Timeout(Duration(minutes: 2)));
}
