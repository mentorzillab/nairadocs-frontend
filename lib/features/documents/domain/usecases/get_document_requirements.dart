import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/document.dart';
import '../repositories/documents_repository.dart';

@injectable
class GetDocumentRequirements implements UseCase<Map<String, dynamic>, DocumentType> {
  final DocumentsRepository repository;

  GetDocumentRequirements(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(DocumentType type) async {
    return await repository.getDocumentRequirements(type);
  }
}
