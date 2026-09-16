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
import '../../cubit/signup_cubit.dart';
import '../../cubit/signup_state.dart';
import 'signup_phone_controller.dart';

part '../contracts/create_pin_contract.dart';
part '../views/create_pin_view.dart';

/// Boards `3i` (create) and `3j` (confirm) as two stages of one screen, so
/// the first PIN never travels through router state.
class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> implements CreatePinControllerContract {
  late final CreatePinViewContract view;
  String _first = '';
  String _entry = '';

  @override
  bool confirming = false;
  @override
  bool mismatch = false;
  @override
  bool matched = false;

  @override
  int get enteredLength => _entry.length;

  @override
  void initState() {
    super.initState();
    view = CreatePinView(controller: this);
  }

  @override
  void onDigit(int digit) {
    if (_entry.length >= AppConstants.pinLength || matched) return;
    setState(() {
      mismatch = false;
      _entry += '$digit';
    });
    if (_entry.length == AppConstants.pinLength) _complete();
  }

  @override
  void onDelete() {
    if (_entry.isEmpty || matched) return;
    setState(() => _entry = _entry.substring(0, _entry.length - 1));
  }

  Future<void> _complete() async {
    if (!confirming) {
      setState(() {
        _first = _entry;
        _entry = '';
        confirming = true;
      });
      return;
    }
    if (_entry != _first) {
      setState(() {
        mismatch = true;
        _first = '';
        _entry = '';
        confirming = false;
      });
      return;
    }
    setState(() => matched = true);
    // Success flips AuthCubit to authenticated; the router takes over from there.
    await context.read<SignupCubit>().submitPin(_entry);
    if (mounted && context.read<SignupCubit>().state.failure != null) {
      setState(() {
        matched = false;
        _entry = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !confirming,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) {
        setState(() {
          confirming = false;
          _first = '';
          _entry = '';
        });
      }
    },
    child: view.build(context),
  );
}
