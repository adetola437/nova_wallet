import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';

/// Layout for a single-question screen: back button, optional step counter,
/// title and body, scrollable content, and actions pinned above the keyboard.
class NovaFormScaffold extends StatelessWidget {
  const NovaFormScaffold({
    super.key,
    this.title,
    this.body,
    this.step,
    this.appBarTitle,
    required this.content,
    this.actions = const [],
    this.showBack = true,
    this.appBarActions,
  });

  final String? title;
  final String? body;

  /// e.g. "Step 2 of 5".
  final String? step;
  final String? appBarTitle;
  final List<Widget> content;
  final List<Widget> actions;
  final bool showBack;
  final List<Widget>? appBarActions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: showBack,
        title: appBarTitle == null ? null : Text(appBarTitle!, style: AppTextStyles.h2.sp),
        actions: appBarActions,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (step != null) ...[
                      Text(step!, style: AppTextStyles.caption.sp.copyWith(color: AppColors.goldInk800)),
                      SizedBox(height: 8.h),
                    ],
                    if (title != null) Semantics(header: true, child: Text(title!, style: AppTextStyles.h1.sp)),
                    if (body != null) ...[SizedBox(height: 8.h), Text(body!, style: AppTextStyles.small.sp)],
                    if (title != null || body != null) SizedBox(height: 24.h),
                    ...content,
                  ],
                ),
              ),
            ),
            if (actions.isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[if (i > 0) SizedBox(height: 8.h), actions[i]],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Small inline error line with an icon, announced when it appears.
class InlineError extends StatelessWidget {
  const InlineError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Icon(Icons.error_rounded, size: 16.r, color: AppColors.failedInk),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(message, style: AppTextStyles.small.sp.copyWith(color: AppColors.failedInk)),
        ),
      ],
    ),
  );
}

/// Tinted note card (info / demo / offline notices).
class NoticeCard extends StatelessWidget {
  const NoticeCard({
    super.key,
    required this.child,
    this.icon = Icons.info_outline_rounded,
    this.background = AppColors.sendingBg,
    this.ink = AppColors.sendingInk,
  });

  final Widget child;
  final IconData icon;
  final Color background;
  final Color ink;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(12.r),
    decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(12.r)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Icon(icon, size: 18.r, color: ink),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: DefaultTextStyle.merge(
            style: AppTextStyles.small.sp.copyWith(color: ink),
            child: child,
          ),
        ),
      ],
    ),
  );
}
