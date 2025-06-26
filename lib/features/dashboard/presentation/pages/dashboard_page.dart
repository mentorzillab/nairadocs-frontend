import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../documents/presentation/bloc/documents_bloc.dart';
import '../../../documents/presentation/bloc/documents_event.dart';
import '../../../documents/presentation/bloc/documents_state.dart';
import '../../../documents/presentation/pages/documents_list_page.dart';
import '../../../documents/presentation/pages/document_upload_page.dart';
import '../../../documents/presentation/widgets/document_card.dart';
import '../../../documents/domain/entities/document.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load documents and stats when dashboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentsBloc>().add(const DocumentsLoadRequested());
      context.read<DocumentsBloc>().add(const DocumentsStatsLoadRequested());
    });
  }

  Widget statusCard(String label, String value, {Color? color, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor ?? AppColors.darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: (textColor ?? AppColors.darkText).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget activityTile(String title, String status, Color statusColor) {
    return ListTile(
      title: Text(title),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          status,
          style: TextStyle(color: statusColor)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DocumentsBloc>().add(const DocumentsRefreshRequested());
          context.read<DocumentsBloc>().add(const DocumentsStatsLoadRequested());
        },
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final userName = state is AuthAuthenticated
                        ? state.user.firstName ?? 'User'
                        : 'User';
                    return Text(
                      'Hi, $userName',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    );
                  },
                ),
                titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<DocumentsBloc>().add(const DocumentsRefreshRequested());
                  },
                  icon: const Icon(Icons.refresh, color: AppColors.darkText),
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to profile
                  },
                  icon: const Icon(Icons.person, color: AppColors.darkText),
                ),
              ],
            ),

            // Stats section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: BlocBuilder<DocumentsBloc, DocumentsState>(
                  builder: (context, state) {
                    if (state is DocumentsLoaded && state.stats != null) {
                      return _buildStatsSection(state.stats!);
                    } else if (state is DocumentsLoading) {
                      return const SizedBox(
                        height: 120,
                        child: Center(child: LoadingWidget()),
                      );
                    } else {
                      // Show default stats
                      return _buildDefaultStatsSection();
                    }
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Quick actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildQuickActions(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Recent documents section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Documents',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DocumentsListPage(),
                          ),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
            ),

            // Recent documents list
            BlocBuilder<DocumentsBloc, DocumentsState>(
              builder: (context, state) {
                if (state is DocumentsLoaded) {
                  final recentDocuments = state.documents.take(3).toList();

                  if (recentDocuments.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: _buildEmptyDocumentsState(),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final document = recentDocuments[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                          child: DocumentCard(
                            document: document,
                            onTap: () => _navigateToDocumentDetail(document),
                          ),
                        );
                      },
                      childCount: recentDocuments.length,
                    ),
                  );
                } else if (state is DocumentsLoading) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                        child: LoadingCard(height: 120),
                      ),
                      childCount: 3,
                    ),
                  );
                } else if (state is DocumentsError) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ErrorWidget(
                        message: state.message,
                        onRetry: () {
                          context.read<DocumentsBloc>().add(const DocumentsLoadRequested());
                        },
                      ),
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: _buildEmptyDocumentsState(),
                    ),
                  );
                }
              },
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(DocumentStats stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: statusCard(
                "Total",
                stats.totalDocuments.toString(),
                color: AppColors.primary.withOpacity(0.1),
                textColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: statusCard(
                "Approved",
                stats.approvedDocuments.toString(),
                color: AppColors.approved.withOpacity(0.1),
                textColor: AppColors.approved,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: statusCard(
                "In Review",
                stats.inReviewDocuments.toString(),
                color: AppColors.inReview.withOpacity(0.1),
                textColor: AppColors.inReview,
              ),
            ),
          ],
        ),
        if (stats.rejectedDocuments > 0 || stats.pendingDocuments > 0) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              if (stats.pendingDocuments > 0)
                Expanded(
                  child: statusCard(
                    "Pending",
                    stats.pendingDocuments.toString(),
                    color: AppColors.pending.withOpacity(0.1),
                    textColor: AppColors.pending,
                  ),
                ),
              if (stats.pendingDocuments > 0 && stats.rejectedDocuments > 0)
                const SizedBox(width: 8),
              if (stats.rejectedDocuments > 0)
                Expanded(
                  child: statusCard(
                    "Rejected",
                    stats.rejectedDocuments.toString(),
                    color: AppColors.rejected.withOpacity(0.1),
                    textColor: AppColors.rejected,
                  ),
                ),
              if (stats.pendingDocuments == 0 || stats.rejectedDocuments == 0)
                const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultStatsSection() {
    return Row(
      children: [
        Expanded(
          child: statusCard(
            "Total",
            "0",
            color: AppColors.primary.withOpacity(0.1),
            textColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: statusCard(
            "Approved",
            "0",
            color: AppColors.approved.withOpacity(0.1),
            textColor: AppColors.approved,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: statusCard(
            "Pending",
            "0",
            color: AppColors.pending.withOpacity(0.1),
            textColor: AppColors.pending,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Upload Document',
                subtitle: 'Add new document',
                icon: Icons.upload_file,
                color: AppColors.primary,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DocumentUploadPage(),
                    ),
                  ).then((result) {
                    if (result != null) {
                      context.read<DocumentsBloc>().add(const DocumentsRefreshRequested());
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                title: 'View All',
                subtitle: 'See all documents',
                icon: Icons.list_alt,
                color: AppColors.inReview,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DocumentsListPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyDocumentsState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.description_outlined,
            size: 48,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Documents Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start by uploading your first document for verification',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.lightText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DocumentUploadPage(),
                ),
              ).then((result) {
                if (result != null) {
                  context.read<DocumentsBloc>().add(const DocumentsRefreshRequested());
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Upload Document'),
          ),
        ],
      ),
    );
  }

  void _navigateToDocumentDetail(Document document) {
    // Navigate to document detail - for now just show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(document.type.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Document Number: ${document.documentNumber}'),
            const SizedBox(height: 8),
            Text('Status: ${document.status.displayName}'),
            if (document.fullName.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Name: ${document.fullName}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
