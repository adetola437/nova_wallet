import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/theme/app_colors.dart';
import 'package:nova_wallet/core/theme/app_text_styles.dart';
import 'package:nova_wallet/core/theme/app_theme.dart';

/// WCAG relative luminance and contrast ratio.
double _luminance(Color c) {
  double channel(double v) => v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
}

double contrast(Color a, Color b) {
  final la = _luminance(a), lb = _luminance(b);
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}

void main() {
  test('tokens match the design system board (1a)', () {
    expect(AppColors.navy900, const Color(0xFF0A1E38));
    expect(AppColors.navy700, const Color(0xFF14355C));
    expect(AppColors.gold500, const Color(0xFFE0A526));
    expect(AppColors.goldInk800, const Color(0xFF8A5F06));
    expect(AppColors.appBg, const Color(0xFFF6F5F2));
    expect(AppColors.border, const Color(0xFFE6E3DC));
  });

  test('every status pair clears WCAG AA (4.5:1) for body text', () {
    expect(contrast(AppColors.sentInk, AppColors.sentBg), greaterThan(4.5));
    expect(contrast(AppColors.pendingInk, AppColors.pendingBg), greaterThan(4.5));
    expect(contrast(AppColors.sendingInk, AppColors.sendingBg), greaterThan(4.5));
    expect(contrast(AppColors.failedInk, AppColors.failedBg), greaterThan(4.5));
  });

  test("the design's gold rule: gold fails as text on white, gold ink passes", () {
    expect(contrast(AppColors.gold500, Colors.white), lessThan(4.5),
        reason: 'this is why gold is only ever a fill, rule or mark');
    expect(contrast(AppColors.goldInk800, Colors.white), greaterThan(4.5));
    expect(contrast(AppColors.textSecondary, AppColors.appBg), greaterThan(4.5));
    expect(contrast(AppColors.onNavy, AppColors.navy900), greaterThan(4.5));
  });

  test('amounts use tabular figures and the bundled variable font axis', () {
    final hero = AppTextStyles.amountHero;
    expect(hero.fontFamily, 'PlusJakartaSans');
    expect(hero.fontFeatures, contains(const FontFeature.tabularFigures()));
    expect(hero.fontVariations!.single.value, 700);
    expect(hero.fontWeight, FontWeight.w700);
  });

  test('theme is flat and keeps 48dp tap targets', () {
    final theme = AppTheme.light;
    expect(theme.scaffoldBackgroundColor, AppColors.appBg);
    expect(theme.cardTheme.elevation, 0);
    expect(theme.materialTapTargetSize, MaterialTapTargetSize.padded);
  });
}
