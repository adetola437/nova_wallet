part of '../controllers/splash_controller.dart';

abstract class SplashControllerContract {
  Animation<double> get animation;
}

abstract class SplashViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
