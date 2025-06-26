import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Check if user is already authenticated
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

// Login events
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

// Register events
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phoneNumber;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName, phoneNumber];
}

// Logout event
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

// Refresh token event
class AuthRefreshTokenRequested extends AuthEvent {
  const AuthRefreshTokenRequested();
}

// Get current user event
class AuthGetCurrentUserRequested extends AuthEvent {
  const AuthGetCurrentUserRequested();
}

// Password reset events
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

class AuthPasswordResetConfirmed extends AuthEvent {
  final String token;
  final String newPassword;

  const AuthPasswordResetConfirmed({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object> get props => [token, newPassword];
}

// Email verification events
class AuthEmailVerificationRequested extends AuthEvent {
  final String token;

  const AuthEmailVerificationRequested({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}

class AuthEmailVerificationResendRequested extends AuthEvent {
  const AuthEmailVerificationResendRequested();
}

// Clear error event
class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}

// Update user event
class AuthUserUpdated extends AuthEvent {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? profileImageUrl;

  const AuthUserUpdated({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [firstName, lastName, phoneNumber, profileImageUrl];
}

// Change password event
class AuthPasswordChangeRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const AuthPasswordChangeRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}

// Biometric authentication events
class AuthBiometricCheckRequested extends AuthEvent {
  const AuthBiometricCheckRequested();
}

class AuthBiometricLoginRequested extends AuthEvent {
  const AuthBiometricLoginRequested();
}

class AuthBiometricSetupRequested extends AuthEvent {
  final bool enable;

  const AuthBiometricSetupRequested({
    required this.enable,
  });

  @override
  List<Object> get props => [enable];
}

// Session management events
class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired();
}

class AuthSessionRefreshed extends AuthEvent {
  const AuthSessionRefreshed();
}

// Account deletion event
class AuthAccountDeletionRequested extends AuthEvent {
  final String password;

  const AuthAccountDeletionRequested({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}
