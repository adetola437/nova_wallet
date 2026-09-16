import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/beneficiary.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../beneficiaries/cubit/beneficiaries_cubit.dart';
import '../../../connectivity/cubit/connectivity_cubit.dart';
import '../../cubit/send_money_cubit.dart';
import '../widgets/recipient_avatar.dart';

part '../contracts/recipient_contract.dart';
part '../views/recipient_view.dart';

/// Boards `2a` (online) and `2b` (offline: saved recipients only).
class RecipientScreen extends StatefulWidget {
  const RecipientScreen({super.key});

  @override
  State<RecipientScreen> createState() => _RecipientScreenState();
}

class _RecipientScreenState extends State<RecipientScreen> implements RecipientControllerContract {
  late final RecipientViewContract view;

  @override
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    view = RecipientView(controller: this);
    context.read<BeneficiariesCubit>().search('');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void onSearch(String query) => context.read<BeneficiariesCubit>().search(query);

  @override
  void onSelect(Beneficiary beneficiary) {
    context.read<SendMoneyCubit>().selectRecipient(beneficiary);
    unawaited(context.push(AppPaths.sendAmount));
  }

  @override
  void onNewRecipient() => unawaited(context.push(AppPaths.sendNewRecipient));

  @override
  void onNovaUser() => unawaited(context.push(AppPaths.sendNovaUser));

  @override
  Widget build(BuildContext context) => view.build(context);
}
