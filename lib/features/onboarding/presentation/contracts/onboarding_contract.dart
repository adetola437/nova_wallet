part of '../controllers/onboarding_controller.dart';

abstract class OnboardingControllerContract {
  PageController get pageController;
  int get page;
  int get pageCount;
  bool get isLastPage;

  void onPageChanged(int index);
  void onNext();
  void onSkip();
  void onCreateAccount();
  void onHaveAccount();
}

abstract class OnboardingViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}
