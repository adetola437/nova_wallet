import '../../../core/models/outbox_item.dart';

class DevSettings {
  const DevSettings({required this.simulateOffline, required this.loseNextResponse, required this.latencyMs});

  final bool simulateOffline;
  final bool loseNextResponse;
  final int latencyMs;

  DevSettings copyWith({bool? simulateOffline, bool? loseNextResponse, int? latencyMs}) => DevSettings(
    simulateOffline: simulateOffline ?? this.simulateOffline,
    loseNextResponse: loseNextResponse ?? this.loseNextResponse,
    latencyMs: latencyMs ?? this.latencyMs,
  );
}

/// Backs the demo panel: the switches flipped live during the presentation.
abstract class IDeveloperRepository {
  Future<DevSettings> load();
  Future<void> setSimulateOffline(bool value);
  void setLoseNextResponse(bool value);
  Future<void> setLatencyMs(int ms);
  Stream<List<OutboxItem>> watchOutbox();
  Future<void> resetDemoData();
  Future<void> simulateIncomingPayment({required int amountKobo, required String from});
}
