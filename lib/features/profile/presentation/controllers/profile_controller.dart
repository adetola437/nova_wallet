import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/utils/masking.dart';
import '../../../../core/widgets/nova_bottom_sheet.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../auth/cubit/auth_cubit.dart';
import '../../../auth/cubit/auth_state.dart';
import '../../../settings/cubit/biometric_settings_cubit.dart';
import '../../../settings/cubit/locale_cubit.dart';
import '../widgets/language_sheet.dart';

part '../contracts/profile_contract.dart';
part '../views/profile_view.dart';

/// Board `4g`.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> implements ProfileControllerContract {
  late final ProfileViewContract view;

  @override
  void initState() {
    super.initState();
    view = ProfileView(controller: this);
    context.read<BiometricSettingsCubit>().load();
  }

  @override
  void onLanguage() {
    final l10n = AppLocalizations.of(context);
    showNovaBottomSheet<void>(
      context,
      title: l10n.profileLanguage,
      builder: (_) => BlocProvider.value(value: context.read<LocaleCubit>(), child: const LanguageSheet()),
    );
  }

  @override
  void onToggleBiometrics(bool value) => context.read<BiometricSettingsCubit>().toggle(value);

  @override
  void onComingSoon() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
  }

  @override
  void onDeveloper() => unawaited(context.push(AppPaths.developer));

  @override
  void onSignOut() => context.read<AuthCubit>().signOut();

  @override
  Widget build(BuildContext context) => view.build(context);
}
