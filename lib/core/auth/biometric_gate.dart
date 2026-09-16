import 'package:dartz/dartz.dart';

import 'biometric_signer.dart';

/// Biometric approval for high-value sends (spec A7, brief stretch goal).
///
/// A stub in one respect only: the fake server does not verify the signature.
/// Everything on the device is real — a hardware-backed EC P-256 key that the
/// OS destroys if biometrics change.
abstract class BiometricGate {
  /// Hardware present, a biometric enrolled, AND our key still valid.
  Future<bool> isAvailable();

  /// Creates the device key (enrolment).
  Future<Either<BiometricSignerError, Unit>> enable();

  Future<void> disable();

  /// Prompts, and returns the base64 DER signature over [payload].
  Future<Either<BiometricSignerError, String>> confirm({required String payload, required String reason});
}

class SignerBiometricGate implements BiometricGate {
  SignerBiometricGate({required this.signer});

  final BiometricSigner signer;

  @override
  Future<bool> isAvailable() async => await signer.isAvailable() && await signer.hasKey();

  @override
  Future<Either<BiometricSignerError, Unit>> enable() async {
    final result = await signer.createKey();
    return result.fold(left, (_) => right(unit));
  }

  @override
  Future<void> disable() => signer.deleteKey();

  @override
  Future<Either<BiometricSignerError, String>> confirm({required String payload, required String reason}) =>
      signer.sign(payload, promptMessage: reason);
}
