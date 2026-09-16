part of '../controllers/login_controller.dart';

abstract class LoginControllerContract {
  TextEditingController get emailController;
  TextEditingController get passwordController;
  bool get obscurePassword;
  bool get canSubmit;

  void onChanged(String _);
  void onToggleObscure();
  void onSubmit();
  void onForgotPassword();
  void onCreateAccount();
}

abstract class LoginViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
