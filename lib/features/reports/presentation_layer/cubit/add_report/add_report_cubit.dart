import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/domin_layer/entityes/task_entity.dart';
import 'package:reports_doing_app/features/reports/domin_layer/usecases/add_today_report_usecase.dart';

part 'add_report_state.dart';

class AddReportCubit extends Cubit<AddReportState> {
  final AddTodayReportUseCase addTodayReportUseCase;
  AddReportCubit({required this.addTodayReportUseCase}) : super(InitialState());

//
  Future<void> addReport(List<TaskEntity> reportTasks) async {
    emit(LoadingAddedState());
    var addedReport = await addTodayReportUseCase.call(reportTasks);
    addedReport.fold((failure) {
      emit(FailurAddedReportState(errorMsg: errorMsgState(failure)));
    }, (unit) {
      emit(const SuccessAddedReportState());
    });
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
