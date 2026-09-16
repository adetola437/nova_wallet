import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';

/// Opens a NovaPay sheet: drag handle, optional title, scrollable body that
/// lifts above the keyboard and never exceeds 90% of the screen.
Future<T?> showNovaBottomSheet<T>(
  BuildContext context, {
  String? title,
  required WidgetBuilder builder,
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    // Above the bottom nav, not inside the current tab.
    useRootNavigator: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    useSafeArea: true,
    builder: (sheetContext) => NovaBottomSheet(title: title, child: builder(sheetContext)),
  );
}

class NovaBottomSheet extends StatelessWidget {
  const NovaBottomSheet({super.key, this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: media.size.height * 0.9),
      child: Padding(
        padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                Semantics(header: true, child: Text(title!, style: AppTextStyles.h2.sp)),
                SizedBox(height: 16.h),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
