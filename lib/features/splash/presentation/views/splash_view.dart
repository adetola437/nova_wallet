part of '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget implements SplashViewContract {
  const SplashView({super.key, required this.controller});

  final SplashControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.navy900,
      body: Center(
        child: FadeTransition(
          opacity: controller.animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1).animate(controller.animation),
            child: Semantics(
              label: l10n.appName,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BrandMark(size: 88),
                  SizedBox(height: 20.h),
                  ExcludeSemantics(
                    child: Text(l10n.appName, style: AppTextStyles.h1.sp.copyWith(color: AppColors.onNavy)),
                  ),
                  SizedBox(height: 6.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Text(
                      l10n.splashTagline,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.small.sp.copyWith(color: AppColors.onNavyMuted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
