part of '../controllers/signup_bvn_controller.dart';

class SignupBvnView extends StatelessWidget implements SignupBvnViewContract {
  const SignupBvnView({super.key, required this.controller});

  final SignupBvnControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        final error = controller.showError ? state.failure?.localized(l10n) : null;
        return NovaFormScaffold(
          step: l10n.stepOf(4, SignupPhoneScreen.totalSteps),
          title: l10n.bvnTitle,
          appBarActions: [TextButton(onPressed: controller.onSkip, child: Text(l10n.skip))],
          actions: [
            NovaButton(
              label: l10n.verifyBvn,
              isLoading: state.isSubmitting,
              onPressed: controller.canSubmit ? controller.onVerify : null,
            ),
            NovaButton(label: l10n.skipForNow, onPressed: controller.onSkip, variant: NovaButtonVariant.text),
          ],
          content: [
            NovaTextField(
              label: l10n.bvnLabel,
              hint: l10n.bvnHint,
              controller: controller.bvnController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
              helper: l10n.bvnHelp,
              errorText: error,
              onChanged: controller.onChanged,
            ),
            SizedBox(height: 16.h),
            NoticeCard(
              icon: Icons.shield_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.bvnWhy, style: AppTextStyles.caption.sp.copyWith(color: AppColors.sendingInk)),
                  SizedBox(height: 4.h),
                  Text(l10n.bvnWhyBody),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _TierCard(title: l10n.tier1, body: l10n.tier1Limit, highlighted: false),
            SizedBox(height: 8.h),
            _TierCard(title: l10n.tier2, body: l10n.tier2Limit, highlighted: true),
            SizedBox(height: 16.h),
            Text(l10n.bvnLater, style: AppTextStyles.small.sp),
          ],
        );
      },
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({required this.title, required this.body, required this.highlighted});

  final String title;
  final String body;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: highlighted ? AppColors.gold500 : AppColors.border, width: highlighted ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption.sp.copyWith(color: AppColors.goldInk800)),
          SizedBox(height: 4.h),
          Text(body, style: AppTextStyles.body.sp),
        ],
      ),
    ),
  );
}
