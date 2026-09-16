import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/profile.dart';
import '../../settings/repository/settings_repository.dart';
import '../repository/auth_repository.dart';
import 'auth_state.dart';

/// The session state machine every other session-scoped cubit follows.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.repository, required this.settings}) : super(const AuthState.unknown());

  final IAuthRepository repository;
  final ISettingsRepository settings;

  /// Set by the session lifecycle: stops session-scoped work (sync, refreshes)
  /// and waits for anything in flight. Runs BEFORE local data is wiped, so a
  /// late response can never write the previous user's data back.
  Future<void> Function()? onBeforeSignOut;

  Profile? get profile => state.profile;

  /// Runs on the splash screen.
  Future<void> bootstrap() async {
    if (await repository.hasSession()) {
      emit(AuthState(status: AuthStatus.locked, profile: await repository.cachedProfile()));
      return;
    }
    final seen = await settings.onboardingSeen();
    emit(AuthState(status: seen ? AuthStatus.unauthenticated : AuthStatus.needsOnboarding));
  }

  Future<void> completeOnboarding() async {
    await settings.markOnboardingSeen();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void sessionStarted(Profile profile) => emit(AuthState(status: AuthStatus.authenticated, profile: profile));

  void unlocked() => emit(AuthState(status: AuthStatus.authenticated, profile: state.profile));

  void profileUpdated(Profile profile) => emit(state.copyWith(profile: profile));

  /// Order matters: stop session work → [beforeWipe] (still signed in, e.g. a
  /// backend reset that needs the current user) → wipe → announce.
  Future<void> signOut({Future<void> Function()? beforeWipe}) async {
    await onBeforeSignOut?.call();
    await beforeWipe?.call();
    await repository.signOut();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
