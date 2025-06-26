import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_tokens.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

// Loading states
class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthLoginLoading extends AuthState {
  const AuthLoginLoading();
}

class AuthRegisterLoading extends AuthState {
  const AuthRegisterLoading();
}

class AuthLogoutLoading extends AuthState {
  const AuthLogoutLoading();
}

class AuthPasswordResetLoading extends AuthState {
  const AuthPasswordResetLoading();
}

class AuthEmailVerificationLoading extends AuthState {
  const AuthEmailVerificationLoading();
}

class AuthRefreshTokenLoading extends AuthState {
  const AuthRefreshTokenLoading();
}

class AuthUserUpdateLoading extends AuthState {
  const AuthUserUpdateLoading();
}

class AuthPasswordChangeLoading extends AuthState {
  const AuthPasswordChangeLoading();
}

class AuthBiometricLoading extends AuthState {
  const AuthBiometricLoading();
}

class AuthAccountDeletionLoading extends AuthState {
  const AuthAccountDeletionLoading();
}

// Success states
class AuthAuthenticated extends AuthState {
  final User user;
  final AuthTokens? tokens;
  final bool isEmailVerified;
  final bool isBiometricEnabled;

  const AuthAuthenticated({
    required this.user,
    this.tokens,
    this.isEmailVerified = false,
    this.isBiometricEnabled = false,
  });

  @override
  List<Object?> get props => [user, tokens, isEmailVerified, isBiometricEnabled];

  AuthAuthenticated copyWith({
    User? user,
    AuthTokens? tokens,
    bool? isEmailVerified,
    bool? isBiometricEnabled,
  }) {
    return AuthAuthenticated(
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthLoginSuccess extends AuthState {
  final User user;
  final AuthTokens tokens;

  const AuthLoginSuccess({
    required this.user,
    required this.tokens,
  });

  @override
  List<Object> get props => [user, tokens];
}

class AuthRegisterSuccess extends AuthState {
  final User user;
  final AuthTokens tokens;
  final bool requiresEmailVerification;

  const AuthRegisterSuccess({
    required this.user,
    required this.tokens,
    this.requiresEmailVerification = true,
  });

  @override
  List<Object> get props => [user, tokens, requiresEmailVerification];
}

class AuthLogoutSuccess extends AuthState {
  const AuthLogoutSuccess();
}

class AuthPasswordResetEmailSent extends AuthState {
  final String email;

  const AuthPasswordResetEmailSent({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}

class AuthEmailVerificationSuccess extends AuthState {
  const AuthEmailVerificationSuccess();
}

class AuthEmailVerificationResent extends AuthState {
  const AuthEmailVerificationResent();
}

class AuthTokenRefreshed extends AuthState {
  final AuthTokens tokens;

  const AuthTokenRefreshed({
    required this.tokens,
  });

  @override
  List<Object> get props => [tokens];
}

class AuthUserUpdated extends AuthState {
  final User user;

  const AuthUserUpdated({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class AuthPasswordChanged extends AuthState {
  const AuthPasswordChanged();
}

class AuthBiometricAvailable extends AuthState {
  final bool isAvailable;
  final bool isEnabled;

  const AuthBiometricAvailable({
    required this.isAvailable,
    required this.isEnabled,
  });

  @override
  List<Object> get props => [isAvailable, isEnabled];
}

class AuthBiometricSuccess extends AuthState {
  final User user;
  final AuthTokens tokens;

  const AuthBiometricSuccess({
    required this.user,
    required this.tokens,
  });

  @override
  List<Object> get props => [user, tokens];
}

class AuthBiometricSetupSuccess extends AuthState {
  final bool isEnabled;

  const AuthBiometricSetupSuccess({
    required this.isEnabled,
  });

  @override
  List<Object> get props => [isEnabled];
}

class AuthSessionExpired extends AuthState {
  const AuthSessionExpired();
}

class AuthAccountDeleted extends AuthState {
  const AuthAccountDeleted();
}

// Error states
class AuthError extends AuthState {
  final String message;
  final String? errorCode;

  const AuthError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class AuthLoginError extends AuthState {
  final String message;
  final String? errorCode;

  const AuthLoginError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class AuthRegisterError extends AuthState {
  final String message;
  final String? errorCode;
  final Map<String, String>? fieldErrors;

  const AuthRegisterError({
    required this.message,
    this.errorCode,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, errorCode, fieldErrors];
}

class AuthPasswordResetError extends AuthState {
  final String message;
  final String? errorCode;

  const AuthPasswordResetError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class AuthEmailVerificationError extends AuthState {
  final String message;
  final String? errorCode;

  const AuthEmailVerificationError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class AuthNetworkError extends AuthState {
  final String message;

  const AuthNetworkError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class AuthValidationError extends AuthState {
  final String message;
  final Map<String, String>? fieldErrors;

  const AuthValidationError({
    required this.message,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, fieldErrors];
}

class AuthUnauthorizedError extends AuthState {
  final String message;

  const AuthUnauthorizedError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class AuthBiometricError extends AuthState {
  final String message;
  final String? errorCode;

  const AuthBiometricError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}
