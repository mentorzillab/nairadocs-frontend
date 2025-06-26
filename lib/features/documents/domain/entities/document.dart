import 'package:equatable/equatable.dart';

enum DocumentType {
  nin('NIN', 'National Identification Number'),
  bvn('BVN', 'Bank Verification Number'),
  waec('WAEC', 'WAEC Certificate'),
  jamb('JAMB', 'JAMB Result'),
  driversLicense('DRIVERS_LICENSE', "Driver's License"),
  passport('PASSPORT', 'International Passport');

  const DocumentType(this.code, this.displayName);
  
  final String code;
  final String displayName;

  static DocumentType fromCode(String code) {
    return DocumentType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => DocumentType.nin,
    );
  }
}

enum DocumentStatus {
  pending('PENDING', 'Pending'),
  inReview('IN_REVIEW', 'In Review'),
  approved('APPROVED', 'Approved'),
  rejected('REJECTED', 'Rejected'),
  expired('EXPIRED', 'Expired');

  const DocumentStatus(this.code, this.displayName);
  
  final String code;
  final String displayName;

  static DocumentStatus fromCode(String code) {
    return DocumentStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => DocumentStatus.pending,
    );
  }
}

class Document extends Equatable {
  final String id;
  final String userId;
  final DocumentType type;
  final DocumentStatus status;
  final String documentNumber;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final String? phoneNumber;
  final String? email;
  final List<String> fileUrls;
  final String? rejectionReason;
  final DateTime? expiryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const Document({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.documentNumber,
    this.firstName,
    this.lastName,
    this.middleName,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.phoneNumber,
    this.email,
    required this.fileUrls,
    this.rejectionReason,
    this.expiryDate,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  String get fullName {
    final parts = [firstName, middleName, lastName]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    return parts.join(' ');
  }

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final now = DateTime.now();
    final daysUntilExpiry = expiryDate!.difference(now).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  Document copyWith({
    String? id,
    String? userId,
    DocumentType? type,
    DocumentStatus? status,
    String? documentNumber,
    String? firstName,
    String? lastName,
    String? middleName,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? phoneNumber,
    String? email,
    List<String>? fileUrls,
    String? rejectionReason,
    DateTime? expiryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Document(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      documentNumber: documentNumber ?? this.documentNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      fileUrls: fileUrls ?? this.fileUrls,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        status,
        documentNumber,
        firstName,
        lastName,
        middleName,
        dateOfBirth,
        gender,
        address,
        phoneNumber,
        email,
        fileUrls,
        rejectionReason,
        expiryDate,
        createdAt,
        updatedAt,
        metadata,
      ];
}

class DocumentUploadRequest extends Equatable {
  final DocumentType type;
  final String documentNumber;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final String? phoneNumber;
  final String? email;
  final List<String> filePaths;
  final DateTime? expiryDate;
  final Map<String, dynamic>? metadata;

  const DocumentUploadRequest({
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

  @override
  List<Object?> get props => [
        type,
        documentNumber,
        firstName,
        lastName,
        middleName,
        dateOfBirth,
        gender,
        address,
        phoneNumber,
        email,
        filePaths,
        expiryDate,
        metadata,
      ];
}

class DocumentStats extends Equatable {
  final int totalDocuments;
  final int pendingDocuments;
  final int inReviewDocuments;
  final int approvedDocuments;
  final int rejectedDocuments;
  final int expiredDocuments;

  const DocumentStats({
    required this.totalDocuments,
    required this.pendingDocuments,
    required this.inReviewDocuments,
    required this.approvedDocuments,
    required this.rejectedDocuments,
    required this.expiredDocuments,
  });

  @override
  List<Object> get props => [
        totalDocuments,
        pendingDocuments,
        inReviewDocuments,
        approvedDocuments,
        rejectedDocuments,
        expiredDocuments,
      ];
}
