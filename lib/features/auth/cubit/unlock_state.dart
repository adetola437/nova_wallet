import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';

class UnlockState extends Equatable {
  const UnlockState({this.isVerifying = false, this.failedAttempts = 0, this.lockedUntil, this.failure});

  final bool isVerifying;
  final int failedAttempts;
  final DateTime? lockedUntil;
  final Failure? failure;

  bool get isLocked => lockedUntil != null;

  @override
  List<Object?> get props => [isVerifying, failedAttempts, lockedUntil, failure];
}
