import 'package:dartz/dartz.dart';

import '../exception/failure.dart';
import 'dto.dart';

/// Remote data source. Two implementations sit behind it: the in-process
/// `FakeNovaServer` and the Firebase-backed service.
///
/// Mutating calls take an idempotency key. The server MUST return the original
/// response for a key it has already processed, including a stored rejection.
abstract class NovaApiService {
  // ── Auth ────────────────────────────────────────────────────────────────
  Future<Either<Failure, Unit>> requestOtp({required String phone});
  Future<Either<Failure, Unit>> verifyOtp({required String phone, required String code});
  Future<Either<Failure, SessionDto>> register(RegisterRequest request);

  /// [identifier] is an email on the Firebase backend and a phone number on
  /// the fake one.
  Future<Either<Failure, SessionDto>> login({required String identifier, required String password});

  /// Ends the backend session (Firebase Auth keeps its own). Works offline.
  Future<void> signOut();

  Future<Either<Failure, Unit>> setPin({required String token, required String pinHash, required String pinSalt});
  Future<Either<Failure, ProfileDto>> verifyBvn({required String token, required String bvn});

  // ── Reads ───────────────────────────────────────────────────────────────
  Future<Either<Failure, WalletDto>> getWallet({required String token});
  Future<Either<Failure, List<TransactionDto>>> getTransactions({required String token, int limit = 200});
  Future<Either<Failure, List<BeneficiaryDto>>> getBeneficiaries({required String token});
  Future<Either<Failure, BeneficiaryDto>> nameEnquiry({
    required String token,
    required String bankCode,
    required String accountNumber,
  });
  Future<Either<Failure, List<GoalDto>>> getGoals({required String token});

  /// Finds another NovaWallet user by exact email. Returns their wallet as a
  /// [BeneficiaryDto] with [Banks.novaWallet]'s code. Needs the network.
  Future<Either<Failure, BeneficiaryDto>> findNovaUser({required String token, required String email});

  // ── Mutations (idempotent) ──────────────────────────────────────────────
  Future<Either<Failure, MutationResultDto>> transfer({
    required String token,
    required String idempotencyKey,
    required TransferRequest request,
  });
  Future<Either<Failure, MutationResultDto>> createGoal({
    required String token,
    required String idempotencyKey,
    required CreateGoalRequest request,
  });
  Future<Either<Failure, MutationResultDto>> contribute({
    required String token,
    required String idempotencyKey,
    required ContributeRequest request,
  });

  /// Goal → wallet. Rejects with [BusinessCode.insufficientFunds] if the goal
  /// no longer holds the amount (e.g. a second device moved it first).
  Future<Either<Failure, MutationResultDto>> moveToWallet({
    required String token,
    required String idempotencyKey,
    required MoveToWalletRequest request,
  });
}
