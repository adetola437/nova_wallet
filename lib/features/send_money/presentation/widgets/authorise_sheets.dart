import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/flavor/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/money/money.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../../core/widgets/pin_pad.dart';
import '../../cubit/send_money_cubit.dart';
import '../../cubit/send_money_state.dart';

/// Board `2h`: PIN for transfers under ₦50,000.00 (or as the biometric fallback).
/// Closes itself as soon as the send leaves the review stage.
class PinAuthoriseSheet extends StatefulWidget {
  const PinAuthoriseSheet({super.key, this.showFallbackNotice = false});

  final bool showFallbackNotice;

  @override
  State<PinAuthoriseSheet> createState() => _PinAuthoriseSheetState();
}

class _PinAuthoriseSheetState extends State<PinAuthoriseSheet> {
  String _entry = '';
  bool _verifying = false;

  Future<void> _onDigit(int d) async {
    if (_entry.length >= AppConstants.pinLength || _verifying) return;
    setState(() => _entry += '$d');
    if (_entry.length < AppConstants.pinLength) return;
    setState(() => _verifying = true);
    final cubit = context.read<SendMoneyCubit>();
    await cubit.authoriseWithPin(_entry);
    if (!mounted) return;
    setState(() {
      _verifying = false;
      if (cubit.state.pinError) _entry = '';
    });
  }

  void _onDelete() {
    if (_entry.isEmpty || _verifying) return;
    setState(() => _entry = _entry.substring(0, _entry.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<SendMoneyCubit, SendMoneyState>(
      listenWhen: (a, b) => a.stage == SendStage.review && b.stage != SendStage.review,
      listener: (context, _) => Navigator.of(context).pop(),
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(l10n.pinTitle, textAlign: TextAlign.center, style: AppTextStyles.h2.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            l10n.pinSending(Money(state.debitKobo).format(), state.recipient?.verifiedName ?? ''),
            textAlign: TextAlign.center,
            style: AppTextStyles.small.sp,
          ),
          if (widget.showFallbackNotice) ...[SizedBox(height: 12.h), NoticeCard(child: Text(l10n.biometricFallback))],
          SizedBox(height: 20.h),
          PinDots(length: _entry.length, hasError: state.pinError),
          SizedBox(height: 8.h),
          if (state.pinError) Center(child: InlineError(l10n.pinWrong)),
          SizedBox(height: 12.h),
          PinPad(onDigit: _onDigit, onDelete: _onDelete, enabled: !_verifying),
        ],
      ),
    );
  }
}

/// Board `2i`: biometric approval at or above ₦50,000.00. Pops `true` when the
/// user asks for the PIN instead.
class BiometricAuthoriseSheet extends StatefulWidget {
  const BiometricAuthoriseSheet({super.key});

  @override
  State<BiometricAuthoriseSheet> createState() => _BiometricAuthoriseSheetState();
}

class _BiometricAuthoriseSheetState extends State<BiometricAuthoriseSheet> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<SendMoneyCubit>().authoriseWithBiometric());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<SendMoneyCubit, SendMoneyState>(
      listenWhen: (a, b) =>
          (a.stage == SendStage.review && b.stage != SendStage.review) || (!a.needsPinFallback && b.needsPinFallback),
      // On fallback the review screen opens the PIN sheet itself.
      listener: (context, _) => Navigator.of(context).pop(),
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.biometricTitle(Money(state.debitKobo).format()),
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(l10n.biometricBody, textAlign: TextAlign.center, style: AppTextStyles.small.sp),
          SizedBox(height: 24.h),
          Center(
            child: Semantics(
              button: true,
              label: l10n.biometricWaiting,
              excludeSemantics: true,
              child: InkResponse(
                onTap: () => context.read<SendMoneyCubit>().authoriseWithBiometric(),
                radius: 48.r,
                child: Container(
                  width: 88.r,
                  height: 88.r,
                  decoration: const BoxDecoration(color: AppColors.sendingBg, shape: BoxShape.circle),
                  child: Icon(Icons.fingerprint_rounded, size: 48.r, color: AppColors.navy900),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(l10n.biometricWaiting, textAlign: TextAlign.center, style: AppTextStyles.small.sp),
          SizedBox(height: 24.h),
          NovaButton(
            label: l10n.usePinInstead,
            variant: NovaButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          SizedBox(height: 8.h),
          NovaButton(
            label: l10n.cancelTransfer,
            variant: NovaButtonVariant.text,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }
}
