part of '../controllers/signup_details_controller.dart';

abstract class SignupDetailsControllerContract {
  TextEditingController get nameController;
  TextEditingController get emailController;
  TextEditingController get passwordController;
  bool get obscurePassword;
  bool get consent;
  bool get showError;
  bool get ruleLength;
  bool get ruleMix;
  bool get ruleSymbol;
  bool get emailInvalid;
  bool get canSubmit;

  void onChanged(String _);
  void onToggleObscure();
  void onConsentChanged(bool? value);
  void onSubmit();
}

abstract class SignupDetailsViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
