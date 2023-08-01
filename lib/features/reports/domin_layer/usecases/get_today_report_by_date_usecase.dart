import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/report_model.dart';
import 'package:reports_doing_app/features/reports/domin_layer/repo/report_repo.dart';

class GetTodayReportByDateUseCase {
  final ReportRepo reportRepo;
  GetTodayReportByDateUseCase({required this.reportRepo});

  Either<ReportFailure, Future<List<ReportModel>>> getReportsOfDate(
      DateTime date) {
    return reportRepo.getReportsOfDate(date);
  }
}
