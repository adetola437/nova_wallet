part of '../controllers/home_controller.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key, required this.controller, required this.offline});

  final HomeControllerContract controller;
  final bool offline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _Action(
              icon: Icons.north_east_rounded,
              label: l10n.homeSend,
              sub: offline ? l10n.homeQueuesOffline : null,
              onTap: controller.onSend,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _Action(
              icon: Icons.diamond_outlined,
              label: l10n.homeSave,
              sub: offline ? l10n.homeQueuesOffline : null,
              onTap: controller.onSave,
              gold: true,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _Action(
              icon: Icons.add_rounded,
              label: l10n.homeAddMoney,
              sub: offline ? l10n.homeNeedsData : null,
              onTap: offline ? null : controller.onAddMoney,
            ),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, required this.onTap, this.sub, this.gold = false});

  final IconData icon;
  final String label;
  final String? sub;
  final VoidCallback? onTap;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: sub == null ? label : '$label, $sub',
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 88.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: enabled ? (gold ? AppColors.pendingBg : AppColors.appBg) : AppColors.appBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 20.r,
                      color: !enabled ? AppColors.textTertiary : (gold ? AppColors.goldInk800 : AppColors.navy900),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.small.sp.copyWith(
                      color: enabled ? AppColors.textPrimary : AppColors.textTertiary,
                      fontWeight: FontWeight.w600,
                      fontVariations: const [FontVariation('wght', 600)],
                    ),
                  ),
                  if (sub != null) Text(sub!, textAlign: TextAlign.center, style: AppTextStyles.caption.sp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
