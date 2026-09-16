import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_colors.dart';

/// Loading placeholder block (board `1e`). One shimmer per group, not per box.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, required this.height, this.radius = 8});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(radius.r)),
  );
}

/// Wraps skeleton blocks in a single shimmer and hides them from screen readers
/// (the screen announces its own loading copy instead).
class Skeleton extends StatelessWidget {
  const Skeleton({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Shimmer.fromColors(baseColor: AppColors.border, highlightColor: AppColors.appBg, child: child),
  );
}

/// Placeholder shaped like an [ActivityRow].
class ActivityRowSkeleton extends StatelessWidget {
  const ActivityRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    child: Row(
      children: [
        SkeletonBox(width: 40.r, height: 40.r, radius: 20),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 140.w, height: 14.h),
              SizedBox(height: 8.h),
              SkeletonBox(width: 90.w, height: 12.h),
            ],
          ),
        ),
        SkeletonBox(width: 72.w, height: 14.h),
      ],
    ),
  );
}
