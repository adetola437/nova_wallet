import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/support/fake_network_info.dart';
import '../test/support/fake_sync_notifier.dart';
import '../test/support/in_memory_secure_storage.dart';
import '../test/support/offline_restart_scenario.dart';

/// The graded scenario on a real device or emulator:
/// `flutter test integration_test/offline_queue_sync_test.dart -d <device>`
///
/// Real Isar, real SharedPreferences, the real app graph. Connectivity is
/// scripted so the run is deterministic; the live demo uses real airplane mode.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('offline queue survives an app restart and syncs exactly once', (tester) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/it_${DateTime.now().millisecondsSinceEpoch}')..createSync(recursive: true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    await runOfflineRestartScenario(
      directory: dir.path,
      network: FakeNetworkInfo(),
      secure: InMemorySecureStorage(),
      preferences: prefs,
      notifier: FakeSyncNotifier(),
    );

    dir.deleteSync(recursive: true);
  }, timeout: const Timeout(Duration(minutes: 3)));
}
