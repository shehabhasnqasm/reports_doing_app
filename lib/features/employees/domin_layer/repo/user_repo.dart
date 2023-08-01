import 'package:reports_doing_app/core/errors/users/failures.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_data.dart';
import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_entity.dart';

abstract class UserRepo {
  Future<bool> isSignin();
  Future<String> getCurrentUserId();
  Future<Either<Failure, UserEntity?>> getUserInfo(String userId);

  Future<Either<Failure, String?>> login(UserData user);
  // Future<Either<Failure, UserEntity>> signInUser(UserData userData);

  Future<Either<Failure, bool>> checkIsFounsUserinAuthByuid(String userId);
  Future<Either<Failure, Unit>> deleteUserFromAuthByUserid(String userId);
  Future<Either<Failure, String>> registerNewUser(UserData userData);
  Future<Either<Failure, String>> saveProfileCreatedUserToStorage(
      String imgUrl, String userId);
  Future<Either<Failure, Unit>> deletImgFromStorage(String userId);
  Future<Either<Failure, UserEntity?>> addCreatedUserToFirestore(
      String userId, UserData userData, String userStorageUrl);

  Future<Either<Failure, Unit>> signOut();
}
