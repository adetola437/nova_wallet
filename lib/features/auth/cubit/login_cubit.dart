import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/utils/phone.dart';
import '../repository/auth_repository.dart';
import 'auth_cubit.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.repository, required this.authCubit}) : super(const LoginState());

  final IAuthRepository repository;
  final AuthCubit authCubit;

  /// The login screen collects an email (Firebase). A phone number still works
  /// against the fake backend: anything without an `@` is normalised as one.
  Future<void> submit({required String identifier, required String password}) async {
    if (state.isSubmitting) return;
    final trimmed = identifier.trim();
    final String resolved;
    if (trimmed.contains('@')) {
      resolved = trimmed;
    } else {
      final phone = PhoneNumber.normalize(trimmed);
      if (phone == null) {
        emit(const LoginState(failure: ValidationFailure(ValidationCode.invalidInput, 'Enter your email address.')));
        return;
      }
      resolved = phone;
    }

    emit(const LoginState(isSubmitting: true));
    final result = await repository.login(identifier: resolved, password: password);
    if (isClosed) return;
    result.fold((f) => emit(LoginState(failure: f)), (profile) {
      authCubit.sessionStarted(profile);
      emit(const LoginState());
    });
  }
}
