part of '../controllers/goal_details_controller.dart';

abstract class GoalDetailsControllerContract {
  String formatDate(DateTime date);
  int daysLeft(GoalView goal);

  bool isMatured(GoalView goal);

  void onContribute(GoalView goal);
  void onMoveToWallet(GoalView goal);
}

abstract class GoalDetailsViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
