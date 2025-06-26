import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../core/network/auth_interceptor.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Register external dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);
  
  final dio = Dio();
  dio.options.baseUrl = 'http://localhost:3000/api/v1';
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);

  // Add auth interceptor
  dio.interceptors.add(AuthInterceptor(secureStorage));

  getIt.registerSingleton<Dio>(dio);

  // Register LocalAuthentication
  final localAuth = LocalAuthentication();
  getIt.registerSingleton<LocalAuthentication>(localAuth);

  // Register Connectivity
  final connectivity = Connectivity();
  getIt.registerSingleton<Connectivity>(connectivity);

  // Initialize generated dependencies
  getIt.init();
}
