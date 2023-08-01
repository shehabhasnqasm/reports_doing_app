import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reports_doing_app/core/services/global_widgets/loader.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_report_today/get_report_today_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_report_today/get_report_today_state.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/pages_widgets/add_report_widgets/add_report_widget.dart';

class AddReportGame extends StatefulWidget {
  const AddReportGame(
      {super.key, required this.focusedDay, required this.reportId});

  final DateTime focusedDay;
  final String? reportId;

  @override
  State<AddReportGame> createState() => _AddReportGameState();
}

class _AddReportGameState extends State<AddReportGame> {
  static Color dartBlue = const Color(0xFF00325A);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<GetReportTodayByDateCubit>(context)
          .getReportsforDate(widget.focusedDay);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return BlocBuilder<GetReportTodayByDateCubit, GetReportDayState>(
        builder: (context, state) {
      if (state is LoadingState) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: dartBlue,
            elevation: 1.0,
            title: Text(
              'Report Today',
              style: TextStyle(color: dartBlue),
            ),
            centerTitle: true,
          ),
          body: const LoadingCircularProgressWidget(),
        );
      } else if (state is FailureGetReportDayState) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: dartBlue,
            elevation: 1.0,
          ),
          body: const Center(
            child: Text(
              "An Error happen",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      } else if (state is SuccessGetReportDayState) {
        var data = state.reportsDay.first;
        final tasksNum = data.tasks != null ? data.tasks!.length : 0;
        return AddReportWidget(
          report: data,
          focusedDay: widget.focusedDay,
          tasksNum: tasksNum,
        );
      } else if (state is GetReportDayInitial) {
        return AddReportWidget(
          report: null,
          focusedDay: widget.focusedDay,
          tasksNum: 0,
        );
      }

      return const Scaffold(
          body: Center(child: Text("loading ,,, please wait ...")));
    });
  }
}
