import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/document.dart';

abstract class DocumentsRepository {
  /// Upload a new document for verification
  Future<Either<Failure, Document>> uploadDocument(DocumentUploadRequest request);

  /// Get all documents for the current user
  Future<Either<Failure, List<Document>>> getUserDocuments();

  /// Get a specific document by ID
  Future<Either<Failure, Document>> getDocumentById(String documentId);

  /// Get documents by type
  Future<Either<Failure, List<Document>>> getDocumentsByType(DocumentType type);

  /// Get documents by status
  Future<Either<Failure, List<Document>>> getDocumentsByStatus(DocumentStatus status);

  /// Update document information
  Future<Either<Failure, Document>> updateDocument(String documentId, Map<String, dynamic> updates);

  /// Delete a document
  Future<Either<Failure, void>> deleteDocument(String documentId);

  /// Get document statistics
  Future<Either<Failure, DocumentStats>> getDocumentStats();

  /// Search documents
  Future<Either<Failure, List<Document>>> searchDocuments({
    String? query,
    DocumentType? type,
    DocumentStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
    int? offset,
  });

  /// Resubmit a rejected document
  Future<Either<Failure, Document>> resubmitDocument(
    String documentId,
    DocumentUploadRequest request,
  );

  /// Download document files
  Future<Either<Failure, List<String>>> downloadDocumentFiles(String documentId);

  /// Check document verification status
  Future<Either<Failure, Document>> checkVerificationStatus(String documentId);

  /// Get supported document types
  Future<Either<Failure, List<DocumentType>>> getSupportedDocumentTypes();

  /// Validate document number format
  Future<Either<Failure, bool>> validateDocumentNumber(
    DocumentType type,
    String documentNumber,
  );

  /// Get document verification requirements
  Future<Either<Failure, Map<String, dynamic>>> getDocumentRequirements(
    DocumentType type,
  );
}
