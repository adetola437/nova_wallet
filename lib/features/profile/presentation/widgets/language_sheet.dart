import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../settings/cubit/locale_cubit.dart';

/// English and Yorùbá are live; Hausa and Igbo are shown, disabled, as
/// "Coming soon" (board `4g`).
class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = Localizations.localeOf(context).languageCode;
    final options = [
      ('en', l10n.languageEnglish, true),
      ('yo', l10n.languageYoruba, true),
      ('ha', l10n.languageHausa, false),
      ('ig', l10n.languageIgbo, false),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.profileLanguageHint, style: AppTextStyles.small.sp),
        SizedBox(height: 8.h),
        RadioGroup<String>(
          groupValue: current,
          onChanged: (code) {
            if (code == null) return;
            context.read<LocaleCubit>().setLocale(code);
            Navigator.of(context).pop();
          },
          child: Column(
            children: [
              for (final (code, name, live) in options)
                RadioListTile<String>(
                  value: code,
                  enabled: live,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    name,
                    style: AppTextStyles.body.sp.copyWith(color: live ? AppColors.textPrimary : AppColors.textTertiary),
                  ),
                  subtitle: live ? null : Text(l10n.comingSoon, style: AppTextStyles.small.sp),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
