import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';

class RecipientAvatar extends StatelessWidget {
  const RecipientAvatar({super.key, required this.name, this.radius = 20});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    final initials = parts.isEmpty
        ? '?'
        : (parts.first.characters.first + (parts.length > 1 ? parts.last.characters.first : '')).toUpperCase();
    return ExcludeSemantics(
      child: CircleAvatar(
        radius: radius.r,
        backgroundColor: AppColors.sendingBg,
        child: Text(initials, style: AppTextStyles.caption.sp.copyWith(color: AppColors.sendingInk)),
      ),
    );
  }
}
