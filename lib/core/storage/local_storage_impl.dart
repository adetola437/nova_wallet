import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage.dart';

class LocalStorageImpl implements LocalStorage {
  LocalStorageImpl({required this.prefs});

  final SharedPreferences prefs;

  static const _locale = 'nova.locale';
  static const _onboardingSeen = 'nova.onboarding_seen';
  static const _biometricEnabled = 'nova.biometric_enabled';
  static const _simulateOffline = 'nova.dev.simulate_offline';
  static const _latencyMs = 'nova.dev.latency_ms';

  @override
  Future<String?> getLocaleCode() async => prefs.getString(_locale);
  @override
  Future<void> saveLocaleCode(String code) => prefs.setString(_locale, code);

  @override
  Future<bool> getOnboardingSeen() async => prefs.getBool(_onboardingSeen) ?? false;
  @override
  Future<void> saveOnboardingSeen(bool seen) => prefs.setBool(_onboardingSeen, seen);

  @override
  Future<bool> getBiometricEnabled() async => prefs.getBool(_biometricEnabled) ?? false;
  @override
  Future<void> saveBiometricEnabled(bool enabled) => prefs.setBool(_biometricEnabled, enabled);

  @override
  Future<bool> getSimulateOffline() async => prefs.getBool(_simulateOffline) ?? false;
  @override
  Future<void> saveSimulateOffline(bool value) => prefs.setBool(_simulateOffline, value);

  @override
  Future<int?> getLatencyMs() async => prefs.getInt(_latencyMs);
  @override
  Future<void> saveLatencyMs(int ms) => prefs.setInt(_latencyMs, ms);

  @override
  Future<void> clearSessionScoped() async {
    await prefs.remove(_biometricEnabled);
  }
}
