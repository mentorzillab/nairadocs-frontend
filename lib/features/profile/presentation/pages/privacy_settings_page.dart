import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _dataCollectionEnabled = true;
  bool _analyticsEnabled = true;
  bool _crashReportingEnabled = true;
  bool _personalizedAdsEnabled = false;
  bool _locationTrackingEnabled = false;
  bool _profileVisibilityPublic = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkText,
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Data Collection
            _buildSectionHeader('Data Collection & Usage'),
            const SizedBox(height: 16),
            
            _buildPrivacyCard(
              icon: Icons.data_usage,
              title: 'Data Collection',
              subtitle: 'Allow N-Docs to collect usage data to improve the app',
              value: _dataCollectionEnabled,
              onChanged: (value) {
                setState(() {
                  _dataCollectionEnabled = value;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            _buildPrivacyCard(
              icon: Icons.analytics,
              title: 'Analytics',
              subtitle: 'Help us understand how you use the app',
              value: _analyticsEnabled,
              onChanged: (value) {
                setState(() {
                  _analyticsEnabled = value;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            _buildPrivacyCard(
              icon: Icons.bug_report,
              title: 'Crash Reporting',
              subtitle: 'Automatically send crash reports to help fix issues',
              value: _crashReportingEnabled,
              onChanged: (value) {
                setState(() {
                  _crashReportingEnabled = value;
                });
              },
            ),
            
            const SizedBox(height: 32),

            // Advertising & Tracking
            _buildSectionHeader('Advertising & Tracking'),
            const SizedBox(height: 16),
            
            _buildPrivacyCard(
              icon: Icons.ads_click,
              title: 'Personalized Ads',
              subtitle: 'Show ads based on your interests and activity',
              value: _personalizedAdsEnabled,
              onChanged: (value) {
                setState(() {
                  _personalizedAdsEnabled = value;
                });
              },
            ),
            
            const SizedBox(height: 8),
            
            _buildPrivacyCard(
              icon: Icons.location_on,
              title: 'Location Tracking',
              subtitle: 'Allow location-based features and services',
              value: _locationTrackingEnabled,
              onChanged: (value) {
                setState(() {
                  _locationTrackingEnabled = value;
                });
              },
            ),
            
            const SizedBox(height: 32),

            // Profile Privacy
            _buildSectionHeader('Profile Privacy'),
            const SizedBox(height: 16),
            
            _buildPrivacyCard(
              icon: Icons.public,
              title: 'Public Profile',
              subtitle: 'Make your profile visible to other users',
              value: _profileVisibilityPublic,
              onChanged: (value) {
                setState(() {
                  _profileVisibilityPublic = value;
                });
              },
            ),
            
            const SizedBox(height: 32),

            // Data Management
            _buildSectionHeader('Data Management'),
            const SizedBox(height: 16),
            
            _buildActionCard(
              icon: Icons.download,
              title: 'Download My Data',
              subtitle: 'Get a copy of all your data stored in N-Docs',
              onTap: _downloadData,
            ),
            
            const SizedBox(height: 8),
            
            _buildActionCard(
              icon: Icons.delete_sweep,
              title: 'Clear App Data',
              subtitle: 'Remove all locally stored data and cache',
              onTap: _clearAppData,
            ),
            
            const SizedBox(height: 8),
            
            _buildActionCard(
              icon: Icons.delete_forever,
              title: 'Delete All Data',
              subtitle: 'Permanently delete all your data from our servers',
              onTap: _deleteAllData,
              isDestructive: true,
            ),
            
            const SizedBox(height: 32),

            // Legal & Compliance
            _buildSectionHeader('Legal & Compliance'),
            const SizedBox(height: 16),
            
            _buildActionCard(
              icon: Icons.policy,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy and data practices',
              onTap: _viewPrivacyPolicy,
            ),
            
            const SizedBox(height: 8),
            
            _buildActionCard(
              icon: Icons.gavel,
              title: 'Terms of Service',
              subtitle: 'Review the terms and conditions',
              onTap: _viewTermsOfService,
            ),
            
            const SizedBox(height: 8),
            
            _buildActionCard(
              icon: Icons.cookie,
              title: 'Cookie Settings',
              subtitle: 'Manage cookie preferences',
              onTap: _manageCookies,
            ),
            
            const SizedBox(height: 32),

            // Privacy Information
            _buildPrivacyInfoCard(),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.darkText,
      ),
    );
  }

  Widget _buildPrivacyCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.lightText,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
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

  Widget _buildPrivacyInfoCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Your Privacy Matters',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'We are committed to protecting your privacy and giving you control over your data. You can adjust these settings at any time.',
              style: TextStyle(
                color: AppColors.lightText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Last updated: December 2024',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Your Data'),
        content: const Text(
          'We will prepare a copy of all your data and send it to your registered email address. This may take up to 24 hours.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data download request submitted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Request Download'),
          ),
        ],
      ),
    );
  }

  void _clearAppData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear App Data'),
        content: const Text(
          'This will remove all locally stored data including cached documents and preferences. You will need to sign in again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App data cleared')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }

  void _deleteAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text(
          'This will permanently delete all your data from our servers. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data deletion request submitted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _viewPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy policy page not implemented yet')),
    );
  }

  void _viewTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terms of service page not implemented yet')),
    );
  }

  void _manageCookies() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cookie settings page not implemented yet')),
    );
  }

  void _saveSettings() {
    // TODO: Implement saving privacy settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
