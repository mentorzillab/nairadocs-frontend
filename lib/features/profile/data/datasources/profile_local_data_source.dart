import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel?> getCachedProfile();
  Future<void> cacheProfile(UserProfileModel profile);
  Future<void> clearCachedProfile();
  Future<NotificationSettingsModel?> getCachedNotificationSettings();
  Future<void> cacheNotificationSettings(NotificationSettingsModel settings);
  Future<SecuritySettingsModel?> getCachedSecuritySettings();
  Future<void> cacheSecuritySettings(SecuritySettingsModel settings);
  Future<void> clearAllCache();
}

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _profileKey = 'cached_profile';
  static const String _notificationSettingsKey = 'cached_notification_settings';
  static const String _securitySettingsKey = 'cached_security_settings';

  ProfileLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<UserProfileModel?> getCachedProfile() async {
    try {
      final profileJson = sharedPreferences.getString(_profileKey);
      if (profileJson != null) {
        final profileMap = json.decode(profileJson) as Map<String, dynamic>;
        return UserProfileModel.fromJson(profileMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached profile: $e');
    }
  }

  @override
  Future<void> cacheProfile(UserProfileModel profile) async {
    try {
      final profileJson = json.encode(profile.toJson());
      await sharedPreferences.setString(_profileKey, profileJson);
    } catch (e) {
      throw CacheException('Failed to cache profile: $e');
    }
  }

  @override
  Future<void> clearCachedProfile() async {
    try {
      await sharedPreferences.remove(_profileKey);
    } catch (e) {
      throw CacheException('Failed to clear cached profile: $e');
    }
  }

  @override
  Future<NotificationSettingsModel?> getCachedNotificationSettings() async {
    try {
      final settingsJson = sharedPreferences.getString(_notificationSettingsKey);
      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        return NotificationSettingsModel.fromJson(settingsMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached notification settings: $e');
    }
  }

  @override
  Future<void> cacheNotificationSettings(NotificationSettingsModel settings) async {
    try {
      final settingsJson = json.encode(settings.toJson());
      await sharedPreferences.setString(_notificationSettingsKey, settingsJson);
    } catch (e) {
      throw CacheException('Failed to cache notification settings: $e');
    }
  }

  @override
  Future<SecuritySettingsModel?> getCachedSecuritySettings() async {
    try {
      final settingsJson = sharedPreferences.getString(_securitySettingsKey);
      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        return SecuritySettingsModel.fromJson(settingsMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached security settings: $e');
    }
  }

  @override
  Future<void> cacheSecuritySettings(SecuritySettingsModel settings) async {
    try {
      final settingsJson = json.encode(settings.toJson());
      await sharedPreferences.setString(_securitySettingsKey, settingsJson);
    } catch (e) {
      throw CacheException('Failed to cache security settings: $e');
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      await Future.wait([
        sharedPreferences.remove(_profileKey),
        sharedPreferences.remove(_notificationSettingsKey),
        sharedPreferences.remove(_securitySettingsKey),
      ]);
    } catch (e) {
      throw CacheException('Failed to clear all cache: $e');
    }
  }
}
