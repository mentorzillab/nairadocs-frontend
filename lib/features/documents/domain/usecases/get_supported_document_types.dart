import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/document.dart';
import '../repositories/documents_repository.dart';

@injectable
class GetSupportedDocumentTypes implements UseCaseNoParams<List<DocumentType>> {
  final DocumentsRepository repository;

  GetSupportedDocumentTypes(this.repository);

  @override
  Future<Either<Failure, List<DocumentType>>> call() async {
    return await repository.getSupportedDocumentTypes();
  }
}
