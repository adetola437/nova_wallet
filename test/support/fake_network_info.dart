import 'dart:async';

import 'package:nova_wallet/core/network/network_info.dart';

/// Scriptable connectivity, the unit-test stand-in for airplane mode.
class FakeNetworkInfo implements NetworkInfo {
  FakeNetworkInfo({bool connected = true}) {
    _connected = connected;
  }

  late bool _connected;
  final _controller = StreamController<bool>.broadcast();

  bool get connected => _connected;

  set connected(bool value) {
    _connected = value;
    _controller.add(value);
  }

  @override
  Future<bool> get isConnected async => _connected;

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;
}
