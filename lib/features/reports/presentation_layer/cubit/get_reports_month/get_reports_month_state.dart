part of 'get_reports_month_cubit.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class InitialState extends ReportState {}

class LoadingState extends ReportState {}

class SuccessGetState extends ReportState {
  final Stream<List<ReportModel>> allReports;
  const SuccessGetState({required this.allReports});

  @override
  List<Object> get props => [allReports];
}

class FailureGetState extends ReportState {
  final String errorMsg;
  const FailureGetState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
