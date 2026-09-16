import 'package:dartz/dartz.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/api/service/dto.dart';
import '../../../core/models/beneficiary.dart';
import '../../../core/models/outbox_item.dart';

class SendDraft {
  const SendDraft({required this.beneficiary, required this.amountKobo, required this.feeKobo, this.narration});

  final Beneficiary beneficiary;
  final int amountKobo;
  final int feeKobo;
  final String? narration;
}

class CreateGoalDraft {
  const CreateGoalDraft({
    required this.clientId,
    required this.name,
    required this.targetKobo,
    required this.targetDate,
  });

  final String clientId;
  final String name;
  final int targetKobo;
  final DateTime targetDate;
}

class ContributeDraft {
  const ContributeDraft({required this.goalClientId, required this.goalName, required this.amountKobo});

  final String goalClientId;
  final String goalName;
  final int amountKobo;
}

class MoveToWalletDraft {
  const MoveToWalletDraft({
    required this.goalClientId,
    required this.goalName,
    required this.amountKobo,
    this.breakFeeKobo = 0,
  });

  final String goalClientId;
  final String goalName;

  /// Leaves the goal.
  final int amountKobo;

  /// Early-break fee the user confirmed; the wallet receives amount − fee.
  final int breakFeeKobo;
}

/// The durable queue of user intents, and the only path to a mutating call.
///
/// Every method that changes an item does so in one Isar transaction, so the
/// item's state and the money it represents can never disagree.
abstract class IOutboxRepository {
  /// Saves the intent with a fresh idempotency key and holds the funds.
  /// Returns [ValidationFailure] if the available balance can't cover it.
  Future<Either<Failure, OutboxItem>> enqueueSend({
    required SendDraft draft,
    required bool online,
    String? biometricSignature,
  });

  Future<Either<Failure, OutboxItem>> enqueueCreateGoal({required CreateGoalDraft draft, required bool online});

  Future<Either<Failure, OutboxItem>> enqueueContribute({required ContributeDraft draft, required bool online});

  /// Returns [ValidationFailure] if the goal's confirmed savings, less moves
  /// already queued from it, can't cover the amount.
  Future<Either<Failure, OutboxItem>> enqueueMoveToWallet({required MoveToWalletDraft draft, required bool online});

  /// `sending` → `queued` after a crash or restart. Keeps the key.
  Future<int> recoverInterrupted();

  /// Claims the FIFO head if it is due and nothing else is in flight.
  Future<OutboxItem?> claimNext(DateTime now);

  /// Sends the claimed item. Performs no local writes.
  Future<Either<Failure, MutationResultDto>> dispatch(OutboxItem item);

  Future<void> markSucceeded(int id, MutationResultDto result, DateTime now);
  Future<void> markFailed(int id, BusinessFailure failure, DateTime now);

  /// Back to `queued` with the same key. [countAttempt] false when the attempt
  /// never reached the network.
  Future<void> markRetry(int id, {required String message, DateTime? nextAttemptAt, bool countAttempt = true});

  /// Makes every queued item immediately due (used when connectivity returns).
  Future<void> clearBackoff();

  /// When the FIFO head becomes due, if it is waiting.
  Future<DateTime?> headRetryAt();

  Future<OutboxItem?> byId(int id);
  Stream<OutboxItem?> watchItem(int id);
  Stream<List<OutboxItem>> watchActive();
  Stream<List<OutboxItem>> watchAll({int limit});
  Future<List<OutboxItem>> activeItems();
}
