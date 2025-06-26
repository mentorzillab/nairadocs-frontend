import 'package:equatable/equatable.dart';
import '../../domain/entities/document.dart';

abstract class DocumentsState extends Equatable {
  const DocumentsState();

  @override
  List<Object?> get props => [];
}

// Initial state
class DocumentsInitial extends DocumentsState {
  const DocumentsInitial();
}

// Loading states
class DocumentsLoading extends DocumentsState {
  const DocumentsLoading();
}

class DocumentsRefreshing extends DocumentsState {
  final List<Document> currentDocuments;

  const DocumentsRefreshing({
    required this.currentDocuments,
  });

  @override
  List<Object> get props => [currentDocuments];
}

class DocumentUploadLoading extends DocumentsState {
  const DocumentUploadLoading();
}

class DocumentLoadLoading extends DocumentsState {
  const DocumentLoadLoading();
}

class DocumentUpdateLoading extends DocumentsState {
  const DocumentUpdateLoading();
}

class DocumentDeleteLoading extends DocumentsState {
  const DocumentDeleteLoading();
}

class DocumentResubmitLoading extends DocumentsState {
  const DocumentResubmitLoading();
}

class DocumentFilesDownloadLoading extends DocumentsState {
  const DocumentFilesDownloadLoading();
}

class DocumentVerificationCheckLoading extends DocumentsState {
  const DocumentVerificationCheckLoading();
}

class DocumentTypesLoading extends DocumentsState {
  const DocumentTypesLoading();
}

class DocumentRequirementsLoading extends DocumentsState {
  const DocumentRequirementsLoading();
}

class DocumentNumberValidationLoading extends DocumentsState {
  const DocumentNumberValidationLoading();
}

// Success states
class DocumentsLoaded extends DocumentsState {
  final List<Document> documents;
  final DocumentStats? stats;
  final DocumentType? filterType;
  final DocumentStatus? filterStatus;
  final Document? selectedDocument;

  const DocumentsLoaded({
    required this.documents,
    this.stats,
    this.filterType,
    this.filterStatus,
    this.selectedDocument,
  });

  @override
  List<Object?> get props => [documents, stats, filterType, filterStatus, selectedDocument];

  DocumentsLoaded copyWith({
    List<Document>? documents,
    DocumentStats? stats,
    DocumentType? filterType,
    DocumentStatus? filterStatus,
    Document? selectedDocument,
    bool clearSelectedDocument = false,
    bool clearFilterType = false,
    bool clearFilterStatus = false,
  }) {
    return DocumentsLoaded(
      documents: documents ?? this.documents,
      stats: stats ?? this.stats,
      filterType: clearFilterType ? null : (filterType ?? this.filterType),
      filterStatus: clearFilterStatus ? null : (filterStatus ?? this.filterStatus),
      selectedDocument: clearSelectedDocument ? null : (selectedDocument ?? this.selectedDocument),
    );
  }
}

class DocumentUploadSuccess extends DocumentsState {
  final Document document;

  const DocumentUploadSuccess({
    required this.document,
  });

  @override
  List<Object> get props => [document];
}

class DocumentLoadSuccess extends DocumentsState {
  final Document document;

  const DocumentLoadSuccess({
    required this.document,
  });

  @override
  List<Object> get props => [document];
}

class DocumentUpdateSuccess extends DocumentsState {
  final Document document;

  const DocumentUpdateSuccess({
    required this.document,
  });

  @override
  List<Object> get props => [document];
}

class DocumentDeleteSuccess extends DocumentsState {
  final String documentId;

  const DocumentDeleteSuccess({
    required this.documentId,
  });

  @override
  List<Object> get props => [documentId];
}

class DocumentResubmitSuccess extends DocumentsState {
  final Document document;

  const DocumentResubmitSuccess({
    required this.document,
  });

  @override
  List<Object> get props => [document];
}

class DocumentFilesDownloadSuccess extends DocumentsState {
  final List<String> fileUrls;

  const DocumentFilesDownloadSuccess({
    required this.fileUrls,
  });

  @override
  List<Object> get props => [fileUrls];
}

class DocumentVerificationStatusUpdated extends DocumentsState {
  final Document document;

  const DocumentVerificationStatusUpdated({
    required this.document,
  });

  @override
  List<Object> get props => [document];
}

class DocumentTypesLoaded extends DocumentsState {
  final List<DocumentType> documentTypes;

  const DocumentTypesLoaded({
    required this.documentTypes,
  });

  @override
  List<Object> get props => [documentTypes];
}

class DocumentRequirementsLoaded extends DocumentsState {
  final DocumentType type;
  final Map<String, dynamic> requirements;

  const DocumentRequirementsLoaded({
    required this.type,
    required this.requirements,
  });

  @override
  List<Object> get props => [type, requirements];
}

class DocumentNumberValidationResult extends DocumentsState {
  final DocumentType type;
  final String documentNumber;
  final bool isValid;

  const DocumentNumberValidationResult({
    required this.type,
    required this.documentNumber,
    required this.isValid,
  });

  @override
  List<Object> get props => [type, documentNumber, isValid];
}

class DocumentsSearchResults extends DocumentsState {
  final List<Document> documents;
  final String? query;
  final DocumentType? type;
  final DocumentStatus? status;

  const DocumentsSearchResults({
    required this.documents,
    this.query,
    this.type,
    this.status,
  });

  @override
  List<Object?> get props => [documents, query, type, status];
}

// Error states
class DocumentsError extends DocumentsState {
  final String message;
  final String? errorCode;

  const DocumentsError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class DocumentUploadError extends DocumentsState {
  final String message;
  final String? errorCode;

  const DocumentUploadError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class DocumentLoadError extends DocumentsState {
  final String message;
  final String? errorCode;

  const DocumentLoadError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class DocumentUpdateError extends DocumentsState {
  final String message;
  final String? errorCode;

  const DocumentUpdateError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class DocumentDeleteError extends DocumentsState {
  final String message;
  final String? errorCode;

  const DocumentDeleteError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class DocumentValidationError extends DocumentsState {
  final String message;
  final Map<String, String>? fieldErrors;

  const DocumentValidationError({
    required this.message,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, fieldErrors];
}

class DocumentNetworkError extends DocumentsState {
  final String message;

  const DocumentNetworkError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class DocumentUnauthorizedError extends DocumentsState {
  final String message;

  const DocumentUnauthorizedError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
