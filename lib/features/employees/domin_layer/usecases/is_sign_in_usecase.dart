import 'package:reports_doing_app/features/employees/domin_layer/repo/user_repo.dart';

class IsSignInUseCase {
  final UserRepo userRepo;
  IsSignInUseCase({required this.userRepo});

  Future<bool> call() async {
    return await userRepo.isSignin();
  }
}
