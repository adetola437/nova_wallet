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
import '../../../../core/widgets/nova_button.dart';
import '../../../auth/cubit/auth_cubit.dart';

part '../contracts/onboarding_contract.dart';
part '../views/onboarding_view.dart';

/// Boards `3b`–`3d`.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> implements OnboardingControllerContract {
  late final OnboardingViewContract view;

  @override
  final PageController pageController = PageController();

  @override
  int page = 0;

  @override
  int get pageCount => 3;

  @override
  bool get isLastPage => page == pageCount - 1;

  @override
  void initState() {
    super.initState();
    view = OnboardingView(controller: this);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void onPageChanged(int index) => setState(() => page = index);

  void _animateTo(int index) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      pageController.jumpToPage(index);
    } else {
      pageController.animateToPage(index, duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    }
  }

  @override
  void onNext() => _animateTo(page + 1);

  @override
  void onSkip() => _animateTo(pageCount - 1);

  Future<void> _finish(String path) async {
    await context.read<AuthCubit>().completeOnboarding();
    if (mounted) context.go(path);
  }

  @override
  void onCreateAccount() => _finish(AppPaths.signup);

  @override
  void onHaveAccount() => _finish(AppPaths.login);

  @override
  Widget build(BuildContext context) => view.build(context);
}
