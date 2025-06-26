import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String role;
  final bool? isEmailVerified;
  final bool? isPhoneVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    this.role = 'user',
    this.isEmailVerified,
    this.isPhoneVerified,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  String get initials => '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        phoneNumber,
        profileImageUrl,
        role,
        isEmailVerified,
        isPhoneVerified,
        createdAt,
        updatedAt,
      ];
}
