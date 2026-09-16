part of '../controllers/profile_controller.dart';

abstract class ProfileControllerContract {
  void onLanguage();
  void onToggleBiometrics(bool value);
  void onComingSoon();
  void onDeveloper();
  void onSignOut();
}

abstract class ProfileViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
