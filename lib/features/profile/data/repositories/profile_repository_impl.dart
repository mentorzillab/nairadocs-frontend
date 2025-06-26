import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_profile_model.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.getUserProfile();
        await localDataSource.cacheProfile(remoteProfile);
        return Right(remoteProfile.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      try {
        final localProfile = await localDataSource.getCachedProfile();
        if (localProfile != null) {
          return Right(localProfile.toEntity());
        } else {
          return const Left(CacheFailure(message: 'No cached profile available'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(ProfileUpdateRequest request) async {
    if (await networkInfo.isConnected) {
      try {
        final requestModel = ProfileUpdateRequestModel.fromEntity(request);
        final updatedProfile = await remoteDataSource.updateProfile(requestModel);
        await localDataSource.cacheProfile(updatedProfile);
        return Right(updatedProfile.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(String imagePath) async {
    if (await networkInfo.isConnected) {
      try {
        final imageUrl = await remoteDataSource.uploadProfileImage(imagePath);
        return Right(imageUrl);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfileImage(String imageUrl) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedProfile = await remoteDataSource.updateProfileImage(imageUrl);
        await localDataSource.cacheProfile(updatedProfile);
        return Right(updatedProfile.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmail(String newEmail) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateEmail(newEmail);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.verifyEmail(token);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resendEmailVerification() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resendEmailVerification();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePhoneNumber(String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updatePhoneNumber(phoneNumber);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyPhoneNumber(String otp) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.verifyPhoneNumber(otp);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resendPhoneVerification() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resendPhoneVerification();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(
    NotificationSettings settings,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final settingsModel = NotificationSettingsModel(
          notificationsEnabled: settings.notificationsEnabled,
          emailNotificationsEnabled: settings.emailNotificationsEnabled,
          smsNotificationsEnabled: settings.smsNotificationsEnabled,
          documentStatusNotifications: settings.documentStatusNotifications,
          securityNotifications: settings.securityNotifications,
          marketingNotifications: settings.marketingNotifications,
        );
        
        final updatedSettings = await remoteDataSource.updateNotificationSettings(settingsModel);
        await localDataSource.cacheNotificationSettings(updatedSettings);
        return Right(updatedSettings.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> getNotificationSettings() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSettings = await remoteDataSource.getNotificationSettings();
        await localDataSource.cacheNotificationSettings(remoteSettings);
        return Right(remoteSettings.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      try {
        final localSettings = await localDataSource.getCachedNotificationSettings();
        if (localSettings != null) {
          return Right(localSettings.toEntity());
        } else {
          return const Left(CacheFailure(message: 'No cached notification settings available'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, SecuritySettings>> updateSecuritySettings(
    SecuritySettings settings,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final settingsModel = SecuritySettingsModel(
          isTwoFactorEnabled: settings.isTwoFactorEnabled,
          isBiometricEnabled: settings.isBiometricEnabled,
          isSessionTimeoutEnabled: settings.isSessionTimeoutEnabled,
          sessionTimeoutMinutes: settings.sessionTimeoutMinutes,
          requirePasswordForSensitiveActions: settings.requirePasswordForSensitiveActions,
        );
        
        final updatedSettings = await remoteDataSource.updateSecuritySettings(settingsModel);
        await localDataSource.cacheSecuritySettings(updatedSettings);
        return Right(updatedSettings.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, SecuritySettings>> getSecuritySettings() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSettings = await remoteDataSource.getSecuritySettings();
        await localDataSource.cacheSecuritySettings(remoteSettings);
        return Right(remoteSettings.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      try {
        final localSettings = await localDataSource.getCachedSecuritySettings();
        if (localSettings != null) {
          return Right(localSettings.toEntity());
        } else {
          return const Left(CacheFailure(message: 'No cached security settings available'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, String>> enableTwoFactor() async {
    if (await networkInfo.isConnected) {
      try {
        final qrCodeUrl = await remoteDataSource.enableTwoFactor();
        return Right(qrCodeUrl);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> verifyTwoFactorSetup(String code) async {
    if (await networkInfo.isConnected) {
      try {
        final backupCodes = await remoteDataSource.verifyTwoFactorSetup(code);
        return Right(backupCodes);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> disableTwoFactor(String password) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.disableTwoFactor(password);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> enableBiometric() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.enableBiometric();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> disableBiometric() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.disableBiometric();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String password) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAccount(password);
        await localDataSource.clearAllCache();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> exportUserData() async {
    if (await networkInfo.isConnected) {
      try {
        final userData = await remoteDataSource.exportUserData();
        return Right(userData);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAccountActivity({
    int? limit,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final activities = await remoteDataSource.getAccountActivity(
          limit: limit,
          fromDate: fromDate,
          toDate: toDate,
        );
        return Right(activities);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getConnectedDevices() async {
    if (await networkInfo.isConnected) {
      try {
        final devices = await remoteDataSource.getConnectedDevices();
        return Right(devices);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> revokeDevice(String deviceId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.revokeDevice(deviceId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> revokeAllOtherSessions() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.revokeAllOtherSessions();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
