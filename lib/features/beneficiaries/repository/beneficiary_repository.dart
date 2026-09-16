import 'package:dartz/dartz.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/beneficiary.dart';

/// Saved recipients with server-verified names, cached so an offline send has
/// a name it can trust (spec A2).
abstract class IBeneficiaryRepository {
  Stream<List<Beneficiary>> watchAll();
  Future<List<Beneficiary>> all();

  /// NIP-style name enquiry. Needs the network.
  Future<Either<Failure, Beneficiary>> verify({required String bankCode, required String accountNumber});

  /// Finds another NovaWallet user by email. Needs the network.
  Future<Either<Failure, Beneficiary>> findNovaUser(String email);

  Future<Either<Failure, Unit>> save(Beneficiary beneficiary);
  Future<void> touch(Beneficiary beneficiary);
  Future<Either<Failure, Unit>> refresh();
}
