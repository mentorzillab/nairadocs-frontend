import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/document.dart';
import '../repositories/documents_repository.dart';

@injectable
class GetUserDocuments implements UseCaseNoParams<List<Document>> {
  final DocumentsRepository repository;

  GetUserDocuments(this.repository);

  @override
  Future<Either<Failure, List<Document>>> call() async {
    return await repository.getUserDocuments();
  }
}

@injectable
class GetDocumentById implements UseCase<Document, String> {
  final DocumentsRepository repository;

  GetDocumentById(this.repository);

  @override
  Future<Either<Failure, Document>> call(String documentId) async {
    if (documentId.trim().isEmpty) {
      return const Left(ValidationFailure('Document ID is required'));
    }
    return await repository.getDocumentById(documentId);
  }
}

@injectable
class GetDocumentStats implements UseCaseNoParams<DocumentStats> {
  final DocumentsRepository repository;

  GetDocumentStats(this.repository);

  @override
  Future<Either<Failure, DocumentStats>> call() async {
    return await repository.getDocumentStats();
  }
}

class SearchDocumentsParams {
  final String? query;
  final DocumentType? type;
  final DocumentStatus? status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? limit;
  final int? offset;

  const SearchDocumentsParams({
    this.query,
    this.type,
    this.status,
    this.fromDate,
    this.toDate,
    this.limit,
    this.offset,
  });
}

@injectable
class SearchDocuments implements UseCase<List<Document>, SearchDocumentsParams> {
  final DocumentsRepository repository;

  SearchDocuments(this.repository);

  @override
  Future<Either<Failure, List<Document>>> call(SearchDocumentsParams params) async {
    return await repository.searchDocuments(
      query: params.query,
      type: params.type,
      status: params.status,
      fromDate: params.fromDate,
      toDate: params.toDate,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class DeleteDocumentParams {
  final String documentId;

  const DeleteDocumentParams({required this.documentId});
}

@injectable
class DeleteDocument implements UseCase<void, DeleteDocumentParams> {
  final DocumentsRepository repository;

  DeleteDocument(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteDocumentParams params) async {
    if (params.documentId.trim().isEmpty) {
      return const Left(ValidationFailure('Document ID is required'));
    }
    return await repository.deleteDocument(params.documentId);
  }
}
