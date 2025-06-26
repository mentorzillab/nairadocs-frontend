import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

@injectable
class UpdateProfile implements UseCase<UserProfile, ProfileUpdateRequest> {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(ProfileUpdateRequest params) async {
    // Validate the request
    final validationResult = _validateRequest(params);
    if (validationResult != null) {
      return Left(ValidationFailure(validationResult));
    }

    return await repository.updateProfile(params);
  }

  String? _validateRequest(ProfileUpdateRequest request) {
    // Validate first name
    if (request.firstName != null && request.firstName!.trim().isEmpty) {
      return 'First name cannot be empty';
    }

    // Validate last name
    if (request.lastName != null && request.lastName!.trim().isEmpty) {
      return 'Last name cannot be empty';
    }

    // Validate phone number
    if (request.phoneNumber != null && request.phoneNumber!.isNotEmpty) {
      final digitsOnly = request.phoneNumber!.replaceAll(RegExp(r'[^\d]'), '');
      if (digitsOnly.length < 10 || digitsOnly.length > 13) {
        return 'Invalid phone number format';
      }
    }

    // Validate date of birth
    if (request.dateOfBirth != null) {
      final now = DateTime.now();
      final age = now.difference(request.dateOfBirth!).inDays / 365;
      
      if (request.dateOfBirth!.isAfter(now)) {
        return 'Date of birth cannot be in the future';
      }
      
      if (age < 13) {
        return 'You must be at least 13 years old';
      }
      
      if (age > 120) {
        return 'Invalid date of birth';
      }
    }

    // Validate gender
    if (request.gender != null && request.gender!.isNotEmpty) {
      final validGenders = ['male', 'female', 'other', 'prefer not to say'];
      if (!validGenders.contains(request.gender!.toLowerCase())) {
        return 'Invalid gender selection';
      }
    }

    return null;
  }
}
