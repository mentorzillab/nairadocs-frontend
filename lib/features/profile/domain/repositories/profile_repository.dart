import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  /// Get current user profile
  Future<Either<Failure, UserProfile>> getUserProfile();

  /// Update user profile
  Future<Either<Failure, UserProfile>> updateProfile(ProfileUpdateRequest request);

  /// Upload profile image
  Future<Either<Failure, String>> uploadProfileImage(String imagePath);

  /// Update profile image
  Future<Either<Failure, UserProfile>> updateProfileImage(String imageUrl);

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Update email
  Future<Either<Failure, void>> updateEmail(String newEmail);

  /// Verify email with token
  Future<Either<Failure, void>> verifyEmail(String token);

  /// Resend email verification
  Future<Either<Failure, void>> resendEmailVerification();

  /// Update phone number
  Future<Either<Failure, void>> updatePhoneNumber(String phoneNumber);

  /// Verify phone number with OTP
  Future<Either<Failure, void>> verifyPhoneNumber(String otp);

  /// Resend phone verification OTP
  Future<Either<Failure, void>> resendPhoneVerification();

  /// Update notification settings
  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(
    NotificationSettings settings,
  );

  /// Get notification settings
  Future<Either<Failure, NotificationSettings>> getNotificationSettings();

  /// Update security settings
  Future<Either<Failure, SecuritySettings>> updateSecuritySettings(
    SecuritySettings settings,
  );

  /// Get security settings
  Future<Either<Failure, SecuritySettings>> getSecuritySettings();

  /// Enable two-factor authentication
  Future<Either<Failure, String>> enableTwoFactor();

  /// Verify two-factor setup with code
  Future<Either<Failure, List<String>>> verifyTwoFactorSetup(String code);

  /// Disable two-factor authentication
  Future<Either<Failure, void>> disableTwoFactor(String password);

  /// Enable biometric authentication
  Future<Either<Failure, void>> enableBiometric();

  /// Disable biometric authentication
  Future<Either<Failure, void>> disableBiometric();

  /// Delete account
  Future<Either<Failure, void>> deleteAccount(String password);

  /// Export user data
  Future<Either<Failure, Map<String, dynamic>>> exportUserData();

  /// Get account activity log
  Future<Either<Failure, List<Map<String, dynamic>>>> getAccountActivity({
    int? limit,
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Get connected devices/sessions
  Future<Either<Failure, List<Map<String, dynamic>>>> getConnectedDevices();

  /// Revoke device/session
  Future<Either<Failure, void>> revokeDevice(String deviceId);

  /// Revoke all other sessions
  Future<Either<Failure, void>> revokeAllOtherSessions();
}
