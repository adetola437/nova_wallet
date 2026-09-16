import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/failure_text.dart';
import '../../../../core/models/bank.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/nova_bottom_sheet.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../../core/widgets/nova_text_field.dart';
import '../../../send_money/cubit/send_money_cubit.dart';
import '../../cubit/name_enquiry_cubit.dart';
import '../../cubit/name_enquiry_state.dart';

part '../contracts/new_recipient_contract.dart';
part '../views/new_recipient_view.dart';

/// Board `2c`. Online only: a transfer is never queued to an unverified name.
class NewRecipientScreen extends StatefulWidget {
  const NewRecipientScreen({super.key});

  @override
  State<NewRecipientScreen> createState() => _NewRecipientScreenState();
}

class _NewRecipientScreenState extends State<NewRecipientScreen> implements NewRecipientControllerContract {
  late final NewRecipientViewContract view;

  @override
  final TextEditingController accountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    view = NewRecipientView(controller: this);
  }

  @override
  void dispose() {
    accountController.dispose();
    super.dispose();
  }

  @override
  Future<void> onPickBank() async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<NameEnquiryCubit>();
    final bank = await showNovaBottomSheet<Bank>(
      context,
      title: l10n.chooseBank,
      builder: (sheetContext) => SizedBox(
        height: MediaQuery.sizeOf(sheetContext).height * 0.5,
        child: ListView.builder(
          itemCount: Banks.all.length,
          itemBuilder: (_, i) {
            final b = Banks.all[i];
            return ListTile(
              minTileHeight: 48,
              title: Text(b.name, style: AppTextStyles.body.sp),
              selected: cubit.state.bank == b,
              trailing: cubit.state.bank == b ? const Icon(Icons.check_rounded) : null,
              onTap: () => Navigator.of(sheetContext).pop(b),
            );
          },
        ),
      ),
    );
    if (bank == null || !mounted) return;
    cubit.selectBank(bank);
    unawaited(cubit.accountNumberChanged(accountController.text));
  }

  @override
  void onAccountChanged(String value) => context.read<NameEnquiryCubit>().accountNumberChanged(value);

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
