import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/document.dart';
import '../repositories/documents_repository.dart';

class ValidateDocumentNumberParams {
  final DocumentType type;
  final String documentNumber;

  const ValidateDocumentNumberParams({
    required this.type,
    required this.documentNumber,
  });
}

@injectable
class ValidateDocumentNumber implements UseCase<bool, ValidateDocumentNumberParams> {
  final DocumentsRepository repository;

  ValidateDocumentNumber(this.repository);

  @override
  Future<Either<Failure, bool>> call(ValidateDocumentNumberParams params) async {
    if (params.documentNumber.trim().isEmpty) {
      return const Left(ValidationFailure('Document number is required'));
    }

    return await repository.validateDocumentNumber(params.type, params.documentNumber);
  }
}
