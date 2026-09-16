import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// `AppTextStyles.body.sp` — applies flutter_screenutil's (clamped) font
/// resolver at the call site. The user's system text scale is still applied on
/// top by Flutter; nothing here overrides it.
extension ScaledTextStyle on TextStyle {
  TextStyle get sp => fontSize == null ? this : copyWith(fontSize: fontSize!.sp);
}
