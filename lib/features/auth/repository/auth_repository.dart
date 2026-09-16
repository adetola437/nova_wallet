import 'package:dartz/dartz.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/profile.dart';

/// Sessions, registration and the device PIN.
abstract class IAuthRepository {
  Future<Either<Failure, Unit>> requestOtp(String phone);
  Future<Either<Failure, Unit>> verifyOtp({required String phone, required String code});

  Future<Either<Failure, Profile>> register({
    required String phone,
    required String fullName,
    required String email,
    required String password,
  });

  /// [identifier] is an email on the Firebase backend, a phone on the fake one.
  Future<Either<Failure, Profile>> login({required String identifier, required String password});
  Future<Either<Failure, Profile>> verifyBvn(String bvn);

  /// Sets the transaction PIN: hashed on device, hash mirrored to the server so
  /// a later login on this device can verify it offline.
  Future<Either<Failure, Unit>> createPin(String pin);

  Future<bool> hasSession();
  Future<bool> hasPin();
  Future<Profile?> cachedProfile();

  /// Local, offline-capable check (spec A8).
  Future<bool> verifyPin(String pin);

  /// Clears the session, the PIN and ALL client data.
  Future<void> signOut();
}
