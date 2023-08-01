import 'package:reports_doing_app/core/errors/users/failures.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_data.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_entity.dart';
import 'package:reports_doing_app/features/employees/domin_layer/repo/user_repo.dart';
import 'package:dartz/dartz.dart';

class RegisterUserUseCase {
  final UserRepo userRepo;
  RegisterUserUseCase({required this.userRepo});

  Future<Either<Failure, String>> call(UserData userData) async {
    return await userRepo.registerNewUser(userData);
  }

  Future<Either<Failure, String>> saveImgToStorage(
      String imgUrl, String userId) async {
    return await userRepo.saveProfileCreatedUserToStorage(imgUrl, userId);
  }

  Future<Either<Failure, UserEntity?>> addUserToFirestore(
      String userId, UserData userData, String userStorageUrl) async {
    return await userRepo.addCreatedUserToFirestore(
        userId, userData, userStorageUrl);
  }

  Future<Either<Failure, Unit>> deletImgFromStorage(
    String userId,
  ) async {
    return await userRepo.deletImgFromStorage(userId);
  }
}
