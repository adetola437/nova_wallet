import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/failure_text.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/brand_mark.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../../core/widgets/nova_text_field.dart';
import '../../cubit/login_cubit.dart';
import '../../cubit/login_state.dart';

part '../contracts/login_contract.dart';
part '../views/login_view.dart';

/// Board `3k`: email + password. No biometric button — a fingerprint can't be
/// a first factor on a fresh install (design review A2).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginControllerContract {
  late final LoginViewContract view;

  @override
  final TextEditingController emailController = TextEditingController();
  @override
  final TextEditingController passwordController = TextEditingController();
  @override
  bool obscurePassword = true;

  @override
  bool get canSubmit => emailController.text.trim().isNotEmpty && passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    view = LoginView(controller: this);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void onChanged(String _) => setState(() {});

  @override
  void onToggleObscure() => setState(() => obscurePassword = !obscurePassword);

  /// Success flips AuthCubit to authenticated and the router moves on.
  @override
  void onSubmit() {
    FocusScope.of(context).unfocus();
    context.read<LoginCubit>().submit(identifier: emailController.text, password: passwordController.text);
  }

  @override
  void onForgotPassword() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.forgotPasswordSoon)));
  }

  @override
  void onCreateAccount() => context.go(AppPaths.signup);

  @override
  Widget build(BuildContext context) => view.build(context);
}
