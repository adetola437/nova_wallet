part of '../controllers/unlock_controller.dart';

class UnlockView extends StatelessWidget implements UnlockViewContract {
  const UnlockView({super.key, required this.controller});

  final UnlockControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = context.select<AuthCubit, AuthState>((c) => c.state).profile;
    final firstName = profile?.firstName;

    return BlocBuilder<UnlockCubit, UnlockState>(
      builder: (context, state) {
        final String? error = controller.cooldownSeconds > 0
            ? l10n.unlockTryIn(controller.cooldownSeconds)
            : state.failure?.localized(l10n);
        final locked = controller.cooldownSeconds > 0;

        return NovaFormScaffold(
          showBack: false,
          content: [
            SizedBox(height: 8.h),
            Center(
              child: ExcludeSemantics(
                child: CircleAvatar(
                  radius: 32.r,
                  backgroundColor: AppColors.navy900,
                  child: Text(
                    (firstName ?? 'N').characters.first.toUpperCase(),
                    style: AppTextStyles.h1.sp.copyWith(color: AppColors.gold500),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Semantics(
              header: true,
              child: Text(
                firstName == null ? l10n.loginWelcome : l10n.unlockGreeting(firstName),
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(l10n.unlockBody, textAlign: TextAlign.center, style: AppTextStyles.small.sp),
            SizedBox(height: 24.h),
            PinDots(length: controller.enteredLength, hasError: error != null),
            SizedBox(height: 12.h),
            if (error != null) Center(child: InlineError(error)),
            SizedBox(height: 16.h),
            PinPad(
              enabled: !locked && !state.isVerifying,
              onDigit: controller.onDigit,
              onDelete: controller.onDelete,
              leading: controller.biometricAvailable
                  ? IconButton(
                      onPressed: locked ? null : controller.onBiometric,
                      tooltip: l10n.unlockBiometric,
                      icon: Icon(Icons.fingerprint_rounded, size: 32.r, color: AppColors.navy900),
                    )
                  : null,
            ),
            SizedBox(height: 8.h),
            Center(
              child: TextButton(onPressed: controller.onSignOut, child: Text(l10n.notYou)),
            ),
          ],
        );
      },
    );
  }
}
