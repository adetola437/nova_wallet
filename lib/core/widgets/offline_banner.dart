import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';

/// Calm navy strip, not red: being offline is a normal state here, and the
/// app still works. A live region so screen readers announce it on appearance.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        color: AppColors.navy700,
        child: Row(
          children: [
            ExcludeSemantics(
              child: Icon(Icons.wifi_off_rounded, size: 18.r, color: AppColors.onNavy),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(message, style: AppTextStyles.small.sp.copyWith(color: AppColors.onNavy)),
            ),
          ],
        ),
      ),
    );
  }
}
