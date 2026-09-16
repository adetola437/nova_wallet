import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../config/di/app_initializer.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/goal_view.dart';
import '../../../../core/money/fees.dart';
import '../../../../core/money/money.dart';
import '../../../../core/money/progress.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/activity_row.dart';
import '../../../../core/widgets/nova_bottom_sheet.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../cubit/contribute_cubit.dart';
import '../../cubit/goal_details_cubit.dart';
import '../../cubit/move_to_wallet_cubit.dart';
import '../widgets/contribute_sheet.dart';
import '../widgets/goal_progress_bar.dart';
import '../widgets/move_to_wallet_sheet.dart';

part '../contracts/goal_details_contract.dart';
part '../views/goal_details_view.dart';

/// Board `4d`.
class GoalDetailsScreen extends StatefulWidget {
  const GoalDetailsScreen({super.key, required this.clientId});

  final String clientId;

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> implements GoalDetailsControllerContract {
  late final GoalDetailsViewContract view;

  @override
  void initState() {
    super.initState();
    view = GoalDetailsView(controller: this);
    context.read<GoalDetailsCubit>().open(widget.clientId);
  }

  @override
  String formatDate(DateTime date) => DateFormat('d MMM yyyy', 'en').format(date);

  @override
  int daysLeft(GoalView goal) {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    final end = DateTime.utc(goal.targetDate.year, goal.targetDate.month, goal.targetDate.day);
    return math.max(0, end.difference(today).inDays);
  }

  /// A fresh ContributeCubit per sheet: one contribution attempt each.
  @override
  void onContribute(GoalView goal) {
    showNovaBottomSheet<void>(
      context,
      builder: (_) => BlocProvider(
        create: (_) => sl<ContributeCubit>(param1: goal),
        child: const ContributeSheet(),
      ),
    );
  }

  @override
  void onMoveToWallet(GoalView goal) {
    showNovaBottomSheet<void>(
      context,
      builder: (_) => BlocProvider(
        create: (_) => sl<MoveToWalletCubit>(param1: goal),
        child: const MoveToWalletSheet(),
      ),
    );
  }

  @override
  bool isMatured(GoalView goal) => Fees.goalIsMatured(
    savedKobo: goal.savedKobo,
    targetKobo: goal.targetKobo,
    targetDate: goal.targetDate,
    now: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) => view.build(context);
}
