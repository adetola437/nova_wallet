part of '../controllers/send_result_controller.dart';

abstract class SendResultControllerContract {
  void onDone();
  void onViewDetails();
  void onTryAgain();
  void onCopyReference(String reference);
}

abstract class SendResultViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
