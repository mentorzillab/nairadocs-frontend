import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/document.dart';

class DocumentFilterChips extends StatelessWidget {
  final DocumentType? selectedType;
  final DocumentStatus? selectedStatus;
  final Function(DocumentType?) onTypeSelected;
  final Function(DocumentStatus?) onStatusSelected;

  const DocumentFilterChips({
    super.key,
    this.selectedType,
    this.selectedStatus,
    required this.onTypeSelected,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Type filters
        const Text(
          'Filter by Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // All types chip
              _buildFilterChip(
                label: 'All',
                isSelected: selectedType == null,
                onTap: () => onTypeSelected(null),
              ),
              const SizedBox(width: 8),
              
              // Individual type chips
              ...DocumentType.values.map((type) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildFilterChip(
                  label: type.displayName,
                  isSelected: selectedType == type,
                  onTap: () => onTypeSelected(type),
                ),
              )),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Status filters
        const Text(
          'Filter by Status',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // All statuses chip
              _buildFilterChip(
                label: 'All',
                isSelected: selectedStatus == null,
                onTap: () => onStatusSelected(null),
              ),
              const SizedBox(width: 8),
              
              // Individual status chips
              ...DocumentStatus.values.map((status) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildFilterChip(
                  label: status.displayName,
                  isSelected: selectedStatus == status,
                  onTap: () => onStatusSelected(status),
                  color: _getStatusColor(status),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final chipColor = color ?? AppColors.primary;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.transparent,
          border: Border.all(
            color: isSelected ? chipColor : AppColors.lightText.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.darkText,
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
}
