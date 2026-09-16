import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/utils/phone.dart';
import '../repository/auth_repository.dart';
import 'auth_cubit.dart';
import 'signup_state.dart';

/// One instance per signup run (registered as a factory).
class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required this.repository, required this.authCubit}) : super(const SignupState());

  final IAuthRepository repository;
  final AuthCubit authCubit;

  Future<void> submitPhone(String phone) async {
    final normalized = PhoneNumber.normalize(phone);
    if (normalized == null) {
      emit(
        state.copyWith(
          failure: const ValidationFailure(ValidationCode.invalidInput, 'Enter a valid Nigerian phone number.'),
        ),
      );
      return;
    }
    await _run(() async {
      final result = await repository.requestOtp(normalized);
      result.fold(
        (f) => emit(state.copyWith(failure: f)),
        (_) => emit(state.copyWith(step: SignupStep.otp, phone: normalized, clearFailure: true)),
      );
    });
  }

  Future<void> resendOtp() => _run(() async {
    final result = await repository.requestOtp(state.phone);
    result.fold((f) => emit(state.copyWith(failure: f)), (_) => emit(state.copyWith(clearFailure: true)));
  });

  Future<void> submitOtp(String code) => _run(() async {
    final result = await repository.verifyOtp(phone: state.phone, code: code);
    result.fold(
      (f) => emit(state.copyWith(failure: f)),
      (_) => emit(state.copyWith(step: SignupStep.details, clearFailure: true)),
    );
  });

  Future<void> submitDetails({required String fullName, required String email, required String password}) =>
      _run(() async {
        final result = await repository.register(
          phone: state.phone,
          fullName: fullName,
          email: email,
          password: password,
        );
        result.fold(
          (f) => emit(state.copyWith(failure: f)),
          (profile) => emit(state.copyWith(step: SignupStep.bvn, profile: profile, clearFailure: true)),
        );
      });

  Future<void> submitBvn(String bvn) => _run(() async {
    final result = await repository.verifyBvn(bvn);
    result.fold(
      (f) => emit(state.copyWith(failure: f)),
      (profile) => emit(state.copyWith(step: SignupStep.pin, profile: profile, clearFailure: true)),
    );
  });

  void skipBvn() => emit(state.copyWith(step: SignupStep.pin, clearFailure: true));

  Future<void> submitPin(String pin) => _run(() async {
    final result = await repository.createPin(pin);
    await result.fold((f) async => emit(state.copyWith(failure: f)), (_) async {
      final profile = state.profile ?? await repository.cachedProfile();
      if (profile != null) authCubit.sessionStarted(profile);
      emit(state.copyWith(step: SignupStep.done, clearFailure: true));
    });
  });

  Future<void> _run(Future<void> Function() body) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, clearFailure: true));
    await body();
    if (!isClosed) emit(state.copyWith(isSubmitting: false));
  }
}
