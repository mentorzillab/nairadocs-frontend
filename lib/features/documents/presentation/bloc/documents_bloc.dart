import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/document.dart';
import '../../domain/usecases/upload_document.dart';
import '../../domain/usecases/get_user_documents.dart';
import '../../domain/usecases/update_document.dart';
import '../../domain/usecases/resubmit_document.dart';
import '../../domain/usecases/download_document_files.dart';
import '../../domain/usecases/check_verification_status.dart';
import '../../domain/usecases/get_supported_document_types.dart';
import '../../domain/usecases/validate_document_number.dart';
import '../../domain/usecases/get_document_requirements.dart';
import '../../../../core/errors/failures.dart';
import 'documents_event.dart';
import 'documents_state.dart';

@injectable
class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  final UploadDocument _uploadDocument;
  final GetUserDocuments _getUserDocuments;
  final GetDocumentById _getDocumentById;
  final GetDocumentStats _getDocumentStats;
  final SearchDocuments _searchDocuments;
  final DeleteDocument _deleteDocument;
  final UpdateDocument _updateDocument;
  final ResubmitDocument _resubmitDocument;
  final DownloadDocumentFiles _downloadDocumentFiles;
  final CheckVerificationStatus _checkVerificationStatus;
  final GetSupportedDocumentTypes _getSupportedDocumentTypes;
  final ValidateDocumentNumber _validateDocumentNumber;
  final GetDocumentRequirements _getDocumentRequirements;

  List<Document> _allDocuments = [];
  DocumentStats? _currentStats;
  DocumentType? _currentFilterType;
  DocumentStatus? _currentFilterStatus;

  DocumentsBloc(
    this._uploadDocument,
    this._getUserDocuments,
    this._getDocumentById,
    this._getDocumentStats,
    this._searchDocuments,
    this._deleteDocument,
    this._updateDocument,
    this._resubmitDocument,
    this._downloadDocumentFiles,
    this._checkVerificationStatus,
    this._getSupportedDocumentTypes,
    this._validateDocumentNumber,
    this._getDocumentRequirements,
  ) : super(const DocumentsInitial()) {
    // Register event handlers
    on<DocumentsLoadRequested>(_onDocumentsLoadRequested);
    on<DocumentsRefreshRequested>(_onDocumentsRefreshRequested);
    on<DocumentsStatsLoadRequested>(_onDocumentsStatsLoadRequested);
    on<DocumentUploadRequested>(_onDocumentUploadRequested);
    on<DocumentLoadRequested>(_onDocumentLoadRequested);
    on<DocumentsFilterByTypeRequested>(_onDocumentsFilterByTypeRequested);
    on<DocumentsFilterByStatusRequested>(_onDocumentsFilterByStatusRequested);
    on<DocumentsSearchRequested>(_onDocumentsSearchRequested);
    on<DocumentUpdateRequested>(_onDocumentUpdateRequested);
    on<DocumentDeleteRequested>(_onDocumentDeleteRequested);
    on<DocumentResubmitRequested>(_onDocumentResubmitRequested);
    on<DocumentFilesDownloadRequested>(_onDocumentFilesDownloadRequested);
    on<DocumentVerificationStatusCheckRequested>(_onDocumentVerificationStatusCheckRequested);
    on<DocumentTypesLoadRequested>(_onDocumentTypesLoadRequested);
    on<DocumentNumberValidationRequested>(_onDocumentNumberValidationRequested);
    on<DocumentRequirementsLoadRequested>(_onDocumentRequirementsLoadRequested);
    on<DocumentsErrorCleared>(_onDocumentsErrorCleared);
    on<DocumentsStateReset>(_onDocumentsStateReset);
    on<DocumentSelected>(_onDocumentSelected);
    on<DocumentsFilterSet>(_onDocumentsFilterSet);
    on<DocumentsFilterCleared>(_onDocumentsFilterCleared);
  }

  // Load user documents
  Future<void> _onDocumentsLoadRequested(
    DocumentsLoadRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(const DocumentsLoading());

    final result = await _getUserDocuments();

    result.fold(
      (failure) {
        emit(_mapFailureToDocumentsError(failure));
      },
      (documents) {
        _allDocuments = documents;
        emit(DocumentsLoaded(
          documents: _getFilteredDocuments(),
          stats: _currentStats,
          filterType: _currentFilterType,
          filterStatus: _currentFilterStatus,
        ));
      },
    );
  }

  // Refresh documents
  Future<void> _onDocumentsRefreshRequested(
    DocumentsRefreshRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    if (state is DocumentsLoaded) {
      emit(DocumentsRefreshing(currentDocuments: (state as DocumentsLoaded).documents));
    } else {
      emit(const DocumentsLoading());
    }

    final result = await _getUserDocuments();

    result.fold(
      (failure) {
        emit(_mapFailureToDocumentsError(failure));
      },
      (documents) {
        _allDocuments = documents;
        emit(DocumentsLoaded(
          documents: _getFilteredDocuments(),
          stats: _currentStats,
          filterType: _currentFilterType,
          filterStatus: _currentFilterStatus,
        ));
      },
    );
  }

  // Load document stats
  Future<void> _onDocumentsStatsLoadRequested(
    DocumentsStatsLoadRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    final result = await _getDocumentStats();

    result.fold(
      (failure) {
        // Don't emit error for stats, just continue without them
      },
      (stats) {
        _currentStats = stats;
        if (state is DocumentsLoaded) {
          emit((state as DocumentsLoaded).copyWith(stats: stats));
        }
      },
    );
  }

  // Upload document
  Future<void> _onDocumentUploadRequested(
    DocumentUploadRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(const DocumentUploadLoading());

    final result = await _uploadDocument(event.request);

    result.fold(
      (failure) {
        emit(_mapFailureToDocumentUploadError(failure));
      },
      (document) {
        _allDocuments.insert(0, document); // Add to beginning of list
        emit(DocumentUploadSuccess(document: document));
        
        // Refresh the documents list
        add(const DocumentsLoadRequested());
      },
    );
  }

  // Load specific document
  Future<void> _onDocumentLoadRequested(
    DocumentLoadRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(const DocumentLoadLoading());

    final result = await _getDocumentById(event.documentId);

    result.fold(
      (failure) {
        emit(_mapFailureToDocumentLoadError(failure));
      },
      (document) {
        emit(DocumentLoadSuccess(document: document));
      },
    );
  }

  // Filter by type
  void _onDocumentsFilterByTypeRequested(
    DocumentsFilterByTypeRequested event,
    Emitter<DocumentsState> emit,
  ) {
    _currentFilterType = event.type;
    _currentFilterStatus = null; // Clear status filter when filtering by type

    if (state is DocumentsLoaded) {
      emit((state as DocumentsLoaded).copyWith(
        documents: _getFilteredDocuments(),
        filterType: _currentFilterType,
        clearFilterStatus: true,
      ));
    }
  }

  // Filter by status
  void _onDocumentsFilterByStatusRequested(
    DocumentsFilterByStatusRequested event,
    Emitter<DocumentsState> emit,
  ) {
    _currentFilterStatus = event.status;
    _currentFilterType = null; // Clear type filter when filtering by status

    if (state is DocumentsLoaded) {
      emit((state as DocumentsLoaded).copyWith(
        documents: _getFilteredDocuments(),
        filterStatus: _currentFilterStatus,
        clearFilterType: true,
      ));
    }
  }

  // Search documents
  Future<void> _onDocumentsSearchRequested(
    DocumentsSearchRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(const DocumentsLoading());

    final params = SearchDocumentsParams(
      query: event.query,
      type: event.type,
      status: event.status,
      fromDate: event.fromDate,
      toDate: event.toDate,
      limit: event.limit,
      offset: event.offset,
    );

    final result = await _searchDocuments(params);

    result.fold(
      (failure) {
        emit(_mapFailureToDocumentsError(failure));
      },
      (documents) {
        emit(DocumentsSearchResults(
          documents: documents,
          query: event.query,
          type: event.type,
          status: event.status,
        ));
      },
    );
  }

  // Update document
  Future<void> _onDocumentUpdateRequested(
    DocumentUpdateRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(const DocumentUpdateLoading());

    final params = UpdateDocumentParams(
      documentId: event.documentId,
      updates: event.updates,
    );

    final result = await _updateDocument(params);

    result.fold(
      (failure) {
        emit(_mapFailureToDocumentUpdateError(failure));
      },
      (document) {
        // Update the document in the local list
        final index = _allDocuments.indexWhere((doc) => doc.id == event.documentId);
        if (index != -1) {
          _allDocuments[index] = document;
        }

        emit(DocumentUpdateSuccess(document: document));

        // Refresh the documents list
        add(const DocumentsLoadRequested());
      },
    );
  }

  // Delete document
  Future<void> _onDocumentDeleteRequested(
    DocumentDeleteRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(const DocumentDeleteLoading());

    final params = DeleteDocumentParams(documentId: event.documentId);
    final result = await _deleteDocument(params);

    result.fold(
      (failure) {
        emit(_mapFailureToDocumentDeleteError(failure));
      },
      (_) {
        // Remove from local list
        _allDocuments.removeWhere((doc) => doc.id == event.documentId);

        emit(DocumentDeleteSuccess(documentId: event.documentId));

        // Refresh the documents list
        add(const DocumentsLoadRequested());
      },
    );
  }

  // Resubmit document
  Future<void> _onDocumentResubmitRequested(
    DocumentResubmitRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(const DocumentResubmitLoading());

    final params = ResubmitDocumentParams(
      documentId: event.documentId,
      request: event.request,
    );

    final result = await _resubmitDocument(params);

    result.fold(
      (failure) {
        emit(_mapFailureToDocumentsError(failure));
      },
      (document) {
        // Update the document in the local list
        final index = _allDocuments.indexWhere((doc) => doc.id == event.documentId);
        if (index != -1) {
          _allDocuments[index] = document;
        }

        emit(DocumentResubmitSuccess(document: document));

        // Refresh the documents list
        add(const DocumentsLoadRequested());
      },
    );
  }

  // Download document files
  Future<void> _onDocumentFilesDownloadRequested(
    DocumentFilesDownloadRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(const DocumentFilesDownloadLoading());

    final result = await _downloadDocumentFiles(event.documentId);

    result.fold(
      (failure) {
        emit(_mapFailureToDocumentsError(failure));
      },
      (fileUrls) {
        emit(DocumentFilesDownloadSuccess(fileUrls: fileUrls));
      },
    );
  }

  // Check verification status
  Future<void> _onDocumentVerificationStatusCheckRequested(
    DocumentVerificationStatusCheckRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(const DocumentVerificationCheckLoading());

    final result = await _checkVerificationStatus(event.documentId);

    result.fold(
      (failure) {
        emit(_mapFailureToDocumentsError(failure));
      },
      (document) {
        // Update the document in the local list
        final index = _allDocuments.indexWhere((doc) => doc.id == event.documentId);
        if (index != -1) {
          _allDocuments[index] = document;
        }

        emit(DocumentVerificationStatusUpdated(document: document));
      },
    );
  }

  // Load document types
  Future<void> _onDocumentTypesLoadRequested(
    DocumentTypesLoadRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(const DocumentTypesLoading());

    final result = await _getSupportedDocumentTypes();

    result.fold(
      (failure) {
        // If API fails, return default types
        emit(const DocumentTypesLoaded(documentTypes: DocumentType.values));
      },
      (documentTypes) {
        emit(DocumentTypesLoaded(documentTypes: documentTypes));
      },
    );
  }

  // Validate document number
  Future<void> _onDocumentNumberValidationRequested(
    DocumentNumberValidationRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(const DocumentNumberValidationLoading());

    final params = ValidateDocumentNumberParams(
      type: event.type,
      documentNumber: event.documentNumber,
    );

    final result = await _validateDocumentNumber(params);

    result.fold(
      (failure) {
        // If API fails, use local validation
        bool isValid = false;
        switch (event.type) {
          case DocumentType.nin:
          case DocumentType.bvn:
            isValid = event.documentNumber.replaceAll(RegExp(r'[^\d]'), '').length == 11;
            break;
          case DocumentType.driversLicense:
            isValid = event.documentNumber.trim().length >= 5;
            break;
          case DocumentType.passport:
            isValid = event.documentNumber.trim().length >= 6;
            break;
          default:
            isValid = event.documentNumber.trim().length >= 3;
        }

        emit(DocumentNumberValidationResult(
          type: event.type,
          documentNumber: event.documentNumber,
          isValid: isValid,
        ));
      },
      (isValid) {
        emit(DocumentNumberValidationResult(
          type: event.type,
          documentNumber: event.documentNumber,
          isValid: isValid,
        ));
      },
    );
  }

  // Load document requirements
  Future<void> _onDocumentRequirementsLoadRequested(
    DocumentRequirementsLoadRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(const DocumentRequirementsLoading());

    final result = await _getDocumentRequirements(event.type);

    result.fold(
      (failure) {
        // If API fails, return mock requirements
        final requirements = _getMockRequirements(event.type);
        emit(DocumentRequirementsLoaded(
          type: event.type,
          requirements: requirements,
        ));
      },
      (requirements) {
        emit(DocumentRequirementsLoaded(
          type: event.type,
          requirements: requirements,
        ));
      },
    );
  }

  // Clear errors
  void _onDocumentsErrorCleared(
    DocumentsErrorCleared event,
    Emitter<DocumentsState> emit,
  ) {
    if (_allDocuments.isNotEmpty) {
      emit(DocumentsLoaded(
        documents: _getFilteredDocuments(),
        stats: _currentStats,
        filterType: _currentFilterType,
        filterStatus: _currentFilterStatus,
      ));
    } else {
      emit(const DocumentsInitial());
    }
  }

  // Reset state
  void _onDocumentsStateReset(
    DocumentsStateReset event,
    Emitter<DocumentsState> emit,
  ) {
    _allDocuments.clear();
    _currentStats = null;
    _currentFilterType = null;
    _currentFilterStatus = null;
    emit(const DocumentsInitial());
  }

  // Select document
  void _onDocumentSelected(
    DocumentSelected event,
    Emitter<DocumentsState> emit,
  ) {
    if (state is DocumentsLoaded) {
      emit((state as DocumentsLoaded).copyWith(
        selectedDocument: event.document,
        clearSelectedDocument: event.document == null,
      ));
    }
  }

  // Set filter
  void _onDocumentsFilterSet(
    DocumentsFilterSet event,
    Emitter<DocumentsState> emit,
  ) {
    _currentFilterType = event.type;
    _currentFilterStatus = event.status;

    if (state is DocumentsLoaded) {
      emit((state as DocumentsLoaded).copyWith(
        documents: _getFilteredDocuments(),
        filterType: _currentFilterType,
        filterStatus: _currentFilterStatus,
      ));
    }
  }

  // Clear filter
  void _onDocumentsFilterCleared(
    DocumentsFilterCleared event,
    Emitter<DocumentsState> emit,
  ) {
    _currentFilterType = null;
    _currentFilterStatus = null;

    if (state is DocumentsLoaded) {
      emit((state as DocumentsLoaded).copyWith(
        documents: _allDocuments,
        clearFilterType: true,
        clearFilterStatus: true,
      ));
    }
  }

  // Helper methods
  List<Document> _getFilteredDocuments() {
    List<Document> filtered = List.from(_allDocuments);

    if (_currentFilterType != null) {
      filtered = filtered.where((doc) => doc.type == _currentFilterType).toList();
    }

    if (_currentFilterStatus != null) {
      filtered = filtered.where((doc) => doc.status == _currentFilterStatus).toList();
    }

    // Sort by creation date (newest first)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }

  DocumentsState _mapFailureToDocumentsError(Failure failure) {
    final message = failure is ServerFailure
        ? failure.message
        : failure is NetworkFailure
            ? failure.message
            : failure is ValidationFailure
                ? failure.message
                : failure is UnauthorizedFailure
                    ? failure.message
                    : 'An unexpected error occurred';

    if (failure is NetworkFailure) {
      return DocumentNetworkError(message: message);
    } else if (failure is ValidationFailure) {
      return DocumentValidationError(message: message);
    } else if (failure is UnauthorizedFailure) {
      return DocumentUnauthorizedError(message: message);
    } else {
      return DocumentsError(message: message);
    }
  }

  DocumentsState _mapFailureToDocumentUploadError(Failure failure) {
    final message = failure is ServerFailure
        ? failure.message
        : failure is NetworkFailure
            ? failure.message
            : failure is ValidationFailure
                ? failure.message
                : failure is UnauthorizedFailure
                    ? failure.message
                    : 'Failed to upload document';

    return DocumentUploadError(message: message);
  }

  DocumentsState _mapFailureToDocumentLoadError(Failure failure) {
    final message = failure is ServerFailure
        ? failure.message
        : failure is NetworkFailure
            ? failure.message
            : failure is UnauthorizedFailure
                    ? failure.message
                    : 'Failed to load document';

    return DocumentLoadError(message: message);
  }

  DocumentsState _mapFailureToDocumentDeleteError(Failure failure) {
    final message = failure is ServerFailure
        ? failure.message
        : failure is NetworkFailure
            ? failure.message
            : failure is UnauthorizedFailure
                    ? failure.message
                    : 'Failed to delete document';

    return DocumentDeleteError(message: message);
  }

  DocumentsState _mapFailureToDocumentUpdateError(Failure failure) {
    final message = failure is ServerFailure
        ? failure.message
        : failure is NetworkFailure
            ? failure.message
            : failure is ValidationFailure
                ? failure.message
            : failure is UnauthorizedFailure
                    ? failure.message
                    : 'Failed to update document';

    return DocumentUpdateError(message: message);
  }

  Map<String, dynamic> _getMockRequirements(DocumentType type) {
    switch (type) {
      case DocumentType.nin:
        return {
          'requiredFields': ['firstName', 'lastName', 'dateOfBirth', 'documentNumber'],
          'documentNumberFormat': '11 digits',
          'acceptedFileTypes': ['jpg', 'jpeg', 'png', 'pdf'],
          'maxFileSize': '5MB',
          'description': 'National Identification Number verification requires a clear photo of your NIN slip or card.',
        };
      case DocumentType.bvn:
        return {
          'requiredFields': ['firstName', 'lastName', 'dateOfBirth', 'documentNumber'],
          'documentNumberFormat': '11 digits',
          'acceptedFileTypes': ['jpg', 'jpeg', 'png', 'pdf'],
          'maxFileSize': '5MB',
          'description': 'Bank Verification Number verification requires your BVN details.',
        };
      case DocumentType.driversLicense:
        return {
          'requiredFields': ['firstName', 'lastName', 'documentNumber', 'expiryDate'],
          'documentNumberFormat': 'Alphanumeric, minimum 5 characters',
          'acceptedFileTypes': ['jpg', 'jpeg', 'png'],
          'maxFileSize': '5MB',
          'description': 'Upload a clear photo of both sides of your driver\'s license.',
        };
      case DocumentType.passport:
        return {
          'requiredFields': ['firstName', 'lastName', 'documentNumber', 'expiryDate'],
          'documentNumberFormat': 'Alphanumeric, minimum 6 characters',
          'acceptedFileTypes': ['jpg', 'jpeg', 'png'],
          'maxFileSize': '5MB',
          'description': 'Upload a clear photo of the data page of your international passport.',
        };
      default:
        return {
          'requiredFields': ['documentNumber'],
          'acceptedFileTypes': ['jpg', 'jpeg', 'png', 'pdf'],
          'maxFileSize': '5MB',
          'description': 'Upload clear photos or scans of your document.',
        };
    }
  }

  // Getters for current state
  List<Document> get allDocuments => List.unmodifiable(_allDocuments);
  DocumentStats? get currentStats => _currentStats;
  DocumentType? get currentFilterType => _currentFilterType;
  DocumentStatus? get currentFilterStatus => _currentFilterStatus;
}
