part of '../controllers/send_review_controller.dart';

class SendReviewView extends StatelessWidget implements SendReviewViewContract {
  const SendReviewView({super.key, required this.controller});

  final SendReviewControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final offline = context.select<ConnectivityCubit, bool>((c) => c.state != ConnectivityStatus.online);
    final available = context.select<WalletCubit, int>((c) => c.state.overview.availableKobo);

    return BlocBuilder<SendMoneyCubit, SendMoneyState>(
      builder: (context, state) {
        final recipient = state.recipient!;
        final submitting = state.stage == SendStage.submitting;
        final amount = state.amountKobo ?? 0;

        return NovaFormScaffold(
          appBarTitle: l10n.reviewTitle,
          actions: [
            NovaButton(
              label: offline ? l10n.queueTransfer : l10n.sendCta(Money(state.debitKobo).format()),
              icon: offline ? Icons.schedule_send_rounded : Icons.lock_outline_rounded,
              isLoading: submitting,
              onPressed: controller.onConfirm,
            ),
            NovaButton(
              label: l10n.editDetails,
              variant: NovaButtonVariant.text,
              onPressed: submitting ? null : controller.onEdit,
            ),
          ],
          content: [
            if (offline) ...[
              NoticeCard(
                icon: Icons.wifi_off_rounded,
                background: AppColors.pendingBg,
                ink: AppColors.pendingInk,
                child: Text(l10n.reviewOfflineNotice),
              ),
              SizedBox(height: 16.h),
            ],
            Center(child: Text(l10n.youAreSending, style: AppTextStyles.small.sp)),
            SizedBox(height: 4.h),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: MoneyText(amount, style: AppTextStyles.amountHero.sp),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  SummaryRow(label: l10n.toLabel, value: recipient.verifiedName),
                  SummaryRow(label: l10n.accountLabel, value: '${recipient.bankName} · ${recipient.maskedAccount}'),
                  if (state.narration.isNotEmpty) SummaryRow(label: l10n.narrationHint, value: state.narration),
                  const Divider(),
                  SummaryRow(label: l10n.amountLabel, kobo: amount),
                  SummaryRow(label: l10n.feeLabel, kobo: state.feeKobo),
                  SummaryRow(label: l10n.totalDebit, kobo: state.debitKobo, emphasis: true),
                  SummaryRow(
                    label: offline ? '${l10n.balanceAfter} · ${l10n.heldUntilSent}' : l10n.balanceAfter,
                    kobo: available - state.debitKobo,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(offline ? l10n.reviewOfflineFooter : l10n.reviewNoCharges, style: AppTextStyles.small.sp),
            if (state.submitFailure != null) ...[
              SizedBox(height: 12.h),
              InlineError(state.submitFailure!.localized(l10n)),
            ],
          ],
        );
      },
    );
  }
}
