import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/document.dart';

class DocumentStatsCard extends StatelessWidget {
  final DocumentStats stats;

  const DocumentStatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Document Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 16),
            
            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    label: 'Total',
                    value: stats.totalDocuments.toString(),
                    color: AppColors.primary,
                    icon: Icons.description,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    label: 'Approved',
                    value: stats.approvedDocuments.toString(),
                    color: AppColors.approved,
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    label: 'Pending',
                    value: stats.pendingDocuments.toString(),
                    color: AppColors.pending,
                    icon: Icons.schedule,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    label: 'In Review',
                    value: stats.inReviewDocuments.toString(),
                    color: AppColors.inReview,
                    icon: Icons.rate_review,
                  ),
                ),
              ],
            ),
            
            if (stats.rejectedDocuments > 0 || stats.expiredDocuments > 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (stats.rejectedDocuments > 0)
                    Expanded(
                      child: _buildStatItem(
                        label: 'Rejected',
                        value: stats.rejectedDocuments.toString(),
                        color: AppColors.rejected,
                        icon: Icons.cancel,
                      ),
                    ),
                  if (stats.rejectedDocuments > 0 && stats.expiredDocuments > 0)
                    const SizedBox(width: 12),
                  if (stats.expiredDocuments > 0)
                    Expanded(
                      child: _buildStatItem(
                        label: 'Expired',
                        value: stats.expiredDocuments.toString(),
                        color: Colors.orange,
                        icon: Icons.error,
                      ),
                    ),
                  if (stats.rejectedDocuments == 0 || stats.expiredDocuments == 0)
                    const Expanded(child: SizedBox()),
                ],
              ),
            ],
            
            // Progress indicator
            if (stats.totalDocuments > 0) ...[
              const SizedBox(height: 16),
              _buildProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final approvalRate = stats.totalDocuments > 0 
        ? stats.approvedDocuments / stats.totalDocuments 
        : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Approval Rate',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.darkText,
              ),
            ),
            Text(
              '${(approvalRate * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: approvalRate >= 0.8 ? AppColors.approved : 
                       approvalRate >= 0.5 ? AppColors.inReview : AppColors.rejected,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: approvalRate,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            approvalRate >= 0.8 ? AppColors.approved : 
            approvalRate >= 0.5 ? AppColors.inReview : AppColors.rejected,
          ),
          minHeight: 6,
        ),
      ],
    );
  }
}
