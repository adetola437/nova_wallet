part of '../controllers/signup_otp_controller.dart';

class SignupOtpView extends StatelessWidget implements SignupOtpViewContract {
  const SignupOtpView({super.key, required this.controller});

  final SignupOtpControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cell = PinTheme(
      width: 48.r,
      height: 56.r,
      textStyle: AppTextStyles.h1.sp,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
    );

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        final error = controller.showError ? state.failure?.localized(l10n) : null;
        final seconds = controller.resendSeconds;
        return NovaFormScaffold(
          step: l10n.stepOf(2, SignupPhoneScreen.totalSteps),
          title: l10n.otpTitle,
          body: l10n.otpSentTo(state.phone),
          content: [
            NoticeCard(
              icon: Icons.science_outlined,
              background: AppColors.pendingBg,
              ink: AppColors.pendingInk,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l10n.demoLabel} · ${AppConstants.fakeOtp}',
                    style: AppTextStyles.amountBody.sp.copyWith(color: AppColors.pendingInk),
                  ),
                  SizedBox(height: 2.h),
                  Text(l10n.otpDemo),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Semantics(
              label: l10n.otpTitle,
              child: Pinput(
                length: 6,
                controller: controller.codeController,
                autofocus: true,
                keyboardType: TextInputType.number,
                defaultPinTheme: cell,
                focusedPinTheme: cell.copyBorderWith(border: Border.all(color: AppColors.navy900, width: 1.5)),
                errorPinTheme: cell.copyBorderWith(border: Border.all(color: AppColors.failedInk, width: 1.5)),
                forceErrorState: error != null,
                onChanged: controller.onChanged,
                onCompleted: controller.onCompleted,
                enabled: !state.isSubmitting,
              ),
            ),
            if (error != null) ...[SizedBox(height: 12.h), InlineError(error)],
            SizedBox(height: 24.h),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8.w,
              children: [
                if (seconds > 0)
                  Semantics(
                    liveRegion: false,
                    child: Text(
                      l10n.resendIn('0:${seconds.toString().padLeft(2, '0')}'),
                      style: AppTextStyles.small.sp,
                    ),
                  )
                else
                  TextButton(onPressed: controller.onResend, child: Text(l10n.resend)),
                TextButton(onPressed: controller.onChangeNumber, child: Text(l10n.changeNumber)),
              ],
            ),
          ],
          actions: [
            NovaButton(
              label: l10n.verify,
              isLoading: state.isSubmitting,
              onPressed: () {
                final code = controller.codeController.text;
                if (code.length == 6) controller.onCompleted(code);
              },
            ),
          ],
        );
      },
    );
  }
}
