import 'dart:async';

import 'package:flutter/services.dart';
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

part '../contracts/signup_bvn_contract.dart';
part '../views/signup_bvn_view.dart';

/// Board `3h`. Optional: nothing here blocks sending today.
class SignupBvnScreen extends StatefulWidget {
  const SignupBvnScreen({super.key});

  @override
  State<SignupBvnScreen> createState() => _SignupBvnScreenState();
}

class _SignupBvnScreenState extends State<SignupBvnScreen> implements SignupBvnControllerContract {
  late final SignupBvnViewContract view;

  @override
  final TextEditingController bvnController = TextEditingController();

  @override
  bool showError = false;

  @override
  bool get canSubmit => bvnController.text.length == 11;

  @override
  void initState() {
    super.initState();
    view = SignupBvnView(controller: this);
  }

  @override
  void dispose() {
    bvnController.dispose();
    super.dispose();
  }

  @override
  void onChanged(String _) => setState(() => showError = false);

  @override
  Future<void> onVerify() async {
    final cubit = context.read<SignupCubit>();
    await cubit.submitBvn(bvnController.text);
    if (!mounted) return;
    if (cubit.state.failure != null) {
      setState(() => showError = true);
    } else if (cubit.state.step == SignupStep.pin) {
      unawaited(context.push(AppPaths.signupPin));
    }
  }

  @override
  void onSkip() {
    context.read<SignupCubit>().skipBvn();
    unawaited(context.push(AppPaths.signupPin));
  }

  @override
  Widget build(BuildContext context) => view.build(context);
}
