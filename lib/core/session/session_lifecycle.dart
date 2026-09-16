import 'dart:async';

import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/cubit/auth_state.dart';
import '../../features/beneficiaries/cubit/beneficiaries_cubit.dart';
import '../../features/savings/cubit/savings_cubit.dart';
import '../../features/sync/cubit/sync_cubit.dart';
import '../../features/wallet/cubit/wallet_cubit.dart';

/// Starts and stops session-scoped cubits as the session changes.
///
/// Sync starts while the app is still LOCKED: a queued transfer should go out
/// as soon as there is a network, even before the user unlocks. On sign-out
/// everything is stopped (and in-flight work awaited) BEFORE the caller wipes
/// local data.
class SessionLifecycle {
  SessionLifecycle({
    required this.auth,
    required this.sync,
    required this.wallet,
    required this.beneficiaries,
    required this.savings,
  });

  final AuthCubit auth;
  final SyncCubit sync;
  final WalletCubit wallet;
  final BeneficiariesCubit beneficiaries;
  final SavingsCubit savings;

  StreamSubscription<AuthState>? _sub;

  /// Serialises transitions so a fast login → logout can't interleave.
  Future<void> _last = Future<void>.value();

  void attach() {
    auth.onBeforeSignOut = _stopSession;
    _enqueue(auth.state);
    _sub = auth.stream.listen(_enqueue);
  }

  void _enqueue(AuthState state) {
    _last = _last.then((_) => _handle(state)).catchError((Object _) {});
  }

  /// Runs inside [AuthCubit.signOut], before the wipe, and is awaited.
  Future<void> _stopSession() {
    _last = _last.then((_) => _resetAll()).catchError((Object _) {});
    return _last;
  }

  Future<void> _resetAll() async {
    await wallet.reset();
    await beneficiaries.reset();
    await savings.reset();
    await sync.reset();
  }

  Future<void> _handle(AuthState state) async {
    switch (state.status) {
      case AuthStatus.locked:
        await sync.start();
      case AuthStatus.authenticated:
        await sync.start();
        await wallet.start();
        await beneficiaries.start();
        await savings.start();
      case AuthStatus.unauthenticated:
      case AuthStatus.needsOnboarding:
        // Usually already done by _stopSession; resetting twice is harmless.
        await _resetAll();
      case AuthStatus.unknown:
        break;
    }
  }

  /// Completes when every transition seen so far has been applied.
  Future<void> get settled => _last;

  Future<void> detach() async {
    if (auth.onBeforeSignOut == _stopSession) auth.onBeforeSignOut = null;
    await _sub?.cancel();
    _sub = null;
    await _last;
  }
}
