// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
      filePaths: (json['filePaths'] as List<dynamic>).cast<String>(),
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
      totalDocuments: json['totalDocuments'] as int,
      pendingDocuments: json['pendingDocuments'] as int,
      inReviewDocuments: json['inReviewDocuments'] as int,
      approvedDocuments: json['approvedDocuments'] as int,
      rejectedDocuments: json['rejectedDocuments'] as int,
      expiredDocuments: json['expiredDocuments'] as int,
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
