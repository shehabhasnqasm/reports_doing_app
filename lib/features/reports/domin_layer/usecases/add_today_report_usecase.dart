import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/domin_layer/entityes/task_entity.dart';
import 'package:reports_doing_app/features/reports/domin_layer/repo/report_repo.dart';

class AddTodayReportUseCase {
  final ReportRepo reportRepo;
  AddTodayReportUseCase({required this.reportRepo});

  Future<Either<ReportFailure, Unit>> call(List<TaskEntity> reportTasks) async {
    return reportRepo.addTodayReport(reportTasks);
  }
}
