import 'package:reports_doing_app/features/employees/domin_layer/repo/user_repo.dart';

class GetCurrentUserIdUseCase {
  final UserRepo userRepo;
  GetCurrentUserIdUseCase({required this.userRepo});

  Future<String> call() async {
    return await userRepo.getCurrentUserId();
  }
}
