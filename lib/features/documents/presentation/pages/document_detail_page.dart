import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/document.dart';
import '../bloc/documents_bloc.dart';
import '../bloc/documents_event.dart';
import '../bloc/documents_state.dart';
import '../widgets/document_status_badge.dart';
import '../widgets/document_file_viewer.dart';

class DocumentDetailPage extends StatefulWidget {
  final Document document;

  const DocumentDetailPage({
    super.key,
    required this.document,
  });

  @override
  State<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends State<DocumentDetailPage> {
  late Document _document;

  @override
  void initState() {
    super.initState();
    _document = widget.document;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_document.type.displayName),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkText,
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 18),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 18),
                    SizedBox(width: 8),
                    Text('Download'),
                  ],
                ),
              ),
              if (_document.status == DocumentStatus.rejected)
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
          ),
        ],
      ),
      body: BlocListener<DocumentsBloc, DocumentsState>(
        listener: (context, state) {
          if (state is DocumentDeleteSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Document deleted successfully')),
            );
          } else if (state is DocumentsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Document header
              _buildDocumentHeader(),
              const SizedBox(height: 24),

              // Document information
              _buildDocumentInfo(),
              const SizedBox(height: 24),

              // Document files
              _buildDocumentFiles(),
              const SizedBox(height: 24),

              // Status timeline
              _buildStatusTimeline(),
              const SizedBox(height: 24),

              // Actions
              _buildActionButtons(),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getDocumentIcon(_document.type),
                  size: 32,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _document.type.displayName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _document.documentNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
                ),
                DocumentStatusBadge(status: _document.status),
              ],
            ),
            
            if (_document.fullName.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.person, size: 20, color: AppColors.lightText),
                  const SizedBox(width: 8),
                  Text(
                    _document.fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkText,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentInfo() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Document Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildInfoRow('Document Number', _document.documentNumber),
            
            if (_document.dateOfBirth != null)
              _buildInfoRow(
                'Date of Birth',
                '${_document.dateOfBirth!.day}/${_document.dateOfBirth!.month}/${_document.dateOfBirth!.year}',
              ),
            
            if (_document.expiryDate != null)
              _buildInfoRow(
                'Expiry Date',
                '${_document.expiryDate!.day}/${_document.expiryDate!.month}/${_document.expiryDate!.year}',
              ),
            
            _buildInfoRow(
              'Uploaded',
              '${_document.createdAt.day}/${_document.createdAt.month}/${_document.createdAt.year}',
            ),
            
            _buildInfoRow(
              'Last Updated',
              '${_document.updatedAt.day}/${_document.updatedAt.month}/${_document.updatedAt.year}',
            ),
            
            if (_document.rejectionReason != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Rejection Reason',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _document.rejectionReason!,
                      style: TextStyle(
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.lightText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.darkText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentFiles() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Document Files',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 16),
            
            if (_document.fileUrls.isNotEmpty) ...[
              ...(_document.fileUrls.asMap().entries.map((entry) {
                final index = entry.key;
                final fileUrl = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DocumentFileViewer(
                    fileUrl: fileUrl,
                    fileName: 'Document ${index + 1}',
                  ),
                );
              }).toList()),
            ] else ...[
              const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.insert_drive_file,
                      size: 48,
                      color: AppColors.lightText,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No files available',
                      style: TextStyle(
                        color: AppColors.lightText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Timeline',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 16),
            
            // Timeline items
            _buildTimelineItem(
              'Document Uploaded',
              _document.createdAt,
              Icons.upload_file,
              AppColors.primary,
              isCompleted: true,
            ),
            
            _buildTimelineItem(
              'Under Review',
              _document.createdAt.add(const Duration(hours: 1)),
              Icons.rate_review,
              AppColors.inReview,
              isCompleted: _document.status != DocumentStatus.pending,
            ),
            
            if (_document.status == DocumentStatus.approved)
              _buildTimelineItem(
                'Approved',
                _document.updatedAt,
                Icons.check_circle,
                AppColors.approved,
                isCompleted: true,
                isLast: true,
              )
            else if (_document.status == DocumentStatus.rejected)
              _buildTimelineItem(
                'Rejected',
                _document.updatedAt,
                Icons.cancel,
                AppColors.rejected,
                isCompleted: true,
                isLast: true,
              )
            else
              _buildTimelineItem(
                'Pending Approval',
                null,
                Icons.schedule,
                AppColors.pending,
                isCompleted: false,
                isLast: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    DateTime? date,
    IconData icon,
    Color color,
    {required bool isCompleted, bool isLast = false}
  ) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted ? color : color.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              if (date != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightText,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (_document.status == DocumentStatus.rejected) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _resubmitDocument,
              icon: const Icon(Icons.refresh),
              label: const Text('Resubmit Document'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _downloadDocument,
                icon: const Icon(Icons.download),
                label: const Text('Download'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _shareDocument,
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
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

  void _handleMenuAction(String action) {
    switch (action) {
      case 'share':
        _shareDocument();
        break;
      case 'download':
        _downloadDocument();
        break;
      case 'resubmit':
        _resubmitDocument();
        break;
      case 'delete':
        _showDeleteConfirmation();
        break;
    }
  }

  void _shareDocument() {
    Share.share(
      'Check out my ${_document.type.displayName} verification status on N-Docs',
      subject: 'Document Verification - ${_document.type.displayName}',
    );
  }

  void _downloadDocument() {
    context.read<DocumentsBloc>().add(
      DocumentFilesDownloadRequested(documentId: _document.id),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download started...')),
    );
  }

  void _resubmitDocument() {
    // Navigate to resubmit page or show resubmit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resubmit functionality not implemented yet')),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text(
          'Are you sure you want to delete this ${_document.type.displayName}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<DocumentsBloc>().add(
                DocumentDeleteRequested(documentId: _document.id),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
