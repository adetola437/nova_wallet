/// Non-sensitive preferences only (SharedPreferences). Anything secret goes to
/// [SecureStorage]; the brief forbids tokens in plain SharedPreferences.
abstract class LocalStorage {
  Future<String?> getLocaleCode();
  Future<void> saveLocaleCode(String code);

  Future<bool> getOnboardingSeen();
  Future<void> saveOnboardingSeen(bool seen);

  Future<bool> getBiometricEnabled();
  Future<void> saveBiometricEnabled(bool enabled);

  // Developer panel
  Future<bool> getSimulateOffline();
  Future<void> saveSimulateOffline(bool value);
  Future<int?> getLatencyMs();
  Future<void> saveLatencyMs(int ms);

  /// Clears values tied to the signed-in user (keeps onboarding + locale).
  Future<void> clearSessionScoped();
}
