import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

// Loading states
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileRefreshing extends ProfileState {
  final UserProfile currentProfile;

  const ProfileRefreshing({
    required this.currentProfile,
  });

  @override
  List<Object> get props => [currentProfile];
}

class ProfileUpdateLoading extends ProfileState {
  const ProfileUpdateLoading();
}

class ProfileImageUploadLoading extends ProfileState {
  const ProfileImageUploadLoading();
}

class PasswordChangeLoading extends ProfileState {
  const PasswordChangeLoading();
}

class EmailUpdateLoading extends ProfileState {
  const EmailUpdateLoading();
}

class EmailVerificationLoading extends ProfileState {
  const EmailVerificationLoading();
}

class PhoneUpdateLoading extends ProfileState {
  const PhoneUpdateLoading();
}

class PhoneVerificationLoading extends ProfileState {
  const PhoneVerificationLoading();
}

class NotificationSettingsLoading extends ProfileState {
  const NotificationSettingsLoading();
}

class SecuritySettingsLoading extends ProfileState {
  const SecuritySettingsLoading();
}

class TwoFactorSetupLoading extends ProfileState {
  const TwoFactorSetupLoading();
}

class BiometricSetupLoading extends ProfileState {
  const BiometricSetupLoading();
}

class AccountDeletionLoading extends ProfileState {
  const AccountDeletionLoading();
}

class UserDataExportLoading extends ProfileState {
  const UserDataExportLoading();
}

class AccountActivityLoading extends ProfileState {
  const AccountActivityLoading();
}

class ConnectedDevicesLoading extends ProfileState {
  const ConnectedDevicesLoading();
}

// Success states
class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  final NotificationSettings? notificationSettings;
  final SecuritySettings? securitySettings;

  const ProfileLoaded({
    required this.profile,
    this.notificationSettings,
    this.securitySettings,
  });

  @override
  List<Object?> get props => [profile, notificationSettings, securitySettings];

  ProfileLoaded copyWith({
    UserProfile? profile,
    NotificationSettings? notificationSettings,
    SecuritySettings? securitySettings,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      securitySettings: securitySettings ?? this.securitySettings,
    );
  }
}

class ProfileUpdateSuccess extends ProfileState {
  final UserProfile profile;

  const ProfileUpdateSuccess({
    required this.profile,
  });

  @override
  List<Object> get props => [profile];
}

class ProfileImageUploadSuccess extends ProfileState {
  final String imageUrl;

  const ProfileImageUploadSuccess({
    required this.imageUrl,
  });

  @override
  List<Object> get props => [imageUrl];
}

class PasswordChangeSuccess extends ProfileState {
  const PasswordChangeSuccess();
}

class EmailUpdateSuccess extends ProfileState {
  const EmailUpdateSuccess();
}

class EmailVerificationSuccess extends ProfileState {
  const EmailVerificationSuccess();
}

class PhoneUpdateSuccess extends ProfileState {
  const PhoneUpdateSuccess();
}

class PhoneVerificationSuccess extends ProfileState {
  const PhoneVerificationSuccess();
}

class NotificationSettingsLoaded extends ProfileState {
  final NotificationSettings settings;

  const NotificationSettingsLoaded({
    required this.settings,
  });

  @override
  List<Object> get props => [settings];
}

class NotificationSettingsUpdateSuccess extends ProfileState {
  final NotificationSettings settings;

  const NotificationSettingsUpdateSuccess({
    required this.settings,
  });

  @override
  List<Object> get props => [settings];
}

class SecuritySettingsLoaded extends ProfileState {
  final SecuritySettings settings;

  const SecuritySettingsLoaded({
    required this.settings,
  });

  @override
  List<Object> get props => [settings];
}

class SecuritySettingsUpdateSuccess extends ProfileState {
  final SecuritySettings settings;

  const SecuritySettingsUpdateSuccess({
    required this.settings,
  });

  @override
  List<Object> get props => [settings];
}

class TwoFactorSetupInitiated extends ProfileState {
  final String qrCodeUrl;

  const TwoFactorSetupInitiated({
    required this.qrCodeUrl,
  });

  @override
  List<Object> get props => [qrCodeUrl];
}

class TwoFactorSetupSuccess extends ProfileState {
  final List<String> backupCodes;

  const TwoFactorSetupSuccess({
    required this.backupCodes,
  });

  @override
  List<Object> get props => [backupCodes];
}

class TwoFactorDisableSuccess extends ProfileState {
  const TwoFactorDisableSuccess();
}

class BiometricSetupSuccess extends ProfileState {
  final bool isEnabled;

  const BiometricSetupSuccess({
    required this.isEnabled,
  });

  @override
  List<Object> get props => [isEnabled];
}

class AccountDeletionSuccess extends ProfileState {
  const AccountDeletionSuccess();
}

class UserDataExportSuccess extends ProfileState {
  final Map<String, dynamic> userData;

  const UserDataExportSuccess({
    required this.userData,
  });

  @override
  List<Object> get props => [userData];
}

class AccountActivityLoaded extends ProfileState {
  final List<Map<String, dynamic>> activities;

  const AccountActivityLoaded({
    required this.activities,
  });

  @override
  List<Object> get props => [activities];
}

class ConnectedDevicesLoaded extends ProfileState {
  final List<Map<String, dynamic>> devices;

  const ConnectedDevicesLoaded({
    required this.devices,
  });

  @override
  List<Object> get props => [devices];
}

class DeviceRevokeSuccess extends ProfileState {
  final String deviceId;

  const DeviceRevokeSuccess({
    required this.deviceId,
  });

  @override
  List<Object> get props => [deviceId];
}

class AllOtherSessionsRevokeSuccess extends ProfileState {
  const AllOtherSessionsRevokeSuccess();
}

// Error states
class ProfileError extends ProfileState {
  final String message;
  final String? errorCode;

  const ProfileError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class ProfileUpdateError extends ProfileState {
  final String message;
  final String? errorCode;

  const ProfileUpdateError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class ProfileImageUploadError extends ProfileState {
  final String message;
  final String? errorCode;

  const ProfileImageUploadError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class PasswordChangeError extends ProfileState {
  final String message;
  final String? errorCode;

  const PasswordChangeError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class EmailUpdateError extends ProfileState {
  final String message;
  final String? errorCode;

  const EmailUpdateError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class PhoneUpdateError extends ProfileState {
  final String message;
  final String? errorCode;

  const PhoneUpdateError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class TwoFactorSetupError extends ProfileState {
  final String message;
  final String? errorCode;

  const TwoFactorSetupError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class BiometricSetupError extends ProfileState {
  final String message;
  final String? errorCode;

  const BiometricSetupError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class ProfileValidationError extends ProfileState {
  final String message;
  final Map<String, String>? fieldErrors;

  const ProfileValidationError({
    required this.message,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, fieldErrors];
}

class ProfileNetworkError extends ProfileState {
  final String message;

  const ProfileNetworkError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class ProfileUnauthorizedError extends ProfileState {
  final String message;

  const ProfileUnauthorizedError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
