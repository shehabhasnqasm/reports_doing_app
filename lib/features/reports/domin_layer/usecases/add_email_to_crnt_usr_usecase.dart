import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/domin_layer/repo/report_repo.dart';

class AddAdminEmailToCurrentUserUseCase {
  final ReportRepo reportRepo;
  AddAdminEmailToCurrentUserUseCase({required this.reportRepo});

  Future<Either<ReportFailure, Unit>> call(String email, String name) async {
    return reportRepo.addAdminEmailToCurrentUser(email, name);
  }
}
