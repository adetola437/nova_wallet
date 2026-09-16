import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/failure_text.dart';
import '../../../../core/money/money.dart';
import '../../../../core/money/money_semantics.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/amount_input.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../../core/widgets/nova_text_field.dart';
import '../../../wallet/cubit/wallet_cubit.dart';
import '../../cubit/send_money_cubit.dart';
import '../../cubit/send_money_state.dart';
import '../widgets/recipient_avatar.dart';

part '../contracts/send_amount_contract.dart';
part '../views/send_amount_view.dart';

/// Boards `2d` and `2e` (over-balance error).
class SendAmountScreen extends StatefulWidget {
  const SendAmountScreen({super.key});

  @override
  State<SendAmountScreen> createState() => _SendAmountScreenState();
}

class _SendAmountScreenState extends State<SendAmountScreen> implements SendAmountControllerContract {
  late final SendAmountViewContract view;
  late final SendMoneyCubit _cubit = context.read<SendMoneyCubit>();

  @override
  late final TextEditingController amountController = TextEditingController(text: _cubit.state.amountText);

  @override
  late final TextEditingController narrationController = TextEditingController(text: _cubit.state.narration);

  @override
  void initState() {
    super.initState();
    view = SendAmountView(controller: this);
  }

  @override
  void dispose() {
    amountController.dispose();
    narrationController.dispose();
    super.dispose();
  }

  @override
  void onAmountChanged(String value) => _cubit.amountChanged(value);

  @override
  void onNarrationChanged(String value) => _cubit.narrationChanged(value);

  @override
  void onChangeRecipient() => context.pop();

  @override
  Future<void> onContinue() async {
    FocusScope.of(context).unfocus();
    await _cubit.continueToReview();
    if (mounted && _cubit.state.stage == SendStage.review) unawaited(context.push(AppPaths.sendReview));
  }

  @override
  Widget build(BuildContext context) => view.build(context);
}
