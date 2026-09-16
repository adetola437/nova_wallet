part of '../controllers/developer_controller.dart';

abstract class DeveloperControllerContract {
  Stream<List<OutboxItem>> get outbox;

  void onSimulateOffline(bool value);
  void onLoseNextResponse(bool value);
  void onLatencyChanged(double value);
  void onSimulateIncomingPayment();
  void onReset();
}

abstract class DeveloperViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
