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
import 'package:local_auth/local_auth.dart' as _i123;
import 'package:ndocs/features/auth/data/datasources/auth_local_data_source.dart'
    as _i240;
import 'package:ndocs/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i446;
import 'package:ndocs/features/auth/data/repositories/auth_repository_impl.dart'
    as _i679;
import 'package:ndocs/features/auth/domain/repositories/auth_repository.dart'
    as _i377;
import 'package:ndocs/features/auth/presentation/bloc/auth_bloc.dart'
    as _i789;
import 'package:ndocs/features/documents/data/datasources/documents_local_data_source.dart'
    as _i890;
import 'package:ndocs/features/documents/data/datasources/documents_remote_data_source.dart'
    as _i891;
import 'package:ndocs/features/documents/data/repositories/documents_repository_impl.dart'
    as _i892;
import 'package:ndocs/features/documents/domain/repositories/documents_repository.dart'
    as _i893;
import 'package:ndocs/features/documents/domain/usecases/upload_document.dart'
    as _i894;
import 'package:ndocs/features/documents/domain/usecases/get_user_documents.dart'
    as _i895;
import 'package:ndocs/features/documents/domain/usecases/update_document.dart'
    as _i897;
import 'package:ndocs/features/documents/domain/usecases/resubmit_document.dart'
    as _i898;
import 'package:ndocs/features/documents/domain/usecases/download_document_files.dart'
    as _i899;
import 'package:ndocs/features/documents/domain/usecases/check_verification_status.dart'
    as _i900;
import 'package:ndocs/features/documents/domain/usecases/get_supported_document_types.dart'
    as _i901;
import 'package:ndocs/features/documents/domain/usecases/validate_document_number.dart'
    as _i902;
import 'package:ndocs/features/documents/domain/usecases/get_document_requirements.dart'
    as _i903;
import 'package:ndocs/features/documents/presentation/bloc/documents_bloc.dart'
    as _i904;
import 'package:ndocs/features/profile/data/datasources/profile_local_data_source.dart'
    as _i905;
import 'package:ndocs/features/profile/data/datasources/profile_remote_data_source.dart'
    as _i906;
import 'package:ndocs/features/profile/data/repositories/profile_repository_impl.dart'
    as _i907;
import 'package:ndocs/features/profile/domain/repositories/profile_repository.dart'
    as _i908;
import 'package:ndocs/features/profile/domain/usecases/get_user_profile.dart'
    as _i909;
import 'package:ndocs/features/profile/domain/usecases/update_profile.dart'
    as _i910;
import 'package:ndocs/features/profile/domain/usecases/change_password.dart'
    as _i911;
import 'package:ndocs/features/profile/domain/usecases/upload_profile_image.dart'
    as _i912;
import 'package:ndocs/features/profile/domain/usecases/update_profile_image.dart'
    as _i913;
