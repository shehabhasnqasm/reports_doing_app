// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/report_model.dart';

abstract class GetReportDayState extends Equatable {
  const GetReportDayState();

  @override
  List<Object> get props => [];
}

class GetReportDayInitial extends GetReportDayState {}

class LoadingState extends GetReportDayState {}

class SuccessGetReportDayState extends GetReportDayState {
  List<ReportModel> reportsDay = [];
  SuccessGetReportDayState({required this.reportsDay});

  @override
  List<Object> get props => [reportsDay];
}

class FailureGetReportDayState extends GetReportDayState {
  final String errorMsg;
  const FailureGetReportDayState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
