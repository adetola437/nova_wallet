part of '../controllers/savings_controller.dart';

abstract class SavingsControllerContract {
  String formatDate(DateTime date);

  Future<void> onRefresh();
  void onCreateGoal([String? suggestedName]);
  void onOpenGoal(GoalView goal);
}

abstract class SavingsViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
