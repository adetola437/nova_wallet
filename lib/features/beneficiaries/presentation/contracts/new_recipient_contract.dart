part of '../controllers/new_recipient_controller.dart';

abstract class NewRecipientControllerContract {
  TextEditingController get accountController;

  void onPickBank();
  void onAccountChanged(String value);
  void onToggleSave(bool value);
  void onContinue();
}

abstract class NewRecipientViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
