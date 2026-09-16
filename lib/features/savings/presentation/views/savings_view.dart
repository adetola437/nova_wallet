part of '../controllers/savings_controller.dart';

class SavingsView extends StatelessWidget implements SavingsViewContract {
  const SavingsView({super.key, required this.controller});

  final SavingsControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final offline = context.select<ConnectivityCubit, bool>((c) => c.state == ConnectivityStatus.offline);
    final goals = context.watch<SavingsCubit>().state;

    final totalSaved = goals.fold<int>(0, (sum, g) => sum + g.savedKobo);
    final totalPending = goals.fold<int>(0, (sum, g) => sum + g.pendingKobo);
    final pendingGoals = goals.where((g) => g.pendingKobo > 0).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.saveTitle),
        actions: [
          if (goals.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Center(child: Text(l10n.saveGoalsCount(goals.length), style: AppTextStyles.small.sp)),
            ),
        ],
      ),
      body: Column(
        children: [
          if (offline) OfflineBanner(message: l10n.offlineBannerSave),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.onRefresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  if (goals.isEmpty)
                    SliverToBoxAdapter(child: _Empty(controller: controller))
                  else ...[
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: AppColors.navy900,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.saveTotalSaved,
                                style: AppTextStyles.caption.sp.copyWith(color: AppColors.onNavyMuted),
                              ),
                              SizedBox(height: 4.h),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: MoneyText(
                                  totalSaved,
                                  style: AppTextStyles.amountHero.sp.copyWith(color: AppColors.onNavy),
                                ),
                              ),
                              if (totalPending > 0) ...[
                                SizedBox(height: 6.h),
                                _PendingAcross(kobo: totalPending, count: pendingGoals),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverList.separated(
                        itemCount: goals.length,
                        separatorBuilder: (_, _) => SizedBox(height: 12.h),
                        itemBuilder: (context, i) =>
                            _GoalCard(key: ValueKey(goals[i].clientId), goal: goals[i], controller: controller),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                      sliver: SliverToBoxAdapter(
                        child: NovaButton(
                          label: l10n.saveCreateGoal,
                          icon: Icons.add_rounded,
                          variant: NovaButtonVariant.secondary,
                          onPressed: controller.onCreateGoal,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingAcross extends StatelessWidget {
  const _PendingAcross({required this.kobo, required this.count});

  final int kobo;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    return Semantics(
      label: l10n.savePendingAcross(MoneySemantics.label(kobo, languageCode: languageCode), count),
      excludeSemantics: true,
      child: Text(
        l10n.savePendingAcross(Money(kobo).format(), count),
        style: AppTextStyles.small.sp.copyWith(color: AppColors.gold500, fontFeatures: AppTextStyles.tabular),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({super.key, required this.goal, required this.controller});

  final GoalView goal;
  final SavingsControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final percent = Progress.formatPercent(
      Progress.uncappedBps(savedKobo: goal.savedKobo, targetKobo: goal.targetKobo),
    );
    final reached = goal.savedKobo >= goal.targetKobo;

    final Widget? pill = switch (goal.syncState) {
      GoalSyncState.pending => _Pill(
        l10n.saveGoalSyncing,
        AppColors.sendingBg,
        AppColors.sendingInk,
        Icons.sync_rounded,
      ),
      GoalSyncState.failed => _Pill(l10n.saveGoalFailed, AppColors.failedBg, AppColors.failedInk, Icons.error_rounded),
      GoalSyncState.synced when reached => _Pill(
        l10n.saveGoalReached,
        AppColors.sentBg,
        AppColors.sentInk,
        Icons.check_circle_rounded,
      ),
      GoalSyncState.synced when goal.pendingKobo > 0 => _Pill(
        l10n.savePendingPill(Money(goal.pendingKobo).format()),
        AppColors.pendingBg,
        AppColors.pendingInk,
        Icons.schedule_rounded,
      ),
      _ => null,
    };

    final spoken = [
      goal.name,
      l10n.saveOfTarget(
        MoneySemantics.label(goal.savedKobo, languageCode: languageCode),
        MoneySemantics.label(goal.targetKobo, languageCode: languageCode),
      ),
      l10n.goalProgressA11y(percent),
      if (pill is _Pill) pill.label,
      l10n.saveTargetDate(controller.formatDate(goal.targetDate)),
    ].join(', ');

    return Semantics(
      button: true,
      label: spoken,
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => controller.onOpenGoal(goal),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8.w,
                  runSpacing: 4.h,
                  children: [
                    Text(goal.name, style: AppTextStyles.h2.sp),
                    ?pill,
                  ],
                ),
                SizedBox(height: 12.h),
                GoalProgressBar(savedBps: goal.savedBps, projectedBps: goal.projectedBps),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.saveOfTarget(Money(goal.savedKobo).format(), Money(goal.targetKobo).format()),
                        style: AppTextStyles.small.sp.copyWith(fontFeatures: AppTextStyles.tabular),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(percent, style: AppTextStyles.amountSmall.sp),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  l10n.saveTargetDate(controller.formatDate(goal.targetDate)),
                  style: AppTextStyles.caption.sp.copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label, this.bg, this.ink, this.icon);

  final String label;
  final Color bg;
  final Color ink;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8.r)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.r, color: ink),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(label, style: AppTextStyles.caption.sp.copyWith(color: ink)),
        ),
      ],
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty({required this.controller});

  final SavingsControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ideas = [l10n.saveIdeaRent, l10n.saveIdeaSchool, l10n.saveIdeaEmergency];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          EmptyState(
            icon: Icons.diamond_outlined,
            title: l10n.saveEmptyTitle,
            body: l10n.saveEmptyBody,
            action: NovaButton(label: l10n.saveCreateGoal, onPressed: controller.onCreateGoal),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(l10n.savePopular, style: AppTextStyles.caption.sp.copyWith(letterSpacing: 0.6)),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final idea in ideas)
                ActionChip(
                  label: Text(idea, style: AppTextStyles.small.sp.copyWith(color: AppColors.textPrimary)),
                  onPressed: () => controller.onCreateGoal(idea),
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.border),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
