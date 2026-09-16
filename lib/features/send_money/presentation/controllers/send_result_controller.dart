import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../transactions/presentation/controllers/transaction_details_controller.dart';
import '../../cubit/send_money_cubit.dart';
import '../../cubit/send_money_state.dart';
import '../widgets/summary_row.dart';

part '../contracts/send_result_contract.dart';
part '../views/send_result_view.dart';

/// Boards `2j` Sent, `2k` Pending, `2l` Processing, `2m` Failed. Follows the
/// outbox item live, so an open Pending screen turns into Sent on reconnect.
class SendResultScreen extends StatefulWidget {
  const SendResultScreen({super.key});

  @override
  State<SendResultScreen> createState() => _SendResultScreenState();
}

class _SendResultScreenState extends State<SendResultScreen> implements SendResultControllerContract {
  late final SendResultViewContract view;

  @override
  void initState() {
    super.initState();
    view = SendResultView(controller: this);
  }

  @override
  void onDone() => context.go(AppPaths.home);

  @override
  void onViewDetails() {
    final id = context.read<SendMoneyCubit>().state.item?.id;
    if (id == null) return;
    unawaited(context.push(AppPaths.transaction, extra: TransactionDetailsArgs(outboxId: id)));
  }

  @override
  void onTryAgain() {
    context.read<SendMoneyCubit>().retry();
    context.pop();
  }

  @override
  void onCopyReference(String reference) {
    unawaited(Clipboard.setData(ClipboardData(text: reference)));
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.copied)));
  }

  // The send is committed: back must not return to the review screen.
  @override
  Widget build(BuildContext context) => PopScope(canPop: false, child: view.build(context));
}
