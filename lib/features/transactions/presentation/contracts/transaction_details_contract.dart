part of '../controllers/transaction_details_controller.dart';

abstract class TransactionDetailsControllerContract {
  String formatDate(DateTime at);
}

abstract class TransactionDetailsViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
