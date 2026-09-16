import '../auth/secret_hasher.dart';
import 'secure_storage.dart';

abstract class SecureKeys {
  static const sessionToken = 'nova.session_token';
  static const pinHash = 'nova.pin_hash';
  static const pinSalt = 'nova.pin_salt';
}

/// Session secrets, always in secure storage.
class SessionStore {
  SessionStore({required this.secureStorage, required this.hasher});

  final SecureStorage secureStorage;
  final SecretHasher hasher;

  Future<String?> readToken() => secureStorage.read(SecureKeys.sessionToken);
  Future<void> saveToken(String token) => secureStorage.write(SecureKeys.sessionToken, token);

  Future<void> savePinHash({required String hash, required String salt}) async {
    await secureStorage.write(SecureKeys.pinHash, hash);
    await secureStorage.write(SecureKeys.pinSalt, salt);
  }

  Future<bool> hasPin() async => (await secureStorage.read(SecureKeys.pinHash)) != null;

  /// Local check so unlock and send authorisation work offline (spec A8).
  Future<bool> verifyPin(String pin) async {
    final hash = await secureStorage.read(SecureKeys.pinHash);
    final salt = await secureStorage.read(SecureKeys.pinSalt);
    if (hash == null || salt == null) return false;
    return hasher.verify(pin, salt, hash);
  }

  Future<void> clear() async {
    await secureStorage.delete(SecureKeys.sessionToken);
    await secureStorage.delete(SecureKeys.pinHash);
    await secureStorage.delete(SecureKeys.pinSalt);
  }
}
