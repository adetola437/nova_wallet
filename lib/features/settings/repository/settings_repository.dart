/// Device preferences. Nothing here is sensitive, so it all lives in
/// SharedPreferences.
abstract class ISettingsRepository {
  Future<String?> localeCode();
  Future<void> saveLocaleCode(String code);

  Future<bool> onboardingSeen();
  Future<void> markOnboardingSeen();

  Future<bool> biometricEnabled();
  Future<void> setBiometricEnabled(bool enabled);
}
