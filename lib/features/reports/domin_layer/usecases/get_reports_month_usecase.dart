import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/report_model.dart';
import 'package:reports_doing_app/features/reports/domin_layer/repo/report_repo.dart';

class GetReportForMonthUseCase {
  final ReportRepo reportRepo;
  GetReportForMonthUseCase({required this.reportRepo});

  Either<ReportFailure, Stream<List<ReportModel>>> call(DateTime dateTime) {
    return reportRepo.getRepoertsForMonth(dateTime);
  }
}
