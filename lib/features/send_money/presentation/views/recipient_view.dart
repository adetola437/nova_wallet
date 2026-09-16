part of '../controllers/recipient_controller.dart';

class RecipientView extends StatelessWidget implements RecipientViewContract {
  const RecipientView({super.key, required this.controller});

  final RecipientControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final offline = context.select<ConnectivityCubit, bool>((c) => c.state == ConnectivityStatus.offline);
    final recipients = context.watch<BeneficiariesCubit>().visible;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sendTitle),
        // First page of the send flow's nested navigator: nothing to pop
        // inside it, so leave the whole flow explicitly.
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Column(
        children: [
          if (offline) OfflineBanner(message: l10n.offlineBanner),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  sliver: SliverList.list(
                    children: [
                      Semantics(
                        textField: true,
                        label: offline ? l10n.sendSearchSavedHint : l10n.sendSearchHint,
                        child: TextField(
                          controller: controller.searchController,
                          onChanged: controller.onSearch,
                          style: AppTextStyles.body.sp,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_rounded),
                            hintText: offline ? l10n.sendSearchSavedHint : l10n.sendSearchHint,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _NewRecipientTile(offline: offline, onTap: controller.onNewRecipient),
                      SizedBox(height: 8.h),
                      _NewRecipientTile(
                        offline: offline,
                        onTap: controller.onNovaUser,
                        icon: Icons.account_balance_wallet_outlined,
                        title: l10n.sendNovaUser,
                        subtitle: l10n.sendNovaUserSub,
                        offlineSubtitle: l10n.sendNovaUserOffline,
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        offline ? l10n.sendSavedRecipientsOffline : l10n.sendSavedRecipients,
                        style: AppTextStyles.caption.sp.copyWith(letterSpacing: 0.6),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
                if (recipients.isEmpty)
                  SliverToBoxAdapter(
                    child: EmptyState(icon: Icons.people_outline_rounded, title: l10n.sendNoRecipients, body: ''),
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
                        itemCount: recipients.length,
                        separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
                        itemBuilder: (context, i) {
                          final b = recipients[i];
                          return _RecipientTile(beneficiary: b, onTap: () => controller.onSelect(b));
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewRecipientTile extends StatelessWidget {
  const _NewRecipientTile({
    required this.offline,
    required this.onTap,
    this.icon = Icons.person_add_alt_rounded,
    this.title,
    this.subtitle,
    this.offlineSubtitle,
  });

  final bool offline;
  final VoidCallback onTap;
  final IconData icon;
  final String? title;
  final String? subtitle;
  final String? offlineSubtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ink = offline ? AppColors.textTertiary : AppColors.navy900;
    final label = title ?? l10n.sendNewRecipient;
    final sub = offline ? (offlineSubtitle ?? l10n.sendNewRecipientOffline) : (subtitle ?? l10n.sendNewRecipientSub);
    return Semantics(
      button: true,
      enabled: !offline,
      label: label,
      hint: sub,
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          onTap: offline ? null : onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 64.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.appBg,
                    child: Icon(icon, size: 20.r, color: ink),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: AppTextStyles.body.sp.copyWith(color: ink)),
                        Text(sub, style: AppTextStyles.small.sp),
                      ],
                    ),
                  ),
                  if (!offline) Icon(Icons.chevron_right_rounded, color: ink),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipientTile extends StatelessWidget {
  const _RecipientTile({required this.beneficiary, required this.onTap});

  final Beneficiary beneficiary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final b = beneficiary;
    return Semantics(
      button: true,
      label: '${b.verifiedName}, ${b.bankName}, ${b.maskedAccount}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 64.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                RecipientAvatar(name: b.verifiedName),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.verifiedName, style: AppTextStyles.body.sp),
                      Text('${b.bankName} · ${b.maskedAccount}', style: AppTextStyles.small.sp),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
