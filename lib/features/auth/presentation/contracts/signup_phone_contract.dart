part of '../controllers/signup_phone_controller.dart';

abstract class SignupPhoneControllerContract {
  TextEditingController get phoneController;
  bool get showError;
  bool get canSubmit;

  void onChanged(String value);
  void onSubmit();
  void onLogIn();
}

abstract class SignupPhoneViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
