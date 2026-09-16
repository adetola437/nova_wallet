import 'package:equatable/equatable.dart';

import '../utils/masking.dart';

/// A recipient whose name was verified online (NIP name enquiry) and cached.
/// Only these can receive a transfer queued while offline (spec A2).
class Beneficiary extends Equatable {
  const Beneficiary({
    required this.accountNumber,
    required this.bankCode,
    required this.bankName,
    required this.verifiedName,
    this.lastUsedAt,
  });

  final String accountNumber;
  final String bankCode;
  final String bankName;
  final String verifiedName;
  final DateTime? lastUsedAt;

  String get maskedAccount => Masking.account(accountNumber);

  @override
  List<Object?> get props => [accountNumber, bankCode, bankName, verifiedName, lastUsedAt];
}
