import 'dart:async';

/// Knobs for the live demo and for tests. They drive the fake server and
/// `Reachability`.
class FakeServerControls {
  FakeServerControls({
    bool simulateOffline = false,
    this.minLatency = const Duration(milliseconds: 400),
    this.maxLatency = const Duration(milliseconds: 1200),
  }) {
    _simulateOffline = simulateOffline;
  }

  final _changes = StreamController<bool>.broadcast();
  late bool _simulateOffline;

  /// When true the fake server behaves as unreachable, even on Wi-Fi.
  bool get simulateOffline => _simulateOffline;

  set simulateOffline(bool value) {
    if (value == _simulateOffline) return;
    _simulateOffline = value;
    _changes.add(value);
  }

  Stream<bool> get simulateOfflineChanges => _changes.stream;

  /// The next mutating request is APPLIED on the server, but the phone gets a
  /// timeout. This reproduces "server accepted, response lost".
  bool loseNextResponse = false;

  Duration minLatency;
  Duration maxLatency;

  void setLatencyMs(int ms) {
    minLatency = Duration(milliseconds: ms);
    maxLatency = Duration(milliseconds: ms);
  }

  Future<void> dispose() => _changes.close();
}
