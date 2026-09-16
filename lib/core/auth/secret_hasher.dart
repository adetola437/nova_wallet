import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Salted SHA-256 for the mock backend's passwords and the on-device PIN.
///
/// A production system would use a slow KDF (Argon2id/PBKDF2) and verify the
/// PIN server-side. This is documented as a mock trade-off in the README.
class SecretHasher {
  SecretHasher({Random? random}) : _random = random ?? Random.secure();

  final Random _random;

  String newSalt() => base64UrlEncode(List<int>.generate(16, (_) => _random.nextInt(256)));

  String hash(String secret, String salt) => sha256.convert(utf8.encode('$salt:$secret')).toString();

  bool verify(String secret, String salt, String expectedHash) {
    final actual = hash(secret, salt);
    if (actual.length != expectedHash.length) return false;
    var diff = 0;
    for (var i = 0; i < actual.length; i++) {
      diff |= actual.codeUnitAt(i) ^ expectedHash.codeUnitAt(i);
    }
    return diff == 0;
  }
}
