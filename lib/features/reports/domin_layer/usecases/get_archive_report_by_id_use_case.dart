import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/report_model.dart';
import 'package:reports_doing_app/features/reports/domin_layer/repo/report_repo.dart';

class GetArchiveReportByIdUseCase {
  final ReportRepo reportRepo;
  GetArchiveReportByIdUseCase({required this.reportRepo});

  Either<ReportFailure, Future<ReportModel>> getArchiveReportByID(
      String reportId) {
    return reportRepo.getArchiveReportByID(reportId);
  }
}
