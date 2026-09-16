import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';
import '../models/activity_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';

/// Pending / Sending / Sent / Failed — always an icon **and** a label on a
/// tinted background with darker ink. Never colour alone.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status, this.label});

  /// Picks "Received" / "Saved" for completed credits and contributions.
  factory StatusPill.forActivity(ActivityItem item, AppLocalizations l10n, {Key? key}) {
    String? label;
    if (item.status == ActivityStatus.completed) {
      if (item.kind == ActivityKind.contribution) {
        label = l10n.statusSaved;
      } else if (item.kind == ActivityKind.goalWithdrawal) {
        label = l10n.statusMoved;
      } else if (item.direction == ActivityDirection.credit) {
        label = l10n.statusReceived;
      }
    }
    return StatusPill(key: key, status: item.status, label: label);
  }

  final ActivityStatus status;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (bg, ink, icon, defaultLabel) = switch (status) {
      ActivityStatus.pending => (AppColors.pendingBg, AppColors.pendingInk, Icons.schedule_rounded, l10n.statusPending),
      ActivityStatus.sending => (AppColors.sendingBg, AppColors.sendingInk, Icons.sync_rounded, l10n.statusSending),
      ActivityStatus.completed => (AppColors.sentBg, AppColors.sentInk, Icons.check_circle_rounded, l10n.statusSent),
      ActivityStatus.failed => (AppColors.failedBg, AppColors.failedInk, Icons.error_rounded, l10n.statusFailed),
    };
    final text = label ?? defaultLabel;

    return Semantics(
      label: text,
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.r, color: ink),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(text, style: AppTextStyles.caption.sp.copyWith(color: ink)),
            ),
          ],
        ),
      ),
    );
  }
}
