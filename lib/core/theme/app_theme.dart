import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Material 3 theme built from the NovaPay tokens.
///
/// Flat surfaces only: 1px borders carry hierarchy, and elevation is zero
/// everywhere except the bottom-sheet scrim (board `1a`). No blur, no gradient
/// behind text — cheap to render on low-end Android.
abstract class AppTheme {
  static const double radiusChip = 8;
  static const double radiusInput = 12;
  static const double radiusCard = 16;

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.navy900, brightness: Brightness.light).copyWith(
      primary: AppColors.navy900,
      onPrimary: AppColors.onNavy,
      secondary: AppColors.gold500,
      onSecondary: AppColors.navy900,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.failedInk,
      onError: Colors.white,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
    );

    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radiusInput)),
      borderSide: BorderSide(color: AppColors.border),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppTextStyles.family,
      textTheme: AppTextStyles.textTheme,
      scaffoldBackgroundColor: AppColors.appBg,
      // Accessibility: every tap target at least 48dp.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.appBg,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.h2,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusCard)),
          side: BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: const BorderSide(color: AppColors.navy900, width: 1.5)),
        errorBorder: border.copyWith(borderSide: const BorderSide(color: AppColors.failedInk)),
        focusedErrorBorder: border.copyWith(borderSide: const BorderSide(color: AppColors.failedInk, width: 1.5)),
        labelStyle: AppTextStyles.small,
        hintStyle: AppTextStyles.small.copyWith(color: AppColors.textTertiary),
        errorStyle: AppTextStyles.small.copyWith(color: AppColors.failedInk),
        errorMaxLines: 3,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy900,
          foregroundColor: AppColors.onNavy,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textTertiary,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppTextStyles.button,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radiusInput))),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy900,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppTextStyles.button,
          side: const BorderSide(color: AppColors.border),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radiusInput))),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.navy700,
          minimumSize: const Size(48, 48),
          textStyle: AppTextStyles.button,
        ),
      ),
      // Off switches need a visible track and thumb on the white surface.
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.onNavy : AppColors.textSecondary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.navy900 : AppColors.appBg,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.navy900 : AppColors.textTertiary,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(radiusCard))),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.navy900,
        contentTextStyle: AppTextStyles.body.copyWith(color: AppColors.onNavy),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
