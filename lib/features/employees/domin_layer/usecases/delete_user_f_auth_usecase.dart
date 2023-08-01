import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/core/errors/users/failures.dart';
import 'package:reports_doing_app/features/employees/domin_layer/repo/user_repo.dart';

class DeleteUserFromAuthUseCase {
  final UserRepo userRepo;
  DeleteUserFromAuthUseCase({required this.userRepo});

  Future<Either<Failure, Unit>> call(String userId) async {
    return await userRepo.deleteUserFromAuthByUserid(userId);
  }

  Future<Either<Failure, Unit>> deletUserImgFromStorage(String userId) async {
    return await userRepo.deletImgFromStorage(userId);
  }
}
