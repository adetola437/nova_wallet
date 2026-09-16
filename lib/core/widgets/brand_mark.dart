import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

/// The gold NovaPay mark: a rotated square (diamond) with a navy "N".
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    final s = size.r;
    return ExcludeSemantics(
      child: SizedBox(
        width: s,
        height: s,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: 0.785398,
              child: Container(
                width: s * 0.72,
                height: s * 0.72,
                decoration: BoxDecoration(color: AppColors.gold500, borderRadius: BorderRadius.circular(s * 0.14)),
              ),
            ),
            Text(
              'N',
              textScaler: TextScaler.noScaling, // a logo, not text: must not grow out of its shape
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: s * 0.36,
                fontWeight: FontWeight.w800,
                fontVariations: const [FontVariation('wght', 800)],
                color: AppColors.navy900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
