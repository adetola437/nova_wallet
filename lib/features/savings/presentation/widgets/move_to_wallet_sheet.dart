import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../config/flavor/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/failure_text.dart';
import '../../../../core/money/money.dart';
import '../../../../core/money/money_semantics.dart';
import '../../../../core/money/progress.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/widgets/amount_input.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../../core/widgets/pin_pad.dart';
import '../../../connectivity/cubit/connectivity_cubit.dart';
import '../../../send_money/presentation/widgets/summary_row.dart';
import '../../cubit/move_to_wallet_cubit.dart';
import '../../cubit/move_to_wallet_state.dart';

/// Goal → wallet: amount → PIN → outcome, in one sheet. Before the goal
/// matures it is a "break", and the fee is spelled out before the PIN.
class MoveToWalletSheet extends StatefulWidget {
  const MoveToWalletSheet({super.key});

  @override
  State<MoveToWalletSheet> createState() => _MoveToWalletSheetState();
}

class _MoveToWalletSheetState extends State<MoveToWalletSheet> {
  final TextEditingController _amount = TextEditingController();
  bool _pinStage = false;
  String _pin = '';

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _moveAll(MoveToWalletCubit cubit) {
    cubit.moveAll();
    final text = cubit.state.amountText;
    _amount.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  Future<void> _onDigit(int d) async {
    final cubit = context.read<MoveToWalletCubit>();
    if (_pin.length >= AppConstants.pinLength || cubit.state.stage != MoveStage.editing) return;
    setState(() => _pin += '$d');
    if (_pin.length < AppConstants.pinLength) return;
    await cubit.submit(_pin);
    if (mounted && cubit.state.pinError) setState(() => _pin = '');
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<MoveToWalletCubit>();
    final goal = cubit.goal;
    final offline = context.select<ConnectivityCubit, bool>((c) => c.state != ConnectivityStatus.online);
    final languageCode = Localizations.localeOf(context).languageCode;
    final percent = Progress.formatPercent(AppConstants.goalBreakFeeBps);
    final matured = cubit.isMatured;

    return BlocBuilder<MoveToWalletCubit, MoveToWalletState>(
      builder: (context, state) {
        if (state.stage == MoveStage.done) return _Outcome(state: state);

        final header = [
          Semantics(header: true, child: Text(l10n.moveTitle(goal.name), style: AppTextStyles.h2.sp)),
          SizedBox(height: 4.h),
          Text(l10n.moveSub, style: AppTextStyles.small.sp),
          SizedBox(height: 16.h),
        ];

        final breakdown = Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(color: AppColors.appBg, borderRadius: BorderRadius.circular(12.r)),
          child: Column(
            children: [
              SummaryRow(label: l10n.amountLabel, kobo: state.amountKobo ?? 0),
              if (state.feeKobo > 0)
                SummaryRow(label: l10n.breakFeeLabel(percent), kobo: -state.feeKobo, valueColor: AppColors.failedInk),
              SummaryRow(label: l10n.moveYouReceive, kobo: state.receiveKobo, emphasis: true),
            ],
          ),
        );

        if (_pinStage) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...header,
              breakdown,
              SizedBox(height: 16.h),
              Text(l10n.pinTitle, textAlign: TextAlign.center, style: AppTextStyles.body.sp),
              SizedBox(height: 12.h),
              PinDots(length: _pin.length, hasError: state.pinError),
              SizedBox(height: 8.h),
              if (state.pinError) Center(child: InlineError(l10n.pinWrong)),
              if (state.stage == MoveStage.submitting)
                const Center(
                  child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
                ),
              SizedBox(height: 8.h),
              PinPad(onDigit: _onDigit, onDelete: _onDelete, enabled: state.stage == MoveStage.editing),
            ],
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...header,
            if (matured)
              NoticeCard(
                icon: Icons.check_circle_outline_rounded,
                background: AppColors.sentBg,
                ink: AppColors.sentInk,
                child: Text(l10n.moveFree),
              )
            else
              NoticeCard(
                icon: Icons.warning_amber_rounded,
                background: AppColors.pendingBg,
                ink: AppColors.pendingInk,
                child: Text(
                  l10n.breakFeeWarning(
                    percent,
                    Money(goal.targetKobo).format(),
                    DateFormat('d MMM yyyy', 'en').format(goal.targetDate),
                  ),
                ),
              ),
            if (offline) ...[
              SizedBox(height: 8.h),
              NoticeCard(icon: Icons.wifi_off_rounded, child: Text(l10n.moveOfflineNotice)),
            ],
            SizedBox(height: 16.h),
            AmountInput(
              controller: _amount,
              onChanged: cubit.amountChanged,
              semanticLabel: l10n.moveQuestion,
              quickAmountsKobo: const [],
              errorText: state.validation?.localized(l10n),
              helper: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      label: l10n.moveInGoal(MoneySemantics.label(goal.movableKobo, languageCode: languageCode)),
                      excludeSemantics: true,
                      child: Text(
                        l10n.moveInGoal(Money(goal.movableKobo).format()),
                        style: AppTextStyles.small.sp.copyWith(fontFeatures: AppTextStyles.tabular),
                      ),
                    ),
                  ),
                  TextButton(onPressed: () => _moveAll(cubit), child: Text(l10n.moveAll)),
                ],
              ),
            ),
            if (state.amountKobo != null && state.validation == null) ...[SizedBox(height: 16.h), breakdown],
            SizedBox(height: 12.h),
            Text(l10n.movePinNote, style: AppTextStyles.small.sp),
            SizedBox(height: 16.h),
            NovaButton(
              label: offline ? l10n.queueMove : l10n.continueLabel,
              onPressed: state.canSubmit ? () => setState(() => _pinStage = true) : null,
            ),
          ],
        );
      },
    );
  }
}

class _Outcome extends StatelessWidget {
  const _Outcome({required this.state});

  final MoveToWalletState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (Color bg, Color ink, IconData icon, String title) = switch (state.outcome) {
      MoveOutcome.moved => (AppColors.sentBg, AppColors.sentInk, Icons.check_rounded, l10n.moveDone),
      MoveOutcome.pending => (AppColors.pendingBg, AppColors.pendingInk, Icons.schedule_rounded, l10n.movePending),
      MoveOutcome.failed => (AppColors.failedBg, AppColors.failedInk, Icons.close_rounded, l10n.moveFailed),
      _ => (AppColors.sendingBg, AppColors.sendingInk, Icons.sync_rounded, l10n.resultProcessingTitle),
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: ExcludeSemantics(
            child: Container(
              width: 72.r,
              height: 72.r,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, size: 36.r, color: ink),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Semantics(
          liveRegion: true,
          header: true,
          child: Text(title, textAlign: TextAlign.center, style: AppTextStyles.h2.sp),
        ),
        SizedBox(height: 4.h),
        Center(child: MoneyText(state.receiveKobo, style: AppTextStyles.amountBody.sp)),
        if (state.outcome == MoveOutcome.failed && state.item?.failureMessage != null) ...[
          SizedBox(height: 8.h),
          Text(state.item!.failureMessage!, textAlign: TextAlign.center, style: AppTextStyles.small.sp),
        ],
        SizedBox(height: 24.h),
        NovaButton(label: l10n.done, onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}
