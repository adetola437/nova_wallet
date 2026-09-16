import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/auth/biometric_gate.dart';
import '../../settings/repository/settings_repository.dart';
import '../repository/auth_repository.dart';
import 'auth_cubit.dart';
import 'unlock_state.dart';

/// Returning-user unlock. Works with no network: the PIN hash and the hardware
/// key both live on the device.
class UnlockCubit extends Cubit<UnlockState> {
  UnlockCubit({
    required this.repository,
    required this.settings,
    required this.biometricGate,
    required this.authCubit,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now,
       super(const UnlockState());

  final IAuthRepository repository;
  final ISettingsRepository settings;
  final BiometricGate biometricGate;
  final AuthCubit authCubit;
  final DateTime Function() _clock;

  Future<bool> biometricAvailable() async => await settings.biometricEnabled() && await biometricGate.isAvailable();

  Future<void> unlockWithPin(String pin) async {
    final lockedUntil = state.lockedUntil;
    if (lockedUntil != null && lockedUntil.isAfter(_clock())) {
      emit(
        UnlockState(
          failedAttempts: state.failedAttempts,
          lockedUntil: lockedUntil,
          failure: const ValidationFailure(ValidationCode.locked, 'Too many attempts. Try again shortly.'),
        ),
      );
      return;
    }

    emit(UnlockState(isVerifying: true, failedAttempts: state.failedAttempts));
    final ok = await repository.verifyPin(pin);
    if (isClosed) return;

    if (ok) {
      emit(const UnlockState());
      authCubit.unlocked();
      return;
    }

    final attempts = state.failedAttempts + 1;
    if (attempts >= AppConstants.pinSignOutAfter) {
      emit(const UnlockState());
      await authCubit.signOut();
      return;
    }
    emit(
      UnlockState(
        failedAttempts: attempts,
        lockedUntil: attempts >= AppConstants.pinCooldownAfter ? _clock().add(AppConstants.pinCooldown) : null,
        failure: const ValidationFailure(ValidationCode.wrongPin, 'Incorrect PIN.'),
      ),
    );
  }

  Future<void> unlockWithBiometric() async {
    if (!await biometricAvailable()) return;
    emit(UnlockState(isVerifying: true, failedAttempts: state.failedAttempts));
    final result = await biometricGate.confirm(
      payload: 'unlock:${_clock().millisecondsSinceEpoch}',
      reason: 'Unlock NovaPay',
    );
    if (isClosed) return;
    result.fold((_) => emit(UnlockState(failedAttempts: state.failedAttempts)), (_) {
      emit(const UnlockState());
      authCubit.unlocked();
    });
  }
}
