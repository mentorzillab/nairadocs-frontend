import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> storeTokens(AuthTokensModel tokens);
  Future<AuthTokensModel?> getStoredTokens();
  Future<void> clearTokens();
  Future<void> storeUser(UserModel user);
  Future<UserModel?> getStoredUser();
  Future<void> clearUser();
  Future<bool> isAuthenticated();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  static const String _tokensKey = 'auth_tokens';
  static const String _userKey = 'user_data';

  AuthLocalDataSourceImpl(this.secureStorage);

  @override
  Future<void> storeTokens(AuthTokensModel tokens) async {
    try {
      final tokensJson = jsonEncode(tokens.toJson());
      await secureStorage.write(key: _tokensKey, value: tokensJson);
    } catch (e) {
      throw CacheException('Failed to store tokens: $e');
    }
  }

  @override
  Future<AuthTokensModel?> getStoredTokens() async {
    try {
      final tokensJson = await secureStorage.read(key: _tokensKey);
      if (tokensJson != null) {
        final tokensMap = jsonDecode(tokensJson) as Map<String, dynamic>;
        return AuthTokensModel.fromJson(tokensMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get stored tokens: $e');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await secureStorage.delete(key: _tokensKey);
    } catch (e) {
      throw CacheException('Failed to clear tokens: $e');
    }
  }

  @override
  Future<void> storeUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await secureStorage.write(key: _userKey, value: userJson);
    } catch (e) {
      throw CacheException('Failed to store user: $e');
    }
  }

  @override
  Future<UserModel?> getStoredUser() async {
    try {
      final userJson = await secureStorage.read(key: _userKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get stored user: $e');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await secureStorage.delete(key: _userKey);
    } catch (e) {
      throw CacheException('Failed to clear user: $e');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final tokens = await getStoredTokens();
      if (tokens == null) return false;
      
      // Check if token is expired
      return !tokens.isExpired;
    } catch (e) {
      return false;
    }
  }
}
