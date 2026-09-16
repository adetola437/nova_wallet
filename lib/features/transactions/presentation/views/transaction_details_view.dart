part of '../controllers/transaction_details_controller.dart';

class TransactionDetailsView extends StatelessWidget implements TransactionDetailsViewContract {
  const TransactionDetailsView({super.key, required this.controller});

  final TransactionDetailsControllerContract controller;

  static ActivityStatus _statusOf(OutboxStatus s) => switch (s) {
    OutboxStatus.queued => ActivityStatus.pending,
    OutboxStatus.sending => ActivityStatus.sending,
    OutboxStatus.succeeded => ActivityStatus.completed,
    OutboxStatus.failed => ActivityStatus.failed,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<TransactionDetailsCubit, TransactionDetailsState>(
      builder: (context, state) {
        final activity = state.activity;
        final item = state.outbox;
        final status = item != null ? _statusOf(item.status) : (activity?.status ?? ActivityStatus.completed);
        final title = item?.counterpartyName ?? activity?.title ?? '';
        final signed =
            activity?.signedKobo ??
            (item?.type == OutboxType.moveToWallet ? (item!.amountKobo - item.feeKobo) : -(item?.debitKobo ?? 0));
        final createdAt = item?.createdAt ?? activity?.createdAt;

        return Scaffold(
          appBar: AppBar(title: Text(l10n.detailsTitle)),
          body: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
            children: [
              Center(
                child: Text(title, textAlign: TextAlign.center, style: AppTextStyles.h2.sp),
              ),
              SizedBox(height: 4.h),
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: MoneyText(signed, signed: true, style: AppTextStyles.amountHero.sp),
                ),
              ),
              SizedBox(height: 8.h),
              Center(child: StatusPill(status: status)),
              if (item != null) ...[
                SizedBox(height: 24.h),
                Text(l10n.progressLabel, style: AppTextStyles.caption.sp.copyWith(letterSpacing: 0.6)),
                SizedBox(height: 8.h),
                _Card(
                  child: _Timeline(item: item, formatDate: controller.formatDate),
                ),
              ],
              SizedBox(height: 24.h),
              Text(l10n.detailsLabel, style: AppTextStyles.caption.sp.copyWith(letterSpacing: 0.6)),
              SizedBox(height: 8.h),
              _Card(
                child: Column(
                  children: [
                    if (item?.maskedAccount != null || activity?.subtitle != null)
                      SummaryRow(
                        label: l10n.accountLabel,
                        value: item == null
                            ? activity!.subtitle!
                            : [item.counterpartyBank, item.maskedAccount].whereType<String>().join(' · '),
                      ),
                    SummaryRow(label: l10n.amountLabel, kobo: item?.amountKobo ?? activity?.amountKobo ?? 0),
                    SummaryRow(label: l10n.feeLabel, kobo: item?.feeKobo ?? activity?.feeKobo ?? 0),
                    if ((item?.narration ?? activity?.narration) != null)
                      SummaryRow(label: l10n.narrationHint, value: (item?.narration ?? activity?.narration)!),
                    if (createdAt != null) SummaryRow(label: l10n.dateLabel, value: controller.formatDate(createdAt)),
                    if ((item?.serverRef ?? activity?.serverRef) != null)
                      SummaryRow(label: l10n.referenceLabel, value: (item?.serverRef ?? activity?.serverRef)!),
                    if (item != null) ...[
                      SummaryRow(label: l10n.idempotencyKeyLabel, value: _truncate(item.idempotencyKey)),
                      SummaryRow(label: l10n.attemptsLabel, value: '${item.attempts}'),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _truncate(String key) =>
      key.length <= 13 ? key : '${key.substring(0, 8)}…${key.substring(key.length - 4)}';
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: AppColors.border),
    ),
    child: child,
  );
}

/// Queued → Sending → Completed (or Failed).
class _Timeline extends StatelessWidget {
  const _Timeline({required this.item, required this.formatDate});

  final OutboxItem item;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final failed = item.status == OutboxStatus.failed;
    final sendingReached = item.status != OutboxStatus.queued || item.attempts > 0;
    final done = item.isTerminal;

    final steps = [
      (l10n.timelineQueued, l10n.timelineQueuedSub, true, formatDate(item.createdAt)),
      (
        l10n.timelineSending,
        l10n.timelineSendingSub,
        sendingReached,
        item.lastAttemptAt == null ? null : formatDate(item.lastAttemptAt!),
      ),
      (
        failed ? l10n.timelineFailed : l10n.timelineCompleted,
        failed ? (item.failureMessage ?? '') : l10n.timelineCompletedSub,
        done,
        item.completedAt == null ? null : formatDate(item.completedAt!),
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          MergeSemantics(
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10.h),
                      Icon(
                        !steps[i].$3
                            ? Icons.radio_button_unchecked_rounded
                            : (i == 2 && failed ? Icons.cancel_rounded : Icons.check_circle_rounded),
                        size: 20.r,
                        color: !steps[i].$3
                            ? AppColors.textTertiary
                            : (i == 2 && failed ? AppColors.failedInk : AppColors.sentInk),
                        semanticLabel: steps[i].$3 ? '✓' : null,
                      ),
                      if (i < steps.length - 1)
                        Expanded(
                          child: Container(width: 2, color: steps[i + 1].$3 ? AppColors.sentInk : AppColors.border),
                        ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            steps[i].$1,
                            style: AppTextStyles.body.sp.copyWith(
                              color: steps[i].$3 ? AppColors.textPrimary : AppColors.textTertiary,
                            ),
                          ),
                          if (steps[i].$2.isNotEmpty) Text(steps[i].$2, style: AppTextStyles.small.sp),
                          if (steps[i].$4 != null)
                            Text(steps[i].$4!, style: AppTextStyles.caption.sp.copyWith(color: AppColors.textTertiary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
