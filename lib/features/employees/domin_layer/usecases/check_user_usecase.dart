import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/core/errors/users/failures.dart';
import 'package:reports_doing_app/features/employees/domin_layer/repo/user_repo.dart';

class CheckUserUseCase {
  final UserRepo userRepo;
  CheckUserUseCase({required this.userRepo});

  Future<Either<Failure, bool>> call(String userId) async {
    return await userRepo.checkIsFounsUserinAuthByuid(userId);
  }
}
