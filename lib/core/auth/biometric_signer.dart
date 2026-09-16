import 'package:biometric_signature/biometric_signature.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

/// Why a signer operation could not complete.
///
/// The distinction matters at the call site: [keyInvalidated] means the OS threw
/// our key away and the user must re-enrol, whereas [canceled] is routine and
/// should be silent.
enum BiometricSignerError {
  /// No biometric hardware, or the platform can't do hardware-backed keys.
  /// The iOS Simulator lands here — it has no Secure Enclave.
  unavailable,

  /// Hardware exists but the user has registered no face/fingerprint.
  notEnrolled,

  /// User dismissed the prompt. Routine — don't show an error.
  canceled,

  /// Too many failed attempts; the OS has locked biometrics for now.
  lockedOut,

  /// Biometrics changed on the device (a face/finger was added or removed), so
  /// the OS destroyed the key. Enrolment must be redone.
  keyInvalidated,

  /// No key exists for our alias — this device was never enrolled, or the key
  /// was deleted.
  keyMissing,

  /// Anything else.
  failed,
}

/// Hardware-backed signer for WebAuthn-style biometric sign-in.
///
/// Generates and uses an **EC P-256** key pair held in the Secure Enclave (iOS)
/// or Keystore/StrongBox (Android). The private key is non-extractable and each
/// use is gated by a biometric prompt — the OS never hands us biometric data,
/// only the resulting signature.
///
/// The backend stores the public key from [createKey] and verifies signatures
/// produced by [sign] against it.
///
/// Note for reviewers running on the iOS Simulator: there is no Secure Enclave
/// there, so [isAvailable] returns false and the flow falls back to PIN.
class BiometricSigner {
  BiometricSigner({BiometricSignature? plugin}) : _plugin = plugin ?? BiometricSignature();

  final BiometricSignature _plugin;

  /// Alias for the sign-in key. Namespaced so a future payment-signing key can
  /// live alongside it without collision.
  static const String keyAlias = 'nova_biometric_confirm';

  /// Key settings. [setInvalidatedByBiometricEnrollment] is deliberately `true`:
  /// if someone enrols their own fingerprint on a stolen unlocked phone, the key
  /// dies rather than signing for them. iOS maps this to `.biometryCurrentSet`.
  static final CreateKeysConfig _keysConfig = CreateKeysConfig(
    signatureType: SignatureType.ecdsa,
    enforceBiometric: true,
    setInvalidatedByBiometricEnrollment: true,
    useDeviceCredentials: false,
    requireAuthentication: true,
  );

  /// True when the device can do biometrics AND the user has enrolled at least
  /// one. Never throws.
  Future<bool> isAvailable() async {
    try {
      final a = await _plugin.biometricAuthAvailable();
      return (a.canAuthenticate ?? false) && (a.hasEnrolledBiometrics ?? false);
    } on PlatformException {
      return false;
    }
  }

  /// Whether this device already holds a sign-in key. `checkValidity` makes the
  /// OS report keys invalidated by a biometric change as absent.
  Future<bool> hasKey() async {
    try {
      return await _plugin.biometricKeyExists(keyAlias: keyAlias, checkValidity: true);
    } on PlatformException {
      return false;
    }
  }

  /// Generates a fresh key pair, replacing any existing one for our alias.
  ///
  /// Returns the public key as **base64 DER SPKI** — precisely the format
  /// `POST /auth/biometric/enrol` expects for `public_key`.
  Future<Either<BiometricSignerError, String>> createKey({
    String promptMessage = 'Confirm to enable biometric approval',
  }) async {
    try {
      final result = await _plugin.createKeys(
        keyAlias: keyAlias,
        config: _keysConfig,
        keyFormat: KeyFormat.base64,
        promptMessage: promptMessage,
      );
      final publicKey = result.publicKey;
      if (result.code != BiometricError.success || publicKey == null || publicKey.isEmpty) {
        return left(_map(result.code));
      }
      return right(publicKey);
    } on PlatformException {
      return left(BiometricSignerError.failed);
    }
  }

  /// Signs [payload] (UTF-8) with the enrolled key, prompting for biometrics.
  ///
  /// Returns the plugin's native base64 **DER** signature, sent as-is. The
  /// backend accepts DER or raw `r||s` (it normalises 64-byte input to DER),
  /// so each platform sends its native format and the app converts nothing.
  Future<Either<BiometricSignerError, String>> sign(
    String payload, {
    String promptMessage = 'Approve this transfer',
  }) async {
    try {
      final result = await _plugin.createSignature(
        payload: payload,
        keyAlias: keyAlias,
        signatureFormat: SignatureFormat.base64,
        promptMessage: promptMessage,
      );
      final signature = result.signature;
      if (result.code != BiometricError.success || signature == null || signature.isEmpty) {
        return left(_map(result.code));
      }
      return right(signature);
    } on PlatformException {
      return left(BiometricSignerError.failed);
    }
  }

  /// Destroys the local key. Safe to call when no key exists.
  Future<void> deleteKey() async {
    try {
      await _plugin.deleteKeys(keyAlias: keyAlias);
    } on PlatformException {
      // Nothing to clean up — treat as already gone.
    }
  }

  BiometricSignerError _map(BiometricError? code) {
    switch (code) {
      case BiometricError.userCanceled:
      case BiometricError.systemCanceled:
        return BiometricSignerError.canceled;
      case BiometricError.notEnrolled:
        return BiometricSignerError.notEnrolled;
      case BiometricError.notAvailable:
      case BiometricError.notSupported:
      case BiometricError.securityUpdateRequired:
        return BiometricSignerError.unavailable;
      case BiometricError.lockedOut:
      case BiometricError.lockedOutPermanent:
        return BiometricSignerError.lockedOut;
      case BiometricError.keyInvalidated:
        return BiometricSignerError.keyInvalidated;
      case BiometricError.keyNotFound:
        return BiometricSignerError.keyMissing;
      default:
        return BiometricSignerError.failed;
    }
  }
}
