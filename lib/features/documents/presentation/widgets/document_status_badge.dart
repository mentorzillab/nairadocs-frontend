import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/document.dart';

class DocumentStatusBadge extends StatelessWidget {
  final DocumentStatus status;
  final double? fontSize;
  final EdgeInsets? padding;

  const DocumentStatusBadge({
    super.key,
    required this.status,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            size: (fontSize ?? 12) + 2,
            color: _getStatusColor(status),
          ),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: fontSize ?? 12,
              fontWeight: FontWeight.w600,
              color: _getStatusColor(status),
            ),
          ),
        ],
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

  IconData _getStatusIcon(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.approved:
        return Icons.check_circle;
      case DocumentStatus.rejected:
        return Icons.cancel;
      case DocumentStatus.inReview:
        return Icons.rate_review;
      case DocumentStatus.expired:
        return Icons.error;
      default:
        return Icons.schedule;
    }
  }
}
