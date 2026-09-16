import 'package:equatable/equatable.dart';

/// Every recoverable error crossing the repository boundary.
///
/// Sealed so `switch` over a failure is exhaustive. That matters in the sync
/// engine, where the failure type decides between "retry with the same key"
/// ([NetworkFailure]) and "stop, tell the user" ([BusinessFailure]).
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  /// Kiba-compatible accessor.
  String failureMessage() => message;

  @override
  List<Object?> get props => [runtimeType, message];
}

/// Offline, timeout or 5xx. The server may or may not have applied the request,
/// so the only safe move is a replay with the SAME idempotency key.
class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'No internet connection.', this.timedOut = false}) : super(message);

  final bool timedOut;

  @override
  List<Object?> get props => [...super.props, timedOut];
}

enum BusinessCode {
  insufficientFunds,
  tierLimitExceeded,
  invalidAccount,
  goalNotFound,
  invalidCredentials,
  accountExists,
  invalidOtp,
  invalidBvn,
  unauthorized,

  /// A NovaWallet transfer addressed to the sender's own wallet.
  selfTransfer,
}

/// The server understood the request and said no. Terminal for that request.
class BusinessFailure extends Failure {
  const BusinessFailure(this.code, String message) : super(message);

  final BusinessCode code;

  @override
  List<Object?> get props => [...super.props, code];
}

enum ValidationCode {
  amountTooSmall,
  amountTooLarge,
  tierLimitExceeded,
  insufficientAvailable,
  invalidInput,
  wrongPin,
  pinMismatch,
  locked,
  offline,
}

/// Rejected on the device before anything was queued or sent.
class ValidationFailure extends Failure {
  const ValidationFailure(this.code, String message) : super(message);

  final ValidationCode code;

  @override
  List<Object?> get props => [...super.props, code];
}

/// Local persistence failed (Isar / secure storage).
class StorageFailure extends Failure {
  const StorageFailure(super.message);
}
