part of '../controllers/create_goal_controller.dart';

abstract class CreateGoalControllerContract {
  TextEditingController get nameController;
  TextEditingController get targetController;
  int? get selectedMonths;
  String formatDate(DateTime date);

  void onNameChanged(String value);
  void onTargetChanged(String value);
  void onPickDate();
  void onQuickDate(int months);
  void onSubmit();
}

abstract class CreateGoalViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
