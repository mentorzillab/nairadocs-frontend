import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/document.dart';
import '../repositories/documents_repository.dart';

@injectable
class CheckVerificationStatus implements UseCase<Document, String> {
  final DocumentsRepository repository;

  CheckVerificationStatus(this.repository);

  @override
  Future<Either<Failure, Document>> call(String documentId) async {
    if (documentId.trim().isEmpty) {
      return const Left(ValidationFailure('Document ID is required'));
    }

    return await repository.checkVerificationStatus(documentId);
  }
}
