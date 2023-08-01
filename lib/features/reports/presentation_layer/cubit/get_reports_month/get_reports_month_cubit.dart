import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/report_model.dart';
import 'package:reports_doing_app/features/reports/domin_layer/usecases/get_reports_month_usecase.dart';

part 'get_reports_month_state.dart';

class GetReportsMonthCubit extends Cubit<ReportState> {
  final GetReportForMonthUseCase getReportForMonthUseCase;

  GetReportsMonthCubit({
    required this.getReportForMonthUseCase,
  }) : super(LoadingState());

  //----------------------- get all reports of current month ----------------------
  void getCurrentMonthReports(DateTime dateTime) {
    emit(LoadingState());
    final success = getReportForMonthUseCase.call(dateTime);
    success.fold((failure) {
      emit(FailureGetState(errorMsg: errorMsgState(failure)));
    }, (reports) {
      emit(SuccessGetState(allReports: reports));
    });
    //emit(const UnAuthenticatedState(errorMsg: ""));
  }
}

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
