import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/failure_text.dart';
import '../../../../core/money/money.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/nova_bottom_sheet.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../connectivity/cubit/connectivity_cubit.dart';
import '../../../wallet/cubit/wallet_cubit.dart';
import '../../cubit/send_money_cubit.dart';
import '../../cubit/send_money_state.dart';
import '../widgets/authorise_sheets.dart';
import '../widgets/summary_row.dart';

part '../contracts/send_review_contract.dart';
part '../views/send_review_view.dart';

/// Boards `2f` (online) and `2g` (offline: queue).
class SendReviewScreen extends StatefulWidget {
  const SendReviewScreen({super.key});

  @override
  State<SendReviewScreen> createState() => _SendReviewScreenState();
}

class _SendReviewScreenState extends State<SendReviewScreen> implements SendReviewControllerContract {
  late final SendReviewViewContract view;
  late final SendMoneyCubit _cubit = context.read<SendMoneyCubit>();
  StreamSubscription<SendMoneyState>? _sub;

  @override
  void initState() {
    super.initState();
    view = SendReviewView(controller: this);
    var lastStage = _cubit.state.stage;
    _sub = _cubit.stream.listen((state) {
      // Item updates keep arriving while on the result screen; push once, on
      // the transition only.
      final entered = state.stage == SendStage.result && lastStage != SendStage.result;
      lastStage = state.stage;
      if (entered && mounted) unawaited(context.push(AppPaths.sendResult));
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  void onEdit() {
    _cubit.backToAmount();
    context.pop();
  }

  @override
  void onConfirm() {
    if (_cubit.state.requiresBiometric) {
      _openBiometricSheet();
    } else {
      _openPinSheet();
    }
  }

  bool _sheetOpen = false;

  Future<void> _openPinSheet({bool showFallbackNotice = false}) async {
    if (_sheetOpen) return;
    _sheetOpen = true;
    await showNovaBottomSheet<void>(
      context,
      builder: (_) => BlocProvider.value(
        value: _cubit,
        child: PinAuthoriseSheet(showFallbackNotice: showFallbackNotice),
      ),
    );
    _sheetOpen = false;
  }

  Future<void> _openBiometricSheet() async {
    if (_sheetOpen) return;
    _sheetOpen = true;
    final usePin = await showNovaBottomSheet<bool>(
      context,
      builder: (_) => BlocProvider.value(value: _cubit, child: const BiometricAuthoriseSheet()),
    );
    _sheetOpen = false;
    if (!mounted || _cubit.state.stage != SendStage.review) return;
    // Either the user chose the PIN, or biometrics couldn't run on this device.
    if (usePin == true || _cubit.state.needsPinFallback) {
      unawaited(_openPinSheet(showFallbackNotice: _cubit.state.needsPinFallback));
    }
  }

  @override
  Widget build(BuildContext context) => view.build(context);
}
