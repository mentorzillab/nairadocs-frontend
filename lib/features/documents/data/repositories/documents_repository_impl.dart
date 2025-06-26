import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/document.dart';
import '../../domain/repositories/documents_repository.dart';
import '../datasources/documents_remote_data_source.dart';
import '../datasources/documents_local_data_source.dart';
import '../models/document_model.dart';

@LazySingleton(as: DocumentsRepository)
class DocumentsRepositoryImpl implements DocumentsRepository {
  final DocumentsRemoteDataSource remoteDataSource;
  final DocumentsLocalDataSource localDataSource;

  DocumentsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Document>> uploadDocument(DocumentUploadRequest request) async {
    try {
      final requestModel = DocumentUploadRequestModel.fromEntity(request);
      final documentModel = await remoteDataSource.uploadDocument(requestModel);
      
      // Cache the uploaded document
      await localDataSource.cacheDocument(documentModel);
      
      return Right(documentModel.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Document>>> getUserDocuments() async {
    try {
      // Try to get from remote first
      final remoteDocuments = await remoteDataSource.getUserDocuments();
      
      // Cache the documents
      await localDataSource.cacheDocuments(remoteDocuments);
      
      return Right(remoteDocuments.map((model) => model.toEntity()).toList());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      // Try to get from cache if server fails
      try {
        final cachedDocuments = await localDataSource.getCachedDocuments();
        if (cachedDocuments.isNotEmpty) {
          return Right(cachedDocuments.map((model) => model.toEntity()).toList());
        }
      } catch (_) {
        // Ignore cache errors
      }
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      // Try to get from cache if network fails
      try {
        final cachedDocuments = await localDataSource.getCachedDocuments();
        if (cachedDocuments.isNotEmpty) {
          return Right(cachedDocuments.map((model) => model.toEntity()).toList());
        }
      } catch (_) {
        // Ignore cache errors
      }
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Document>> getDocumentById(String documentId) async {
    try {
      // Try to get from cache first for better performance
      final cachedDocument = await localDataSource.getCachedDocument(documentId);
      if (cachedDocument != null) {
        return Right(cachedDocument.toEntity());
      }

      // Get from remote if not in cache
      final documentModel = await remoteDataSource.getDocumentById(documentId);
      
      // Cache the document
      await localDataSource.cacheDocument(documentModel);
      
      return Right(documentModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Document>>> getDocumentsByType(DocumentType type) async {
    try {
      // Try to get from remote first
      final remoteDocuments = await remoteDataSource.getDocumentsByType(type);
      
      // Cache the documents
      await localDataSource.cacheDocumentsByType(type, remoteDocuments);
      
      return Right(remoteDocuments.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      // Try to get from cache if server fails
      try {
        final cachedDocuments = await localDataSource.getCachedDocumentsByType(type);
        if (cachedDocuments != null && cachedDocuments.isNotEmpty) {
          return Right(cachedDocuments.map((model) => model.toEntity()).toList());
        }
      } catch (_) {
        // Ignore cache errors
      }
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      // Try to get from cache if network fails
      try {
        final cachedDocuments = await localDataSource.getCachedDocumentsByType(type);
        if (cachedDocuments != null && cachedDocuments.isNotEmpty) {
          return Right(cachedDocuments.map((model) => model.toEntity()).toList());
        }
      } catch (_) {
        // Ignore cache errors
      }
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Document>>> getDocumentsByStatus(DocumentStatus status) async {
    try {
      // Try to get from remote first
      final remoteDocuments = await remoteDataSource.getDocumentsByStatus(status);
      
      // Cache the documents
      await localDataSource.cacheDocumentsByStatus(status, remoteDocuments);
      
      return Right(remoteDocuments.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      // Try to get from cache if server fails
      try {
        final cachedDocuments = await localDataSource.getCachedDocumentsByStatus(status);
        if (cachedDocuments != null && cachedDocuments.isNotEmpty) {
          return Right(cachedDocuments.map((model) => model.toEntity()).toList());
        }
      } catch (_) {
        // Ignore cache errors
      }
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      // Try to get from cache if network fails
      try {
        final cachedDocuments = await localDataSource.getCachedDocumentsByStatus(status);
        if (cachedDocuments != null && cachedDocuments.isNotEmpty) {
          return Right(cachedDocuments.map((model) => model.toEntity()).toList());
        }
      } catch (_) {
        // Ignore cache errors
      }
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Document>> updateDocument(String documentId, Map<String, dynamic> updates) async {
    try {
      final documentModel = await remoteDataSource.updateDocument(documentId, updates);
      
      // Update cache
      await localDataSource.cacheDocument(documentModel);
      
      return Right(documentModel.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocument(String documentId) async {
    try {
      await remoteDataSource.deleteDocument(documentId);
      
      // Remove from cache
      await localDataSource.removeCachedDocument(documentId);
      
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, DocumentStats>> getDocumentStats() async {
    try {
      // Try to get from remote first
      final statsModel = await remoteDataSource.getDocumentStats();
      
      // Cache the stats
      await localDataSource.cacheDocumentStats(statsModel);
      
      return Right(statsModel.toEntity());
    } on ServerException catch (e) {
      // Try to get from cache if server fails
      try {
        final cachedStats = await localDataSource.getCachedDocumentStats();
        if (cachedStats != null) {
          return Right(cachedStats.toEntity());
        }
      } catch (_) {
        // Ignore cache errors
      }
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      // Try to get from cache if network fails
      try {
        final cachedStats = await localDataSource.getCachedDocumentStats();
        if (cachedStats != null) {
          return Right(cachedStats.toEntity());
        }
      } catch (_) {
        // Ignore cache errors
      }
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Document>>> searchDocuments({
    String? query,
    DocumentType? type,
    DocumentStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
    int? offset,
  }) async {
    try {
      final remoteDocuments = await remoteDataSource.searchDocuments(
        query: query,
        type: type,
        status: status,
        fromDate: fromDate,
        toDate: toDate,
        limit: limit,
        offset: offset,
      );

      return Right(remoteDocuments.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Document>> resubmitDocument(
    String documentId,
    DocumentUploadRequest request,
  ) async {
    try {
      final requestModel = DocumentUploadRequestModel.fromEntity(request);
      final documentModel = await remoteDataSource.resubmitDocument(documentId, requestModel);

      // Update cache
      await localDataSource.cacheDocument(documentModel);

      return Right(documentModel.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> downloadDocumentFiles(String documentId) async {
    try {
      final fileUrls = await remoteDataSource.downloadDocumentFiles(documentId);
      return Right(fileUrls);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Document>> checkVerificationStatus(String documentId) async {
    try {
      final documentModel = await remoteDataSource.checkVerificationStatus(documentId);

      // Update cache with latest status
      await localDataSource.cacheDocument(documentModel);

      return Right(documentModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DocumentType>>> getSupportedDocumentTypes() async {
    try {
      final documentTypes = await remoteDataSource.getSupportedDocumentTypes();
      return Right(documentTypes);
    } on ServerException catch (e) {
      // Return default supported types if server fails
      return const Right(DocumentType.values);
    } on NetworkException catch (e) {
      // Return default supported types if network fails
      return const Right(DocumentType.values);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateDocumentNumber(
    DocumentType type,
    String documentNumber,
  ) async {
    try {
      final isValid = await remoteDataSource.validateDocumentNumber(type, documentNumber);
      return Right(isValid);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDocumentRequirements(
    DocumentType type,
  ) async {
    try {
      final requirements = await remoteDataSource.getDocumentRequirements(type);
      return Right(requirements);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
