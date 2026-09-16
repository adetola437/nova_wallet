part of '../controllers/recipient_controller.dart';

abstract class RecipientControllerContract {
  TextEditingController get searchController;

  void onSearch(String query);
  void onSelect(Beneficiary beneficiary);
  void onNewRecipient();
  void onNovaUser();
}

abstract class RecipientViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
