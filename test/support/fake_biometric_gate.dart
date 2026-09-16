import 'package:dartz/dartz.dart';
import 'package:nova_wallet/core/auth/biometric_gate.dart';
import 'package:nova_wallet/core/auth/biometric_signer.dart';

class FakeBiometricGate implements BiometricGate {
  FakeBiometricGate({this.available = true});

  bool available;

  /// When set, [confirm] and [enable] fail with this error.
  BiometricSignerError? nextError;
  String signature = 'fake-signature';
  int confirmCalls = 0;
  String? lastPayload;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<Either<BiometricSignerError, Unit>> enable() async {
    final error = nextError;
    if (error != null) return left(error);
    available = true;
    return right(unit);
  }

  @override
  Future<void> disable() async => available = false;

  @override
  Future<Either<BiometricSignerError, String>> confirm({
    required String payload,
    required String reason,
  }) async {
    confirmCalls++;
    lastPayload = payload;
    final error = nextError;
    if (error != null) return left(error);
    return right(signature);
  }
}
