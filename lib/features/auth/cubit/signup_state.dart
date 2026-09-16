import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/profile.dart';

enum SignupStep { phone, otp, details, bvn, pin, done }

class SignupState extends Equatable {
  const SignupState({
    this.step = SignupStep.phone,
    this.phone = '',
    this.isSubmitting = false,
    this.failure,
    this.profile,
  });

  final SignupStep step;
  final String phone;
  final bool isSubmitting;
  final Failure? failure;
  final Profile? profile;

  SignupState copyWith({
    SignupStep? step,
    String? phone,
    bool? isSubmitting,
    Failure? failure,
    Profile? profile,
    bool clearFailure = false,
  }) => SignupState(
    step: step ?? this.step,
    phone: phone ?? this.phone,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    failure: clearFailure ? null : (failure ?? this.failure),
    profile: profile ?? this.profile,
  );

  @override
  List<Object?> get props => [step, phone, isSubmitting, failure, profile];
}
