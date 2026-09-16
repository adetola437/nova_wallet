import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../config/flavor/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/failure_text.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../cubit/signup_cubit.dart';
import '../../cubit/signup_state.dart';
import 'signup_phone_controller.dart';

part '../contracts/signup_otp_contract.dart';
part '../views/signup_otp_view.dart';

/// Board `3f`.
class SignupOtpScreen extends StatefulWidget {
  const SignupOtpScreen({super.key});

  @override
  State<SignupOtpScreen> createState() => _SignupOtpScreenState();
}

class _SignupOtpScreenState extends State<SignupOtpScreen> implements SignupOtpControllerContract {
  late final SignupOtpViewContract view;
  Timer? _timer;

  @override
  final TextEditingController codeController = TextEditingController();

  @override
  int resendSeconds = 60;

  @override
  bool showError = false;

  @override
  void initState() {
    super.initState();
    view = SignupOtpView(controller: this);
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    resendSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (resendSeconds <= 1) t.cancel();
      setState(() => resendSeconds = resendSeconds > 0 ? resendSeconds - 1 : 0);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    codeController.dispose();
    super.dispose();
  }

  @override
  void onChanged(String value) {
    if (showError) setState(() => showError = false);
  }

  @override
  Future<void> onCompleted(String code) async {
    final cubit = context.read<SignupCubit>();
    await cubit.submitOtp(code);
    if (!mounted) return;
    if (cubit.state.failure != null) {
      codeController.clear();
      setState(() => showError = true);
    } else if (cubit.state.step == SignupStep.details) {
      unawaited(context.push(AppPaths.signupDetails));
    }
  }

  @override
  Future<void> onResend() async {
    await context.read<SignupCubit>().resendOtp();
    if (mounted) setState(_startCountdown);
  }

  @override
  void onChangeNumber() => context.pop();

  @override
  Widget build(BuildContext context) => view.build(context);
}
