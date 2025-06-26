import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/change_password.dart';
import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile _getUserProfile;
  final UpdateProfile _updateProfile;
  final ChangePassword _changePassword;

  ProfileBloc(
    this._getUserProfile,
    this._updateProfile,
    this._changePassword,
  ) : super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileRefreshRequested>(_onProfileRefreshRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileImageUploadRequested>(_onProfileImageUploadRequested);
    on<ProfileImageUpdateRequested>(_onProfileImageUpdateRequested);
    on<PasswordChangeRequested>(_onPasswordChangeRequested);
    on<EmailUpdateRequested>(_onEmailUpdateRequested);
    on<EmailVerificationRequested>(_onEmailVerificationRequested);
    on<EmailVerificationResendRequested>(_onEmailVerificationResendRequested);
    on<PhoneUpdateRequested>(_onPhoneUpdateRequested);
    on<PhoneVerificationRequested>(_onPhoneVerificationRequested);
    on<PhoneVerificationResendRequested>(_onPhoneVerificationResendRequested);
    on<NotificationSettingsLoadRequested>(_onNotificationSettingsLoadRequested);
    on<NotificationSettingsUpdateRequested>(_onNotificationSettingsUpdateRequested);
    on<SecuritySettingsLoadRequested>(_onSecuritySettingsLoadRequested);
    on<SecuritySettingsUpdateRequested>(_onSecuritySettingsUpdateRequested);
    on<TwoFactorEnableRequested>(_onTwoFactorEnableRequested);
    on<TwoFactorSetupVerificationRequested>(_onTwoFactorSetupVerificationRequested);
    on<TwoFactorDisableRequested>(_onTwoFactorDisableRequested);
    on<BiometricEnableRequested>(_onBiometricEnableRequested);
    on<BiometricDisableRequested>(_onBiometricDisableRequested);
    on<AccountDeletionRequested>(_onAccountDeletionRequested);
    on<UserDataExportRequested>(_onUserDataExportRequested);
    on<AccountActivityLoadRequested>(_onAccountActivityLoadRequested);
    on<ConnectedDevicesLoadRequested>(_onConnectedDevicesLoadRequested);
    on<DeviceRevokeRequested>(_onDeviceRevokeRequested);
    on<AllOtherSessionsRevokeRequested>(_onAllOtherSessionsRevokeRequested);
    on<ProfileErrorCleared>(_onProfileErrorCleared);
    on<ProfileStateReset>(_onProfileStateReset);
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await _getUserProfile();

    result.fold(
      (failure) {
        emit(_mapFailureToProfileError(failure));
      },
      (profile) {
        emit(ProfileLoaded(profile: profile));
      },
    );
  }

  Future<void> _onProfileRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      emit(ProfileRefreshing(currentProfile: (state as ProfileLoaded).profile));
    } else {
      emit(const ProfileLoading());
    }

    final result = await _getUserProfile();

    result.fold(
      (failure) {
        emit(_mapFailureToProfileError(failure));
      },
      (profile) {
        emit(ProfileLoaded(profile: profile));
      },
    );
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileUpdateLoading());

    final result = await _updateProfile(event.request);

    result.fold(
      (failure) {
        emit(_mapFailureToProfileUpdateError(failure));
      },
      (profile) {
        emit(ProfileUpdateSuccess(profile: profile));
        // Also update the main profile state
        emit(ProfileLoaded(profile: profile));
      },
    );
  }

  Future<void> _onProfileImageUploadRequested(
    ProfileImageUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileImageUploadLoading());

    // TODO: Implement image upload use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 2));
    
    emit(ProfileImageUploadSuccess(imageUrl: event.imagePath));
  }

  Future<void> _onProfileImageUpdateRequested(
    ProfileImageUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileImageUploadLoading());

    // TODO: Implement image update use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    emit(ProfileImageUploadSuccess(imageUrl: event.imageUrl));
  }

  Future<void> _onPasswordChangeRequested(
    PasswordChangeRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const PasswordChangeLoading());

    final params = ChangePasswordParams(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    final result = await _changePassword(params);

    result.fold(
      (failure) {
        emit(_mapFailureToPasswordChangeError(failure));
      },
      (_) {
        emit(const PasswordChangeSuccess());
      },
    );
  }

  Future<void> _onEmailUpdateRequested(
    EmailUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const EmailUpdateLoading());

    // TODO: Implement email update use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    emit(const EmailUpdateSuccess());
  }

  Future<void> _onEmailVerificationRequested(
    EmailVerificationRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const EmailVerificationLoading());

    // TODO: Implement email verification use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    emit(const EmailVerificationSuccess());
  }

  Future<void> _onEmailVerificationResendRequested(
    EmailVerificationResendRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const EmailVerificationLoading());

    // TODO: Implement email verification resend use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    emit(const EmailVerificationSuccess());
  }

  Future<void> _onPhoneUpdateRequested(
    PhoneUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const PhoneUpdateLoading());

    // TODO: Implement phone update use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    emit(const PhoneUpdateSuccess());
  }

  Future<void> _onPhoneVerificationRequested(
    PhoneVerificationRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const PhoneVerificationLoading());

    // TODO: Implement phone verification use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    emit(const PhoneVerificationSuccess());
  }

  Future<void> _onPhoneVerificationResendRequested(
    PhoneVerificationResendRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const PhoneVerificationLoading());

    // TODO: Implement phone verification resend use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    emit(const PhoneVerificationSuccess());
  }

  Future<void> _onNotificationSettingsLoadRequested(
    NotificationSettingsLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const NotificationSettingsLoading());

    // TODO: Implement notification settings load use case
    // For now, return mock settings
    await Future.delayed(const Duration(milliseconds: 500));
    
    const settings = NotificationSettings(
      notificationsEnabled: true,
      emailNotificationsEnabled: true,
      smsNotificationsEnabled: false,
      documentStatusNotifications: true,
      securityNotifications: true,
      marketingNotifications: false,
    );
    
    emit(const NotificationSettingsLoaded(settings: settings));
  }

  Future<void> _onNotificationSettingsUpdateRequested(
    NotificationSettingsUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const NotificationSettingsLoading());

    // TODO: Implement notification settings update use case
    // For now, simulate success
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(NotificationSettingsUpdateSuccess(settings: event.settings));
  }

  Future<void> _onSecuritySettingsLoadRequested(
    SecuritySettingsLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const SecuritySettingsLoading());

    // TODO: Implement security settings load use case
    // For now, return mock settings
    await Future.delayed(const Duration(milliseconds: 500));
    
    const settings = SecuritySettings(
      isTwoFactorEnabled: false,
      isBiometricEnabled: false,
      isSessionTimeoutEnabled: true,
      sessionTimeoutMinutes: 30,
      requirePasswordForSensitiveActions: true,
    );
    
    emit(const SecuritySettingsLoaded(settings: settings));
  }

  Future<void> _onSecuritySettingsUpdateRequested(
    SecuritySettingsUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const SecuritySettingsLoading());

    // TODO: Implement security settings update use case
    // For now, simulate success
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(SecuritySettingsUpdateSuccess(settings: event.settings));
  }

  Future<void> _onTwoFactorEnableRequested(
    TwoFactorEnableRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const TwoFactorSetupLoading());

    // TODO: Implement two factor enable use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    const qrCodeUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=otpauth://totp/N-Docs:user@example.com?secret=JBSWY3DPEHPK3PXP&issuer=N-Docs';
    
    emit(const TwoFactorSetupInitiated(qrCodeUrl: qrCodeUrl));
  }

  Future<void> _onTwoFactorSetupVerificationRequested(
    TwoFactorSetupVerificationRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const TwoFactorSetupLoading());

    // TODO: Implement two factor verification use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    const backupCodes = [
      'ABCD-EFGH-IJKL-MNOP',
      'QRST-UVWX-YZAB-CDEF',
      'GHIJ-KLMN-OPQR-STUV',
      'WXYZ-ABCD-EFGH-IJKL',
      'MNOP-QRST-UVWX-YZAB',
    ];
    
    emit(const TwoFactorSetupSuccess(backupCodes: backupCodes));
  }

  Future<void> _onTwoFactorDisableRequested(
    TwoFactorDisableRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const TwoFactorSetupLoading());

    // TODO: Implement two factor disable use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    emit(const TwoFactorDisableSuccess());
  }

  Future<void> _onBiometricEnableRequested(
    BiometricEnableRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const BiometricSetupLoading());

    // TODO: Implement biometric enable use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    emit(const BiometricSetupSuccess(isEnabled: true));
  }

  Future<void> _onBiometricDisableRequested(
    BiometricDisableRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const BiometricSetupLoading());

    // TODO: Implement biometric disable use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    emit(const BiometricSetupSuccess(isEnabled: false));
  }

  Future<void> _onAccountDeletionRequested(
    AccountDeletionRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const AccountDeletionLoading());

    // TODO: Implement account deletion use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 2));
    
    emit(const AccountDeletionSuccess());
  }

  Future<void> _onUserDataExportRequested(
    UserDataExportRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const UserDataExportLoading());

    // TODO: Implement user data export use case
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 3));
    
    final userData = {
      'profile': {},
      'documents': [],
      'settings': {},
      'exportDate': DateTime.now().toIso8601String(),
    };
    
    emit(UserDataExportSuccess(userData: userData));
  }

  Future<void> _onAccountActivityLoadRequested(
    AccountActivityLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const AccountActivityLoading());

    // TODO: Implement account activity load use case
    // For now, return empty list
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(const AccountActivityLoaded(activities: []));
  }

  Future<void> _onConnectedDevicesLoadRequested(
    ConnectedDevicesLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ConnectedDevicesLoading());

    // TODO: Implement connected devices load use case
    // For now, return empty list
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(const ConnectedDevicesLoaded(devices: []));
  }

  Future<void> _onDeviceRevokeRequested(
    DeviceRevokeRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // TODO: Implement device revoke use case
    // For now, simulate success
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(DeviceRevokeSuccess(deviceId: event.deviceId));
  }

  Future<void> _onAllOtherSessionsRevokeRequested(
    AllOtherSessionsRevokeRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // TODO: Implement all other sessions revoke use case
    // For now, simulate success
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(const AllOtherSessionsRevokeSuccess());
  }

  void _onProfileErrorCleared(
    ProfileErrorCleared event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileError) {
      emit(const ProfileInitial());
    }
  }

  void _onProfileStateReset(
    ProfileStateReset event,
    Emitter<ProfileState> emit,
  ) {
    emit(const ProfileInitial());
  }

  ProfileState _mapFailureToProfileError(Failure failure) {
    final message = failure is ServerFailure
        ? failure.message
        : failure is NetworkFailure
            ? failure.message
            : failure is UnauthorizedFailure
                ? failure.message
                : failure is CacheFailure
                    ? failure.message
                    : 'An unexpected error occurred';

    return ProfileError(message: message);
  }

  ProfileState _mapFailureToProfileUpdateError(Failure failure) {
    final message = failure is ServerFailure
        ? failure.message
        : failure is NetworkFailure
            ? failure.message
            : failure is ValidationFailure
                ? failure.message
            : failure is UnauthorizedFailure
                ? failure.message
                : 'Failed to update profile';

    return ProfileUpdateError(message: message);
  }

  ProfileState _mapFailureToPasswordChangeError(Failure failure) {
    final message = failure is ServerFailure
        ? failure.message
        : failure is NetworkFailure
            ? failure.message
            : failure is ValidationFailure
                ? failure.message
            : failure is UnauthorizedFailure
                ? failure.message
                : 'Failed to change password';

    return PasswordChangeError(message: message);
  }
}
