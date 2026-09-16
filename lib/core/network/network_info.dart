/// Whether a network interface is up. This is not proof that the internet
/// works (captive portals, dead data plans). `Reachability` layers on top.
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}
