import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/document.dart';
import '../repositories/documents_repository.dart';

class UpdateDocumentParams {
  final String documentId;
  final Map<String, dynamic> updates;

  const UpdateDocumentParams({
    required this.documentId,
    required this.updates,
  });
}

@injectable
class UpdateDocument implements UseCase<Document, UpdateDocumentParams> {
  final DocumentsRepository repository;

  UpdateDocument(this.repository);

  @override
  Future<Either<Failure, Document>> call(UpdateDocumentParams params) async {
    // Validate the parameters
    if (params.documentId.trim().isEmpty) {
      return const Left(ValidationFailure('Document ID is required'));
    }

    if (params.updates.isEmpty) {
      return const Left(ValidationFailure('No updates provided'));
    }

    // Validate the updates
    final validationResult = _validateUpdates(params.updates);
    if (validationResult != null) {
      return Left(ValidationFailure(validationResult));
    }

    return await repository.updateDocument(params.documentId, params.updates);
  }

  String? _validateUpdates(Map<String, dynamic> updates) {
    // Check for valid update fields
    final allowedFields = {
      'firstName',
      'lastName',
      'middleName',
      'dateOfBirth',
      'gender',
      'address',
      'phoneNumber',
      'email',
      'expiryDate',
      'metadata',
    };

    for (final key in updates.keys) {
      if (!allowedFields.contains(key)) {
        return 'Invalid field: $key';
      }
    }

    // Validate specific fields if present
    if (updates.containsKey('firstName')) {
      final firstName = updates['firstName'] as String?;
      if (firstName != null && firstName.trim().isEmpty) {
        return 'First name cannot be empty';
      }
    }

    if (updates.containsKey('lastName')) {
      final lastName = updates['lastName'] as String?;
      if (lastName != null && lastName.trim().isEmpty) {
        return 'Last name cannot be empty';
      }
    }

    if (updates.containsKey('email')) {
      final email = updates['email'] as String?;
      if (email != null && email.isNotEmpty) {
        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        if (!emailRegex.hasMatch(email)) {
          return 'Invalid email format';
        }
      }
    }

    if (updates.containsKey('phoneNumber')) {
      final phoneNumber = updates['phoneNumber'] as String?;
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
        if (digitsOnly.length < 10 || digitsOnly.length > 13) {
          return 'Invalid phone number format';
        }
      }
    }

    if (updates.containsKey('dateOfBirth')) {
      final dateOfBirth = updates['dateOfBirth'];
      if (dateOfBirth != null) {
        try {
          if (dateOfBirth is String) {
            final date = DateTime.parse(dateOfBirth);
            if (date.isAfter(DateTime.now())) {
              return 'Date of birth cannot be in the future';
            }
          }
        } catch (e) {
          return 'Invalid date of birth format';
        }
      }
    }

    if (updates.containsKey('expiryDate')) {
      final expiryDate = updates['expiryDate'];
      if (expiryDate != null) {
        try {
          if (expiryDate is String) {
            final date = DateTime.parse(expiryDate);
            if (date.isBefore(DateTime.now())) {
              return 'Expiry date cannot be in the past';
            }
          }
        } catch (e) {
          return 'Invalid expiry date format';
        }
      }
    }

    return null;
  }
}
