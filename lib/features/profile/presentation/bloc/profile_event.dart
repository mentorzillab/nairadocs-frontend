import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Load profile events
class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileRefreshRequested extends ProfileEvent {
  const ProfileRefreshRequested();
}

// Update profile events
class ProfileUpdateRequested extends ProfileEvent {
  final ProfileUpdateRequest request;

  const ProfileUpdateRequested({
    required this.request,
  });

  @override
  List<Object> get props => [request];
}

// Profile image events
class ProfileImageUploadRequested extends ProfileEvent {
  final String imagePath;

  const ProfileImageUploadRequested({
    required this.imagePath,
  });

  @override
  List<Object> get props => [imagePath];
}

class ProfileImageUpdateRequested extends ProfileEvent {
  final String imageUrl;

  const ProfileImageUpdateRequested({
    required this.imageUrl,
  });

  @override
  List<Object> get props => [imageUrl];
}

// Password events
class PasswordChangeRequested extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  const PasswordChangeRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}

// Email events
class EmailUpdateRequested extends ProfileEvent {
  final String newEmail;

  const EmailUpdateRequested({
    required this.newEmail,
  });

  @override
  List<Object> get props => [newEmail];
}

class EmailVerificationRequested extends ProfileEvent {
  final String token;

  const EmailVerificationRequested({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}

class EmailVerificationResendRequested extends ProfileEvent {
  const EmailVerificationResendRequested();
}

// Phone events
class PhoneUpdateRequested extends ProfileEvent {
  final String phoneNumber;

  const PhoneUpdateRequested({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];
}

class PhoneVerificationRequested extends ProfileEvent {
  final String otp;

  const PhoneVerificationRequested({
    required this.otp,
  });

  @override
  List<Object> get props => [otp];
}

class PhoneVerificationResendRequested extends ProfileEvent {
  const PhoneVerificationResendRequested();
}

// Settings events
class NotificationSettingsLoadRequested extends ProfileEvent {
  const NotificationSettingsLoadRequested();
}

class NotificationSettingsUpdateRequested extends ProfileEvent {
  final NotificationSettings settings;

  const NotificationSettingsUpdateRequested({
    required this.settings,
  });

  @override
  List<Object> get props => [settings];
}

class SecuritySettingsLoadRequested extends ProfileEvent {
  const SecuritySettingsLoadRequested();
}

class SecuritySettingsUpdateRequested extends ProfileEvent {
  final SecuritySettings settings;

  const SecuritySettingsUpdateRequested({
    required this.settings,
  });

  @override
  List<Object> get props => [settings];
}

// Two-factor authentication events
class TwoFactorEnableRequested extends ProfileEvent {
  const TwoFactorEnableRequested();
}

class TwoFactorSetupVerificationRequested extends ProfileEvent {
  final String code;

  const TwoFactorSetupVerificationRequested({
    required this.code,
  });

  @override
  List<Object> get props => [code];
}

class TwoFactorDisableRequested extends ProfileEvent {
  final String password;

  const TwoFactorDisableRequested({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}

// Biometric events
class BiometricEnableRequested extends ProfileEvent {
  const BiometricEnableRequested();
}

class BiometricDisableRequested extends ProfileEvent {
  const BiometricDisableRequested();
}

// Account management events
class AccountDeletionRequested extends ProfileEvent {
  final String password;

  const AccountDeletionRequested({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}

class UserDataExportRequested extends ProfileEvent {
  const UserDataExportRequested();
}

class AccountActivityLoadRequested extends ProfileEvent {
  final int? limit;
  final DateTime? fromDate;
  final DateTime? toDate;

  const AccountActivityLoadRequested({
    this.limit,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [limit, fromDate, toDate];
}

class ConnectedDevicesLoadRequested extends ProfileEvent {
  const ConnectedDevicesLoadRequested();
}

class DeviceRevokeRequested extends ProfileEvent {
  final String deviceId;

  const DeviceRevokeRequested({
    required this.deviceId,
  });

  @override
  List<Object> get props => [deviceId];
}

class AllOtherSessionsRevokeRequested extends ProfileEvent {
  const AllOtherSessionsRevokeRequested();
}

// Error handling events
class ProfileErrorCleared extends ProfileEvent {
  const ProfileErrorCleared();
}

class ProfileStateReset extends ProfileEvent {
  const ProfileStateReset();
}
