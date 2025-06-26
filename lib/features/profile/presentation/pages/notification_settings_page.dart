import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _smsNotificationsEnabled = false;
  bool _documentStatusNotifications = true;
  bool _securityNotifications = true;
  bool _marketingNotifications = false;
  bool _pushNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _notificationTime = 'Anytime';

  final List<String> _notificationTimes = [
    'Anytime',
    '9 AM - 6 PM',
    '9 AM - 9 PM',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notification Settings'),
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
            // Master notification toggle
            _buildSectionHeader('Notifications'),
            const SizedBox(height: 16),
            
            _buildNotificationCard(
              icon: Icons.notifications,
              title: 'Enable Notifications',
              subtitle: 'Receive notifications from N-Docs',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                  if (!value) {
                    // Disable all other notifications
                    _emailNotificationsEnabled = false;
                    _smsNotificationsEnabled = false;
                    _pushNotifications = false;
                  }
                });
              },
            ),
            
            if (_notificationsEnabled) ...[
              const SizedBox(height: 32),

              // Notification channels
              _buildSectionHeader('Notification Channels'),
              const SizedBox(height: 16),
              
              _buildNotificationCard(
                icon: Icons.push_pin,
                title: 'Push Notifications',
                subtitle: 'Receive push notifications on this device',
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              
              const SizedBox(height: 8),
              
              _buildNotificationCard(
                icon: Icons.email,
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                value: _emailNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _emailNotificationsEnabled = value;
                  });
                },
              ),
              
              const SizedBox(height: 8),
              
              _buildNotificationCard(
                icon: Icons.sms,
                title: 'SMS Notifications',
                subtitle: 'Receive notifications via text message',
                value: _smsNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _smsNotificationsEnabled = value;
                  });
                },
              ),
              
              const SizedBox(height: 32),

              // Notification types
              _buildSectionHeader('Notification Types'),
              const SizedBox(height: 16),
              
              _buildNotificationCard(
                icon: Icons.description,
                title: 'Document Status Updates',
                subtitle: 'When your document status changes',
                value: _documentStatusNotifications,
                onChanged: (value) {
                  setState(() {
                    _documentStatusNotifications = value;
                  });
                },
              ),
              
              const SizedBox(height: 8),
              
              _buildNotificationCard(
                icon: Icons.security,
                title: 'Security Alerts',
                subtitle: 'Important security and account updates',
                value: _securityNotifications,
                onChanged: (value) {
                  setState(() {
                    _securityNotifications = value;
                  });
                },
              ),
              
              const SizedBox(height: 8),
              
              _buildNotificationCard(
                icon: Icons.campaign,
                title: 'Marketing & Promotions',
                subtitle: 'News, updates, and promotional content',
                value: _marketingNotifications,
                onChanged: (value) {
                  setState(() {
                    _marketingNotifications = value;
                  });
                },
              ),
              
              if (_pushNotifications) ...[
                const SizedBox(height: 32),

                // Push notification settings
                _buildSectionHeader('Push Notification Settings'),
                const SizedBox(height: 16),
                
                _buildNotificationCard(
                  icon: Icons.volume_up,
                  title: 'Sound',
                  subtitle: 'Play sound for notifications',
                  value: _soundEnabled,
                  onChanged: (value) {
                    setState(() {
                      _soundEnabled = value;
                    });
                  },
                ),
                
                const SizedBox(height: 8),
                
                _buildNotificationCard(
                  icon: Icons.vibration,
                  title: 'Vibration',
                  subtitle: 'Vibrate for notifications',
                  value: _vibrationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _vibrationEnabled = value;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Notification timing
                _buildTimingSelector(),
              ],
            ],
            
            const SizedBox(height: 32),

            // Test notification
            _buildTestNotificationSection(),
            
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

  Widget _buildNotificationCard({
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
          onChanged: _notificationsEnabled ? onChanged : null,
          activeColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTimingSelector() {
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
                  Icons.schedule,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Notification Timing',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'When would you like to receive notifications?',
              style: TextStyle(
                color: AppColors.lightText,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _notificationTime,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _notificationTimes.map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _notificationTime = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestNotificationSection() {
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
                  Icons.notifications_active,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Test Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Send a test notification to verify your settings',
              style: TextStyle(
                color: AppColors.lightText,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _notificationsEnabled ? _sendTestNotification : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Send Test Notification'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendTestNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test notification sent!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveSettings() {
    // TODO: Implement saving notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
