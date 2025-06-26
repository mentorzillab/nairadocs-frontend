import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

@injectable
class UpdateProfileImage implements UseCase<UserProfile, String> {
  final ProfileRepository repository;

  UpdateProfileImage(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(String imageUrl) async {
    return await repository.updateProfileImage(imageUrl);
  }
}
