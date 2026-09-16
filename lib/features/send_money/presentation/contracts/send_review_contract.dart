part of '../controllers/send_review_controller.dart';

abstract class SendReviewControllerContract {
  void onEdit();
  void onConfirm();
}

abstract class SendReviewViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
