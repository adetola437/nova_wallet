import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';

class LoginState extends Equatable {
  const LoginState({this.isSubmitting = false, this.failure});

  final bool isSubmitting;
  final Failure? failure;

  @override
  List<Object?> get props => [isSubmitting, failure];
}
