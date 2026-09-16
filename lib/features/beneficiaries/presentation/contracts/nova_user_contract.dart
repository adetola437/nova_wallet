part of '../controllers/nova_user_controller.dart';

abstract class NovaUserControllerContract {
  TextEditingController get emailController;

  void onEmailChanged(String value);
  void onFind();
  void onToggleSave(bool value);
  void onContinue();
}

abstract class NovaUserViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
