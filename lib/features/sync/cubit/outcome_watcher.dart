import 'dart:async';

import '../../../core/models/outbox_item.dart';
import '../repository/outbox_repository.dart';

/// Waits for a queued item to settle, so a screen can show Sent/Failed rather
/// than a spinner that never resolves. On timeout it returns the item as it
/// stands — still queued means "Pending", which is a truthful answer.
mixin OutboxOutcomeWatcher {
  Future<OutboxItem> awaitOutcome({
    required IOutboxRepository outbox,
    required int id,
    required Duration timeout,
  }) async {
    try {
      return await outbox
          .watchItem(id)
          .where((item) => item != null && item.isTerminal)
          .map((item) => item!)
          .first
          .timeout(timeout);
    } on TimeoutException {
      return (await outbox.byId(id))!;
    }
  }
}
