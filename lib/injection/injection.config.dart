// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:ndocs/features/auth/data/datasources/auth_local_data_source.dart'
    as _i240;
import 'package:ndocs/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i446;
import 'package:ndocs/features/auth/data/repositories/auth_repository_impl.dart'
    as _i679;
import 'package:ndocs/features/auth/domain/repositories/auth_repository.dart'
    as _i377;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i240.AuthLocalDataSource>(
        () => _i240.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i446.AuthRemoteDataSource>(
        () => _i446.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i377.AuthRepository>(() => _i679.AuthRepositoryImpl(
          remoteDataSource: gh<_i446.AuthRemoteDataSource>(),
          localDataSource: gh<_i240.AuthLocalDataSource>(),
        ));
    return this;
  }
}
