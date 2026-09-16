import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';
import '../models/activity_item.dart';
import '../money/money_semantics.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';
import 'money_text.dart';
import 'status_pill.dart';

/// One transaction row: avatar initial, title, subtitle, signed amount, pill.
///
/// Uses a minimum height, never a fixed one, so it grows at 200% text.
class ActivityRow extends StatelessWidget {
  const ActivityRow({super.key, required this.item, this.subtitle, this.onTap});

  final ActivityItem item;

  /// Overrides `item.subtitle` (e.g. "Queued 2:14 PM").
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final pill = StatusPill.forActivity(item, l10n);
    final sub = subtitle ?? item.subtitle;
    final isCredit = item.signedKobo > 0;
    final initial = item.title.trim().isEmpty ? '?' : item.title.trim().characters.first.toUpperCase();

    final statusLabel = switch (item.status) {
      ActivityStatus.pending => l10n.statusPending,
      ActivityStatus.sending => l10n.statusSending,
      ActivityStatus.failed => l10n.statusFailed,
      ActivityStatus.completed => pill.label ?? l10n.statusSent,
    };

    return Semantics(
      button: onTap != null,
      label: [
        item.title,
        ?sub,
        MoneySemantics.label(item.signedKobo, languageCode: languageCode),
        statusLabel,
      ].join(', '),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 72.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: item.kind == ActivityKind.contribution ? AppColors.pendingBg : AppColors.appBg,
                  child: Text(
                    initial,
                    style: AppTextStyles.h2.sp.copyWith(
                      color: item.kind == ActivityKind.contribution ? AppColors.goldInk800 : AppColors.navy700,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: AppTextStyles.body.sp, maxLines: 2, overflow: TextOverflow.ellipsis),
                      if (sub != null) ...[SizedBox(height: 2.h), Text(sub, style: AppTextStyles.small.sp)],
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MoneyText(
                        item.signedKobo,
                        signed: true,
                        textAlign: TextAlign.end,
                        style: AppTextStyles.amountBody.sp.copyWith(
                          color: isCredit ? AppColors.sentInk : AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      pill,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
