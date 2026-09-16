import 'package:equatable/equatable.dart';

import '../../../core/models/profile.dart';

enum AuthStatus {
  /// Before bootstrap finishes (splash).
  unknown,
  needsOnboarding,
  unauthenticated,

  /// A session exists but the app is locked (PIN / biometric).
  locked,
  authenticated,
}

class AuthState extends Equatable {
  const AuthState({required this.status, this.profile});

  const AuthState.unknown() : status = AuthStatus.unknown, profile = null;

  final AuthStatus status;
  final Profile? profile;

  AuthState copyWith({AuthStatus? status, Profile? profile}) =>
      AuthState(status: status ?? this.status, profile: profile ?? this.profile);

  @override
  List<Object?> get props => [status, profile];
}
