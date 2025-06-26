import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/documents_repository.dart';

@injectable
class DownloadDocumentFiles implements UseCase<List<String>, String> {
  final DocumentsRepository repository;

  DownloadDocumentFiles(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(String documentId) async {
    if (documentId.trim().isEmpty) {
      return const Left(ValidationFailure('Document ID is required'));
    }

    return await repository.downloadDocumentFiles(documentId);
  }
}
