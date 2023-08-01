import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/core/errors/users/failures.dart';
import 'package:reports_doing_app/features/employees/domin_layer/repo/user_repo.dart';

class SignOutUseCase {
  final UserRepo userRepo;
  SignOutUseCase({required this.userRepo});

  Future<Either<Failure, Unit>> call() async {
    return await userRepo.signOut();
  }
}
