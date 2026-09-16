import 'package:equatable/equatable.dart';

class SyncState extends Equatable {
  const SyncState({
    this.pendingCount = 0,
    this.pendingDebitKobo = 0,
    this.troubleCount = 0,
    this.isSyncing = false,
    this.lastSyncedAt,
    this.settledCount = 0,
  });

  /// Items queued or sending.
  final int pendingCount;

  /// Money those items are holding.
  final int pendingDebitKobo;

  /// Items that have failed to reach the server many times (trouble copy).
  final int troubleCount;

  final bool isSyncing;
  final DateTime? lastSyncedAt;

  /// Increments on every terminal outcome. The wallet watches this to refresh.
  final int settledCount;

  SyncState copyWith({
    int? pendingCount,
    int? pendingDebitKobo,
    int? troubleCount,
    bool? isSyncing,
    DateTime? lastSyncedAt,
    int? settledCount,
  }) => SyncState(
    pendingCount: pendingCount ?? this.pendingCount,
    pendingDebitKobo: pendingDebitKobo ?? this.pendingDebitKobo,
    troubleCount: troubleCount ?? this.troubleCount,
    isSyncing: isSyncing ?? this.isSyncing,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    settledCount: settledCount ?? this.settledCount,
  );

  @override
  List<Object?> get props => [pendingCount, pendingDebitKobo, troubleCount, isSyncing, lastSyncedAt, settledCount];
}
