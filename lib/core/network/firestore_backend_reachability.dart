import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'backend_reachability.dart';

/// Reads a one-field public document, from the server, with a short timeout.
/// A captive portal or a dead data plan fails here, where `connectivity_plus`
/// would still report "connected". Cached for a few seconds so a flapping
/// connection can't turn into a storm of reads.
class FirestoreBackendReachability implements BackendReachability {
  FirestoreBackendReachability({
    required this.firestore,
    this.probeTimeout = const Duration(seconds: 3),
    this.cacheFor = const Duration(seconds: 5),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final FirebaseFirestore firestore;
  final Duration probeTimeout;
  final Duration cacheFor;
  final DateTime Function() _clock;

  final _changes = StreamController<bool>.broadcast();
  bool _last = true;
  DateTime? _checkedAt;

  @override
  Future<bool> get isReachable async {
    final checkedAt = _checkedAt;
    if (checkedAt != null && _clock().difference(checkedAt) < cacheFor) {
      return _last;
    }
    var reachable = false;
    try {
      await firestore.doc('meta/health').get(const GetOptions(source: Source.server)).timeout(probeTimeout);
      reachable = true;
    } catch (_) {
      reachable = false;
    }
    _checkedAt = _clock();
    if (reachable != _last) {
      _last = reachable;
      if (!_changes.isClosed) _changes.add(reachable);
    }
    return reachable;
  }

  /// Lets the service report "the backend just went away" without a probe.
  void reportUnreachable() {
    _checkedAt = _clock();
    if (_last) {
      _last = false;
      if (!_changes.isClosed) _changes.add(false);
    }
  }

  @override
  Stream<bool> get changes => _changes.stream;

  Future<void> dispose() => _changes.close();
}
