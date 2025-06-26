import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? occupation;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isTwoFactorEnabled;
  final bool isBiometricEnabled;
  final String? preferredLanguage;
  final String? timezone;
  final bool notificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool smsNotificationsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const UserProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.phoneNumber,
    this.profileImageUrl,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.dateOfBirth,
    this.gender,
    this.occupation,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    this.isTwoFactorEnabled = false,
    this.isBiometricEnabled = false,
    this.preferredLanguage = 'en',
    this.timezone,
    this.notificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.smsNotificationsEnabled = true,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  String get fullName {
    final parts = [firstName, middleName, lastName]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    return parts.join(' ');
  }

  String get initials {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  String get displayName => fullName.isNotEmpty ? fullName : email;

  bool get hasCompleteProfile {
    return firstName.isNotEmpty &&
           lastName.isNotEmpty &&
           phoneNumber != null &&
           phoneNumber!.isNotEmpty &&
           dateOfBirth != null;
  }

  String get fullAddress {
    final addressParts = [address, city, state, country, postalCode]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    return addressParts.join(', ');
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? middleName,
    String? phoneNumber,
    String? profileImageUrl,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    DateTime? dateOfBirth,
    String? gender,
    String? occupation,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isTwoFactorEnabled,
    bool? isBiometricEnabled,
    String? preferredLanguage,
    String? timezone,
    bool? notificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? smsNotificationsEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      timezone: timezone ?? this.timezone,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      smsNotificationsEnabled: smsNotificationsEnabled ?? this.smsNotificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        middleName,
        phoneNumber,
        profileImageUrl,
        address,
        city,
        state,
        country,
        postalCode,
        dateOfBirth,
        gender,
        occupation,
        isEmailVerified,
        isPhoneVerified,
        isTwoFactorEnabled,
        isBiometricEnabled,
        preferredLanguage,
        timezone,
        notificationsEnabled,
        emailNotificationsEnabled,
        smsNotificationsEnabled,
        createdAt,
        updatedAt,
        metadata,
      ];
}

class ProfileUpdateRequest extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? occupation;
  final String? preferredLanguage;
  final String? timezone;

  const ProfileUpdateRequest({
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

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        middleName,
        phoneNumber,
        address,
        city,
        state,
        country,
        postalCode,
        dateOfBirth,
        gender,
        occupation,
        preferredLanguage,
        timezone,
      ];
}

class NotificationSettings extends Equatable {
  final bool notificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool smsNotificationsEnabled;
  final bool documentStatusNotifications;
  final bool securityNotifications;
  final bool marketingNotifications;

  const NotificationSettings({
    required this.notificationsEnabled,
    required this.emailNotificationsEnabled,
    required this.smsNotificationsEnabled,
    this.documentStatusNotifications = true,
    this.securityNotifications = true,
    this.marketingNotifications = false,
  });

  @override
  List<Object> get props => [
        notificationsEnabled,
        emailNotificationsEnabled,
        smsNotificationsEnabled,
        documentStatusNotifications,
        securityNotifications,
        marketingNotifications,
      ];
}

class SecuritySettings extends Equatable {
  final bool isTwoFactorEnabled;
  final bool isBiometricEnabled;
  final bool isSessionTimeoutEnabled;
  final int sessionTimeoutMinutes;
  final bool requirePasswordForSensitiveActions;

  const SecuritySettings({
    required this.isTwoFactorEnabled,
    required this.isBiometricEnabled,
    this.isSessionTimeoutEnabled = true,
    this.sessionTimeoutMinutes = 30,
    this.requirePasswordForSensitiveActions = true,
  });

  @override
  List<Object> get props => [
        isTwoFactorEnabled,
        isBiometricEnabled,
        isSessionTimeoutEnabled,
        sessionTimeoutMinutes,
        requirePasswordForSensitiveActions,
      ];
}
