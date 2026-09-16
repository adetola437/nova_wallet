part of '../controllers/create_pin_controller.dart';

class CreatePinView extends StatelessWidget implements CreatePinViewContract {
  const CreatePinView({super.key, required this.controller});

  final CreatePinControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        final failure = state.failure?.localized(l10n);
        return NovaFormScaffold(
          step: l10n.stepOf(5, SignupPhoneScreen.totalSteps),
          title: controller.confirming ? l10n.confirmPinTitle : l10n.createPinTitle,
          body: controller.confirming ? l10n.confirmPinBody : l10n.createPinBody,
          content: [
            PinDots(length: controller.enteredLength, hasError: controller.mismatch),
            SizedBox(height: 16.h),
            if (controller.mismatch)
              InlineError(l10n.pinsDontMatch)
            else if (controller.matched)
              Semantics(
                liveRegion: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 18.r, color: AppColors.sentInk),
                    SizedBox(width: 6.w),
                    Text(l10n.pinsMatch, style: AppTextStyles.small.sp.copyWith(color: AppColors.sentInk)),
                  ],
                ),
              )
            else if (failure != null)
              InlineError(failure),
            SizedBox(height: 24.h),
            PinPad(onDigit: controller.onDigit, onDelete: controller.onDelete, enabled: !state.isSubmitting),
          ],
        );
      },
    );
  }
}
