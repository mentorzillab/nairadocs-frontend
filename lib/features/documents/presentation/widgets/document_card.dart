import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/document.dart';

class DocumentCard extends StatelessWidget {
  final Document document;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onResubmit;

  const DocumentCard({
    super.key,
    required this.document,
    this.onTap,
    this.onDelete,
    this.onResubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Document type icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getStatusColor(document.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getDocumentIcon(document.type),
                      color: _getStatusColor(document.status),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Document info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.type.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          document.documentNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.lightText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(document.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      document.status.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(document.status),
                      ),
                    ),
                  ),
                  
                  // More options
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'delete':
                          onDelete?.call();
                          break;
                        case 'resubmit':
                          onResubmit?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (document.status == DocumentStatus.rejected && onResubmit != null)
                        const PopupMenuItem(
                          value: 'resubmit',
                          child: Row(
                            children: [
                              Icon(Icons.refresh, size: 18),
                              SizedBox(width: 8),
                              Text('Resubmit'),
                            ],
                          ),
                        ),
                      if (onDelete != null)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                    ],
                    child: const Icon(
                      Icons.more_vert,
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Additional info
              if (document.fullName.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: AppColors.lightText),
                    const SizedBox(width: 8),
                    Text(
                      document.fullName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              
              // Upload date
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: AppColors.lightText),
                  const SizedBox(width: 8),
                  Text(
                    'Uploaded ${_formatDate(document.createdAt)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
              
              // Expiry warning
              if (document.isExpiringSoon) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        'Expires soon',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (document.isExpired) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        'Expired',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              // Rejection reason
              if (document.status == DocumentStatus.rejected && document.rejectionReason != null) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rejection Reason:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        document.rejectionReason!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.approved:
        return AppColors.approved;
      case DocumentStatus.rejected:
        return AppColors.rejected;
      case DocumentStatus.inReview:
        return AppColors.inReview;
      case DocumentStatus.expired:
        return Colors.orange;
      default:
        return AppColors.pending;
    }
  }

  IconData _getDocumentIcon(DocumentType type) {
    switch (type) {
      case DocumentType.nin:
        return Icons.badge;
      case DocumentType.bvn:
        return Icons.account_balance;
      case DocumentType.driversLicense:
        return Icons.drive_eta;
      case DocumentType.passport:
        return Icons.flight;
      case DocumentType.waec:
      case DocumentType.jamb:
        return Icons.school;
      default:
        return Icons.description;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
