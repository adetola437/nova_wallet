part of '../controllers/signup_details_controller.dart';

class SignupDetailsView extends StatelessWidget implements SignupDetailsViewContract {
  const SignupDetailsView({super.key, required this.controller});

  final SignupDetailsControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        final error = controller.showError ? state.failure?.localized(l10n) : null;
        return NovaFormScaffold(
          step: l10n.stepOf(3, SignupPhoneScreen.totalSteps),
          title: l10n.detailsTitleSignup,
          content: [
            NovaTextField(
              label: l10n.fullName,
              controller: controller.nameController,
              helper: l10n.fullNameHelp,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              onChanged: controller.onChanged,
            ),
            SizedBox(height: 16.h),
            NovaTextField(
              label: l10n.email,
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              errorText: controller.emailInvalid ? l10n.errorInvalidEmail : null,
              onChanged: controller.onChanged,
            ),
            SizedBox(height: 16.h),
            NovaTextField(
              label: l10n.password,
              controller: controller.passwordController,
              obscureText: controller.obscurePassword,
              autofillHints: const [AutofillHints.newPassword],
              onChanged: controller.onChanged,
              suffix: TextButton(
                onPressed: controller.onToggleObscure,
                child: Text(controller.obscurePassword ? l10n.show : l10n.hide),
              ),
            ),
            SizedBox(height: 12.h),
            _Rule(met: controller.ruleLength, label: l10n.pwRuleLength),
            _Rule(met: controller.ruleMix, label: l10n.pwRuleMix),
            _Rule(met: controller.ruleSymbol, label: l10n.pwRuleSymbol),
            SizedBox(height: 16.h),
            MergeSemantics(
              child: InkWell(
                onTap: () => controller.onConsentChanged(!controller.consent),
                borderRadius: BorderRadius.circular(12.r),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Row(
                    children: [
                      Checkbox(value: controller.consent, onChanged: controller.onConsentChanged),
                      Expanded(child: Text(l10n.consent, style: AppTextStyles.small.sp)),
                    ],
                  ),
                ),
              ),
            ),
            if (error != null) ...[SizedBox(height: 12.h), InlineError(error)],
          ],
          actions: [
            NovaButton(
              label: l10n.continueLabel,
              isLoading: state.isSubmitting,
              onPressed: controller.canSubmit ? controller.onSubmit : null,
            ),
          ],
        );
      },
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule({required this.met, required this.label});

  final bool met;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = met ? AppColors.sentInk : AppColors.textSecondary;
    return MergeSemantics(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Row(
          children: [
            Icon(
              met ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              size: 16.r,
              color: color,
              semanticLabel: met ? '✓' : null,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(label, style: AppTextStyles.small.sp.copyWith(color: color)),
            ),
          ],
        ),
      ),
    );
  }
}
