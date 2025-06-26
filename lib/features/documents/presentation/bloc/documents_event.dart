import 'package:equatable/equatable.dart';
import '../../domain/entities/document.dart';

abstract class DocumentsEvent extends Equatable {
  const DocumentsEvent();

  @override
  List<Object?> get props => [];
}

// Load documents events
class DocumentsLoadRequested extends DocumentsEvent {
  const DocumentsLoadRequested();
}

class DocumentsRefreshRequested extends DocumentsEvent {
  const DocumentsRefreshRequested();
}

class DocumentsStatsLoadRequested extends DocumentsEvent {
  const DocumentsStatsLoadRequested();
}

// Upload document event
class DocumentUploadRequested extends DocumentsEvent {
  final DocumentUploadRequest request;

  const DocumentUploadRequested({
    required this.request,
  });

  @override
  List<Object> get props => [request];
}

// Get specific document
class DocumentLoadRequested extends DocumentsEvent {
  final String documentId;

  const DocumentLoadRequested({
    required this.documentId,
  });

  @override
  List<Object> get props => [documentId];
}

// Filter documents
class DocumentsFilterByTypeRequested extends DocumentsEvent {
  final DocumentType type;

  const DocumentsFilterByTypeRequested({
    required this.type,
  });

  @override
  List<Object> get props => [type];
}

class DocumentsFilterByStatusRequested extends DocumentsEvent {
  final DocumentStatus status;

  const DocumentsFilterByStatusRequested({
    required this.status,
  });

  @override
  List<Object> get props => [status];
}

// Search documents
class DocumentsSearchRequested extends DocumentsEvent {
  final String? query;
  final DocumentType? type;
  final DocumentStatus? status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? limit;
  final int? offset;

  const DocumentsSearchRequested({
    this.query,
    this.type,
    this.status,
    this.fromDate,
    this.toDate,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [query, type, status, fromDate, toDate, limit, offset];
}

// Update document
class DocumentUpdateRequested extends DocumentsEvent {
  final String documentId;
  final Map<String, dynamic> updates;

  const DocumentUpdateRequested({
    required this.documentId,
    required this.updates,
  });

  @override
  List<Object> get props => [documentId, updates];
}

// Delete document
class DocumentDeleteRequested extends DocumentsEvent {
  final String documentId;

  const DocumentDeleteRequested({
    required this.documentId,
  });

  @override
  List<Object> get props => [documentId];
}

// Resubmit document
class DocumentResubmitRequested extends DocumentsEvent {
  final String documentId;
  final DocumentUploadRequest request;

  const DocumentResubmitRequested({
    required this.documentId,
    required this.request,
  });

  @override
  List<Object> get props => [documentId, request];
}

// Download document files
class DocumentFilesDownloadRequested extends DocumentsEvent {
  final String documentId;

  const DocumentFilesDownloadRequested({
    required this.documentId,
  });

  @override
  List<Object> get props => [documentId];
}

// Check verification status
class DocumentVerificationStatusCheckRequested extends DocumentsEvent {
  final String documentId;

  const DocumentVerificationStatusCheckRequested({
    required this.documentId,
  });

  @override
  List<Object> get props => [documentId];
}

// Get supported document types
class DocumentTypesLoadRequested extends DocumentsEvent {
  const DocumentTypesLoadRequested();
}

// Validate document number
class DocumentNumberValidationRequested extends DocumentsEvent {
  final DocumentType type;
  final String documentNumber;

  const DocumentNumberValidationRequested({
    required this.type,
    required this.documentNumber,
  });

  @override
  List<Object> get props => [type, documentNumber];
}

// Get document requirements
class DocumentRequirementsLoadRequested extends DocumentsEvent {
  final DocumentType type;

  const DocumentRequirementsLoadRequested({
    required this.type,
  });

  @override
  List<Object> get props => [type];
}

// Clear errors
class DocumentsErrorCleared extends DocumentsEvent {
  const DocumentsErrorCleared();
}

// Reset state
class DocumentsStateReset extends DocumentsEvent {
  const DocumentsStateReset();
}

// Set selected document
class DocumentSelected extends DocumentsEvent {
  final Document? document;

  const DocumentSelected({
    this.document,
  });

  @override
  List<Object?> get props => [document];
}

// Set filter
class DocumentsFilterSet extends DocumentsEvent {
  final DocumentType? type;
  final DocumentStatus? status;

  const DocumentsFilterSet({
    this.type,
    this.status,
  });

  @override
  List<Object?> get props => [type, status];
}

// Clear filter
class DocumentsFilterCleared extends DocumentsEvent {
  const DocumentsFilterCleared();
}
