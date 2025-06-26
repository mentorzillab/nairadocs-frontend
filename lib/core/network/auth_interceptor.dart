import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  static const String _tokensKey = 'auth_tokens';

  AuthInterceptor(this.secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add authorization header if token exists
    try {
      final tokensJson = await secureStorage.read(key: _tokensKey);
      if (tokensJson != null) {
        final tokensMap = jsonDecode(tokensJson) as Map<String, dynamic>;
        final accessToken = tokensMap['accessToken'] as String?;
        
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
      }
    } catch (e) {
      // Continue without token if there's an error
    }

    // Add common headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      // Clear stored tokens on unauthorized error
      secureStorage.delete(key: _tokensKey);
      secureStorage.delete(key: 'user_data');
    }

    handler.next(err);
  }
}
