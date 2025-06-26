import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/document.dart';
import '../repositories/documents_repository.dart';

class ResubmitDocumentParams {
  final String documentId;
  final DocumentUploadRequest request;

  const ResubmitDocumentParams({
    required this.documentId,
    required this.request,
  });
}

@injectable
class ResubmitDocument implements UseCase<Document, ResubmitDocumentParams> {
  final DocumentsRepository repository;

  ResubmitDocument(this.repository);

  @override
  Future<Either<Failure, Document>> call(ResubmitDocumentParams params) async {
    // Validate the parameters
    if (params.documentId.trim().isEmpty) {
      return const Left(ValidationFailure('Document ID is required'));
    }

    // Validate the request
    final validationResult = _validateRequest(params.request);
    if (validationResult != null) {
      return Left(ValidationFailure(validationResult));
    }

    return await repository.resubmitDocument(params.documentId, params.request);
  }

  String? _validateRequest(DocumentUploadRequest request) {
    // Validate document number
    if (request.documentNumber.trim().isEmpty) {
      return 'Document number is required';
    }

    // Validate file paths
    if (request.filePaths.isEmpty) {
      return 'At least one document file is required';
    }

    // Type-specific validations
    switch (request.type) {
      case DocumentType.nin:
        if (request.documentNumber.replaceAll(RegExp(r'[^\d]'), '').length != 11) {
          return 'NIN must be exactly 11 digits';
        }
        break;
      case DocumentType.bvn:
        if (request.documentNumber.replaceAll(RegExp(r'[^\d]'), '').length != 11) {
          return 'BVN must be exactly 11 digits';
        }
        break;
      case DocumentType.driversLicense:
        if (request.documentNumber.trim().length < 5) {
          return 'Driver\'s license number must be at least 5 characters long';
        }
        break;
      case DocumentType.passport:
        if (request.documentNumber.trim().length < 6) {
          return 'Passport number must be at least 6 characters long';
        }
        break;
      default:
        if (request.documentNumber.trim().length < 3) {
          return 'Document number must be at least 3 characters';
        }
    }

    // Validate required fields for certain document types
    if (request.type == DocumentType.nin || request.type == DocumentType.bvn) {
      if (request.firstName == null || request.firstName!.trim().isEmpty) {
        return 'First name is required for ${request.type.displayName}';
      }
      if (request.lastName == null || request.lastName!.trim().isEmpty) {
        return 'Last name is required for ${request.type.displayName}';
      }
      if (request.dateOfBirth == null) {
        return 'Date of birth is required for ${request.type.displayName}';
      }
    }

    return null;
  }
}
