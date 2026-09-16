import 'package:dartz/dartz.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/activity_item.dart';
import '../../../core/models/wallet_overview.dart';

/// Reads the wallet from local storage (so the app renders offline) and pulls
/// fresh figures when asked.
abstract class IWalletRepository {
  /// Ledger balance minus outbox holds. Emits on every relevant Isar change.
  Stream<WalletOverview> watchOverview();

  /// Pending/failed outbox items first, then settled transactions.
  Stream<List<ActivityItem>> watchActivity({int limit});

  Future<WalletOverview> currentOverview();

  /// Pulls balance, profile and history. Caller holds the sync lock.
  ///
  /// Returns the credits seen for the first time. The very first pull on a
  /// device returns none: history already in the account isn't news.
  Future<Either<Failure, List<ActivityItem>>> refresh();
}
