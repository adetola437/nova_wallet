part of '../controllers/login_controller.dart';

class LoginView extends StatelessWidget implements LoginViewContract {
  const LoginView({super.key, required this.controller});

  final LoginControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final error = state.failure?.localized(l10n);
        return NovaFormScaffold(
          showBack: false,
          title: l10n.loginWelcome,
          body: l10n.loginBody,
          actions: [
            NovaButton(
              label: l10n.logIn,
              isLoading: state.isSubmitting,
              onPressed: controller.canSubmit ? controller.onSubmit : null,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(l10n.newHere, style: AppTextStyles.small.sp),
                TextButton(onPressed: controller.onCreateAccount, child: Text(l10n.createAccount)),
              ],
            ),
          ],
          content: [
            const Align(alignment: Alignment.centerLeft, child: BrandMark(size: 56)),
            SizedBox(height: 24.h),
            NovaTextField(
              label: l10n.email,
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onChanged: controller.onChanged,
            ),
            SizedBox(height: 16.h),
            NovaTextField(
              label: l10n.password,
              controller: controller.passwordController,
              obscureText: controller.obscurePassword,
              autofillHints: const [AutofillHints.password],
              onChanged: controller.onChanged,
              onSubmitted: (_) => controller.canSubmit ? controller.onSubmit() : null,
              suffix: TextButton(
                onPressed: controller.onToggleObscure,
                child: Text(controller.obscurePassword ? l10n.show : l10n.hide),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: controller.onForgotPassword, child: Text(l10n.forgotPassword)),
            ),
            if (error != null) ...[SizedBox(height: 4.h), InlineError(error)],
          ],
        );
      },
    );
  }
}
