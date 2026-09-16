import '../../../core/api/backend_admin.dart';
import '../../../core/api/fake/fake_server_controls.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/storage/session_store.dart';
import '../../sync/repository/outbox_repository.dart';
import 'developer_repository.dart';

class DeveloperRepositoryImpl implements IDeveloperRepository {
  DeveloperRepositoryImpl({
    required this.localStorage,
    required this.controls,
    required this.outbox,
    required this.admin,
    required this.db,
    this.session,
  });

  final LocalStorage localStorage;
  final FakeServerControls controls;
  final IOutboxRepository outbox;

  /// Whichever backend is live — fake or Firebase — knows how to reset itself.
  final BackendAdmin admin;
  final IsarDb db;
  final SessionStore? session;

  /// Applies the saved switches to the running app. Called at startup so
  /// "offline" survives a restart during the demo.
  @override
  Future<DevSettings> load() async {
    final offline = await localStorage.getSimulateOffline();
    final latency = await localStorage.getLatencyMs() ?? controls.maxLatency.inMilliseconds;
    controls.simulateOffline = offline;
    controls.setLatencyMs(latency);
    return DevSettings(simulateOffline: offline, loseNextResponse: controls.loseNextResponse, latencyMs: latency);
  }

  @override
  Future<void> setSimulateOffline(bool value) async {
    controls.simulateOffline = value;
    await localStorage.saveSimulateOffline(value);
  }

  @override
  void setLoseNextResponse(bool value) => controls.loseNextResponse = value;

  @override
  Future<void> setLatencyMs(int ms) async {
    controls.setLatencyMs(ms);
    await localStorage.saveLatencyMs(ms);
  }

  @override
  Stream<List<OutboxItem>> watchOutbox() => outbox.watchAll();

  @override
  Future<void> resetDemoData() async {
    await db.clearClient();
    await admin.resetDemo();
  }

  @override
  Future<void> simulateIncomingPayment({required int amountKobo, required String from}) async {
    final token = await session?.readToken();
    if (token == null) return;
    await admin.simulateIncomingPayment(token: token, amountKobo: amountKobo, from: from);
  }
}
