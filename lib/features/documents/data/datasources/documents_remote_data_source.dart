import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/document_model.dart';
import '../../domain/entities/document.dart';

abstract class DocumentsRemoteDataSource {
  Future<DocumentModel> uploadDocument(DocumentUploadRequestModel request);
  Future<List<DocumentModel>> getUserDocuments();
  Future<DocumentModel> getDocumentById(String documentId);
  Future<List<DocumentModel>> getDocumentsByType(DocumentType type);
  Future<List<DocumentModel>> getDocumentsByStatus(DocumentStatus status);
  Future<DocumentModel> updateDocument(String documentId, Map<String, dynamic> updates);
  Future<void> deleteDocument(String documentId);
  Future<DocumentStatsModel> getDocumentStats();
  Future<List<DocumentModel>> searchDocuments({
    String? query,
    DocumentType? type,
    DocumentStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
    int? offset,
  });
  Future<DocumentModel> resubmitDocument(String documentId, DocumentUploadRequestModel request);
  Future<List<String>> downloadDocumentFiles(String documentId);
  Future<DocumentModel> checkVerificationStatus(String documentId);
  Future<List<DocumentType>> getSupportedDocumentTypes();
  Future<bool> validateDocumentNumber(DocumentType type, String documentNumber);
  Future<Map<String, dynamic>> getDocumentRequirements(DocumentType type);
}

@LazySingleton(as: DocumentsRemoteDataSource)
class DocumentsRemoteDataSourceImpl implements DocumentsRemoteDataSource {
  final Dio dio;

  DocumentsRemoteDataSourceImpl(this.dio);

