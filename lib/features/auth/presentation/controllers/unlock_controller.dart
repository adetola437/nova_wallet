import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/flavor/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/failure_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../../core/widgets/pin_pad.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
import '../../cubit/unlock_cubit.dart';
import '../../cubit/unlock_state.dart';

part '../contracts/unlock_contract.dart';
part '../views/unlock_view.dart';

/// Board `3l`. Works offline: the PIN hash and the hardware key are on-device.
class UnlockScreen extends StatefulWidget {
  const UnlockScreen({super.key});

  @override
  State<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends State<UnlockScreen> implements UnlockControllerContract {
  late final UnlockViewContract view;
  late final UnlockCubit _cubit = context.read<UnlockCubit>();
  StreamSubscription<UnlockState>? _sub;
  Timer? _ticker;
  String _entry = '';

  @override
  bool biometricAvailable = false;

  @override
  int cooldownSeconds = 0;

  @override
  int get enteredLength => _entry.length;

  @override
  void initState() {
    super.initState();
    view = UnlockView(controller: this);
    _sub = _cubit.stream.listen(_onState);
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final available = await _cubit.biometricAvailable();
    if (!mounted) return;
    setState(() => biometricAvailable = available);
    if (available) unawaited(_cubit.unlockWithBiometric());
  }

  void _onState(UnlockState state) {
    if (state.isVerifying || !mounted) return;
    if (state.failure != null) setState(() => _entry = '');
    final until = state.lockedUntil;
    if (until != null) _startCooldown(until);
  }

  void _startCooldown(DateTime until) {
    _ticker?.cancel();
    void tick() {
      final left = until.difference(DateTime.now()).inSeconds + 1;
      setState(() => cooldownSeconds = left > 0 ? left : 0);
      if (left <= 0) _ticker?.cancel();
    }

    tick();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _sub?.cancel();
    super.dispose();
  }

  @override
  void onDigit(int digit) {
    if (_entry.length >= AppConstants.pinLength || cooldownSeconds > 0 || _cubit.state.isVerifying) return;
    setState(() => _entry += '$digit');
    if (_entry.length == AppConstants.pinLength) _cubit.unlockWithPin(_entry);
  }

  @override
  void onDelete() {
    if (_entry.isEmpty) return;
    setState(() => _entry = _entry.substring(0, _entry.length - 1));
  }

  @override
  void onBiometric() => _cubit.unlockWithBiometric();

  @override
  void onSignOut() => context.read<AuthCubit>().signOut();

  @override
  Widget build(BuildContext context) => view.build(context);
}
