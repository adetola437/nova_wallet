import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/auth/biometric_gate.dart';
import '../../../core/auth/biometric_signer.dart';
import '../repository/settings_repository.dart';

class BiometricSettingsState extends Equatable {
  const BiometricSettingsState({this.enabled = false, this.available = false, this.busy = false, this.error});

  final bool enabled;

  /// Whether a key exists and the hardware can use it. Note this is false
  /// before the first [BiometricSettingsCubit.toggle] on — enabling is what
  /// creates the key.
  final bool available;
  final bool busy;
  final BiometricSignerError? error;

  @override
  List<Object?> get props => [enabled, available, busy, error];
}

class BiometricSettingsCubit extends Cubit<BiometricSettingsState> {
  BiometricSettingsCubit({required this.settings, required this.gate}) : super(const BiometricSettingsState());

  final ISettingsRepository settings;
  final BiometricGate gate;

  Future<void> load() async {
    final enabled = await settings.biometricEnabled();
    final available = await gate.isAvailable();
    if (!isClosed) emit(BiometricSettingsState(enabled: enabled && available, available: available));
  }

  Future<void> toggle(bool value) async {
    emit(BiometricSettingsState(enabled: state.enabled, available: state.available, busy: true));
    if (!value) {
      await gate.disable();
      await settings.setBiometricEnabled(false);
      await load();
      return;
    }
    // Enable directly — gating on isAvailable() first would never succeed,
    // because the key it checks for is created right here.
    final result = await gate.enable();
    final error = result.fold((e) => e, (_) => null);
    if (error == null) await settings.setBiometricEnabled(true);
    await load();
    if (error != null && !isClosed) {
      emit(BiometricSettingsState(enabled: state.enabled, available: state.available, error: error));
    }
  }
}
