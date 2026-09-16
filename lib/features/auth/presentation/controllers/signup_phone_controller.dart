import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/exception/failure.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/failure_text.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../../core/widgets/nova_text_field.dart';
import '../../cubit/signup_cubit.dart';
import '../../cubit/signup_state.dart';

part '../contracts/signup_phone_contract.dart';
part '../views/signup_phone_view.dart';

/// Board `3e`.
class SignupPhoneScreen extends StatefulWidget {
  const SignupPhoneScreen({super.key});

  static const int totalSteps = 5;

  @override
  State<SignupPhoneScreen> createState() => _SignupPhoneScreenState();
}

class _SignupPhoneScreenState extends State<SignupPhoneScreen> implements SignupPhoneControllerContract {
  late final SignupPhoneViewContract view;

  @override
  final TextEditingController phoneController = TextEditingController();

  @override
  bool showError = false;

  @override
  bool get canSubmit => phoneController.text.length == 10;

  @override
  void initState() {
    super.initState();
    view = SignupPhoneView(controller: this);
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  void onChanged(String value) => setState(() => showError = false);

  @override
  Future<void> onSubmit() async {
    final cubit = context.read<SignupCubit>();
    await cubit.submitPhone(phoneController.text);
    if (!mounted) return;
    if (cubit.state.failure != null) {
      setState(() => showError = true);
    } else if (cubit.state.step == SignupStep.otp) {
      unawaited(context.push(AppPaths.signupOtp));
    }
  }

  @override
  void onLogIn() => context.go(AppPaths.login);

  @override
  Widget build(BuildContext context) => view.build(context);
}
