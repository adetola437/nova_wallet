part of '../controllers/home_controller.dart';

class HomeView extends StatelessWidget implements HomeViewContract {
  const HomeView({super.key, required this.controller});

  final HomeControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final firstName = context.select<AuthCubit, String?>((c) => c.state.profile?.firstName);
    final offline = context.select<ConnectivityCubit, bool>((c) => c.state == ConnectivityStatus.offline);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (offline) OfflineBanner(message: l10n.offlineBanner),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.navy900,
                onRefresh: controller.onRefresh,
                child: NotificationListener<ScrollNotification>(
                  onNotification: controller.onScroll,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                        sliver: SliverList.list(
                          children: [
                            _Header(greeting: controller.greeting(l10n), firstName: firstName),
                            SizedBox(height: 16.h),
                            BalanceCard(controller: controller),
                            SizedBox(height: 16.h),
                            QuickActions(controller: controller, offline: offline),
                            SizedBox(height: 24.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Semantics(
                                    header: true,
                                    child: Text(l10n.homeRecent, style: AppTextStyles.h2.sp),
                                  ),
                                ),
                                if (offline)
                                  Text(
                                    l10n.homeSavedCopy,
                                    style: AppTextStyles.caption.sp.copyWith(color: AppColors.textTertiary),
                                  ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                          ],
                        ),
                      ),
                      _ActivitySliver(controller: controller),
                      SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.greeting, required this.firstName});

  final String greeting;
  final String? firstName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ExcludeSemantics(
          child: CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.navy900,
            child: Text(
              (firstName ?? 'N').characters.first.toUpperCase(),
              style: AppTextStyles.h2.sp.copyWith(color: AppColors.gold500),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting, style: AppTextStyles.small.sp),
                if (firstName != null) Text(firstName!, style: AppTextStyles.h2.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The transaction list. Rebuilds only when the wallet's list or loading
/// status changes, not on every balance or outbox tick.
class _ActivitySliver extends StatelessWidget {
  const _ActivitySliver({required this.controller});

  final HomeControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<WalletCubit, WalletState>(
      buildWhen: (a, b) => a.activity != b.activity || a.status != b.status,
      builder: (context, state) {
        final loading = state.status == WalletStatus.initial || state.status == WalletStatus.loading;
        if (state.activity.isEmpty && loading) {
          return SliverToBoxAdapter(
            child: Semantics(
              label: l10n.homeLoading,
              liveRegion: true,
              child: Skeleton(child: Column(children: [for (var i = 0; i < 4; i++) const ActivityRowSkeleton()])),
            ),
          );
        }
        if (state.activity.isEmpty) {
          return SliverToBoxAdapter(
            child: EmptyState(icon: Icons.receipt_long_rounded, title: l10n.homeEmptyTitle, body: l10n.homeEmptyBody),
          );
        }
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: DecoratedSliver(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.border),
            ),
            sliver: SliverList.separated(
              itemCount: state.activity.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, i) {
                final item = state.activity[i];
                return ActivityRow(
                  key: ValueKey(item.id),
                  item: item,
                  subtitle: controller.activitySubtitle(item, l10n),
                  onTap: () => controller.onActivityTap(item),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
