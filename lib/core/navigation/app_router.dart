import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/di/app_initializer.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/cubit/auth_state.dart';
import '../../features/auth/cubit/login_cubit.dart';
import '../../features/auth/cubit/signup_cubit.dart';
import '../../features/auth/cubit/unlock_cubit.dart';
import '../../features/auth/presentation/controllers/create_pin_controller.dart';
import '../../features/auth/presentation/controllers/login_controller.dart';
import '../../features/auth/presentation/controllers/signup_bvn_controller.dart';
import '../../features/auth/presentation/controllers/signup_details_controller.dart';
import '../../features/auth/presentation/controllers/signup_otp_controller.dart';
import '../../features/auth/presentation/controllers/signup_phone_controller.dart';
import '../../features/auth/presentation/controllers/unlock_controller.dart';
import '../../features/home/presentation/controllers/home_controller.dart';
import '../../features/onboarding/presentation/controllers/onboarding_controller.dart';
import '../../features/beneficiaries/cubit/name_enquiry_cubit.dart';
import '../../features/beneficiaries/presentation/controllers/new_recipient_controller.dart';
import '../../features/beneficiaries/presentation/controllers/nova_user_controller.dart';
import '../../features/send_money/cubit/send_money_cubit.dart';
import '../../features/send_money/presentation/controllers/recipient_controller.dart';
import '../../features/send_money/presentation/controllers/send_amount_controller.dart';
import '../../features/send_money/presentation/controllers/send_result_controller.dart';
import '../../features/send_money/presentation/controllers/send_review_controller.dart';
import '../../features/transactions/cubit/transaction_details_cubit.dart';
import '../../features/transactions/presentation/controllers/transaction_details_controller.dart';
import '../../features/developer/presentation/controllers/developer_controller.dart';
import '../../features/profile/presentation/controllers/profile_controller.dart';
import '../../features/savings/cubit/create_goal_cubit.dart';
import '../../features/savings/cubit/goal_details_cubit.dart';
import '../../features/savings/presentation/controllers/create_goal_controller.dart';
import '../../features/savings/presentation/controllers/goal_details_controller.dart';
import '../../features/savings/presentation/controllers/savings_controller.dart';
import '../../features/settings/cubit/biometric_settings_cubit.dart';
import '../../features/splash/presentation/controllers/splash_controller.dart';
import '../shell/main_shell.dart';

/// Every path in the app, in one place.
abstract class AppPaths {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const unlock = '/unlock';

  static const signup = '/signup';
  static const signupOtp = '/signup/otp';
  static const signupDetails = '/signup/details';
  static const signupBvn = '/signup/bvn';
  static const signupPin = '/signup/pin';

  static const home = '/home';
  static const save = '/save';
  static const saveCreate = '/save/create';
  static const saveGoal = '/save/goal'; // + '/:id'
  static const profile = '/profile';
  static const developer = '/profile/developer';

  static const send = '/send';
  static const sendNewRecipient = '/send/new';
  static const sendNovaUser = '/send/nova';
  static const sendAmount = '/send/amount';
  static const sendReview = '/send/review';
  static const sendResult = '/send/result';
  static const transaction = '/transaction';
}

