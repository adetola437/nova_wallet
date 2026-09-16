import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/wallet_overview.dart';
import '../../../../core/money/money.dart';
import '../../../../core/money/money_semantics.dart';
import '../../../../core/models/activity_item.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/activity_row.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/sync_chip.dart';
import '../../../auth/cubit/auth_cubit.dart';
import '../../../transactions/presentation/controllers/transaction_details_controller.dart';
import '../../../connectivity/cubit/connectivity_cubit.dart';
import '../../../sync/cubit/sync_cubit.dart';
import '../../../sync/cubit/sync_state.dart';
import '../../../wallet/cubit/wallet_cubit.dart';
import '../../../wallet/cubit/wallet_state.dart';

part '../contracts/home_contract.dart';
part '../views/home_view.dart';
part '../widgets/balance_card.dart';
part '../widgets/quick_actions.dart';

/// Boards `1c`–`1g`, `4i`, `4k`.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeControllerContract {
  late final HomeViewContract view;

  @override
  bool balanceHidden = false;

  @override
  void initState() {
    super.initState();
    view = HomeView(controller: this);
  }

  @override
  String greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.homeGreetingMorning;
    if (hour < 17) return l10n.homeGreeting;
    return l10n.homeGreetingEvening;
  }

  @override
  String activitySubtitle(ActivityItem item, AppLocalizations l10n) {
    final time = _timeLabel(item.createdAt, l10n);
    if (item.status == ActivityStatus.pending || item.status == ActivityStatus.sending) {
      return l10n.queuedAt(time);
    }
    return item.subtitle == null || item.subtitle!.isEmpty ? time : '${item.subtitle} · $time';
  }

  /// Dates are formatted with the English pattern: intl has no Yorùbá date
  /// symbols, and the digits read the same either way.
  String _timeLabel(DateTime at, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(at.year, at.month, at.day);
    final clock = DateFormat.jm('en').format(at);
    if (day == today) return '${l10n.today}, $clock';
    if (day == today.subtract(const Duration(days: 1))) return '${l10n.yesterday}, $clock';
    return DateFormat('d MMM, h:mm a', 'en').format(at);
  }

  @override
  void onToggleBalance() => setState(() => balanceHidden = !balanceHidden);

  @override
  Future<void> onRefresh() => context.read<WalletCubit>().refresh();

  @override
  void onSend() => unawaited(context.push(AppPaths.send));

  @override
  void onSave() => context.go(AppPaths.save);

  @override
  void onAddMoney() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.homeAddMoneySoon)));
  }

  @override
  void onActivityTap(ActivityItem item) =>
      unawaited(context.push(AppPaths.transaction, extra: TransactionDetailsArgs(activity: item)));

  /// Loads the next page when the user nears the end of the list.
  @override
  bool onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.pixels < metrics.maxScrollExtent - 400) return false;
    final wallet = context.read<WalletCubit>();
    if (wallet.state.activity.length >= wallet.state.limit) wallet.loadMore();
    return false;
  }

  @override
  Widget build(BuildContext context) => view.build(context);
}
