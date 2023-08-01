part of 'get_archive_report_day_cubit.dart';

abstract class GetArchiveReportDayState extends Equatable {
  const GetArchiveReportDayState();

  @override
  List<Object> get props => [];
}

//class GetArchiveReportDayInitial extends GetArchiveReportDayState {}

class LoadingGetArchiveReportDayState extends GetArchiveReportDayState {}

class SuccessGetArchiveReportDayState extends GetArchiveReportDayState {
  final ReportModel archvReprtOfDay;
  const SuccessGetArchiveReportDayState({required this.archvReprtOfDay});

  @override
  List<Object> get props => [archvReprtOfDay];
}

class FailureGetArchiveReportDayState extends GetArchiveReportDayState {
  final String errorMsg;
  const FailureGetArchiveReportDayState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
