import '../models/activity_item.dart';
import '../models/outbox_item.dart';

/// What the app tells the user about, without knowing how (the local
/// notification implementation lives in `local_notification_service.dart`).
abstract class SyncNotifier {
  /// A transfer, goal or contribution went through.
  Future<void> syncSucceeded(OutboxItem item);

  /// The server rejected a queued action.
  Future<void> syncFailed(OutboxItem item);

  /// Money arrived in the wallet (a credit seen for the first time on refresh).
  Future<void> paymentReceived(ActivityItem credit);
}
