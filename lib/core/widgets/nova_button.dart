import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';

enum NovaButtonVariant { primary, secondary, text, danger }

/// Full-width action button. Height is a minimum (52dp), never fixed, so the
/// label wraps instead of clipping at 200% text.
class NovaButton extends StatelessWidget {
  const NovaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = NovaButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.semanticsHint,
    this.expand = true,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final NovaButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final String? semanticsHint;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final minSize = Size(expand ? double.infinity : 48, 52);
    final padding = EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h);
    final textStyle = AppTextStyles.button.sp;
    final fg = switch (variant) {
      NovaButtonVariant.primary => AppColors.onNavy,
      NovaButtonVariant.danger => AppColors.failedInk,
      _ => AppColors.navy900,
    };

    final child = isLoading
        ? SizedBox(
            width: 20.r,
            height: 20.r,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 20.r), SizedBox(width: 8.w)],
              Flexible(child: Text(label, textAlign: TextAlign.center)),
            ],
          );

    final action = enabled ? onPressed : null;
    final button = switch (variant) {
      NovaButtonVariant.primary => FilledButton(
        onPressed: action,
        style: FilledButton.styleFrom(minimumSize: minSize, padding: padding, textStyle: textStyle),
        child: child,
      ),
      NovaButtonVariant.secondary => OutlinedButton(
        onPressed: action,
        style: OutlinedButton.styleFrom(minimumSize: minSize, padding: padding, textStyle: textStyle),
        child: child,
      ),
      NovaButtonVariant.danger => OutlinedButton(
        onPressed: action,
        style: OutlinedButton.styleFrom(
          minimumSize: minSize,
          padding: padding,
          textStyle: textStyle,
          foregroundColor: AppColors.failedInk,
          side: const BorderSide(color: AppColors.failedBg),
        ),
        child: child,
      ),
      NovaButtonVariant.text => TextButton(
        onPressed: action,
        style: TextButton.styleFrom(minimumSize: minSize, padding: padding, textStyle: textStyle),
        child: child,
      ),
    };

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      hint: semanticsHint,
      excludeSemantics: true,
      child: button,
    );
  }
}
