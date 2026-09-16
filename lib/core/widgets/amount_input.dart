import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/flavor/app_constants.dart';
import '../money/kobo_parser.dart';
import '../money/money.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';

/// Big naira amount field with optional quick-amount chips.
///
/// Emits raw text; the cubit parses it with [KoboParser] (never a double) and
/// owns the validation message shown in [errorText].
class AmountInput extends StatelessWidget {
  const AmountInput({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.semanticLabel,
    this.errorText,
    this.helper,
    this.quickAmountsKobo = AppConstants.quickAmountsKobo,
    this.autofocus = true,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String semanticLabel;
  final String? errorText;

  /// Line under the field, e.g. "Available: ₦186,450.25".
  final Widget? helper;
  final List<int> quickAmountsKobo;
  final bool autofocus;
  final bool enabled;

  void _applyQuick(int kobo) {
    final text = KoboParser.toInputText(kobo);
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    onChanged(text);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final heroStyle = AppTextStyles.amountHero.sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          textField: true,
          label: semanticLabel,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            autofocus: autofocus,
            enabled: enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')), const _GroupingFormatter()],
            style: heroStyle.copyWith(color: hasError ? AppColors.failedInk : AppColors.textPrimary),
            decoration: InputDecoration(
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              prefixText: '₦',
              prefixStyle: heroStyle.copyWith(color: AppColors.textTertiary),
              hintText: '0.00',
              hintStyle: heroStyle.copyWith(color: AppColors.textTertiary),
            ),
          ),
        ),
        Divider(color: hasError ? AppColors.failedInk : AppColors.border, thickness: hasError ? 1.5 : 1),
        if (hasError) ...[
          SizedBox(height: 8.h),
          Semantics(
            liveRegion: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Icon(Icons.error_rounded, size: 16.r, color: AppColors.failedInk),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(errorText!, style: AppTextStyles.small.sp.copyWith(color: AppColors.failedInk)),
                ),
              ],
            ),
          ),
        ],
        if (helper != null) ...[SizedBox(height: 8.h), helper!],
        if (quickAmountsKobo.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final kobo in quickAmountsKobo)
                ActionChip(
                  label: Text(Money(kobo).format().replaceAll('.00', ''), style: AppTextStyles.amountSmall.sp),
                  onPressed: enabled ? () => _applyQuick(kobo) : null,
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Adds thousands separators to the whole part as the user types, keeps at
/// most one '.', and leaves the fractional part alone (the parser rejects >2
/// decimals with a proper message rather than silently eating keystrokes).
class _GroupingFormatter extends TextInputFormatter {
  const _GroupingFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final raw = newValue.text.replaceAll(',', '');
    if (raw.isEmpty) return newValue.copyWith(text: '');
    if ('.'.allMatches(raw).length > 1) return oldValue;

    final dot = raw.indexOf('.');
    final whole = dot == -1 ? raw : raw.substring(0, dot);
    final frac = dot == -1 ? '' : raw.substring(dot);
    if (whole.length > 13) return oldValue;

    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
      buffer.write(whole[i]);
    }
    final text = '$buffer$frac';
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
