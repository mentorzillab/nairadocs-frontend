import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/document_model.dart';
import '../../domain/entities/document.dart';

abstract class DocumentsLocalDataSource {
  Future<void> cacheDocuments(List<DocumentModel> documents);
  Future<List<DocumentModel>> getCachedDocuments();
  Future<void> cacheDocument(DocumentModel document);
  Future<DocumentModel?> getCachedDocument(String documentId);
  Future<void> removeCachedDocument(String documentId);
  Future<void> clearCache();
  Future<void> cacheDocumentStats(DocumentStatsModel stats);
  Future<DocumentStatsModel?> getCachedDocumentStats();
  Future<void> cacheDocumentsByType(DocumentType type, List<DocumentModel> documents);
  Future<List<DocumentModel>?> getCachedDocumentsByType(DocumentType type);
  Future<void> cacheDocumentsByStatus(DocumentStatus status, List<DocumentModel> documents);
  Future<List<DocumentModel>?> getCachedDocumentsByStatus(DocumentStatus status);
}

@LazySingleton(as: DocumentsLocalDataSource)
class DocumentsLocalDataSourceImpl implements DocumentsLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _documentsKey = 'cached_documents';
  static const String _documentStatsKey = 'cached_document_stats';
  static const String _documentsByTypePrefix = 'cached_documents_type_';
  static const String _documentsByStatusPrefix = 'cached_documents_status_';
  static const String _singleDocumentPrefix = 'cached_document_';

  DocumentsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheDocuments(List<DocumentModel> documents) async {
    try {
      final documentsJson = documents.map((doc) => doc.toJson()).toList();
      final jsonString = jsonEncode(documentsJson);
      await sharedPreferences.setString(_documentsKey, jsonString);
      
      // Also cache individual documents for quick access
      for (final document in documents) {
        await cacheDocument(document);
      }
    } catch (e) {
      throw CacheException('Failed to cache documents: $e');
    }
  }

  @override
  Future<List<DocumentModel>> getCachedDocuments() async {
    try {
      final jsonString = sharedPreferences.getString(_documentsKey);
      if (jsonString != null) {
        final List<dynamic> documentsJson = jsonDecode(jsonString);
        return documentsJson.map((json) => DocumentModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached documents: $e');
    }
  }

  @override
  Future<void> cacheDocument(DocumentModel document) async {
    try {
      final jsonString = jsonEncode(document.toJson());
      await sharedPreferences.setString('$_singleDocumentPrefix${document.id}', jsonString);
    } catch (e) {
      throw CacheException('Failed to cache document: $e');
    }
  }

  @override
  Future<DocumentModel?> getCachedDocument(String documentId) async {
    try {
      final jsonString = sharedPreferences.getString('$_singleDocumentPrefix$documentId');
      if (jsonString != null) {
        final documentJson = jsonDecode(jsonString) as Map<String, dynamic>;
        return DocumentModel.fromJson(documentJson);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached document: $e');
    }
  }

  @override
  Future<void> removeCachedDocument(String documentId) async {
    try {
      await sharedPreferences.remove('$_singleDocumentPrefix$documentId');
      
      // Also remove from main documents cache
      final cachedDocuments = await getCachedDocuments();
      final updatedDocuments = cachedDocuments.where((doc) => doc.id != documentId).toList();
      await cacheDocuments(updatedDocuments);
    } catch (e) {
      throw CacheException('Failed to remove cached document: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final keys = sharedPreferences.getKeys();
      final documentKeys = keys.where((key) => 
        key.startsWith(_documentsKey) ||
        key.startsWith(_documentStatsKey) ||
        key.startsWith(_documentsByTypePrefix) ||
        key.startsWith(_documentsByStatusPrefix) ||
        key.startsWith(_singleDocumentPrefix)
      ).toList();
      
      for (final key in documentKeys) {
        await sharedPreferences.remove(key);
      }
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  @override
  Future<void> cacheDocumentStats(DocumentStatsModel stats) async {
    try {
      final jsonString = jsonEncode(stats.toJson());
      await sharedPreferences.setString(_documentStatsKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache document stats: $e');
    }
  }

  @override
  Future<DocumentStatsModel?> getCachedDocumentStats() async {
    try {
      final jsonString = sharedPreferences.getString(_documentStatsKey);
      if (jsonString != null) {
        final statsJson = jsonDecode(jsonString) as Map<String, dynamic>;
        return DocumentStatsModel.fromJson(statsJson);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached document stats: $e');
    }
  }

  @override
  Future<void> cacheDocumentsByType(DocumentType type, List<DocumentModel> documents) async {
    try {
      final documentsJson = documents.map((doc) => doc.toJson()).toList();
      final jsonString = jsonEncode(documentsJson);
      await sharedPreferences.setString('$_documentsByTypePrefix${type.code}', jsonString);
    } catch (e) {
      throw CacheException('Failed to cache documents by type: $e');
    }
  }

  @override
  Future<List<DocumentModel>?> getCachedDocumentsByType(DocumentType type) async {
    try {
      final jsonString = sharedPreferences.getString('$_documentsByTypePrefix${type.code}');
      if (jsonString != null) {
        final List<dynamic> documentsJson = jsonDecode(jsonString);
        return documentsJson.map((json) => DocumentModel.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached documents by type: $e');
    }
  }

  @override
  Future<void> cacheDocumentsByStatus(DocumentStatus status, List<DocumentModel> documents) async {
    try {
      final documentsJson = documents.map((doc) => doc.toJson()).toList();
      final jsonString = jsonEncode(documentsJson);
      await sharedPreferences.setString('$_documentsByStatusPrefix${status.code}', jsonString);
    } catch (e) {
      throw CacheException('Failed to cache documents by status: $e');
    }
  }

  @override
  Future<List<DocumentModel>?> getCachedDocumentsByStatus(DocumentStatus status) async {
    try {
      final jsonString = sharedPreferences.getString('$_documentsByStatusPrefix${status.code}');
      if (jsonString != null) {
        final List<dynamic> documentsJson = jsonDecode(jsonString);
        return documentsJson.map((json) => DocumentModel.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached documents by status: $e');
    }
  }
}
