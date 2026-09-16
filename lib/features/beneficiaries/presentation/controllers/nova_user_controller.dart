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
import '../../../send_money/cubit/send_money_cubit.dart';
import '../../cubit/name_enquiry_cubit.dart';
import '../../cubit/name_enquiry_state.dart';

part '../contracts/nova_user_contract.dart';
part '../views/nova_user_view.dart';

/// Send to another NovaWallet user by email. Online only: like a bank
/// recipient, nothing is queued until the server has confirmed the name.
class NovaUserScreen extends StatefulWidget {
  const NovaUserScreen({super.key});

  @override
  State<NovaUserScreen> createState() => _NovaUserScreenState();
}

class _NovaUserScreenState extends State<NovaUserScreen> implements NovaUserControllerContract {
  late final NovaUserViewContract view;

  @override
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    view = NovaUserView(controller: this);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  void onEmailChanged(String value) {
    final cubit = context.read<NameEnquiryCubit>();
    if (cubit.state.verified != null || cubit.state.failure != null) cubit.emailChanged();
    setState(() {});
  }

  @override
  void onFind() {
    FocusScope.of(context).unfocus();
    context.read<NameEnquiryCubit>().lookupEmail(emailController.text);
  }

  @override
  void onToggleSave(bool value) => context.read<NameEnquiryCubit>().toggleSave(value);

  @override
  Future<void> onContinue() async {
    final result = await context.read<NameEnquiryCubit>().confirm();
    if (!mounted) return;
    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.localized(AppLocalizations.of(context))))),
      (beneficiary) {
        context.read<SendMoneyCubit>().selectRecipient(beneficiary);
        context.pushReplacement(AppPaths.sendAmount);
      },
    );
  }

  @override
  Widget build(BuildContext context) => view.build(context);
}
