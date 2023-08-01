import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/email_user_model.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/report_model.dart';
import 'package:reports_doing_app/features/reports/domin_layer/entityes/task_entity.dart';

abstract class ReportRepo {
  Either<ReportFailure, Stream<List<ReportModel>>> getRepoertsForMonth(
      DateTime dateTime);

  Either<ReportFailure, Future<ReportModel>> getArchiveReportByID(
      String reportId);
  Either<ReportFailure, Future<List<ReportModel>>> getReportsOfDate(
      DateTime date);

  Future<Either<ReportFailure, Unit>> addTodayReport(
      List<TaskEntity> reportTasks);

  Future<Either<ReportFailure, Unit>> addAdminEmailToCurrentUser(
      String email, String name);
  Future<Either<ReportFailure, List<EmailUserModel>>>
      getAdminEmailsForCurrentUser();
}