/// go_router with a redirect driven by [AuthCubit].
///
/// Built from a cubit rather than `sl` so tests can drive it with any status.
abstract class AppRouter {
  static GoRouter create({required AuthCubit auth, String initialLocation = AppPaths.splash}) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      refreshListenable: _StreamListenable(auth.stream.map((s) => s.status).distinct()),
      redirect: (context, state) => redirectFor(auth.state.status, state.matchedLocation),
      routes: [
        GoRoute(path: AppPaths.splash, builder: (_, _) => const SplashScreen()),
        GoRoute(path: AppPaths.onboarding, builder: (_, _) => const OnboardingScreen()),
        GoRoute(
          path: AppPaths.login,
          builder: (_, _) => BlocProvider(create: (_) => sl<LoginCubit>(), child: const LoginScreen()),
        ),
        GoRoute(
          path: AppPaths.unlock,
          builder: (_, _) => BlocProvider(create: (_) => sl<UnlockCubit>(), child: const UnlockScreen()),
        ),
        // One SignupCubit for the whole signup run, shared by every step.
        ShellRoute(
          builder: (_, _, child) => BlocProvider(create: (_) => sl<SignupCubit>(), child: child),
          routes: [
            GoRoute(
              path: AppPaths.signup,
              builder: (_, _) => const SignupPhoneScreen(),
              routes: [
                GoRoute(path: 'otp', builder: (_, _) => const SignupOtpScreen()),
                GoRoute(path: 'details', builder: (_, _) => const SignupDetailsScreen()),
                GoRoute(path: 'bvn', builder: (_, _) => const SignupBvnScreen()),
                GoRoute(path: 'pin', builder: (_, _) => const CreatePinScreen()),
              ],
            ),
          ],
        ),
        // One SendMoneyCubit per send: every step of the flow shares it.
        ShellRoute(
          builder: (_, _, child) => BlocProvider(create: (_) => sl<SendMoneyCubit>(), child: child),
          routes: [
            GoRoute(
              path: AppPaths.send,
              builder: (_, _) => const RecipientScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (_, _) =>
                      BlocProvider(create: (_) => sl<NameEnquiryCubit>(), child: const NewRecipientScreen()),
                ),
                GoRoute(
                  path: 'nova',
                  builder: (_, _) => BlocProvider(create: (_) => sl<NameEnquiryCubit>(), child: const NovaUserScreen()),
                ),
                GoRoute(path: 'amount', builder: (_, _) => const SendAmountScreen()),
                GoRoute(path: 'review', builder: (_, _) => const SendReviewScreen()),
                GoRoute(path: 'result', builder: (_, _) => const SendResultScreen()),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppPaths.transaction,
          builder: (_, state) => BlocProvider(
            create: (_) => sl<TransactionDetailsCubit>(),
            child: TransactionDetailsScreen(
              args: state.extra is TransactionDetailsArgs
                  ? state.extra! as TransactionDetailsArgs
                  : const TransactionDetailsArgs(),
            ),
          ),
        ),
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => MainShell(navigationShell: shell),
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: AppPaths.home, builder: (_, _) => const HomeScreen())],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppPaths.save,
                  builder: (_, _) => const SavingsScreen(),
                  routes: [
                    GoRoute(
                      path: 'create',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, state) => BlocProvider(
                        create: (_) => sl<CreateGoalCubit>(),
                        child: CreateGoalScreen(suggestedName: state.extra is String ? state.extra! as String : null),
                      ),
                    ),
                    GoRoute(
                      path: 'goal/:id',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, state) => BlocProvider(
                        create: (_) => sl<GoalDetailsCubit>(),
                        child: GoalDetailsScreen(clientId: state.pathParameters['id']!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppPaths.profile,
                  builder: (_, _) =>
                      BlocProvider(create: (_) => sl<BiometricSettingsCubit>(), child: const ProfileScreen()),
                  routes: [
                    GoRoute(
                      path: 'developer',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, _) => const DeveloperScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Where a user in [status] may be. Returns null to stay on [location].
  ///
  /// The splash screen is always allowed: it plays its short animation, then
  /// navigates to Home and lets this function route it onwards.
  static String? redirectFor(AuthStatus status, String location) {
    bool under(String path) => location == path || location.startsWith('$path/');
    if (location == AppPaths.splash) return null;

    final inEntry = under(AppPaths.onboarding) || under(AppPaths.login) || under(AppPaths.signup);

    return switch (status) {
      AuthStatus.unknown => AppPaths.splash,
      AuthStatus.needsOnboarding => under(AppPaths.onboarding) ? null : AppPaths.onboarding,
      AuthStatus.unauthenticated => inEntry ? null : AppPaths.login,
      AuthStatus.locked => under(AppPaths.unlock) ? null : AppPaths.unlock,
      AuthStatus.authenticated => (inEntry || under(AppPaths.unlock)) ? AppPaths.home : null,
    };
  }
}

/// Bridges a cubit stream to go_router's `refreshListenable`.
class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<Object?> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
