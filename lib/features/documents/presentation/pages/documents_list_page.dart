import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../domain/entities/document.dart';
import '../bloc/documents_bloc.dart';
import '../bloc/documents_event.dart';
import '../bloc/documents_state.dart';
import '../widgets/document_card.dart';
import '../widgets/document_filter_chips.dart';
import '../widgets/document_stats_card.dart';
import 'document_upload_page.dart';
import 'document_detail_page.dart';

class DocumentsListPage extends StatefulWidget {
  const DocumentsListPage({super.key});

  @override
  State<DocumentsListPage> createState() => _DocumentsListPageState();
}

class _DocumentsListPageState extends State<DocumentsListPage> {
  @override
  void initState() {
    super.initState();
    // Load documents when page opens
    context.read<DocumentsBloc>().add(const DocumentsLoadRequested());
    context.read<DocumentsBloc>().add(const DocumentsStatsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Documents'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkText,
        actions: [
          IconButton(
            onPressed: () {
              context.read<DocumentsBloc>().add(const DocumentsRefreshRequested());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocListener<DocumentsBloc, DocumentsState>(
        listener: (context, state) {
          if (state is DocumentsError) {
            ErrorSnackBar.show(context, state.message);
          } else if (state is DocumentDeleteSuccess) {
            SuccessSnackBar.show(context, 'Document deleted successfully');
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<DocumentsBloc>().add(const DocumentsRefreshRequested());
          },
          child: CustomScrollView(
            slivers: [
              // Stats section
              SliverToBoxAdapter(
                child: BlocBuilder<DocumentsBloc, DocumentsState>(
                  builder: (context, state) {
                    if (state is DocumentsLoaded && state.stats != null) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DocumentStatsCard(stats: state.stats!),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

              // Filter chips
              SliverToBoxAdapter(
                child: BlocBuilder<DocumentsBloc, DocumentsState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DocumentFilterChips(
                        selectedType: state is DocumentsLoaded ? state.filterType : null,
                        selectedStatus: state is DocumentsLoaded ? state.filterStatus : null,
                        onTypeSelected: (type) {
                          if (type != null) {
                            context.read<DocumentsBloc>().add(
                              DocumentsFilterByTypeRequested(type: type),
                            );
                          } else {
                            context.read<DocumentsBloc>().add(const DocumentsFilterCleared());
                          }
                        },
                        onStatusSelected: (status) {
                          if (status != null) {
                            context.read<DocumentsBloc>().add(
                              DocumentsFilterByStatusRequested(status: status),
                            );
                          } else {
                            context.read<DocumentsBloc>().add(const DocumentsFilterCleared());
                          }
                        },
                      ),
                    );
                  },
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Documents list
              BlocBuilder<DocumentsBloc, DocumentsState>(
                builder: (context, state) {
                  if (state is DocumentsLoading) {
                    return const SliverFillRemaining(
                      child: Center(child: LoadingWidget(message: 'Loading documents...')),
                    );
                  } else if (state is DocumentsRefreshing) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < state.currentDocuments.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                              child: DocumentCard(
                                document: state.currentDocuments[index],
                                onTap: () => _navigateToDocumentDetail(state.currentDocuments[index]),
                                onDelete: () => _showDeleteConfirmation(state.currentDocuments[index]),
                              ),
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: LoadingWidget(size: 20)),
                            );
                          }
                        },
                        childCount: state.currentDocuments.length + 1,
                      ),
                    );
                  } else if (state is DocumentsLoaded) {
                    if (state.documents.isEmpty) {
                      return SliverFillRemaining(
                        child: EmptyStateWidget(
                          title: 'No Documents Found',
                          message: state.filterType != null || state.filterStatus != null
                              ? 'No documents match your current filter. Try adjusting your filters.'
                              : 'You haven\'t uploaded any documents yet. Start by uploading your first document.',
                          icon: Icons.description_outlined,
                          onAction: state.filterType != null || state.filterStatus != null
                              ? () {
                                  context.read<DocumentsBloc>().add(const DocumentsFilterCleared());
                                }
                              : () {
                                  _navigateToUpload();
                                },
                          actionText: state.filterType != null || state.filterStatus != null
                              ? 'Clear Filters'
                              : 'Upload Document',
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final document = state.documents[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: DocumentCard(
                              document: document,
                              onTap: () => _navigateToDocumentDetail(document),
                              onDelete: () => _showDeleteConfirmation(document),
                            ),
                          );
                        },
                        childCount: state.documents.length,
                      ),
                    );
                  } else if (state is DocumentsError) {
                    return SliverFillRemaining(
                      child: ErrorWidget(
                        message: state.message,
                        onRetry: () {
                          context.read<DocumentsBloc>().add(const DocumentsLoadRequested());
                        },
                      ),
                    );
                  } else if (state is DocumentsSearchResults) {
                    if (state.documents.isEmpty) {
                      return const SliverFillRemaining(
                        child: EmptyStateWidget(
                          title: 'No Results Found',
                          message: 'No documents match your search criteria.',
                          icon: Icons.search_off,
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final document = state.documents[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: DocumentCard(
                              document: document,
                              onTap: () => _navigateToDocumentDetail(document),
                              onDelete: () => _showDeleteConfirmation(document),
                            ),
                          );
                        },
                        childCount: state.documents.length,
                      ),
                    );
                  }

                  return const SliverFillRemaining(
                    child: Center(child: Text('Unknown state')),
                  );
                },
              ),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToUpload,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Upload'),
      ),
    );
  }

  void _navigateToUpload() {
    // Navigate to document upload page
    // This would be implemented with proper routing
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DocumentUploadPage(),
      ),
    ).then((result) {
      if (result != null) {
        // Refresh documents list if upload was successful
        context.read<DocumentsBloc>().add(const DocumentsRefreshRequested());
      }
    });
  }

  void _navigateToDocumentDetail(Document document) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentDetailPage(document: document),
      ),
    ).then((result) {
      // Refresh documents list if any changes were made
      if (result != null) {
        context.read<DocumentsBloc>().add(const DocumentsRefreshRequested());
      }
    });
  }

  void _showDeleteConfirmation(Document document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete this ${document.type.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<DocumentsBloc>().add(
                DocumentDeleteRequested(documentId: document.id),
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


