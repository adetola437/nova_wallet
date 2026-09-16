part of '../controllers/create_pin_controller.dart';

abstract class CreatePinControllerContract {
  bool get confirming;
  int get enteredLength;
  bool get mismatch;
  bool get matched;

  void onDigit(int digit);
  void onDelete();
}

abstract class CreatePinViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
