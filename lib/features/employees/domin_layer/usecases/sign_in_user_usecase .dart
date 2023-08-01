import 'package:reports_doing_app/core/errors/users/failures.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_data.dart';
import 'package:reports_doing_app/features/employees/domin_layer/repo/user_repo.dart';
import 'package:dartz/dartz.dart';

class SignInUserUseCase {
  final UserRepo userRepo;
  SignInUserUseCase({required this.userRepo});

  Future<Either<Failure, String?>> login(UserData userData) async {
    return await userRepo.login(userData);
  }
}
