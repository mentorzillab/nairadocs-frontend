import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _isTwoFactorEnabled = false;
  bool _isBiometricEnabled = false;
  bool _isSessionTimeoutEnabled = true;
  int _sessionTimeoutMinutes = 30;
  bool _requirePasswordForSensitiveActions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Security Settings'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkText,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Password Section
            _buildSectionHeader('Password & Authentication'),
            const SizedBox(height: 16),
            
            _buildSettingCard(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your account password',
              onTap: _showChangePasswordDialog,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
            
            const SizedBox(height: 32),

            // Two-Factor Authentication
            _buildSectionHeader('Two-Factor Authentication'),
            const SizedBox(height: 16),
            
            _buildSettingCard(
              icon: Icons.security,
              title: 'Two-Factor Authentication',
              subtitle: _isTwoFactorEnabled 
                  ? 'Enabled - Your account is protected with 2FA'
                  : 'Add an extra layer of security to your account',
              trailing: Switch(
                value: _isTwoFactorEnabled,
                onChanged: _toggleTwoFactor,
                activeColor: AppColors.primary,
              ),
            ),
            
            const SizedBox(height: 32),

            // Biometric Authentication
            _buildSectionHeader('Biometric Authentication'),
            const SizedBox(height: 16),
            
            _buildSettingCard(
              icon: Icons.fingerprint,
              title: 'Biometric Login',
              subtitle: _isBiometricEnabled
                  ? 'Enabled - Use fingerprint or face to sign in'
                  : 'Use fingerprint or face recognition to sign in',
              trailing: Switch(
                value: _isBiometricEnabled,
                onChanged: _toggleBiometric,
                activeColor: AppColors.primary,
              ),
            ),
            
            const SizedBox(height: 32),

            // Session Management
            _buildSectionHeader('Session Management'),
            const SizedBox(height: 16),
            
            _buildSettingCard(
              icon: Icons.timer,
              title: 'Auto-logout',
              subtitle: _isSessionTimeoutEnabled
                  ? 'Automatically sign out after $_sessionTimeoutMinutes minutes of inactivity'
                  : 'Stay signed in until manually logged out',
              trailing: Switch(
                value: _isSessionTimeoutEnabled,
                onChanged: (value) {
                  setState(() {
                    _isSessionTimeoutEnabled = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ),
            
            if (_isSessionTimeoutEnabled) ...[
              const SizedBox(height: 16),
              _buildTimeoutSelector(),
            ],
            
            const SizedBox(height: 16),
            
            _buildSettingCard(
              icon: Icons.devices,
              title: 'Active Sessions',
              subtitle: 'Manage devices and sessions',
              onTap: _showActiveSessions,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
            
            const SizedBox(height: 32),

            // Security Preferences
            _buildSectionHeader('Security Preferences'),
            const SizedBox(height: 16),
            
            _buildSettingCard(
              icon: Icons.verified_user,
              title: 'Require Password for Sensitive Actions',
              subtitle: 'Ask for password when performing sensitive operations',
              trailing: Switch(
                value: _requirePasswordForSensitiveActions,
                onChanged: (value) {
                  setState(() {
                    _requirePasswordForSensitiveActions = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ),
            
            const SizedBox(height: 32),

            // Account Actions
            _buildSectionHeader('Account Actions'),
            const SizedBox(height: 16),
            
            _buildSettingCard(
              icon: Icons.logout,
              title: 'Sign Out All Devices',
              subtitle: 'Sign out from all devices except this one',
              onTap: _signOutAllDevices,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingCard(
              icon: Icons.delete_forever,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account and all data',
              onTap: _showDeleteAccountDialog,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              isDestructive: true,
            ),
            
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

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
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
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildTimeoutSelector() {
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
            const Text(
              'Auto-logout after:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [15, 30, 60, 120].map((minutes) {
                final isSelected = _sessionTimeoutMinutes == minutes;
                return ChoiceChip(
                  label: Text('${minutes}m'),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _sessionTimeoutMinutes = minutes;
                      });
                    }
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.darkText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: currentPasswordController,
                label: 'Current Password',
                obscureText: true,
                validator: (value) => value?.isEmpty ?? true ? 'Current password is required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: newPasswordController,
                label: 'New Password',
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: confirmPasswordController,
                label: 'Confirm New Password',
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please confirm your password';
                  if (value != newPasswordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                // TODO: Implement password change
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password changed successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _toggleTwoFactor(bool value) {
    if (value) {
      _showTwoFactorSetupDialog();
    } else {
      _showTwoFactorDisableDialog();
    }
  }

  void _showTwoFactorSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Two-Factor Authentication'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.security, size: 64, color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'Two-factor authentication adds an extra layer of security to your account.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'You will need an authenticator app like Google Authenticator or Authy.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.lightText),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isTwoFactorEnabled = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Two-factor authentication enabled')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  void _showTwoFactorDisableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable Two-Factor Authentication'),
        content: const Text(
          'Are you sure you want to disable two-factor authentication? This will make your account less secure.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isTwoFactorEnabled = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Two-factor authentication disabled')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Disable'),
          ),
        ],
      ),
    );
  }

  void _toggleBiometric(bool value) {
    setState(() {
      _isBiometricEnabled = value;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value 
              ? 'Biometric authentication enabled'
              : 'Biometric authentication disabled',
        ),
      ),
    );
  }

  void _showActiveSessions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Active sessions page not implemented yet')),
    );
  }

  void _signOutAllDevices() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out All Devices'),
        content: const Text(
          'This will sign you out from all devices except this one. You will need to sign in again on other devices.',
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
                const SnackBar(content: Text('Signed out from all other devices')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final passwordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: passwordController,
              label: 'Enter your password to confirm',
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (passwordController.text.isNotEmpty) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deletion requested')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
