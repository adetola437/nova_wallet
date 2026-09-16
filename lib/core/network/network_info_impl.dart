import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static bool _anyUp(List<ConnectivityResult> results) => results.any((r) => r != ConnectivityResult.none);

  @override
  Future<bool> get isConnected async => _anyUp(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged.map(_anyUp);
}
