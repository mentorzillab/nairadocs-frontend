import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<Either<Failure, AuthTokens>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  });

  /// Logout the current user
  Future<Either<Failure, void>> logout();

  /// Get current user information
  Future<Either<Failure, User>> getCurrentUser();

  /// Refresh authentication tokens
  Future<Either<Failure, AuthTokens>> refreshTokens();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Get stored tokens
  Future<AuthTokens?> getStoredTokens();

  /// Store tokens securely
  Future<void> storeTokens(AuthTokens tokens);

  /// Clear stored tokens
  Future<void> clearTokens();

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  /// Reset password with token
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verify email with token
  Future<Either<Failure, void>> verifyEmail(String token);

  /// Resend email verification
  Future<Either<Failure, void>> resendEmailVerification();
}
