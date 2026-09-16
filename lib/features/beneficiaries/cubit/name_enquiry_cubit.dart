import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/bank.dart';
import '../../../core/models/beneficiary.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../repository/beneficiary_repository.dart';
import 'name_enquiry_state.dart';

/// Adding a NEW recipient. Requires connectivity: without a verified name we
/// will not let a transfer be queued (spec A2).
class NameEnquiryCubit extends Cubit<NameEnquiryState> {
  NameEnquiryCubit({required this.repository, required this.connectivity}) : super(const NameEnquiryState());

  final IBeneficiaryRepository repository;
  final ConnectivityCubit connectivity;

  static const _offline = ValidationFailure(ValidationCode.offline, 'Connect to the internet to add a new recipient.');

  void selectBank(Bank bank) => emit(state.copyWith(bank: bank, clearVerified: true, clearFailure: true));

  void toggleSave(bool value) => emit(state.copyWith(saveBeneficiary: value));

  Future<void> accountNumberChanged(String value) async {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    emit(state.copyWith(accountNumber: digits, clearVerified: true, clearFailure: true));
    if (!state.canVerify) return;

    if (!connectivity.isOnline) {
      emit(state.copyWith(failure: _offline));
      return;
    }

    emit(state.copyWith(isVerifying: true));
    final result = await repository.verify(bankCode: state.bank!.code, accountNumber: digits);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(isVerifying: false, failure: failure, clearVerified: true)),
      (beneficiary) => emit(state.copyWith(isVerifying: false, verified: beneficiary, clearFailure: true)),
    );
  }

  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// NovaWallet user by email. Same contract as the bank check: online only,
  /// and nothing can be queued until a name has come back from the server.
  Future<void> lookupEmail(String email) async {
    final trimmed = email.trim();
    emit(state.copyWith(clearVerified: true, clearFailure: true));
    if (!_email.hasMatch(trimmed)) {
      emit(state.copyWith(failure: const ValidationFailure(ValidationCode.invalidInput, 'Enter a valid email.')));
      return;
    }
    if (!connectivity.isOnline) {
      emit(state.copyWith(failure: _offline));
      return;
    }
    emit(state.copyWith(isVerifying: true));
    final result = await repository.findNovaUser(trimmed);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(isVerifying: false, failure: failure, clearVerified: true)),
      (beneficiary) => emit(state.copyWith(isVerifying: false, verified: beneficiary, clearFailure: true)),
    );
  }

  /// Clears a previous result while the user edits the email.
  void emailChanged() => emit(state.copyWith(clearVerified: true, clearFailure: true));

  /// Saves the verified recipient (when the toggle is on) and returns it.
  Future<Either<Failure, Beneficiary>> confirm() async {
    final verified = state.verified;
    if (verified == null) {
      return left(const ValidationFailure(ValidationCode.invalidInput, 'Verify the account first.'));
    }
    if (!state.saveBeneficiary) return right(verified);
    final saved = await repository.save(verified);
    return saved.fold(left, (_) => right(verified));
  }
}
