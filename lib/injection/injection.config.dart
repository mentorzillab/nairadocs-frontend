// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;
import 'package:ndocs/core/network/network_info.dart' as _i147;
import 'package:ndocs/features/auth/data/datasources/auth_local_data_source.dart'
    as _i240;
import 'package:ndocs/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i446;
import 'package:ndocs/features/auth/data/repositories/auth_repository_impl.dart'
    as _i679;
import 'package:ndocs/features/auth/domain/repositories/auth_repository.dart'
    as _i377;
import 'package:ndocs/features/auth/presentation/bloc/auth_bloc.dart' as _i134;
import 'package:ndocs/features/documents/data/datasources/documents_local_data_source.dart'
    as _i904;
import 'package:ndocs/features/documents/data/datasources/documents_remote_data_source.dart'
    as _i785;
import 'package:ndocs/features/documents/data/repositories/documents_repository_impl.dart'
    as _i188;
import 'package:ndocs/features/documents/domain/repositories/documents_repository.dart'
    as _i420;
import 'package:ndocs/features/documents/domain/usecases/check_verification_status.dart'
    as _i728;
import 'package:ndocs/features/documents/domain/usecases/download_document_files.dart'
    as _i15;
import 'package:ndocs/features/documents/domain/usecases/get_document_requirements.dart'
    as _i501;
import 'package:ndocs/features/documents/domain/usecases/get_supported_document_types.dart'
    as _i481;
import 'package:ndocs/features/documents/domain/usecases/get_user_documents.dart'
    as _i399;
import 'package:ndocs/features/documents/domain/usecases/resubmit_document.dart'
    as _i990;
import 'package:ndocs/features/documents/domain/usecases/update_document.dart'
    as _i75;
import 'package:ndocs/features/documents/domain/usecases/upload_document.dart'
    as _i229;
import 'package:ndocs/features/documents/domain/usecases/validate_document_number.dart'
    as _i853;
import 'package:ndocs/features/documents/presentation/bloc/documents_bloc.dart'
    as _i985;
import 'package:ndocs/features/profile/data/datasources/profile_local_data_source.dart'
    as _i898;
import 'package:ndocs/features/profile/data/datasources/profile_remote_data_source.dart'
    as _i568;
import 'package:ndocs/features/profile/data/repositories/profile_repository_impl.dart'
    as _i137;
import 'package:ndocs/features/profile/domain/repositories/profile_repository.dart'
    as _i767;
import 'package:ndocs/features/profile/domain/usecases/change_password.dart'
    as _i208;
import 'package:ndocs/features/profile/domain/usecases/get_user_profile.dart'
    as _i85;
import 'package:ndocs/features/profile/domain/usecases/update_profile.dart'
    as _i380;
import 'package:ndocs/features/profile/domain/usecases/update_profile_image.dart'
    as _i571;
import 'package:ndocs/features/profile/domain/usecases/upload_profile_image.dart'
    as _i384;
