// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
      sessionTimeoutMinutes: json['sessionTimeoutMinutes'] as int? ?? 30,
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
