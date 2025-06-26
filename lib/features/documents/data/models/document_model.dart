import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/document.dart';

part 'document_model.g.dart';

@JsonSerializable()
class DocumentModel extends Document {
  const DocumentModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.status,
    required super.documentNumber,
    super.firstName,
    super.lastName,
    super.middleName,
    super.dateOfBirth,
    super.gender,
    super.address,
    super.phoneNumber,
    super.email,
    required super.fileUrls,
    super.rejectionReason,
    super.expiryDate,
    required super.createdAt,
    required super.updatedAt,
    super.metadata,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: DocumentType.fromCode(json['type'] as String),
      status: DocumentStatus.fromCode(json['status'] as String),
      documentNumber: json['documentNumber'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      middleName: json['middleName'] as String?,
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      fileUrls: (json['fileUrls'] as List<dynamic>).cast<String>(),
      rejectionReason: json['rejectionReason'] as String?,
      expiryDate: json['expiryDate'] != null 
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.code,
      'status': status.code,
      'documentNumber': documentNumber,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'fileUrls': fileUrls,
      'rejectionReason': rejectionReason,
      'expiryDate': expiryDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory DocumentModel.fromEntity(Document document) {
    return DocumentModel(
      id: document.id,
      userId: document.userId,
      type: document.type,
      status: document.status,
      documentNumber: document.documentNumber,
      firstName: document.firstName,
      lastName: document.lastName,
      middleName: document.middleName,
      dateOfBirth: document.dateOfBirth,
      gender: document.gender,
      address: document.address,
      phoneNumber: document.phoneNumber,
      email: document.email,
      fileUrls: document.fileUrls,
      rejectionReason: document.rejectionReason,
      expiryDate: document.expiryDate,
      createdAt: document.createdAt,
      updatedAt: document.updatedAt,
      metadata: document.metadata,
    );
  }

  Document toEntity() {
    return Document(
      id: id,
      userId: userId,
      type: type,
      status: status,
      documentNumber: documentNumber,
      firstName: firstName,
      lastName: lastName,
      middleName: middleName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: address,
      phoneNumber: phoneNumber,
      email: email,
      fileUrls: fileUrls,
      rejectionReason: rejectionReason,
      expiryDate: expiryDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      metadata: metadata,
    );
  }
}

@JsonSerializable()
class DocumentUploadRequestModel {
  final String type;
  final String documentNumber;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? phoneNumber;
  final String? email;
  final List<String> filePaths;
  final String? expiryDate;
  final Map<String, dynamic>? metadata;

  const DocumentUploadRequestModel({
    required this.type,
    required this.documentNumber,
    this.firstName,
    this.lastName,
    this.middleName,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.phoneNumber,
    this.email,
    required this.filePaths,
    this.expiryDate,
    this.metadata,
  });

  factory DocumentUploadRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentUploadRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentUploadRequestModelToJson(this);

  factory DocumentUploadRequestModel.fromEntity(DocumentUploadRequest request) {
    return DocumentUploadRequestModel(
      type: request.type.code,
      documentNumber: request.documentNumber,
      firstName: request.firstName,
      lastName: request.lastName,
      middleName: request.middleName,
      dateOfBirth: request.dateOfBirth?.toIso8601String(),
      gender: request.gender,
      address: request.address,
      phoneNumber: request.phoneNumber,
      email: request.email,
      filePaths: request.filePaths,
      expiryDate: request.expiryDate?.toIso8601String(),
      metadata: request.metadata,
    );
  }
}

@JsonSerializable()
class DocumentStatsModel extends DocumentStats {
  const DocumentStatsModel({
    required super.totalDocuments,
    required super.pendingDocuments,
    required super.inReviewDocuments,
    required super.approvedDocuments,
    required super.rejectedDocuments,
    required super.expiredDocuments,
  });

  factory DocumentStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentStatsModelToJson(this);

  DocumentStats toEntity() {
    return DocumentStats(
      totalDocuments: totalDocuments,
      pendingDocuments: pendingDocuments,
      inReviewDocuments: inReviewDocuments,
      approvedDocuments: approvedDocuments,
      rejectedDocuments: rejectedDocuments,
      expiredDocuments: expiredDocuments,
    );
  }
}
