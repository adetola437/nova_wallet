part of '../controllers/signup_phone_controller.dart';

class SignupPhoneView extends StatelessWidget implements SignupPhoneViewContract {
  const SignupPhoneView({super.key, required this.controller});

  final SignupPhoneControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        final failure = controller.showError ? state.failure : null;
        final error = switch (failure) {
          null => null,
          ValidationFailure() => l10n.errorInvalidPhone,
          final f => f.localized(l10n),
        };
        return NovaFormScaffold(
          step: l10n.stepOf(1, SignupPhoneScreen.totalSteps),
          appBarActions: [TextButton(onPressed: controller.onLogIn, child: Text(l10n.logIn))],
          title: l10n.phoneTitle,
          body: l10n.phoneBody,
          content: [
            NovaTextField(
              label: l10n.phoneTitle,
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              autofocus: true,
              autofillHints: const [AutofillHints.telephoneNumberNational],
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              hint: '801 234 5678',
              helper: l10n.phoneHelp,
              errorText: error,
              onChanged: controller.onChanged,
              onSubmitted: (_) => controller.canSubmit ? controller.onSubmit() : null,
              prefix: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 8.w),
                child: Align(widthFactor: 1, child: Text('+234', style: AppTextStyles.body.sp)),
              ),
            ),
            SizedBox(height: 16.h),
            NoticeCard(icon: Icons.lock_outline_rounded, child: Text(l10n.phonePrivacy)),
          ],
          actions: [
            NovaButton(
              label: l10n.sendCode,
              isLoading: state.isSubmitting,
              onPressed: controller.canSubmit ? controller.onSubmit : null,
            ),
          ],
        );
      },
    );
  }
}
