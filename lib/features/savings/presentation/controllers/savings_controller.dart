import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/goal_view.dart';
import '../../../../core/money/money.dart';
import '../../../../core/money/money_semantics.dart';
import '../../../../core/money/progress.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../connectivity/cubit/connectivity_cubit.dart';
import '../../cubit/savings_cubit.dart';
import '../widgets/goal_progress_bar.dart';

part '../contracts/savings_contract.dart';
part '../views/savings_view.dart';

/// Boards `4a` (goals) and `4b` (empty).
class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> implements SavingsControllerContract {
  late final SavingsViewContract view;

  @override
  void initState() {
    super.initState();
    view = SavingsView(controller: this);
  }

  @override
  String formatDate(DateTime date) => DateFormat('d MMM yyyy', 'en').format(date);

  @override
  Future<void> onRefresh() => context.read<SavingsCubit>().refresh();

  @override
  void onCreateGoal([String? suggestedName]) => unawaited(context.push(AppPaths.saveCreate, extra: suggestedName));

  @override
  void onOpenGoal(GoalView goal) => unawaited(context.push('${AppPaths.saveGoal}/${goal.clientId}'));

  @override
  Widget build(BuildContext context) => view.build(context);
}
