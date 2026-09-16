part of '../controllers/goal_details_controller.dart';

class GoalDetailsView extends StatelessWidget implements GoalDetailsViewContract {
  const GoalDetailsView({super.key, required this.controller});

  final GoalDetailsControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<GoalDetailsCubit, GoalDetailsState>(
      builder: (context, state) {
        final goal = state.goal;
        if (goal == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: state.loaded ? Text(l10n.errorGoalNotFound) : const CircularProgressIndicator()),
          );
        }
        final percent = Progress.formatPercent(
          Progress.uncappedBps(savedKobo: goal.savedKobo, targetKobo: goal.targetKobo),
        );
        final canContribute = goal.syncState != GoalSyncState.failed;

        return Scaffold(
          appBar: AppBar(title: Text(goal.name)),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NovaButton(
                    label: l10n.contribute,
                    icon: Icons.add_rounded,
                    onPressed: canContribute ? () => controller.onContribute(goal) : null,
                  ),
                  if (goal.savedKobo > 0) ...[
                    SizedBox(height: 8.h),
                    // Before the goal matures, moving money out is a break (with a fee).
                    NovaButton(
                      label: controller.isMatured(goal) ? l10n.moveToWallet : l10n.breakGoal,
                      icon: Icons.account_balance_wallet_outlined,
                      variant: NovaButtonVariant.secondary,
                      onPressed: goal.movableKobo > 0 ? () => controller.onMoveToWallet(goal) : null,
                    ),
                  ],
                ],
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                sliver: SliverList.list(
                  children: [
                    if (goal.isReached) ...[
                      Semantics(
                        container: true,
                        child: Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(color: AppColors.sentBg, borderRadius: BorderRadius.circular(12.r)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExcludeSemantics(
                                child: Icon(Icons.emoji_events_rounded, size: 20.r, color: AppColors.sentInk),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  l10n.goalReachedBanner,
                                  style: AppTextStyles.small.sp.copyWith(color: AppColors.sentInk),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],
                    Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            label: l10n.goalProgressA11y(percent),
                            excludeSemantics: true,
                            child: Text(percent, style: AppTextStyles.amountHero.sp),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            l10n.saveOfTarget(Money(goal.savedKobo).format(), Money(goal.targetKobo).format()),
                            style: AppTextStyles.small.sp.copyWith(fontFeatures: AppTextStyles.tabular),
                          ),
                          SizedBox(height: 16.h),
                          GoalProgressBar(savedBps: goal.savedBps, projectedBps: goal.projectedBps, height: 14),
                          SizedBox(height: 12.h),
                          Wrap(
                            spacing: 16.w,
                            runSpacing: 6.h,
                            children: [
                              _Legend(color: AppColors.gold500, label: l10n.goalSaved(Money(goal.savedKobo).format())),
                              if (goal.movingKobo > 0)
                                _Legend(
                                  color: AppColors.sendingBg,
                                  border: AppColors.sendingInk,
                                  label: l10n.goalMoving(Money(goal.movingKobo).format()),
                                ),
                              if (goal.pendingKobo > 0)
                                _Legend(
                                  color: AppColors.pendingBg,
                                  border: AppColors.gold500,
                                  label: l10n.goalPending(Money(goal.pendingKobo).format()),
                                ),
                            ],
                          ),
                          const Divider(height: 32),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 16.w,
                            runSpacing: 8.h,
                            children: [
                              _Stat(label: l10n.daysLeft, value: '${controller.daysLeft(goal)}'),
                              _Stat(label: l10n.targetDateLabel, value: controller.formatDate(goal.targetDate)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(l10n.contributionsLabel, style: AppTextStyles.caption.sp.copyWith(letterSpacing: 0.6)),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
              if (state.contributions.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Text(l10n.goalNoContributions, style: AppTextStyles.small.sp),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                  sliver: DecoratedSliver(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    sliver: SliverList.separated(
                      itemCount: state.contributions.length,
                      separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
                      itemBuilder: (context, i) {
                        final item = state.contributions[i];
                        return ActivityRow(
                          key: ValueKey(item.id),
                          item: item,
                          subtitle: controller.formatDate(item.createdAt),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label, this.border});

  final Color color;
  final Color? border;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12.r,
        height: 12.r,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3.r),
          border: border == null ? null : Border.all(color: border!),
        ),
      ),
      SizedBox(width: 6.w),
      Text(label, style: AppTextStyles.small.sp.copyWith(fontFeatures: AppTextStyles.tabular)),
    ],
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.sp),
        Text(value, style: AppTextStyles.h2.sp),
      ],
    ),
  );
}
