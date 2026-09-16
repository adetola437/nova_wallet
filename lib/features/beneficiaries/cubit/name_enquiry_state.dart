import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/bank.dart';
import '../../../core/models/beneficiary.dart';

class NameEnquiryState extends Equatable {
  const NameEnquiryState({
    this.bank,
    this.accountNumber = '',
    this.isVerifying = false,
    this.verified,
    this.failure,
    this.saveBeneficiary = true,
  });

  final Bank? bank;
  final String accountNumber;
  final bool isVerifying;
  final Beneficiary? verified;
  final Failure? failure;
  final bool saveBeneficiary;

  bool get canVerify => bank != null && accountNumber.length == 10;

  NameEnquiryState copyWith({
    Bank? bank,
    String? accountNumber,
    bool? isVerifying,
    Beneficiary? verified,
    Failure? failure,
    bool? saveBeneficiary,
    bool clearVerified = false,
    bool clearFailure = false,
  }) => NameEnquiryState(
    bank: bank ?? this.bank,
    accountNumber: accountNumber ?? this.accountNumber,
    isVerifying: isVerifying ?? this.isVerifying,
    verified: clearVerified ? null : (verified ?? this.verified),
    failure: clearFailure ? null : (failure ?? this.failure),
    saveBeneficiary: saveBeneficiary ?? this.saveBeneficiary,
  );

  @override
  List<Object?> get props => [bank, accountNumber, isVerifying, verified, failure, saveBeneficiary];
}
