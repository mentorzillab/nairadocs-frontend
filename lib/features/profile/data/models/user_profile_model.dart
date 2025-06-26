import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.middleName,
    super.phoneNumber,
    super.profileImageUrl,
    super.address,
    super.city,
    super.state,
    super.country,
    super.postalCode,
    super.dateOfBirth,
    super.gender,
    super.occupation,
    required super.isEmailVerified,
    required super.isPhoneVerified,
    super.isTwoFactorEnabled,
    super.isBiometricEnabled,
    super.preferredLanguage,
    super.timezone,
    super.notificationsEnabled,
    super.emailNotificationsEnabled,
    super.smsNotificationsEnabled,
    required super.createdAt,
    required super.updatedAt,
    super.metadata,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
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
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      occupation: json['occupation'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      isTwoFactorEnabled: json['isTwoFactorEnabled'] as bool? ?? false,
      isBiometricEnabled: json['isBiometricEnabled'] as bool? ?? false,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      timezone: json['timezone'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      emailNotificationsEnabled: json['emailNotificationsEnabled'] as bool? ?? true,
      smsNotificationsEnabled: json['smsNotificationsEnabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'occupation': occupation,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'isTwoFactorEnabled': isTwoFactorEnabled,
      'isBiometricEnabled': isBiometricEnabled,
      'preferredLanguage': preferredLanguage,
      'timezone': timezone,
      'notificationsEnabled': notificationsEnabled,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'smsNotificationsEnabled': smsNotificationsEnabled,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      id: profile.id,
      email: profile.email,
      firstName: profile.firstName,
      lastName: profile.lastName,
      middleName: profile.middleName,
      phoneNumber: profile.phoneNumber,
      profileImageUrl: profile.profileImageUrl,
      address: profile.address,
      city: profile.city,
      state: profile.state,
      country: profile.country,
      postalCode: profile.postalCode,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      occupation: profile.occupation,
      isEmailVerified: profile.isEmailVerified,
      isPhoneVerified: profile.isPhoneVerified,
      isTwoFactorEnabled: profile.isTwoFactorEnabled,
      isBiometricEnabled: profile.isBiometricEnabled,
      preferredLanguage: profile.preferredLanguage,
      timezone: profile.timezone,
      notificationsEnabled: profile.notificationsEnabled,
      emailNotificationsEnabled: profile.emailNotificationsEnabled,
      smsNotificationsEnabled: profile.smsNotificationsEnabled,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
      metadata: profile.metadata,
    );
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      middleName: middleName,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      address: address,
      city: city,
      state: state,
      country: country,
      postalCode: postalCode,
      dateOfBirth: dateOfBirth,
      gender: gender,
      occupation: occupation,
      isEmailVerified: isEmailVerified,
      isPhoneVerified: isPhoneVerified,
      isTwoFactorEnabled: isTwoFactorEnabled,
      isBiometricEnabled: isBiometricEnabled,
      preferredLanguage: preferredLanguage,
      timezone: timezone,
      notificationsEnabled: notificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled,
      smsNotificationsEnabled: smsNotificationsEnabled,
      createdAt: createdAt,
      updatedAt: updatedAt,
      metadata: metadata,
    );
  }
}

@JsonSerializable()
class ProfileUpdateRequestModel {
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? dateOfBirth;
  final String? gender;
  final String? occupation;
  final String? preferredLanguage;
  final String? timezone;

  const ProfileUpdateRequestModel({
    this.firstName,
    this.lastName,
    this.middleName,
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.dateOfBirth,
    this.gender,
    this.occupation,
    this.preferredLanguage,
    this.timezone,
  });

  factory ProfileUpdateRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileUpdateRequestModelToJson(this);

  factory ProfileUpdateRequestModel.fromEntity(ProfileUpdateRequest request) {
    return ProfileUpdateRequestModel(
      firstName: request.firstName,
      lastName: request.lastName,
      middleName: request.middleName,
      phoneNumber: request.phoneNumber,
      address: request.address,
      city: request.city,
      state: request.state,
      country: request.country,
      postalCode: request.postalCode,
      dateOfBirth: request.dateOfBirth?.toIso8601String(),
      gender: request.gender,
      occupation: request.occupation,
      preferredLanguage: request.preferredLanguage,
      timezone: request.timezone,
    );
  }
}

@JsonSerializable()
class NotificationSettingsModel extends NotificationSettings {
  const NotificationSettingsModel({
    required super.notificationsEnabled,
    required super.emailNotificationsEnabled,
    required super.smsNotificationsEnabled,
    super.documentStatusNotifications,
    super.securityNotifications,
    super.marketingNotifications,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsModelToJson(this);

  NotificationSettings toEntity() {
    return NotificationSettings(
      notificationsEnabled: notificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled,
      smsNotificationsEnabled: smsNotificationsEnabled,
      documentStatusNotifications: documentStatusNotifications,
      securityNotifications: securityNotifications,
      marketingNotifications: marketingNotifications,
    );
  }
}

@JsonSerializable()
class SecuritySettingsModel extends SecuritySettings {
  const SecuritySettingsModel({
    required super.isTwoFactorEnabled,
    required super.isBiometricEnabled,
    super.isSessionTimeoutEnabled,
    super.sessionTimeoutMinutes,
    super.requirePasswordForSensitiveActions,
  });

  factory SecuritySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SecuritySettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SecuritySettingsModelToJson(this);

  SecuritySettings toEntity() {
    return SecuritySettings(
      isTwoFactorEnabled: isTwoFactorEnabled,
      isBiometricEnabled: isBiometricEnabled,
      isSessionTimeoutEnabled: isSessionTimeoutEnabled,
      sessionTimeoutMinutes: sessionTimeoutMinutes,
      requirePasswordForSensitiveActions: requirePasswordForSensitiveActions,
    );
  }
}
