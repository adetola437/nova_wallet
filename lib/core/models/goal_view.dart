import 'dart:math';

import 'package:equatable/equatable.dart';

import '../money/progress.dart';

enum GoalSyncState { pending, synced, failed }

class GoalView extends Equatable {
  const GoalView({
    required this.clientId,
    required this.name,
    required this.targetKobo,
    required this.targetDate,
    required this.savedKobo,
    required this.pendingKobo,
    this.movingKobo = 0,
    required this.syncState,
    required this.createdAt,
  });

  final String clientId;
  final String name;
  final int targetKobo;
  final DateTime targetDate;

  /// Server-confirmed.
  final int savedKobo;

  /// Sum of queued/sending contributions to this goal.
  final int pendingKobo;

  /// Sum of queued/sending moves from this goal back to the wallet.
  final int movingKobo;
  final GoalSyncState syncState;
  final DateTime createdAt;

  int get savedBps => Progress.bps(savedKobo: savedKobo, targetKobo: targetKobo);
  int get projectedBps => Progress.bps(savedKobo: savedKobo + pendingKobo, targetKobo: targetKobo);
  int get remainingKobo => max(0, targetKobo - savedKobo);
  bool get isReached => savedKobo >= targetKobo;

  /// What "Move to wallet" may still take: confirmed savings not already moving.
  int get movableKobo => max(0, savedKobo - movingKobo);

  @override
  List<Object?> get props => [
    clientId,
    name,
    targetKobo,
    targetDate,
    savedKobo,
    pendingKobo,
    movingKobo,
    syncState,
    createdAt,
  ];
}
