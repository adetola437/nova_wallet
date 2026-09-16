import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_text_styles.dart';
import '../theme/text_style_x.dart';

/// Labelled text input: the label sits above the field (not floating inside),
/// so long Yorùbá labels wrap instead of truncating.
class NovaTextField extends StatelessWidget {
  const NovaTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.helper,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLength,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.autofillHints,
    this.focusNode,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helper;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final int? maxLength;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(child: Text(label, style: AppTextStyles.caption.sp)),
        SizedBox(height: 6.h),
        Semantics(
          textField: true,
          label: label,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            obscureText: obscureText,
            enabled: enabled,
            autofocus: autofocus,
            maxLength: maxLength,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            autofillHints: autofillHints,
            style: AppTextStyles.body.sp,
            decoration: InputDecoration(
              // Screen readers get the label from here; the visual one is excluded.
              semanticCounterText: '',
              counterText: '',
              hintText: hint,
              helperText: helper,
              helperMaxLines: 3,
              errorText: errorText,
              prefixIcon: prefix,
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}
