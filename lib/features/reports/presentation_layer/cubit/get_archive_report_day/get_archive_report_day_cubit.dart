import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/report_model.dart';
import 'package:reports_doing_app/features/reports/domin_layer/usecases/get_archive_report_by_id_use_case.dart';

part 'get_archive_report_day_state.dart';

class GetArchiveReportDayCubit extends Cubit<GetArchiveReportDayState> {
  final GetArchiveReportByIdUseCase getArchiveReportByIdUseCase;
  GetArchiveReportDayCubit({required this.getArchiveReportByIdUseCase})
      : super(LoadingGetArchiveReportDayState());

  Future<void> getArchiveReportByID(String reportId) async {
    emit(LoadingGetArchiveReportDayState());
    final success = getArchiveReportByIdUseCase.getArchiveReportByID(reportId);
    success.fold((failure) {
      emit(FailureGetArchiveReportDayState(errorMsg: errorMsgState(failure)));
    }, (theReport) async {
      var data = await theReport;
      emit(SuccessGetArchiveReportDayState(archvReprtOfDay: data));
    });
  }

  //_____________________

  String errorMsgState(ReportFailure failure) {
    switch (failure.runtimeType) {
      case OfflineReportFailure:
        return OfflineReportFailure().message;
      case PublicErrorFailure:
        return PublicErrorFailure().message;

      default:
        return "unknown error when getting reports from firebase ";
    }
  }
}
