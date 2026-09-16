import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Type scale from board `1a` (Plus Jakarta Sans, bundled — never fetched at
/// runtime, which fails on a fresh offline install).
///
/// The family is a variable font, so every style sets the `wght` axis as well
/// as [FontWeight]; with `fontWeight` alone some renderers draw every weight as
/// Regular.
///
/// Sizes here are logical pixels. Screens apply `.sp` from flutter_screenutil;
/// the user's system font scale is applied on top by Flutter and is never
/// overridden anywhere in the app.
abstract class AppTextStyles {
  static const String family = 'PlusJakartaSans';

  static TextStyle _style(double size, int weight, {Color color = AppColors.textPrimary, double? height}) => TextStyle(
    fontFamily: family,
    fontSize: size,
    fontWeight: FontWeight.values[(weight ~/ 100) - 1],
    fontVariations: [FontVariation('wght', weight.toDouble())],
    color: color,
    height: height,
  );

  /// Tabular figures so amounts don't jitter as digits change.
  static const List<FontFeature> tabular = [FontFeature.tabularFigures()];

  /// ₦186,450.25 — the hero figure on a screen (40/700, tabular).
  static TextStyle get amountHero => _style(40, 700, height: 1.1).copyWith(fontFeatures: tabular);

  static TextStyle get h1 => _style(24, 700, height: 1.25);
  static TextStyle get h2 => _style(18, 600, height: 1.3);
  static TextStyle get body => _style(16, 500, height: 1.4);
  static TextStyle get small => _style(14, 400, color: AppColors.textSecondary, height: 1.4);
  static TextStyle get caption => _style(12, 600, color: AppColors.textSecondary, height: 1.35);

  /// Money inside body text: same size as body, tabular.
  static TextStyle get amountBody => _style(16, 600, height: 1.4).copyWith(fontFeatures: tabular);
  static TextStyle get amountSmall => _style(14, 600, height: 1.4).copyWith(fontFeatures: tabular);

  static TextStyle get button => _style(16, 600, height: 1.2);

  static TextTheme get textTheme => TextTheme(
    displaySmall: amountHero,
    headlineSmall: h1,
    titleLarge: h1,
    titleMedium: h2,
    bodyLarge: body,
    bodyMedium: body,
    bodySmall: small,
    labelLarge: button,
    labelMedium: caption,
    labelSmall: caption,
  );
}
