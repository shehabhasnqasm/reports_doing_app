import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
// import 'package:reports_doing_app/features/reports/data_layer/models/report_model.dart';

import 'package:reports_doing_app/features/reports/domin_layer/usecases/get_today_report_by_date_usecase.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_report_today/get_report_today_state.dart';

class GetReportTodayByDateCubit extends Cubit<GetReportDayState> {
  final GetTodayReportByDateUseCase getReportByDateUseCase;

  GetReportTodayByDateCubit({required this.getReportByDateUseCase})
      : super(LoadingState());

  Future<void> getReportsforDate(DateTime dateTime) async {
    emit(LoadingState());
    final success = getReportByDateUseCase.getReportsOfDate(dateTime);
    success.fold((failure) {
      emit(FailureGetReportDayState(errorMsg: errorMsgState(failure)));
    }, (reports) async {
      var listReports = await reports;
      if (listReports.isNotEmpty) {
        emit(SuccessGetReportDayState(reportsDay: listReports));
      } else if (listReports.isEmpty) {
        emit(GetReportDayInitial());
      }

      //---
    });
    //emit(const UnAuthenticatedState(errorMsg: ""));
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
