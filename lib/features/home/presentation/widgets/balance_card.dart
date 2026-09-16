part of '../controllers/home_controller.dart';

/// Navy card: available balance as the hero (ledger − holds), the hold line,
/// the sync chip, and a freshness line.
class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.controller});

  final HomeControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hidden = controller.balanceHidden;

    return BlocBuilder<WalletCubit, WalletState>(
      buildWhen: (a, b) =>
          a.overview != b.overview || a.lastRefreshFailure != b.lastRefreshFailure || a.status != b.status,
      builder: (context, wallet) {
        final overview = wallet.overview;
        final loading = wallet.status == WalletStatus.initial || wallet.status == WalletStatus.loading;
        final lastSynced = overview.lastSyncedAt;

        final String freshness;
        if (wallet.lastRefreshFailure != null && lastSynced != null) {
          freshness = l10n.homeLastUpdated(DateFormat('d MMM, h:mm a', 'en').format(lastSynced));
        } else if (overview.pendingCount == 0) {
          freshness = l10n.homeUpToDate;
        } else {
          freshness = '';
        }

        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(color: AppColors.navy900, borderRadius: BorderRadius.circular(16.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.homeAvailableBalance,
                      style: AppTextStyles.caption.sp.copyWith(color: AppColors.onNavyMuted, letterSpacing: 0.8),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.onToggleBalance,
                    tooltip: hidden ? l10n.homeShowBalance : l10n.homeHideBalance,
                    icon: Icon(
                      hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.onNavy,
                      size: 22.r,
                    ),
                  ),
                ],
              ),
              if (loading && overview == WalletOverview.empty)
                Skeleton(
                  child: SkeletonBox(width: 200.w, height: 40.h),
                )
              else if (hidden)
                Semantics(
                  label: l10n.homeBalanceHidden,
                  excludeSemantics: true,
                  child: MoneyText(
                    overview.availableKobo,
                    masked: true,
                    style: AppTextStyles.amountHero.sp.copyWith(color: AppColors.onNavy),
                  ),
                )
              else
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: MoneyText(
                    overview.availableKobo,
                    style: AppTextStyles.amountHero.sp.copyWith(color: AppColors.onNavy),
                  ),
                ),
              if (overview.heldKobo > 0) ...[
                SizedBox(height: 6.h),
                _HoldLine(heldKobo: overview.heldKobo, count: overview.pendingCount, hidden: hidden),
              ],
              BlocBuilder<SyncCubit, SyncState>(
                builder: (context, sync) => sync.pendingCount == 0
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: SyncChip(
                          pendingCount: sync.pendingCount,
                          isSyncing: sync.isSyncing,
                          troubleCount: sync.troubleCount,
                        ),
                      ),
              ),
              if (freshness.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Text(freshness, style: AppTextStyles.small.sp.copyWith(color: AppColors.onNavyMuted)),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _HoldLine extends StatelessWidget {
  const _HoldLine({required this.heldKobo, required this.count, required this.hidden});

  final int heldKobo;
  final int count;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final visual = hidden ? '••••' : Money(heldKobo).format();
    final spoken = hidden ? l10n.homeBalanceHidden : MoneySemantics.label(heldKobo, languageCode: languageCode);
    final style = AppTextStyles.small.sp.copyWith(color: AppColors.gold500, fontFeatures: AppTextStyles.tabular);
    return Semantics(
      label: count > 0 ? l10n.homeOnHoldPending(spoken, count) : l10n.homeOnHold(spoken),
      excludeSemantics: true,
      child: Text(count > 0 ? l10n.homeOnHoldPending(visual, count) : l10n.homeOnHold(visual), style: style),
    );
  }
}
