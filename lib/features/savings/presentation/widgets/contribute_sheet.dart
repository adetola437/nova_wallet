import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/flavor/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/failure_text.dart';
import '../../../../core/money/money.dart';
import '../../../../core/money/money_semantics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/widgets/amount_input.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../../core/widgets/pin_pad.dart';
import '../../../connectivity/cubit/connectivity_cubit.dart';
import '../../../wallet/cubit/wallet_cubit.dart';
import '../../cubit/contribute_cubit.dart';
import '../../cubit/contribute_state.dart';

/// Boards `4e` (online) / `4f` (offline). Amount → PIN → outcome, in one sheet.
class ContributeSheet extends StatefulWidget {
  const ContributeSheet({super.key});

  @override
  State<ContributeSheet> createState() => _ContributeSheetState();
}

class _ContributeSheetState extends State<ContributeSheet> {
  final TextEditingController _amount = TextEditingController();
  bool _pinStage = false;
  String _pin = '';

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _onDigit(int d) async {
    final cubit = context.read<ContributeCubit>();
    if (_pin.length >= AppConstants.pinLength || cubit.state.stage != ContributeStage.editing) return;
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
    final cubit = context.read<ContributeCubit>();
    final offline = context.select<ConnectivityCubit, bool>((c) => c.state != ConnectivityStatus.online);
    final available = context.select<WalletCubit, int>((c) => c.state.overview.availableKobo);
    final languageCode = Localizations.localeOf(context).languageCode;

    return BlocBuilder<ContributeCubit, ContributeState>(
      builder: (context, state) {
        if (state.stage == ContributeStage.done) return _Outcome(state: state);

        final header = [
          Semantics(header: true, child: Text(l10n.contributeTitle(cubit.goal.name), style: AppTextStyles.h2.sp)),
          SizedBox(height: 4.h),
          Text(l10n.contributeSub, style: AppTextStyles.small.sp),
          SizedBox(height: 16.h),
        ];

        if (_pinStage) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...header,
              Text(l10n.pinTitle, textAlign: TextAlign.center, style: AppTextStyles.body.sp),
              SizedBox(height: 4.h),
              Center(child: MoneyText(state.amountKobo ?? 0, style: AppTextStyles.amountBody.sp)),
              SizedBox(height: 16.h),
              PinDots(length: _pin.length, hasError: state.pinError),
              SizedBox(height: 8.h),
              if (state.pinError) Center(child: InlineError(l10n.pinWrong)),
              if (state.stage == ContributeStage.submitting)
                const Center(
                  child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
                ),
              SizedBox(height: 8.h),
              PinPad(onDigit: _onDigit, onDelete: _onDelete, enabled: state.stage == ContributeStage.editing),
            ],
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...header,
            if (offline) ...[
              NoticeCard(
                icon: Icons.wifi_off_rounded,
                background: AppColors.pendingBg,
                ink: AppColors.pendingInk,
                child: Text(l10n.contributeOfflineNotice),
              ),
              SizedBox(height: 16.h),
            ],
            AmountInput(
              controller: _amount,
              onChanged: cubit.amountChanged,
              semanticLabel: l10n.contributeAmountQuestion,
              errorText: state.validation?.localized(l10n),
              helper: Semantics(
                label:
                    '${l10n.contributeFrom}, ${l10n.availableAmount(MoneySemantics.label(available, languageCode: languageCode))}',
                excludeSemantics: true,
                child: Text(
                  '${l10n.contributeFrom} · ${l10n.availableAmount(Money(available).format())}',
                  style: AppTextStyles.small.sp.copyWith(fontFeatures: AppTextStyles.tabular),
                ),
              ),
            ),
            if (state.amountKobo != null &&
                cubit.goal.savedKobo + cubit.goal.pendingKobo + state.amountKobo! > cubit.goal.targetKobo) ...[
              SizedBox(height: 12.h),
              NoticeCard(
                icon: Icons.emoji_events_outlined,
                background: AppColors.sentBg,
                ink: AppColors.sentInk,
                child: Text(l10n.contributePastTarget),
              ),
            ],
            SizedBox(height: 16.h),
            Text(offline ? l10n.contributeHeld : l10n.contributeNoFee, style: AppTextStyles.small.sp),
            SizedBox(height: 16.h),
            NovaButton(
              label: offline ? l10n.queueContribution : l10n.continueLabel,
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

  final ContributeState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (Color bg, Color ink, IconData icon, String title) = switch (state.outcome) {
      ContributeOutcome.saved => (AppColors.sentBg, AppColors.sentInk, Icons.check_rounded, l10n.contributeSaved),
      ContributeOutcome.pending => (
        AppColors.pendingBg,
        AppColors.pendingInk,
        Icons.schedule_rounded,
        l10n.contributePending,
      ),
      ContributeOutcome.failed => (AppColors.failedBg, AppColors.failedInk, Icons.close_rounded, l10n.contributeFailed),
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
        Center(child: MoneyText(state.amountKobo ?? 0, style: AppTextStyles.amountBody.sp)),
        if (state.outcome == ContributeOutcome.pending) ...[
          SizedBox(height: 8.h),
          Text(l10n.contributeHeld, textAlign: TextAlign.center, style: AppTextStyles.small.sp),
        ],
        SizedBox(height: 24.h),
        NovaButton(label: l10n.done, onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}
