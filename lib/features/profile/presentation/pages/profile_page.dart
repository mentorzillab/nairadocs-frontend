import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import 'edit_profile_page.dart';
import 'security_settings_page.dart';
import 'notification_settings_page.dart';
import 'privacy_settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile when page opens
    context.read<ProfileBloc>().add(const ProfileLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkText,
        actions: [
          IconButton(
            onPressed: () {
              context.read<ProfileBloc>().add(const ProfileRefreshRequested());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Profile header
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return _buildProfileHeader(state.profile);
                } else if (state is ProfileLoading || state is ProfileRefreshing) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: LoadingWidget()),
                  );
                } else {
                  // Fallback to AuthBloc for basic user info
                  return BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      if (authState is AuthAuthenticated) {
                        return _buildProfileHeader(authState.user);
                      } else {
                        return const SizedBox(height: 200);
                      }
                    },
                  );
                }
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Menu items
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    subtitle: 'Update your personal details',
                    onTap: () => _navigateToPersonalInfo(),
                  ),

                  _buildMenuItem(
                    icon: Icons.security,
                    title: 'Security',
                    subtitle: 'Password, 2FA, and security settings',
                    onTap: () => _navigateToSecurity(),
                  ),

                  _buildMenuItem(
                    icon: Icons.notifications_outline,
                    title: 'Notifications',
                    subtitle: 'Manage your notification preferences',
                    onTap: () => _navigateToNotifications(),
                  ),

                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy',
                    subtitle: 'Data and privacy settings',
                    onTap: () => _navigateToPrivacy(),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Support',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    onTap: () => _navigateToHelp(),
                  ),

                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and information',
                    onTap: () => _navigateToAbout(),
                  ),

                  const SizedBox(height: 24),

                  // Logout button
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Sign Out',
                    subtitle: 'Sign out of your account',
                    onTap: () => _showLogoutConfirmation(),
                    isDestructive: true,
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: user.profileImageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          user.profileImageUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              _getInitials(user),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            );
                          },
                        ),
                      )
                    : Text(
                        _getInitials(user),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showImageOptions(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getDisplayName(user),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email ?? 'No email',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.lightText,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Documents', '0'),
              _buildStatItem('Verified', '0'),
              _buildStatItem('Pending', '0'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.lightText,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : AppColors.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : AppColors.darkText,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDestructive ? Colors.red.withOpacity(0.7) : AppColors.lightText,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDestructive ? Colors.red : AppColors.lightText,
        ),
        onTap: onTap,
      ),
    );
  }

  String _getInitials(dynamic user) {
    final firstName = user.firstName ?? '';
    final lastName = user.lastName ?? '';
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  String _getDisplayName(dynamic user) {
    final firstName = user.firstName ?? '';
    final lastName = user.lastName ?? '';
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return '$firstName $lastName'.trim();
    }
    return user.email ?? 'User';
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.of(context).pop();
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _chooseFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                _removePhoto();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _takePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera functionality not implemented yet')),
    );
  }

  void _chooseFromGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gallery functionality not implemented yet')),
    );
  }

  void _removePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Remove photo functionality not implemented yet')),
    );
  }

  void _navigateToPersonalInfo() {
    // Get current user from AuthBloc
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditProfilePage(
            profile: null, // TODO: Convert User to UserProfile
          ),
        ),
      ).then((result) {
        if (result == true) {
          // Refresh profile data
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      });
    }
  }

  void _navigateToSecurity() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SecuritySettingsPage(),
      ),
    );
  }

  void _navigateToNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NotificationSettingsPage(),
      ),
    );
  }

  void _navigateToPrivacy() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PrivacySettingsPage(),
      ),
    );
  }

  void _navigateToHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help page not implemented yet')),
    );
  }

  void _navigateToAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About N-Docs'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Build: 1.0.0+1'),
            SizedBox(height: 8),
            Text('© 2024 N-Docs. All rights reserved.'),
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

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go('/login');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
