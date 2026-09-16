import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/brand_mark.dart';

part '../contracts/splash_contract.dart';
part '../views/splash_view.dart';

/// Board `3a`. One short animation (no Lottie), then hands over to the router,
/// whose AuthCubit-driven redirect picks onboarding / login / unlock / home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin
    implements SplashControllerContract {
  late final SplashViewContract view;
  late final AnimationController _controller;

  @override
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    view = SplashView(controller: this);
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward().whenCompleteOrCancel(_leave);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect "reduce motion": jump straight to the end state.
    if (MediaQuery.disableAnimationsOf(context) && _controller.isAnimating) _controller.value = 1;
  }

  Future<void> _leave() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (mounted) context.go(AppPaths.home);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => view.build(context);
}
