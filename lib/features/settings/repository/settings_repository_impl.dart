import '../../../core/storage/local_storage.dart';
import 'settings_repository.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  SettingsRepositoryImpl({required this.localStorage});

  final LocalStorage localStorage;

  @override
  Future<String?> localeCode() => localStorage.getLocaleCode();

  @override
  Future<void> saveLocaleCode(String code) => localStorage.saveLocaleCode(code);

  @override
  Future<bool> onboardingSeen() => localStorage.getOnboardingSeen();

  @override
  Future<void> markOnboardingSeen() => localStorage.saveOnboardingSeen(true);

  @override
  Future<bool> biometricEnabled() => localStorage.getBiometricEnabled();

  @override
  Future<void> setBiometricEnabled(bool enabled) => localStorage.saveBiometricEnabled(enabled);
}
