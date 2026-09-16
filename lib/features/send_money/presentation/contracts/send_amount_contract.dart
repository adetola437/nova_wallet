part of '../controllers/send_amount_controller.dart';

abstract class SendAmountControllerContract {
  TextEditingController get amountController;
  TextEditingController get narrationController;

  void onAmountChanged(String value);
  void onNarrationChanged(String value);
  void onChangeRecipient();
  void onContinue();
}

abstract class SendAmountViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
