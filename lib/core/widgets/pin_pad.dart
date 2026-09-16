import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';

/// The four PIN dots. Announces how many digits are entered, never the digits.
class PinDots extends StatelessWidget {
  const PinDots({super.key, required this.length, this.maxLength = 4, this.hasError = false});

  final int length;
  final int maxLength;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fill = hasError ? AppColors.failedInk : AppColors.navy900;
    return Semantics(
      liveRegion: true,
      label: l10n.pinEnteredCount(length),
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < maxLength; i++)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              width: 16.r,
              height: 16.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < length ? fill : Colors.transparent,
                border: Border.all(color: hasError ? AppColors.failedInk : AppColors.textTertiary, width: 1.5),
              ),
            ),
        ],
      ),
    );
  }
}

/// 3×4 numeric keypad. Every key is at least 48dp and labelled; the owning
/// screen keeps the entered value (in its cubit), this only reports taps.
class PinPad extends StatelessWidget {
  const PinPad({super.key, required this.onDigit, required this.onDelete, this.leading, this.enabled = true});

  final ValueChanged<int> onDigit;
  final VoidCallback onDelete;

  /// Bottom-left slot (e.g. a biometric button). Empty when null.
  final Widget? leading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    Widget key(Widget child, {required String label, required VoidCallback onTap}) => Expanded(
      child: Semantics(
        button: true,
        enabled: enabled,
        label: label,
        excludeSemantics: true,
        child: InkWell(
          onTap: enabled
              ? () {
                  HapticFeedback.selectionClick();
                  onTap();
                }
              : null,
          customBorder: const CircleBorder(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: math.max(64.h, 48)),
            child: Center(child: child),
          ),
        ),
      ),
    );

    Widget digit(int d) => key(
      Text('$d', style: AppTextStyles.h1.sp),
      label: '$d',
      onTap: () => onDigit(d),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ])
          Row(children: [for (final d in row) digit(d)]),
        Row(
          children: [
            Expanded(child: leading ?? const SizedBox.shrink()),
            digit(0),
            key(
              Icon(Icons.backspace_outlined, size: 24.r, color: AppColors.navy900),
              label: l10n.pinDelete,
              onTap: onDelete,
            ),
          ],
        ),
      ],
    );
  }
}
