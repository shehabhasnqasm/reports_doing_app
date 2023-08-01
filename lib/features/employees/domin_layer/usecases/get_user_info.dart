import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/core/errors/users/failures.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_entity.dart';
import 'package:reports_doing_app/features/employees/domin_layer/repo/user_repo.dart';

class GetUserInfoUseCase {
  final UserRepo userRepo;
  GetUserInfoUseCase({required this.userRepo});

  Future<Either<Failure, UserEntity?>> call(String userId) async {
    return await userRepo.getUserInfo(userId);
  }
}
