import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
}

@injectable
class ChangePassword implements UseCase<void, ChangePasswordParams> {
  final ProfileRepository repository;

  ChangePassword(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    // Validate passwords
    final validationResult = _validatePasswords(params);
    if (validationResult != null) {
      return Left(ValidationFailure(validationResult));
    }

    return await repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }

  String? _validatePasswords(ChangePasswordParams params) {
    // Check if current password is provided
    if (params.currentPassword.trim().isEmpty) {
      return 'Current password is required';
    }

    // Check if new password is provided
    if (params.newPassword.trim().isEmpty) {
      return 'New password is required';
    }

    // Check if passwords are different
    if (params.currentPassword == params.newPassword) {
      return 'New password must be different from current password';
    }

    // Validate new password strength
    if (params.newPassword.length < 8) {
      return 'New password must be at least 8 characters long';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(params.newPassword)) {
      return 'New password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(params.newPassword)) {
      return 'New password must contain at least one lowercase letter';
    }

    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(params.newPassword)) {
      return 'New password must contain at least one number';
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(params.newPassword)) {
      return 'New password must contain at least one special character';
    }

    return null;
  }
}