import 'package:ndocs/features/profile/presentation/bloc/profile_bloc.dart'
    as _i914;

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
    gh.factory<_i789.AuthBloc>(() => _i789.AuthBloc(
          gh<_i377.AuthRepository>(),
          gh<_i123.LocalAuthentication>(),
        ));
    gh.lazySingleton<_i890.DocumentsLocalDataSource>(
        () => _i890.DocumentsLocalDataSourceImpl(gh<_i558.SharedPreferences>()));
    gh.lazySingleton<_i891.DocumentsRemoteDataSource>(
        () => _i891.DocumentsRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i893.DocumentsRepository>(() => _i892.DocumentsRepositoryImpl(
          remoteDataSource: gh<_i891.DocumentsRemoteDataSource>(),
          localDataSource: gh<_i890.DocumentsLocalDataSource>(),
        ));
    gh.factory<_i894.UploadDocument>(() => _i894.UploadDocument(gh<_i893.DocumentsRepository>()));
    gh.factory<_i895.GetUserDocuments>(() => _i895.GetUserDocuments(gh<_i893.DocumentsRepository>()));
    gh.factory<_i895.GetDocumentById>(() => _i895.GetDocumentById(gh<_i893.DocumentsRepository>()));
    gh.factory<_i895.GetDocumentStats>(() => _i895.GetDocumentStats(gh<_i893.DocumentsRepository>()));
    gh.factory<_i895.SearchDocuments>(() => _i895.SearchDocuments(gh<_i893.DocumentsRepository>()));
    gh.factory<_i895.DeleteDocument>(() => _i895.DeleteDocument(gh<_i893.DocumentsRepository>()));
    gh.factory<_i897.UpdateDocument>(() => _i897.UpdateDocument(gh<_i893.DocumentsRepository>()));
    gh.factory<_i898.ResubmitDocument>(() => _i898.ResubmitDocument(gh<_i893.DocumentsRepository>()));
    gh.factory<_i899.DownloadDocumentFiles>(() => _i899.DownloadDocumentFiles(gh<_i893.DocumentsRepository>()));
    gh.factory<_i900.CheckVerificationStatus>(() => _i900.CheckVerificationStatus(gh<_i893.DocumentsRepository>()));
    gh.factory<_i901.GetSupportedDocumentTypes>(() => _i901.GetSupportedDocumentTypes(gh<_i893.DocumentsRepository>()));
    gh.factory<_i902.ValidateDocumentNumber>(() => _i902.ValidateDocumentNumber(gh<_i893.DocumentsRepository>()));
    gh.factory<_i903.GetDocumentRequirements>(() => _i903.GetDocumentRequirements(gh<_i893.DocumentsRepository>()));
    gh.factory<_i904.DocumentsBloc>(() => _i904.DocumentsBloc(
          gh<_i894.UploadDocument>(),
          gh<_i895.GetUserDocuments>(),
          gh<_i895.GetDocumentById>(),
          gh<_i895.GetDocumentStats>(),
          gh<_i895.SearchDocuments>(),
          gh<_i895.DeleteDocument>(),
          gh<_i897.UpdateDocument>(),
          gh<_i898.ResubmitDocument>(),
          gh<_i899.DownloadDocumentFiles>(),
          gh<_i900.CheckVerificationStatus>(),
          gh<_i901.GetSupportedDocumentTypes>(),
          gh<_i902.ValidateDocumentNumber>(),
          gh<_i903.GetDocumentRequirements>(),
        ));

    // Profile dependencies
    gh.lazySingleton<_i905.ProfileLocalDataSource>(() => _i905.ProfileLocalDataSourceImpl(gh<_i8.SharedPreferences>()));
    gh.lazySingleton<_i906.ProfileRemoteDataSource>(() => _i906.ProfileRemoteDataSourceImpl(gh<_i10.Dio>()));
    gh.lazySingleton<_i908.ProfileRepository>(() => _i907.ProfileRepositoryImpl(
          remoteDataSource: gh<_i906.ProfileRemoteDataSource>(),
          localDataSource: gh<_i905.ProfileLocalDataSource>(),
          networkInfo: gh<_i11.NetworkInfo>(),
        ));

    // Profile use cases
    gh.factory<_i909.GetUserProfile>(() => _i909.GetUserProfile(gh<_i908.ProfileRepository>()));
    gh.factory<_i910.UpdateProfile>(() => _i910.UpdateProfile(gh<_i908.ProfileRepository>()));
    gh.factory<_i911.ChangePassword>(() => _i911.ChangePassword(gh<_i908.ProfileRepository>()));
    gh.factory<_i912.UploadProfileImage>(() => _i912.UploadProfileImage(gh<_i908.ProfileRepository>()));
    gh.factory<_i913.UpdateProfileImage>(() => _i913.UpdateProfileImage(gh<_i908.ProfileRepository>()));

    // Profile BLoC
    gh.factory<_i914.ProfileBloc>(() => _i914.ProfileBloc(
          gh<_i909.GetUserProfile>(),
          gh<_i910.UpdateProfile>(),
          gh<_i911.ChangePassword>(),
        ));
    return this;
  }
}
