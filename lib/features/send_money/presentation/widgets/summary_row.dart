import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/widgets/money_text.dart';

/// Label on the left, value (text or money) on the right. Both sides wrap
/// rather than overflow at large text sizes.
class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key, required this.label, this.value, this.kobo, this.emphasis = false, this.valueColor})
    : assert(value != null || kobo != null);

  final String label;
  final String? value;
  final int? kobo;
  final bool emphasis;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final valueStyle = (emphasis ? AppTextStyles.amountBody : AppTextStyles.amountSmall).sp.copyWith(
      color: valueColor ?? AppColors.textPrimary,
    );
    final value = kobo != null
        ? MoneyText(kobo!, style: valueStyle, textAlign: TextAlign.end)
        : Text(this.value!, style: valueStyle, textAlign: TextAlign.end);
    return MergeSemantics(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(label, style: emphasis ? AppTextStyles.body.sp : AppTextStyles.small.sp)),
            SizedBox(width: 12.w),
            Flexible(
              flex: 2,
              child: Align(alignment: Alignment.centerRight, child: value),
            ),
          ],
        ),
      ),
    );
  }
}
