import 'dart:async';

/// Serialises async critical sections in one isolate.
///
/// The sync engine holds it for a whole replay pass, and a wallet refresh holds
/// it too. A balance fetched mid-send can therefore never overwrite the balance
/// that send just applied.
class AsyncMutex {
  Future<void> _last = Future<void>.value();

  Future<T> synchronized<T>(Future<T> Function() body) {
    final previous = _last;
    final release = Completer<void>();
    _last = release.future;
    return previous.then((_) => body()).whenComplete(release.complete);
  }
}