  @override
  Future<DocumentModel> uploadDocument(DocumentUploadRequestModel request) async {
    try {
      final formData = FormData();
      
      // Add document data
      formData.fields.addAll([
        MapEntry('type', request.type),
        MapEntry('documentNumber', request.documentNumber),
        if (request.firstName != null) MapEntry('firstName', request.firstName!),
        if (request.lastName != null) MapEntry('lastName', request.lastName!),
        if (request.middleName != null) MapEntry('middleName', request.middleName!),
        if (request.dateOfBirth != null) MapEntry('dateOfBirth', request.dateOfBirth!),
        if (request.gender != null) MapEntry('gender', request.gender!),
        if (request.address != null) MapEntry('address', request.address!),
        if (request.phoneNumber != null) MapEntry('phoneNumber', request.phoneNumber!),
        if (request.email != null) MapEntry('email', request.email!),
        if (request.expiryDate != null) MapEntry('expiryDate', request.expiryDate!),
      ]);

      // Add files
      for (int i = 0; i < request.filePaths.length; i++) {
        final file = await MultipartFile.fromFile(
          request.filePaths[i],
          filename: 'document_$i.jpg',
        );
        formData.files.add(MapEntry('files', file));
      }

      final response = await dio.post('/documents', data: formData);

      if (response.statusCode == 201) {
        return DocumentModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to upload document: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ValidationException(e.response?.data['message'] ?? 'Invalid document data');
      } else if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Authentication required');
      } else {
        throw ServerException(e.message ?? 'Failed to upload document');
      }
    }
  }

  @override
  Future<List<DocumentModel>> getUserDocuments() async {
    try {
      final response = await dio.get('/documents');

      if (response.statusCode == 200) {
        final List<dynamic> documentsJson = response.data['data'];
        return documentsJson.map((json) => DocumentModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get documents: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Authentication required');
      } else {
        throw ServerException(e.message ?? 'Failed to get documents');
      }
    }
  }

  @override
  Future<DocumentModel> getDocumentById(String documentId) async {
    try {
      final response = await dio.get('/documents/$documentId');

      if (response.statusCode == 200) {
        return DocumentModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to get document: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('Document not found');
      } else if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Authentication required');
      } else {
        throw ServerException(e.message ?? 'Failed to get document');
      }
    }
  }

  @override
  Future<List<DocumentModel>> getDocumentsByType(DocumentType type) async {
    try {
      final response = await dio.get('/documents', queryParameters: {
        'type': type.code,
      });

      if (response.statusCode == 200) {
        final List<dynamic> documentsJson = response.data['data'];
        return documentsJson.map((json) => DocumentModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get documents: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to get documents by type');
    }
  }

  @override
  Future<List<DocumentModel>> getDocumentsByStatus(DocumentStatus status) async {
    try {
      final response = await dio.get('/documents', queryParameters: {
        'status': status.code,
      });

      if (response.statusCode == 200) {
        final List<dynamic> documentsJson = response.data['data'];
        return documentsJson.map((json) => DocumentModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get documents: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to get documents by status');
    }
  }

  @override
  Future<DocumentModel> updateDocument(String documentId, Map<String, dynamic> updates) async {
    try {
      final response = await dio.patch('/documents/$documentId', data: updates);

      if (response.statusCode == 200) {
        return DocumentModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to update document: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('Document not found');
      } else if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Authentication required');
      } else {
        throw ServerException(e.message ?? 'Failed to update document');
      }
    }
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    try {
      final response = await dio.delete('/documents/$documentId');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException('Failed to delete document: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('Document not found');
      } else if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Authentication required');
      } else {
        throw ServerException(e.message ?? 'Failed to delete document');
      }
    }
  }

  @override
  Future<DocumentStatsModel> getDocumentStats() async {
    try {
      final response = await dio.get('/documents/stats');

      if (response.statusCode == 200) {
        return DocumentStatsModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to get document stats: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to get document stats');
    }
  }

  @override
  Future<List<DocumentModel>> searchDocuments({
    String? query,
    DocumentType? type,
    DocumentStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (query != null) queryParams['query'] = query;
      if (type != null) queryParams['type'] = type.code;
      if (status != null) queryParams['status'] = status.code;
      if (fromDate != null) queryParams['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await dio.get('/documents/search', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final List<dynamic> documentsJson = response.data['data'];
        return documentsJson.map((json) => DocumentModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to search documents: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to search documents');
    }
  }

  @override
  Future<DocumentModel> resubmitDocument(String documentId, DocumentUploadRequestModel request) async {
    try {
      final formData = FormData();

      // Add document data
      formData.fields.addAll([
        MapEntry('type', request.type),
        MapEntry('documentNumber', request.documentNumber),
        if (request.firstName != null) MapEntry('firstName', request.firstName!),
        if (request.lastName != null) MapEntry('lastName', request.lastName!),
        if (request.middleName != null) MapEntry('middleName', request.middleName!),
        if (request.dateOfBirth != null) MapEntry('dateOfBirth', request.dateOfBirth!),
        if (request.gender != null) MapEntry('gender', request.gender!),
        if (request.address != null) MapEntry('address', request.address!),
        if (request.phoneNumber != null) MapEntry('phoneNumber', request.phoneNumber!),
        if (request.email != null) MapEntry('email', request.email!),
        if (request.expiryDate != null) MapEntry('expiryDate', request.expiryDate!),
      ]);

      // Add files
      for (int i = 0; i < request.filePaths.length; i++) {
        final file = await MultipartFile.fromFile(
          request.filePaths[i],
          filename: 'document_$i.jpg',
        );
        formData.files.add(MapEntry('files', file));
      }

      final response = await dio.post('/documents/$documentId/resubmit', data: formData);

      if (response.statusCode == 200) {
        return DocumentModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to resubmit document: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('Document not found');
      } else if (e.response?.statusCode == 400) {
        throw ValidationException(e.response?.data['message'] ?? 'Invalid document data');
      } else {
        throw ServerException(e.message ?? 'Failed to resubmit document');
      }
    }
  }

  @override
  Future<List<String>> downloadDocumentFiles(String documentId) async {
    try {
      final response = await dio.get('/documents/$documentId/files');

      if (response.statusCode == 200) {
        final List<dynamic> filesJson = response.data['data'];
        return filesJson.cast<String>();
      } else {
        throw ServerException('Failed to get document files: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('Document not found');
      } else {
        throw ServerException(e.message ?? 'Failed to get document files');
      }
    }
  }

  @override
  Future<DocumentModel> checkVerificationStatus(String documentId) async {
    try {
      final response = await dio.get('/documents/$documentId/status');

      if (response.statusCode == 200) {
        return DocumentModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to check verification status: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('Document not found');
      } else {
        throw ServerException(e.message ?? 'Failed to check verification status');
      }
    }
  }

  @override
  Future<List<DocumentType>> getSupportedDocumentTypes() async {
    try {
      final response = await dio.get('/documents/types');

      if (response.statusCode == 200) {
        final List<dynamic> typesJson = response.data['data'];
        return typesJson.map((typeCode) => DocumentType.fromCode(typeCode as String)).toList();
      } else {
        throw ServerException('Failed to get supported document types: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to get supported document types');
    }
  }

  @override
  Future<bool> validateDocumentNumber(DocumentType type, String documentNumber) async {
    try {
      final response = await dio.post('/documents/validate', data: {
        'type': type.code,
        'documentNumber': documentNumber,
      });

      if (response.statusCode == 200) {
        return response.data['data']['isValid'] as bool;
      } else {
        throw ServerException('Failed to validate document number: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to validate document number');
    }
  }

  @override
  Future<Map<String, dynamic>> getDocumentRequirements(DocumentType type) async {
    try {
      final response = await dio.get('/documents/requirements/${type.code}');

      if (response.statusCode == 200) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw ServerException('Failed to get document requirements: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to get document requirements');
    }
  }
}
