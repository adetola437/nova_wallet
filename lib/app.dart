import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'config/di/app_initializer.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/yo_fallback_localizations.dart';
import 'core/navigation/app_router.dart';
import 'core/notifications/local_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/cubit/auth_state.dart';
import 'features/beneficiaries/cubit/beneficiaries_cubit.dart';
import 'features/connectivity/cubit/connectivity_cubit.dart';
import 'features/developer/cubit/developer_cubit.dart';
import 'features/savings/cubit/savings_cubit.dart';
import 'features/settings/cubit/locale_cubit.dart';
import 'features/sync/cubit/sync_cubit.dart';
import 'features/transactions/presentation/controllers/transaction_details_controller.dart';
import 'features/wallet/cubit/wallet_cubit.dart';

class NovaWalletApp extends StatefulWidget {
  const NovaWalletApp({super.key});

  /// Screen-size scaling for fonts, clamped: on a large phone a 2× system
  /// text setting multiplied by an unclamped screen factor overflows. The
  /// user's own text scale is never touched.
  static double clampedFontSize(num fontSize, ScreenUtil util) =>
      fontSize * math.min(math.max(util.scaleText, 0.9), 1.1);

  @override
  State<NovaWalletApp> createState() => _NovaWalletAppState();
}

class _NovaWalletAppState extends State<NovaWalletApp> {
  late final GoRouter _router = AppRouter.create(auth: sl<AuthCubit>());
  late final AppLifecycleListener _lifecycle;
  final LocalNotificationService _notifications = sl<LocalNotificationService>();
  StreamSubscription<String>? _tapSub;
  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    _tapSub = _notifications.taps.listen(_openFromNotification);
    unawaited(
      _notifications.launchPayload().then((payload) {
        if (payload != null) _openFromNotification(payload);
      }),
    );
    // Ask for notification permission once the user is signed in, not on the
    // splash screen — by then the prompt has context.
    _authSub = sl<AuthCubit>().stream.listen(_maybeAskForNotifications);
    _maybeAskForNotifications(sl<AuthCubit>().state);
    // Resume is a replay trigger: the OS may not have told us about a
    // reconnect while we were suspended, and a queued transfer should go out
    // the moment the user comes back.
    _lifecycle = AppLifecycleListener(
      onResume: () {
        sl<SyncCubit>().setForeground(true);
        sl<ConnectivityCubit>().recheck();
        // Money may have arrived while we were away.
        if (sl<AuthCubit>().state.status == AuthStatus.authenticated) {
          unawaited(sl<WalletCubit>().checkForUpdates());
        }
      },
      onPause: () => sl<SyncCubit>().setForeground(false),
    );
  }

  void _maybeAskForNotifications(AuthState state) {
    if (state.status == AuthStatus.authenticated) unawaited(_notifications.requestPermission());
  }

  /// `outbox:<id>` opens that transaction's timeline; anything else opens
  /// Home. A locked app is redirected to unlock first by the router.
  void _openFromNotification(String payload) {
    final outboxId = payload.startsWith('outbox:') ? int.tryParse(payload.substring(7)) : null;
    if (outboxId != null) {
      unawaited(_router.push(AppPaths.transaction, extra: TransactionDetailsArgs(outboxId: outboxId)));
    } else {
      _router.go(AppPaths.home);
    }
  }

  @override
  void dispose() {
    _tapSub?.cancel();
    _authSub?.cancel();
    _lifecycle.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      fontSizeResolver: NovaWalletApp.clampedFontSize,
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<AuthCubit>()),
          BlocProvider.value(value: sl<LocaleCubit>()),
          BlocProvider.value(value: sl<ConnectivityCubit>()),
          BlocProvider.value(value: sl<SyncCubit>()),
          BlocProvider.value(value: sl<WalletCubit>()),
          BlocProvider.value(value: sl<BeneficiariesCubit>()),
          BlocProvider.value(value: sl<SavingsCubit>()),
          BlocProvider.value(value: sl<DeveloperCubit>()),
        ],
        child: BlocBuilder<LocaleCubit, Locale?>(
          builder: (context, locale) => MaterialApp.router(
            onGenerateTitle: (context) => AppLocalizations.of(context).appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: _router,
            scaffoldMessengerKey: messengerKey,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            // The Yorùbá fallbacks must come before the Global delegates.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              YoMaterialLocalizationsDelegate(),
              YoCupertinoLocalizationsDelegate(),
              YoWidgetsLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
          ),
        ),
      ),
    );
  }
}
