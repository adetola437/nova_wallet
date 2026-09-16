import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';
import 'nova_button.dart';

/// Inline failure with a retry. Announced as a live region.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, this.message, this.onRetry});

  /// Defaults to the generic error copy.
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      liveRegion: true,
      container: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Container(
                width: 64.r,
                height: 64.r,
                decoration: const BoxDecoration(color: AppColors.failedBg, shape: BoxShape.circle),
                child: Icon(Icons.error_outline_rounded, size: 28.r, color: AppColors.failedInk),
              ),
            ),
            SizedBox(height: 16.h),
            Text(message ?? l10n.errorGeneric, textAlign: TextAlign.center, style: AppTextStyles.body.sp),
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              NovaButton(
                label: l10n.retry,
                onPressed: onRetry,
                variant: NovaButtonVariant.secondary,
                icon: Icons.refresh_rounded,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
