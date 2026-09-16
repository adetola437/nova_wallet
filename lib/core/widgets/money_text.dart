import 'package:flutter/material.dart';

import '../money/money.dart';
import '../money/money_semantics.dart';
import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';

/// Every amount on screen goes through here: [Money.format] for the eye,
/// [MoneySemantics.label] for the ear, and tabular figures so digits don't
/// jitter as they change.
class MoneyText extends StatelessWidget {
  const MoneyText(this.kobo, {super.key, this.style, this.signed = false, this.masked = false, this.textAlign});

  final int kobo;
  final TextStyle? style;

  /// Prefix a `+` on credits (debits already carry `-`).
  final bool signed;

  /// Show [Money.masked] instead of the figure (balance eye toggle).
  final bool masked;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final base = (style ?? AppTextStyles.amountBody.sp);
    final text = masked ? Money.masked : '${signed && kobo > 0 ? '+' : ''}${Money(kobo).format()}';

    return Semantics(
      label: masked ? null : MoneySemantics.label(kobo, languageCode: languageCode),
      excludeSemantics: !masked,
      child: Text(
        text,
        textAlign: textAlign,
        style: base.copyWith(fontFeatures: AppTextStyles.tabular),
      ),
    );
  }
}
