import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/login_request.dart';
import '../models/auth_tokens_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await remoteDataSource.login(request);
      
      // Store tokens and user data locally
      await localDataSource.storeTokens(response.data.tokens);
      await localDataSource.storeUser(response.data.user);

      return Right(response.data.tokens.toEntity());
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );
      final response = await remoteDataSource.register(request);
      
      // Store tokens and user data locally
      await localDataSource.storeTokens(response.data.tokens);
      await localDataSource.storeUser(response.data.user);

      return Right(response.data.tokens.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Try to logout from server first
      await remoteDataSource.logout();
      
      // Clear local data regardless of server response
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
      
      return const Right(null);
    } on ServerException catch (e) {
      // Still clear local data even if server logout fails
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
      return Left(ServerFailure(e.message));
    } catch (e) {
      // Still clear local data even if unexpected error occurs
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Try to get user from local storage first
      final localUser = await localDataSource.getStoredUser();
      if (localUser != null) {
        return Right(localUser.toEntity());
      }
      
      // If not found locally, fetch from server
      final remoteUser = await remoteDataSource.getCurrentUser();
      await localDataSource.storeUser(remoteUser);
      
      return Right(remoteUser.toEntity());
    } on UnauthorizedException catch (e) {
      // Clear local data if unauthorized
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshTokens() async {
    try {
      final storedTokens = await localDataSource.getStoredTokens();
      if (storedTokens == null) {
        return const Left(UnauthorizedFailure('No refresh token available'));
      }
      
      final newTokens = await remoteDataSource.refreshTokens(storedTokens.refreshToken);
      await localDataSource.storeTokens(newTokens);
      
      return Right(newTokens.toEntity());
    } on UnauthorizedException catch (e) {
      // Clear local data if refresh token is invalid
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return await localDataSource.isAuthenticated();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthTokens?> getStoredTokens() async {
    try {
      final tokens = await localDataSource.getStoredTokens();
      return tokens?.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> storeTokens(AuthTokens tokens) async {
    final tokensModel = AuthTokensModel.fromEntity(tokens);
    await localDataSource.storeTokens(tokensModel);
  }

  @override
  Future<void> clearTokens() async {
    await localDataSource.clearTokens();
    await localDataSource.clearUser();
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(token, newPassword);
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    try {
      await remoteDataSource.verifyEmail(token);
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resendEmailVerification() async {
    try {
      await remoteDataSource.resendEmailVerification();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
