/// Whether the backend itself answers. A captive portal or a dead data plan
/// shows up here, where `connectivity_plus` would still say "connected".
abstract class BackendReachability {
  Future<bool> get isReachable;
  Stream<bool> get changes;
}

/// Fake backend: reachable whenever the device is.
class AlwaysReachable implements BackendReachability {
  const AlwaysReachable();

  @override
  Future<bool> get isReachable async => true;

  @override
  Stream<bool> get changes => const Stream<bool>.empty();
}
