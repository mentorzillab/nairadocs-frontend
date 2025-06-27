// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    DocumentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$DocumentTypeEnumMap, json['type']),
      status: $enumDecode(_$DocumentStatusEnumMap, json['status']),
      documentNumber: json['documentNumber'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      middleName: json['middleName'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      fileUrls:
          (json['fileUrls'] as List<dynamic>).map((e) => e as String).toList(),
      rejectionReason: json['rejectionReason'] as String?,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DocumentModelToJson(DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$DocumentTypeEnumMap[instance.type]!,
      'status': _$DocumentStatusEnumMap[instance.status]!,
      'documentNumber': instance.documentNumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'fileUrls': instance.fileUrls,
      'rejectionReason': instance.rejectionReason,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$DocumentTypeEnumMap = {
  DocumentType.nin: 'nin',
  DocumentType.bvn: 'bvn',
  DocumentType.waec: 'waec',
  DocumentType.jamb: 'jamb',
  DocumentType.driversLicense: 'driversLicense',
  DocumentType.passport: 'passport',
};

const _$DocumentStatusEnumMap = {
  DocumentStatus.pending: 'pending',
  DocumentStatus.inReview: 'inReview',
  DocumentStatus.approved: 'approved',
  DocumentStatus.rejected: 'rejected',
  DocumentStatus.expired: 'expired',
};

DocumentUploadRequestModel _$DocumentUploadRequestModelFromJson(
        Map<String, dynamic> json) =>
    DocumentUploadRequestModel(
      type: json['type'] as String,
      documentNumber: json['documentNumber'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      middleName: json['middleName'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      filePaths:
          (json['filePaths'] as List<dynamic>).map((e) => e as String).toList(),
      expiryDate: json['expiryDate'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DocumentUploadRequestModelToJson(
        DocumentUploadRequestModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'documentNumber': instance.documentNumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'dateOfBirth': instance.dateOfBirth,
      'gender': instance.gender,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'filePaths': instance.filePaths,
      'expiryDate': instance.expiryDate,
      'metadata': instance.metadata,
    };

DocumentStatsModel _$DocumentStatsModelFromJson(Map<String, dynamic> json) =>
    DocumentStatsModel(
      totalDocuments: (json['totalDocuments'] as num).toInt(),
      pendingDocuments: (json['pendingDocuments'] as num).toInt(),
      inReviewDocuments: (json['inReviewDocuments'] as num).toInt(),
      approvedDocuments: (json['approvedDocuments'] as num).toInt(),
      rejectedDocuments: (json['rejectedDocuments'] as num).toInt(),
      expiredDocuments: (json['expiredDocuments'] as num).toInt(),
    );

Map<String, dynamic> _$DocumentStatsModelToJson(DocumentStatsModel instance) =>
    <String, dynamic>{
      'totalDocuments': instance.totalDocuments,
      'pendingDocuments': instance.pendingDocuments,
      'inReviewDocuments': instance.inReviewDocuments,
      'approvedDocuments': instance.approvedDocuments,
      'rejectedDocuments': instance.rejectedDocuments,
      'expiredDocuments': instance.expiredDocuments,
    };
