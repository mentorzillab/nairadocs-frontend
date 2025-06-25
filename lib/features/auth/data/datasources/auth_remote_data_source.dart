import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import '../models/auth_tokens_model.dart';
import '../models/login_request.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<AuthTokensModel> refreshTokens(String refreshToken);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> verifyEmail(String token);
  Future<void> resendEmailVerification();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        if (authResponse.success) {
          return authResponse;
        } else {
          throw ServerException(authResponse.message);
        }
      } else {
        throw ServerException('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.response?.statusCode == 401) {
        throw AuthenticationException('Invalid credentials');
      } else if (e.response?.statusCode == 422) {
        final message = e.response?.data['message'] ?? 'Validation error';
        throw ValidationException(message);
      } else {
        throw ServerException(e.message ?? 'Unknown server error');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.data);
        if (authResponse.success) {
          return authResponse;
        } else {
          throw ServerException(authResponse.message);
        }
      } else {
        throw ServerException('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.response?.statusCode == 409) {
        throw ValidationException('Email already exists');
      } else if (e.response?.statusCode == 422) {
        final message = e.response?.data['message'] ?? 'Validation error';
        throw ValidationException(message);
      } else {
        throw ServerException(e.message ?? 'Unknown server error');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('/auth/logout');
    } on DioException catch (e) {
      // Logout should succeed even if server call fails
      if (e.response?.statusCode != 401) {
        throw ServerException(e.message ?? 'Logout failed');
      }
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get('/auth/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to get user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Token expired or invalid');
      } else {
        throw ServerException(e.message ?? 'Unknown server error');
      }
    }
  }

  @override
  Future<AuthTokensModel> refreshTokens(String refreshToken) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        return AuthTokensModel.fromJson(response.data);
      } else {
        throw ServerException('Token refresh failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Refresh token expired or invalid');
      } else {
        throw ServerException(e.message ?? 'Unknown server error');
      }
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to send reset email');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await dio.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'password': newPassword,
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ValidationException('Invalid or expired reset token');
      } else {
        throw ServerException(e.message ?? 'Failed to reset password');
      }
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      await dio.post(
        '/auth/verify-email',
        data: {'token': token},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ValidationException('Invalid or expired verification token');
      } else {
        throw ServerException(e.message ?? 'Failed to verify email');
      }
    }
  }

  @override
  Future<void> resendEmailVerification() async {
    try {
      await dio.post('/auth/resend-verification');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to resend verification email');
    }
  }
}
