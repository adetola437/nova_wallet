import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';

/// Small status chip on the balance card: nothing when the outbox is empty,
/// "N pending" while offline, "Sending N queued…" while syncing, and the
/// trouble copy once items have failed to reach the server repeatedly.
class SyncChip extends StatelessWidget {
  const SyncChip({
    super.key,
    required this.pendingCount,
    required this.isSyncing,
    this.troubleCount = 0,
    this.onNavy = true,
  });

  final int pendingCount;
  final bool isSyncing;
  final int troubleCount;

  /// Drawn on the navy balance card (default) or on a light surface.
  final bool onNavy;

  @override
  Widget build(BuildContext context) {
    if (pendingCount == 0) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);

    final (String text, IconData icon) = troubleCount > 0
        ? (l10n.syncTrouble, Icons.report_problem_rounded)
        : isSyncing
        ? (l10n.syncChipSending(pendingCount), Icons.sync_rounded)
        : (l10n.syncChipPending(pendingCount), Icons.schedule_rounded);

    final bg = onNavy ? AppColors.navy700 : AppColors.pendingBg;
    final ink = onNavy ? AppColors.gold500 : AppColors.pendingInk;
    final textInk = onNavy ? AppColors.onNavy : AppColors.pendingInk;

    return Semantics(
      liveRegion: true,
      label: text,
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.r, color: ink),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(text, style: AppTextStyles.caption.sp.copyWith(color: textInk)),
            ),
          ],
        ),
      ),
    );
  }
}
