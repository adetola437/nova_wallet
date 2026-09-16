part of '../controllers/send_result_controller.dart';

class SendResultView extends StatelessWidget implements SendResultViewContract {
  const SendResultView({super.key, required this.controller});

  final SendResultControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<SendMoneyCubit, SendMoneyState>(
      buildWhen: (a, b) => b.stage == SendStage.result,
      builder: (context, state) {
        final outcome = state.outcome ?? SendOutcome.processing;
        final item = state.item;
        final name = state.recipient?.verifiedName ?? item?.counterpartyName ?? '';

        final (Color bg, Color ink, IconData icon, String title, String? body) = switch (outcome) {
          SendOutcome.sent => (AppColors.sentBg, AppColors.sentInk, Icons.check_rounded, l10n.resultSentTo(name), null),
          SendOutcome.pending => (
            AppColors.pendingBg,
            AppColors.pendingInk,
            Icons.schedule_rounded,
            l10n.resultPendingTitle,
            l10n.resultPendingBody,
          ),
          SendOutcome.processing => (
            AppColors.sendingBg,
            AppColors.sendingInk,
            Icons.sync_rounded,
            l10n.resultProcessingTitle,
            l10n.resultProcessingBody,
          ),
          SendOutcome.failed => (
            AppColors.failedBg,
            AppColors.failedInk,
            Icons.close_rounded,
            l10n.resultFailedTitle,
            l10n.resultNotDebited,
          ),
        };

        return NovaFormScaffold(
          showBack: false,
          actions: [
            if (outcome == SendOutcome.failed) NovaButton(label: l10n.retry, onPressed: controller.onTryAgain),
            NovaButton(
              label: l10n.done,
              onPressed: controller.onDone,
              variant: outcome == SendOutcome.failed ? NovaButtonVariant.secondary : NovaButtonVariant.primary,
            ),
            if (item != null)
              NovaButton(label: l10n.viewDetails, onPressed: controller.onViewDetails, variant: NovaButtonVariant.text),
          ],
          content: [
            SizedBox(height: 24.h),
            Center(
              child: ExcludeSemantics(
                child: Container(
                  width: 88.r,
                  height: 88.r,
                  decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                  child: Icon(icon, size: 44.r, color: ink),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Semantics(
              header: true,
              liveRegion: true,
              child: Text(title, textAlign: TextAlign.center, style: AppTextStyles.h1.sp),
            ),
            SizedBox(height: 8.h),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: MoneyText(state.amountKobo ?? item?.amountKobo ?? 0, style: AppTextStyles.amountHero.sp),
              ),
            ),
            if (body != null) ...[
              SizedBox(height: 12.h),
              Text(
                body,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.sp.copyWith(color: AppColors.textSecondary),
              ),
            ],
            if (outcome == SendOutcome.failed && item?.failureMessage != null) ...[
              SizedBox(height: 8.h),
              Text(item!.failureMessage!, textAlign: TextAlign.center, style: AppTextStyles.small.sp),
            ],
            SizedBox(height: 24.h),
            if (item != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    SummaryRow(label: l10n.toLabel, value: name),
                    if (item.maskedAccount != null)
                      SummaryRow(
                        label: l10n.accountLabel,
                        value: [item.counterpartyBank, item.maskedAccount].whereType<String>().join(' · '),
                      ),
                    if (outcome == SendOutcome.pending || outcome == SendOutcome.processing)
                      SummaryRow(label: l10n.heldFromBalance, kobo: item.debitKobo)
                    else
                      SummaryRow(label: l10n.totalDebit, kobo: item.debitKobo),
                    if (item.serverRef != null)
                      Row(
                        children: [
                          Expanded(
                            child: SummaryRow(label: l10n.referenceLabel, value: item.serverRef!),
                          ),
                          IconButton(
                            tooltip: l10n.copy,
                            icon: Icon(Icons.copy_rounded, size: 18.r),
                            onPressed: () => controller.onCopyReference(item.serverRef!),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
