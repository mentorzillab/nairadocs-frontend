// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String?,
      occupation: json['occupation'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool,
      isPhoneVerified: json['isPhoneVerified'] as bool,
      isTwoFactorEnabled: json['isTwoFactorEnabled'] as bool? ?? false,
      isBiometricEnabled: json['isBiometricEnabled'] as bool? ?? false,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      timezone: json['timezone'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      emailNotificationsEnabled:
          json['emailNotificationsEnabled'] as bool? ?? true,
      smsNotificationsEnabled: json['smsNotificationsEnabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'phoneNumber': instance.phoneNumber,
      'profileImageUrl': instance.profileImageUrl,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postalCode': instance.postalCode,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'occupation': instance.occupation,
      'isEmailVerified': instance.isEmailVerified,
      'isPhoneVerified': instance.isPhoneVerified,
      'isTwoFactorEnabled': instance.isTwoFactorEnabled,
      'isBiometricEnabled': instance.isBiometricEnabled,
      'preferredLanguage': instance.preferredLanguage,
      'timezone': instance.timezone,
      'notificationsEnabled': instance.notificationsEnabled,
      'emailNotificationsEnabled': instance.emailNotificationsEnabled,
      'smsNotificationsEnabled': instance.smsNotificationsEnabled,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'metadata': instance.metadata,
    };

ProfileUpdateRequestModel _$ProfileUpdateRequestModelFromJson(
        Map<String, dynamic> json) =>
    ProfileUpdateRequestModel(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      middleName: json['middleName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      occupation: json['occupation'] as String?,
      preferredLanguage: json['preferredLanguage'] as String?,
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$ProfileUpdateRequestModelToJson(
        ProfileUpdateRequestModel instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postalCode': instance.postalCode,
      'dateOfBirth': instance.dateOfBirth,
      'gender': instance.gender,
      'occupation': instance.occupation,
      'preferredLanguage': instance.preferredLanguage,
      'timezone': instance.timezone,
    };

NotificationSettingsModel _$NotificationSettingsModelFromJson(
        Map<String, dynamic> json) =>
    NotificationSettingsModel(
      notificationsEnabled: json['notificationsEnabled'] as bool,
      emailNotificationsEnabled: json['emailNotificationsEnabled'] as bool,
      smsNotificationsEnabled: json['smsNotificationsEnabled'] as bool,
      documentStatusNotifications:
          json['documentStatusNotifications'] as bool? ?? true,
      securityNotifications: json['securityNotifications'] as bool? ?? true,
      marketingNotifications: json['marketingNotifications'] as bool? ?? false,
    );

Map<String, dynamic> _$NotificationSettingsModelToJson(
        NotificationSettingsModel instance) =>
    <String, dynamic>{
      'notificationsEnabled': instance.notificationsEnabled,
      'emailNotificationsEnabled': instance.emailNotificationsEnabled,
      'smsNotificationsEnabled': instance.smsNotificationsEnabled,
      'documentStatusNotifications': instance.documentStatusNotifications,
      'securityNotifications': instance.securityNotifications,
      'marketingNotifications': instance.marketingNotifications,
    };

SecuritySettingsModel _$SecuritySettingsModelFromJson(
        Map<String, dynamic> json) =>
    SecuritySettingsModel(
      isTwoFactorEnabled: json['isTwoFactorEnabled'] as bool,
      isBiometricEnabled: json['isBiometricEnabled'] as bool,
      isSessionTimeoutEnabled: json['isSessionTimeoutEnabled'] as bool? ?? true,
      sessionTimeoutMinutes:
          (json['sessionTimeoutMinutes'] as num?)?.toInt() ?? 30,
      requirePasswordForSensitiveActions:
          json['requirePasswordForSensitiveActions'] as bool? ?? true,
    );

Map<String, dynamic> _$SecuritySettingsModelToJson(
        SecuritySettingsModel instance) =>
    <String, dynamic>{
      'isTwoFactorEnabled': instance.isTwoFactorEnabled,
      'isBiometricEnabled': instance.isBiometricEnabled,
      'isSessionTimeoutEnabled': instance.isSessionTimeoutEnabled,
      'sessionTimeoutMinutes': instance.sessionTimeoutMinutes,
      'requirePasswordForSensitiveActions':
          instance.requirePasswordForSensitiveActions,
    };
