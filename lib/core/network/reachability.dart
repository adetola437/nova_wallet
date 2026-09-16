import 'dart:async';

import '../api/fake/fake_server_controls.dart';
import 'backend_reachability.dart';
import 'network_info.dart';

/// "Can we reach the backend?" Interface up AND the simulate-offline switch
/// off AND the backend itself answering (spec A3's health probe).
class Reachability {
  Reachability({required this.networkInfo, required this.controls, required this.backend});

  final NetworkInfo networkInfo;
  final FakeServerControls controls;
  final BackendReachability backend;

  Future<bool> get isReachable async =>
      !controls.simulateOffline && await networkInfo.isConnected && await backend.isReachable;

  Stream<bool> get onChanged {
    late StreamController<bool> controller;
    StreamSubscription<bool>? network;
    StreamSubscription<bool>? simulated;
    StreamSubscription<bool>? backendChanges;

    Future<void> push() async {
      final reachable = await isReachable;
      if (!controller.isClosed) controller.add(reachable);
    }

    controller = StreamController<bool>(
      onListen: () {
        network = networkInfo.onConnectivityChanged.listen((_) => push());
        simulated = controls.simulateOfflineChanges.listen((_) => push());
        backendChanges = backend.changes.listen((_) => push());
      },
      onCancel: () async {
        await network?.cancel();
        await simulated?.cancel();
        await backendChanges?.cancel();
      },
    );
    return controller.stream;
  }
}
