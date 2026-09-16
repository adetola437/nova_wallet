import 'package:nova_wallet/core/models/activity_item.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/notifications/sync_notifier.dart';

class FakeSyncNotifier implements SyncNotifier {
  final List<OutboxItem> succeeded = [];
  final List<OutboxItem> failed = [];
  final List<ActivityItem> received = [];

  @override
  Future<void> syncSucceeded(OutboxItem item) async => succeeded.add(item);

  @override
  Future<void> syncFailed(OutboxItem item) async => failed.add(item);

  @override
  Future<void> paymentReceived(ActivityItem credit) async => received.add(credit);
}
