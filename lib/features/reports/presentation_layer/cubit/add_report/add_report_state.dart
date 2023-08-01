part of 'add_report_cubit.dart';

abstract class AddReportState extends Equatable {
  const AddReportState();

  @override
  List<Object> get props => [];
}

class InitialState extends AddReportState {}

class LoadingAddedState extends AddReportState {}

class SuccessAddedReportState extends AddReportState {
  const SuccessAddedReportState();
}

class FailurAddedReportState extends AddReportState {
  final String errorMsg;
  const FailurAddedReportState({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
