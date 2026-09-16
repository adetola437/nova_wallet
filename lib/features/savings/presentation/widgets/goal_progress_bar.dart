import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/money/progress.dart';
import '../../../../core/theme/app_colors.dart';

/// Two segments: confirmed (solid gold) and pending (hatched gold, "on the
/// way"). Widths are capped at 100%; the percentage TEXT elsewhere is not.
class GoalProgressBar extends StatelessWidget {
  const GoalProgressBar({super.key, required this.savedBps, required this.projectedBps, this.height = 10});

  final int savedBps;
  final int projectedBps;
  final double height;

  @override
  Widget build(BuildContext context) {
    final saved = savedBps.clamp(0, Progress.full) / Progress.full;
    final projected = projectedBps.clamp(0, Progress.full) / Progress.full;
    return ExcludeSemantics(
      child: SizedBox(
        height: height.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(height.h),
          child: CustomPaint(
            painter: _BarPainter(saved: saved, projected: projected),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter({required this.saved, required this.projected});

  final double saved;
  final double projected;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.border);

    final pendingRect = Rect.fromLTWH(size.width * saved, 0, size.width * (projected - saved), size.height);
    if (pendingRect.width > 0) {
      canvas.drawRect(pendingRect, Paint()..color = AppColors.pendingBg);
      final stripe = Paint()
        ..color = AppColors.gold500
        ..strokeWidth = 2;
      canvas.save();
      canvas.clipRect(pendingRect);
      for (var x = pendingRect.left - size.height; x < pendingRect.right; x += 6) {
        canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), stripe);
      }
      canvas.restore();
    }
    if (saved > 0) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width * saved, size.height), Paint()..color = AppColors.gold500);
    }
  }

  @override
  bool shouldRepaint(_BarPainter old) => old.saved != saved || old.projected != projected;
}
