import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/email_user_model.dart';
import 'package:reports_doing_app/features/reports/domin_layer/repo/report_repo.dart';

class GetAdminEmailsForCurrentUserUseCase {
  final ReportRepo reportRepo;
  GetAdminEmailsForCurrentUserUseCase({required this.reportRepo});

  Future<Either<ReportFailure, List<EmailUserModel>>> call() async {
    return reportRepo.getAdminEmailsForCurrentUser();
  }
}
