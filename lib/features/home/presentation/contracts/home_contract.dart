part of '../controllers/home_controller.dart';

abstract class HomeControllerContract {
  bool get balanceHidden;
  String greeting(AppLocalizations l10n);
  String activitySubtitle(ActivityItem item, AppLocalizations l10n);

  void onToggleBalance();
  Future<void> onRefresh();
  void onSend();
  void onSave();
  void onAddMoney();
  void onActivityTap(ActivityItem item);
  bool onScroll(ScrollNotification notification);
}

abstract class HomeViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
