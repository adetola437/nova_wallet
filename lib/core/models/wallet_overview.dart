import 'package:equatable/equatable.dart';

/// Balance as the Home screen shows it. [heldKobo] is derived from active
/// outbox debits, never stored, so it can't drift from the items causing it.
class WalletOverview extends Equatable {
  const WalletOverview({
    required this.ledgerKobo,
    required this.heldKobo,
    required this.pendingCount,
    this.lastSyncedAt,
  });

  static const WalletOverview empty = WalletOverview(ledgerKobo: 0, heldKobo: 0, pendingCount: 0);

  /// Last server-confirmed balance.
  final int ledgerKobo;
  final int heldKobo;
  final int pendingCount;
  final DateTime? lastSyncedAt;

  int get availableKobo => ledgerKobo - heldKobo;

  @override
  List<Object?> get props => [ledgerKobo, heldKobo, pendingCount, lastSyncedAt];
}
