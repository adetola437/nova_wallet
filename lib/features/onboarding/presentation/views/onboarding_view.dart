part of '../controllers/onboarding_controller.dart';

class OnboardingView extends StatelessWidget implements OnboardingViewContract {
  const OnboardingView({super.key, required this.controller});

  final OnboardingControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      (Icons.send_rounded, l10n.onboardSendTitle, l10n.onboardSendBody),
      (Icons.savings_rounded, l10n.onboardSaveTitle, l10n.onboardSaveBody),
      (Icons.wifi_off_rounded, l10n.onboardOfflineTitle, l10n.onboardOfflineBody),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Visibility(
                visible: !controller.isLastPage,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: TextButton(onPressed: controller.onSkip, child: Text(l10n.skip)),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, i) => _OnboardingPage(icon: pages[i].$1, title: pages[i].$2, body: pages[i].$3),
              ),
            ),
            Semantics(
              label: l10n.stepOf(controller.page + 1, controller.pageCount),
              excludeSemantics: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < controller.pageCount; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: i == controller.page ? 24.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: i == controller.page ? AppColors.navy900 : AppColors.border,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
              child: controller.isLastPage
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NovaButton(label: l10n.createAccount, onPressed: controller.onCreateAccount),
                        SizedBox(height: 8.h),
                        NovaButton(
                          label: l10n.haveAccount,
                          onPressed: controller.onHaveAccount,
                          variant: NovaButtonVariant.secondary,
                        ),
                      ],
                    )
                  : NovaButton(label: l10n.next, onPressed: controller.onNext),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        children: [
          ExcludeSemantics(
            child: Container(
              width: 160.r,
              height: 160.r,
              decoration: const BoxDecoration(color: AppColors.navy900, shape: BoxShape.circle),
              child: Icon(icon, size: 64.r, color: AppColors.gold500),
            ),
          ),
          SizedBox(height: 32.h),
          Semantics(
            header: true,
            child: Text(title, textAlign: TextAlign.center, style: AppTextStyles.h1.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.sp.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
