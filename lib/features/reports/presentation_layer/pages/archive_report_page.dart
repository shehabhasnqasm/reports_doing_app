import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reports_doing_app/core/services/global_widgets/loader.dart';
import 'package:reports_doing_app/core/services/utils/global_dialogs.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_archive_report_day/get_archive_report_day_cubit.dart';

class ArchiveReport extends StatelessWidget {
  final String reportId;
  const ArchiveReport({super.key, required this.reportId});
  static Color dartBlue = const Color(0xFF00325A);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    BlocProvider.of<GetArchiveReportDayCubit>(context)
        .getArchiveReportByID(reportId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: dartBlue,
        elevation: 1.0,
        title: Text(
          'Report Info',
          style: TextStyle(color: dartBlue),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<GetArchiveReportDayCubit, GetArchiveReportDayState>(
        listener: (context, state) {
          if (state is FailureGetArchiveReportDayState) {
            return GlobalDialogs.showErrorDialog(
                error: state.errorMsg, context: context);
          }
        },
        builder: (context, state) {
          if (state is LoadingGetArchiveReportDayState) {
            return const LoadingCircularProgressWidget();
          } else if (state is SuccessGetArchiveReportDayState) {
            var reportData = state.archvReprtOfDay;
            int tasksLength = 0;
            if (state.archvReprtOfDay.tasks?.length != null) {
              tasksLength = state.archvReprtOfDay.tasks!.length;
            } else if (state.archvReprtOfDay.tasks?.length == null ||
                state.archvReprtOfDay.tasks!.isEmpty) {
              tasksLength = 0;
            }

            return Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 8.0),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: tasksLength,
                itemBuilder: state.archvReprtOfDay.tasks?.length != null ||
                        state.archvReprtOfDay.tasks!.isNotEmpty
                    ? (context, index) {
                        var taskNumber = index + 1;
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 5, left: 10, right: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Task $taskNumber",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, top: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Title :",
                                      style: TextStyle(
                                          color: Color(0xFF00325A), //0xFF00325A
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    Text(
                                      reportData.tasks![index].taskTitle,
                                      style: const TextStyle(
                                          color: Color(0xFF00325A), //0xFF00325A
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(
                                      height: 7.0,
                                    ),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Detail :",
                                        // textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color:
                                                Color(0xFF00325A), //0xFF00325A
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "${reportData.tasks![index].taskDetail}",
                                          style: const TextStyle(
                                              color: Color(
                                                  0xFF00325A), //0xFF00325A
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic),
                                          maxLines: 5),
                                    ),
                                    const SizedBox(
                                      height: 7.0,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Is Complated ?:",
                                          style: TextStyle(
                                              color: Color(
                                                  0xFF00325A), //0xFF00325A
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${reportData.tasks![index].taskCopmlated}",
                                          style: const TextStyle(
                                              color: Color(
                                                  0xFF00325A), //0xFF00325A
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        reportData.tasks![index].taskCopmlated
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.green.shade800,
                                              )
                                            : Icon(
                                                Icons.close,
                                                color: Colors.green.shade800,
                                              )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    : (context, index) {
                        return const Center(
                          child: Text(
                            " This report is Empty! ;;; havn't any task's .",
                            style: TextStyle(
                              color: Color(0xFF00325A), //0xFF00325A
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1,
                    color: Color(0xFF00325A),
                  );
                },
              ),
            );
          } else if (state is FailureGetArchiveReportDayState) {
            return const Center(
              child: Text(
                " An error happen ;; please check your internet connection .",
                style: TextStyle(
                  color: Color(0xFF00325A), //0xFF00325A
                  fontSize: 18,
                ),
              ),
            );
          }
          return const Center(
            child: Text(
              " This report is Empty! ;;; havn't any task's .",
              style: TextStyle(
                color: Color(0xFF00325A), //0xFF00325A
                fontSize: 18,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar:
          BlocBuilder<GetArchiveReportDayCubit, GetArchiveReportDayState>(
        builder: (context, state) {
          if (state is LoadingGetArchiveReportDayState) {
            return const LoadingCircularProgressWidget();
          } else if (state is SuccessGetArchiveReportDayState) {
            var report = state.archvReprtOfDay;
            int taskNum = 0;
            int com = 0;

            if (state.archvReprtOfDay.tasks?.length != null ||
                state.archvReprtOfDay.tasks!.isNotEmpty) {
              taskNum = report.tasks!.length;
              com = report.tasks!
                  .where((element) => element.taskCopmlated == true)
                  .toList()
                  .length;
            } else {
              taskNum = 0;
              com = 0;
            }

            return Container(
              width: double.infinity,
              height: kBottomNavigationBarHeight + 50,
              padding: EdgeInsets.only(
                top: size.height * (20 / size.height),
                bottom: size.height * (20 / size.height),
                right: size.width * (20 / size.width),
                left: size.width * (20 / size.width),
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: dartBlue,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.only(
                      topRight:
                          Radius.circular(size.height * (20 / size.height)),
                      topLeft:
                          Radius.circular(size.height * (20 / size.height))),
                  color: dartBlue),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Tasks Count: ",
                        style: TextStyle(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " $taskNum",
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "complated tasks: ",
                        style: TextStyle(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " $com",
                        style: const TextStyle(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
          return const Text('');
        },
      ),
    );
  }
}
