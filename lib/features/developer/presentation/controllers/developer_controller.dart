import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/activity_item.dart';
import '../../../../core/models/outbox_item.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../../connectivity/cubit/connectivity_cubit.dart';
import '../../cubit/developer_cubit.dart';
import '../../repository/developer_repository.dart' show DevSettings;

part '../contracts/developer_contract.dart';
part '../views/developer_view.dart';

/// Board `4h`. Demo switches plus a live view of the outbox.
class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> implements DeveloperControllerContract {
  late final DeveloperViewContract view;
  late final DeveloperCubit _cubit = context.read<DeveloperCubit>();

  @override
  late final Stream<List<OutboxItem>> outbox = _cubit.watchOutbox();

  @override
  void initState() {
    super.initState();
    view = DeveloperView(controller: this);
  }

  /// Flipping the switch also re-probes connectivity, so the offline banner
  /// and the sync engine react straight away.
  @override
  Future<void> onSimulateOffline(bool value) async {
    await _cubit.setSimulateOffline(value);
    if (mounted) await context.read<ConnectivityCubit>().recheck();
  }

  @override
  void onLoseNextResponse(bool value) => _cubit.setLoseNextResponse(value);

  @override
  void onLatencyChanged(double value) => _cubit.setLatency(value.round());

  @override
  Future<void> onSimulateIncomingPayment() => _cubit.simulateIncomingPayment();

  @override
  Future<void> onReset() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.devReset),
        content: Text(l10n.devResetConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.devReset)),
        ],
      ),
    );
    if (confirmed == true) await _cubit.resetDemoData();
  }

  @override
  Widget build(BuildContext context) => view.build(context);
}
