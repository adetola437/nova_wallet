part of '../controllers/unlock_controller.dart';

abstract class UnlockControllerContract {
  int get enteredLength;
  bool get biometricAvailable;
  int get cooldownSeconds;

  void onDigit(int digit);
  void onDelete();
  void onBiometric();
  void onSignOut();
}

abstract class UnlockViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
