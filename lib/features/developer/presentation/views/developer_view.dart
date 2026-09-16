part of '../controllers/developer_controller.dart';

class DeveloperView extends StatelessWidget implements DeveloperViewContract {
  const DeveloperView({super.key, required this.controller});

  final DeveloperControllerContract controller;

  static ActivityStatus _status(OutboxStatus s) => switch (s) {
    OutboxStatus.queued => ActivityStatus.pending,
    OutboxStatus.sending => ActivityStatus.sending,
    OutboxStatus.succeeded => ActivityStatus.completed,
    OutboxStatus.failed => ActivityStatus.failed,
  };

  static String _shortKey(String key) =>
      key.length <= 13 ? key : '${key.substring(0, 8)}…${key.substring(key.length - 4)}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<DeveloperCubit>().state;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.devTitle)),
      body: StreamBuilder<List<OutboxItem>>(
        stream: controller.outbox,
        builder: (context, snapshot) {
          final items = snapshot.data ?? const <OutboxItem>[];
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                sliver: SliverList.list(
                  children: [
                    _Switches(settings: settings, controller: controller),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(l10n.devOutbox, style: AppTextStyles.caption.sp.copyWith(letterSpacing: 0.6)),
                        ),
                        Text(l10n.devOutboxItems(items.length), style: AppTextStyles.caption.sp),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    if (items.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Text(l10n.devOutboxEmpty, style: AppTextStyles.small.sp),
                      ),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return Container(
                      key: ValueKey(item.id),
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8.w,
                            runSpacing: 4.h,
                            children: [
                              Text(
                                '#${item.id} ${item.type.name} · ${item.counterpartyName ?? item.goalClientId ?? ''}',
                                style: AppTextStyles.body.sp,
                              ),
                              StatusPill(status: _status(item.status)),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          MoneyText(item.debitKobo, style: AppTextStyles.amountSmall.sp),
                          Text(
                            '${l10n.attemptsLabel}: ${item.attempts} · ${l10n.idempotencyKeyLabel}: ${_shortKey(item.idempotencyKey)}',
                            style: AppTextStyles.caption.sp,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
                sliver: SliverList.list(
                  children: [
                    NoticeCard(child: Text(l10n.devIdempotencyNote)),
                    SizedBox(height: 16.h),
                    NovaButton(
                      label: l10n.devSimulateCredit,
                      icon: Icons.south_west_rounded,
                      variant: NovaButtonVariant.secondary,
                      onPressed: controller.onSimulateIncomingPayment,
                    ),
                    SizedBox(height: 4.h),
                    Text(l10n.devSimulateCreditSub, style: AppTextStyles.small.sp, textAlign: TextAlign.center),
                    SizedBox(height: 16.h),
                    NovaButton(
                      label: l10n.devReset,
                      icon: Icons.restart_alt_rounded,
                      variant: NovaButtonVariant.danger,
                      onPressed: controller.onReset,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Switches extends StatelessWidget {
  const _Switches({required this.settings, required this.controller});

  final DevSettings settings;
  final DeveloperControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Column(
        children: [
          MergeSemantics(
            child: SwitchListTile(
              title: Text(l10n.devSimulateOffline, style: AppTextStyles.body.sp),
              subtitle: Text(l10n.devSimulateOfflineSub, style: AppTextStyles.small.sp),
              value: settings.simulateOffline,
              onChanged: controller.onSimulateOffline,
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          MergeSemantics(
            child: SwitchListTile(
              title: Text(l10n.devLoseResponse, style: AppTextStyles.body.sp),
              subtitle: Text(l10n.devLoseResponseSub, style: AppTextStyles.small.sp),
              value: settings.loseNextResponse,
              onChanged: controller.onLoseNextResponse,
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
            child: Row(
              children: [
                Expanded(child: Text(l10n.devLatency, style: AppTextStyles.body.sp)),
                Text(l10n.devLatencyMs(settings.latencyMs), style: AppTextStyles.amountSmall.sp),
              ],
            ),
          ),
          Slider(
            value: settings.latencyMs.clamp(0, 5000).toDouble(),
            max: 5000,
            divisions: 50,
            label: l10n.devLatencyMs(settings.latencyMs),
            semanticFormatterCallback: (v) => l10n.devLatencyMs(v.round()),
            onChanged: controller.onLatencyChanged,
          ),
        ],
      ),
    );
  }
}
