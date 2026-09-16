import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/api/fake/fake_server_controls.dart';
import 'package:nova_wallet/core/network/backend_reachability.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';

import '../../support/fake_network_info.dart';

void main() {
  late FakeNetworkInfo network;
  late FakeServerControls controls;
  late ConnectivityCubit cubit;
  const debounce = Duration(milliseconds: 30);

  setUp(() {
    network = FakeNetworkInfo();
    controls = FakeServerControls(
      minLatency: Duration.zero,
      maxLatency: Duration.zero,
    );
    cubit = ConnectivityCubit(
      reachability: Reachability(
        networkInfo: network,
        controls: controls,
        backend: const AlwaysReachable(),
      ),
      onlineDebounce: debounce,
    );
  });

  tearDown(() async {
    await cubit.close();
    await controls.dispose();
  });

  test('start reports the current state immediately', () async {
    await cubit.start();
    expect(cubit.state, ConnectivityStatus.online);
  });

  test('going offline is immediate', () async {
    await cubit.start();
    network.connected = false;
    await pumpEventQueue();
    expect(cubit.state, ConnectivityStatus.offline);
  });

  test('a flapping connection produces ONE online event after the debounce',
      () async {
    network.connected = false;
    await cubit.start();
    final states = <ConnectivityStatus>[];
    final sub = cubit.stream.listen(states.add);

    for (var i = 0; i < 5; i++) {
      network.connected = true;
      await pumpEventQueue();
      network.connected = false;
      await pumpEventQueue();
    }
    network.connected = true;
    await Future<void>.delayed(debounce * 3);

    expect(states.where((s) => s == ConnectivityStatus.online).length, 1);
    expect(cubit.state, ConnectivityStatus.online);
    await sub.cancel();
  });

  test('the developer "simulate offline" switch overrides real connectivity',
      () async {
    await cubit.start();
    controls.simulateOffline = true;
    await pumpEventQueue();
    expect(cubit.state, ConnectivityStatus.offline);
    controls.simulateOffline = false;
    await Future<void>.delayed(debounce * 3);
    expect(cubit.state, ConnectivityStatus.online);
  });
}
