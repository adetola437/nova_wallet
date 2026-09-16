part of '../controllers/signup_bvn_controller.dart';

abstract class SignupBvnControllerContract {
  TextEditingController get bvnController;
  bool get showError;
  bool get canSubmit;

  void onChanged(String _);
  void onVerify();
  void onSkip();
}

abstract class SignupBvnViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