import 'package:ndocs/features/profile/presentation/bloc/profile_bloc.dart'
    as _i615;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

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
    gh.lazySingleton<_i785.DocumentsRemoteDataSource>(
        () => _i785.DocumentsRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i446.AuthRemoteDataSource>(
        () => _i446.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i147.NetworkInfo>(
        () => _i147.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i568.ProfileRemoteDataSource>(
        () => _i568.ProfileRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i904.DocumentsLocalDataSource>(() =>
        _i904.DocumentsLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i377.AuthRepository>(() => _i679.AuthRepositoryImpl(
          remoteDataSource: gh<_i446.AuthRemoteDataSource>(),
          localDataSource: gh<_i240.AuthLocalDataSource>(),
        ));
    gh.lazySingleton<_i898.ProfileLocalDataSource>(
        () => _i898.ProfileLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i420.DocumentsRepository>(
        () => _i188.DocumentsRepositoryImpl(
              remoteDataSource: gh<_i785.DocumentsRemoteDataSource>(),
              localDataSource: gh<_i904.DocumentsLocalDataSource>(),
            ));
    gh.factory<_i134.AuthBloc>(() => _i134.AuthBloc(
          gh<_i377.AuthRepository>(),
          gh<_i152.LocalAuthentication>(),
        ));
    gh.lazySingleton<_i767.ProfileRepository>(() => _i137.ProfileRepositoryImpl(
          remoteDataSource: gh<_i568.ProfileRemoteDataSource>(),
          localDataSource: gh<_i898.ProfileLocalDataSource>(),
          networkInfo: gh<_i147.NetworkInfo>(),
        ));
    gh.factory<_i208.ChangePassword>(
        () => _i208.ChangePassword(gh<_i767.ProfileRepository>()));
    gh.factory<_i571.UpdateProfileImage>(
        () => _i571.UpdateProfileImage(gh<_i767.ProfileRepository>()));
    gh.factory<_i85.GetUserProfile>(
        () => _i85.GetUserProfile(gh<_i767.ProfileRepository>()));
    gh.factory<_i380.UpdateProfile>(
        () => _i380.UpdateProfile(gh<_i767.ProfileRepository>()));
    gh.factory<_i384.UploadProfileImage>(
        () => _i384.UploadProfileImage(gh<_i767.ProfileRepository>()));
    gh.factory<_i481.GetSupportedDocumentTypes>(
        () => _i481.GetSupportedDocumentTypes(gh<_i420.DocumentsRepository>()));
    gh.factory<_i75.UpdateDocument>(
        () => _i75.UpdateDocument(gh<_i420.DocumentsRepository>()));
    gh.factory<_i399.GetUserDocuments>(
        () => _i399.GetUserDocuments(gh<_i420.DocumentsRepository>()));
    gh.factory<_i399.GetDocumentById>(
        () => _i399.GetDocumentById(gh<_i420.DocumentsRepository>()));
    gh.factory<_i399.GetDocumentStats>(
        () => _i399.GetDocumentStats(gh<_i420.DocumentsRepository>()));
    gh.factory<_i399.SearchDocuments>(
        () => _i399.SearchDocuments(gh<_i420.DocumentsRepository>()));
    gh.factory<_i399.DeleteDocument>(
        () => _i399.DeleteDocument(gh<_i420.DocumentsRepository>()));
    gh.factory<_i501.GetDocumentRequirements>(
        () => _i501.GetDocumentRequirements(gh<_i420.DocumentsRepository>()));
    gh.factory<_i728.CheckVerificationStatus>(
        () => _i728.CheckVerificationStatus(gh<_i420.DocumentsRepository>()));
    gh.factory<_i990.ResubmitDocument>(
        () => _i990.ResubmitDocument(gh<_i420.DocumentsRepository>()));
    gh.factory<_i15.DownloadDocumentFiles>(
        () => _i15.DownloadDocumentFiles(gh<_i420.DocumentsRepository>()));
    gh.factory<_i853.ValidateDocumentNumber>(
        () => _i853.ValidateDocumentNumber(gh<_i420.DocumentsRepository>()));
    gh.factory<_i229.UploadDocument>(
        () => _i229.UploadDocument(gh<_i420.DocumentsRepository>()));
    gh.factory<_i615.ProfileBloc>(() => _i615.ProfileBloc(
          gh<_i85.GetUserProfile>(),
          gh<_i380.UpdateProfile>(),
          gh<_i208.ChangePassword>(),
        ));
    gh.factory<_i985.DocumentsBloc>(() => _i985.DocumentsBloc(
          gh<_i229.UploadDocument>(),
          gh<_i399.GetUserDocuments>(),
          gh<_i399.GetDocumentById>(),
          gh<_i399.GetDocumentStats>(),
          gh<_i399.SearchDocuments>(),
          gh<_i399.DeleteDocument>(),
          gh<_i75.UpdateDocument>(),
          gh<_i990.ResubmitDocument>(),
          gh<_i15.DownloadDocumentFiles>(),
          gh<_i728.CheckVerificationStatus>(),
          gh<_i481.GetSupportedDocumentTypes>(),
          gh<_i853.ValidateDocumentNumber>(),
          gh<_i501.GetDocumentRequirements>(),
        ));
    return this;
  }
}
