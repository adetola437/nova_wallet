part of '../controllers/signup_otp_controller.dart';

abstract class SignupOtpControllerContract {
  TextEditingController get codeController;
  int get resendSeconds;
  bool get showError;

  void onChanged(String value);
  void onCompleted(String code);
  void onResend();
  void onChangeNumber();
}

abstract class SignupOtpViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
