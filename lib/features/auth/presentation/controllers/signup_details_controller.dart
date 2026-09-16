import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/failure_text.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../../core/widgets/nova_text_field.dart';
import '../../cubit/signup_cubit.dart';
import '../../cubit/signup_state.dart';
import 'signup_phone_controller.dart';

part '../contracts/signup_details_contract.dart';
part '../views/signup_details_view.dart';

/// Board `3g`.
class SignupDetailsScreen extends StatefulWidget {
  const SignupDetailsScreen({super.key});

  @override
  State<SignupDetailsScreen> createState() => _SignupDetailsScreenState();
}

class _SignupDetailsScreenState extends State<SignupDetailsScreen> implements SignupDetailsControllerContract {
  late final SignupDetailsViewContract view;
  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  final TextEditingController nameController = TextEditingController();
  @override
  final TextEditingController emailController = TextEditingController();
  @override
  final TextEditingController passwordController = TextEditingController();

  @override
  bool obscurePassword = true;
  @override
  bool consent = false;
  @override
  bool showError = false;

  String get _password => passwordController.text;

  @override
  bool get ruleLength => _password.length >= 8;
  @override
  bool get ruleMix => _password.contains(RegExp('[A-Z]')) && _password.contains(RegExp(r'\d'));
  @override
  bool get ruleSymbol => _password.contains(RegExp('[^A-Za-z0-9]'));
  @override
  bool get emailInvalid => emailController.text.isNotEmpty && !_email.hasMatch(emailController.text.trim());

  @override
  bool get canSubmit =>
      nameController.text.trim().split(RegExp(r'\s+')).length >= 2 &&
      _email.hasMatch(emailController.text.trim()) &&
      ruleLength &&
      ruleMix &&
      ruleSymbol &&
      consent;

  @override
  void initState() {
    super.initState();
    view = SignupDetailsView(controller: this);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void onChanged(String _) => setState(() => showError = false);

  @override
  void onToggleObscure() => setState(() => obscurePassword = !obscurePassword);

  @override
  void onConsentChanged(bool? value) => setState(() => consent = value ?? false);

  @override
  Future<void> onSubmit() async {
    final cubit = context.read<SignupCubit>();
    await cubit.submitDetails(
      fullName: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    if (!mounted) return;
    if (cubit.state.failure != null) {
      setState(() => showError = true);
    } else if (cubit.state.step == SignupStep.bvn) {
      unawaited(context.push(AppPaths.signupBvn));
    }
  }

  @override
  Widget build(BuildContext context) => view.build(context);
}
