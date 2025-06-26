import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../../../core/errors/failures.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final LocalAuthentication _localAuth;
  
  Timer? _tokenRefreshTimer;
  User? _currentUser;
  AuthTokens? _currentTokens;

  AuthBloc(
    this._authRepository,
    this._localAuth,
  ) : super(const AuthInitial()) {
    // Register event handlers
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthRefreshTokenRequested>(_onAuthRefreshTokenRequested);
    on<AuthGetCurrentUserRequested>(_onAuthGetCurrentUserRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);
    on<AuthPasswordResetConfirmed>(_onAuthPasswordResetConfirmed);
    on<AuthEmailVerificationRequested>(_onAuthEmailVerificationRequested);
    on<AuthEmailVerificationResendRequested>(_onAuthEmailVerificationResendRequested);
    on<AuthErrorCleared>(_onAuthErrorCleared);
    on<AuthUserUpdated>(_onAuthUserUpdated);
    on<AuthPasswordChangeRequested>(_onAuthPasswordChangeRequested);
    on<AuthBiometricCheckRequested>(_onAuthBiometricCheckRequested);
    on<AuthBiometricLoginRequested>(_onAuthBiometricLoginRequested);
    on<AuthBiometricSetupRequested>(_onAuthBiometricSetupRequested);
    on<AuthSessionExpired>(_onAuthSessionExpired);
    on<AuthSessionRefreshed>(_onAuthSessionRefreshed);
    on<AuthAccountDeletionRequested>(_onAuthAccountDeletionRequested);
  }

  @override
  Future<void> close() {
    _tokenRefreshTimer?.cancel();
    return super.close();
  }

  // Check if user is already authenticated
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      
      if (isAuthenticated) {
        final tokens = await _authRepository.getStoredTokens();
        
        if (tokens != null) {
          // Check if token is expired or expiring soon
          if (tokens.isExpired) {
            // Try to refresh token
            final refreshResult = await _authRepository.refreshTokens();
            
            await refreshResult.fold(
              (failure) async {
                // Refresh failed, user needs to login again
                await _authRepository.clearTokens();
                emit(const AuthUnauthenticated());
              },
              (newTokens) async {
                _currentTokens = newTokens;
                await _getUserAndEmitAuthenticated(emit, newTokens);
                _scheduleTokenRefresh(newTokens);
              },
            );
          } else {
            _currentTokens = tokens;
            await _getUserAndEmitAuthenticated(emit, tokens);
            _scheduleTokenRefresh(tokens);
          }
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to check authentication status: $e'));
    }
  }

  // Login user
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoginLoading());

    final result = await _authRepository.login(
      email: event.email,
      password: event.password,
    );

    await result.fold(
      (failure) async {
        emit(_mapFailureToAuthError(failure, isLogin: true));
      },
      (tokens) async {
        _currentTokens = tokens;
        await _getUserAndEmitAuthenticated(emit, tokens);
        _scheduleTokenRefresh(tokens);
      },
    );
  }

  // Register user
  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthRegisterLoading());

    final result = await _authRepository.register(
      email: event.email,
      password: event.password,
      firstName: event.firstName,
      lastName: event.lastName,
      phoneNumber: event.phoneNumber,
    );

    await result.fold(
      (failure) async {
        emit(_mapFailureToAuthError(failure, isRegister: true));
      },
      (tokens) async {
        _currentTokens = tokens;
        await _getUserAndEmitAuthenticated(emit, tokens);
        _scheduleTokenRefresh(tokens);
      },
    );
  }

  // Logout user
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLogoutLoading());

    _tokenRefreshTimer?.cancel();

    final result = await _authRepository.logout();

    result.fold(
      (failure) {
        // Even if server logout fails, clear local data
        _currentUser = null;
        _currentTokens = null;
        emit(const AuthLogoutSuccess());
      },
      (_) {
        _currentUser = null;
        _currentTokens = null;
        emit(const AuthLogoutSuccess());
      },
    );
  }

  // Refresh tokens
  Future<void> _onAuthRefreshTokenRequested(
    AuthRefreshTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthRefreshTokenLoading());

    final result = await _authRepository.refreshTokens();

    result.fold(
      (failure) {
        emit(_mapFailureToAuthError(failure));
      },
      (tokens) {
        _currentTokens = tokens;
        emit(AuthTokenRefreshed(tokens: tokens));
        _scheduleTokenRefresh(tokens);
      },
    );
  }

  // Get current user
  Future<void> _onAuthGetCurrentUserRequested(
    AuthGetCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.getCurrentUser();

    result.fold(
      (failure) {
        emit(_mapFailureToAuthError(failure));
      },
      (user) {
        _currentUser = user;
        emit(AuthAuthenticated(
          user: user,
          tokens: _currentTokens,
          isEmailVerified: user.isEmailVerified ?? false,
        ));
      },
    );
  }

  // Password reset request
  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthPasswordResetLoading());

    final result = await _authRepository.sendPasswordResetEmail(event.email);

    result.fold(
      (failure) {
        emit(_mapFailureToAuthError(failure, isPasswordReset: true));
      },
      (_) {
        emit(AuthPasswordResetEmailSent(email: event.email));
      },
    );
  }

  // Password reset confirmation
  Future<void> _onAuthPasswordResetConfirmed(
    AuthPasswordResetConfirmed event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthPasswordResetLoading());

    final result = await _authRepository.resetPassword(
      token: event.token,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) {
        emit(_mapFailureToAuthError(failure, isPasswordReset: true));
      },
      (_) {
        emit(const AuthPasswordResetSuccess());
      },
    );
  }

  // Email verification
  Future<void> _onAuthEmailVerificationRequested(
    AuthEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthEmailVerificationLoading());

    final result = await _authRepository.verifyEmail(event.token);

    result.fold(
      (failure) {
        emit(_mapFailureToAuthError(failure, isEmailVerification: true));
      },
      (_) {
        emit(const AuthEmailVerificationSuccess());
        // Update current user if authenticated
        if (_currentUser != null) {
          add(const AuthGetCurrentUserRequested());
        }
      },
    );
  }

  // Resend email verification
  Future<void> _onAuthEmailVerificationResendRequested(
    AuthEmailVerificationResendRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthEmailVerificationLoading());

    final result = await _authRepository.resendEmailVerification();

    result.fold(
      (failure) {
        emit(_mapFailureToAuthError(failure, isEmailVerification: true));
      },
      (_) {
        emit(const AuthEmailVerificationResent());
      },
    );
  }

  // Clear error
  void _onAuthErrorCleared(
    AuthErrorCleared event,
    Emitter<AuthState> emit,
  ) {
    if (_currentUser != null && _currentTokens != null) {
      emit(AuthAuthenticated(
        user: _currentUser!,
        tokens: _currentTokens,
        isEmailVerified: _currentUser!.isEmailVerified ?? false,
      ));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  // Update user
  Future<void> _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthUserUpdateLoading());

    // For now, just update locally. In a real app, you'd call an API
    if (_currentUser != null) {
      final updatedUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        firstName: event.firstName ?? _currentUser!.firstName,
        lastName: event.lastName ?? _currentUser!.lastName,
        phoneNumber: event.phoneNumber ?? _currentUser!.phoneNumber,
        profileImageUrl: event.profileImageUrl ?? _currentUser!.profileImageUrl,
        isEmailVerified: _currentUser!.isEmailVerified,
        isPhoneVerified: _currentUser!.isPhoneVerified,
        createdAt: _currentUser!.createdAt,
        updatedAt: DateTime.now(),
      );

      _currentUser = updatedUser;
      emit(AuthUserUpdated(user: updatedUser));
    } else {
      emit(const AuthError(message: 'No user to update'));
    }
  }

  // Change password
  Future<void> _onAuthPasswordChangeRequested(
    AuthPasswordChangeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthPasswordChangeLoading());

    // This would typically call an API endpoint
    // For now, just simulate success
    await Future.delayed(const Duration(seconds: 1));
    emit(const AuthPasswordChanged());
  }

  // Check biometric availability
  Future<void> _onAuthBiometricCheckRequested(
    AuthBiometricCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthBiometricLoading());

    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      emit(AuthBiometricAvailable(
        isAvailable: isAvailable && availableBiometrics.isNotEmpty,
        isEnabled: false, // This would come from user preferences
      ));
    } catch (e) {
      emit(AuthBiometricError(message: 'Failed to check biometric availability: $e'));
    }
  }

  // Biometric login
  Future<void> _onAuthBiometricLoginRequested(
    AuthBiometricLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthBiometricLoading());

    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        // In a real app, you'd retrieve stored credentials and login
        // For now, just check if user is already authenticated
        final tokens = await _authRepository.getStoredTokens();
        if (tokens != null && _currentUser != null) {
          emit(AuthBiometricSuccess(user: _currentUser!, tokens: tokens));
        } else {
          emit(const AuthBiometricError(message: 'No stored credentials found'));
        }
      } else {
        emit(const AuthBiometricError(message: 'Biometric authentication failed'));
      }
    } catch (e) {
      emit(AuthBiometricError(message: 'Biometric authentication error: $e'));
    }
  }

  // Setup biometric
  Future<void> _onAuthBiometricSetupRequested(
    AuthBiometricSetupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthBiometricLoading());

    try {
      if (event.enable) {
        final isAuthenticated = await _localAuth.authenticate(
          localizedReason: 'Please authenticate to enable biometric login',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );

        if (isAuthenticated) {
          // Store biometric preference
          emit(const AuthBiometricSetupSuccess(isEnabled: true));
        } else {
          emit(const AuthBiometricError(message: 'Authentication required to enable biometric login'));
        }
      } else {
        // Disable biometric
        emit(const AuthBiometricSetupSuccess(isEnabled: false));
      }
    } catch (e) {
      emit(AuthBiometricError(message: 'Failed to setup biometric authentication: $e'));
    }
  }

  // Session expired
  Future<void> _onAuthSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    _tokenRefreshTimer?.cancel();
    await _authRepository.clearTokens();
    _currentUser = null;
    _currentTokens = null;
    emit(const AuthSessionExpired());
  }

  // Session refreshed
  void _onAuthSessionRefreshed(
    AuthSessionRefreshed event,
    Emitter<AuthState> emit,
  ) {
    // This would be called after a successful token refresh
    if (_currentUser != null && _currentTokens != null) {
      emit(AuthAuthenticated(
        user: _currentUser!,
        tokens: _currentTokens,
        isEmailVerified: _currentUser!.isEmailVerified ?? false,
      ));
    }
  }

  // Account deletion
  Future<void> _onAuthAccountDeletionRequested(
    AuthAccountDeletionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthAccountDeletionLoading());

    // This would typically call an API endpoint to delete the account
    // For now, just simulate the process
    await Future.delayed(const Duration(seconds: 2));

    _tokenRefreshTimer?.cancel();
    await _authRepository.clearTokens();
    _currentUser = null;
    _currentTokens = null;

    emit(const AuthAccountDeleted());
  }

  // Helper methods
  Future<void> _getUserAndEmitAuthenticated(
    Emitter<AuthState> emit,
    AuthTokens tokens,
  ) async {
    final userResult = await _authRepository.getCurrentUser();

    userResult.fold(
      (failure) {
        emit(_mapFailureToAuthError(failure));
      },
      (user) {
        _currentUser = user;
        emit(AuthAuthenticated(
          user: user,
          tokens: tokens,
          isEmailVerified: user.isEmailVerified ?? false,
        ));
      },
    );
  }

  void _scheduleTokenRefresh(AuthTokens tokens) {
    _tokenRefreshTimer?.cancel();

    if (tokens.expiresAt != null) {
      final now = DateTime.now();
      final expiresAt = tokens.expiresAt!;
      final timeUntilExpiry = expiresAt.difference(now);

      // Refresh token 5 minutes before expiry
      final refreshTime = timeUntilExpiry - const Duration(minutes: 5);

      if (refreshTime.isNegative) {
        // Token is already expired or expiring very soon, refresh immediately
        add(const AuthRefreshTokenRequested());
      } else {
        _tokenRefreshTimer = Timer(refreshTime, () {
          add(const AuthRefreshTokenRequested());
        });
      }
    }
  }

  AuthState _mapFailureToAuthError(
    Failure failure, {
    bool isLogin = false,
    bool isRegister = false,
    bool isPasswordReset = false,
    bool isEmailVerification = false,
  }) {
    final message = failure is ServerFailure
        ? failure.message
        : failure is NetworkFailure
            ? failure.message
            : failure is ValidationFailure
                ? failure.message
                : failure is AuthenticationFailure
                    ? failure.message
                    : failure is UnauthorizedFailure
                        ? failure.message
                        : 'An unexpected error occurred';

    if (isLogin) {
      return AuthLoginError(message: message);
    } else if (isRegister) {
      return AuthRegisterError(message: message);
    } else if (isPasswordReset) {
      return AuthPasswordResetError(message: message);
    } else if (isEmailVerification) {
      return AuthEmailVerificationError(message: message);
    } else if (failure is NetworkFailure) {
      return AuthNetworkError(message: message);
    } else if (failure is ValidationFailure) {
      return AuthValidationError(message: message);
    } else if (failure is UnauthorizedFailure) {
      return AuthUnauthorizedError(message: message);
    } else {
      return AuthError(message: message);
    }
  }

  // Getters for current state
  User? get currentUser => _currentUser;
  AuthTokens? get currentTokens => _currentTokens;
  bool get isAuthenticated => _currentUser != null && _currentTokens != null;
}
