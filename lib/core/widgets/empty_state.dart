import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';

/// Icon, title, body and an optional action (boards `1f`, `4b`).
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.body, this.action});

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Container(
              width: 64.r,
              height: 64.r,
              decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
              child: Icon(icon, size: 28.r, color: AppColors.navy700),
            ),
          ),
          SizedBox(height: 16.h),
          Semantics(
            header: true,
            child: Text(title, textAlign: TextAlign.center, style: AppTextStyles.h2.sp),
          ),
          SizedBox(height: 8.h),
          Text(body, textAlign: TextAlign.center, style: AppTextStyles.small.sp),
          if (action != null) ...[SizedBox(height: 24.h), action!],
        ],
      ),
    );
  }
}
