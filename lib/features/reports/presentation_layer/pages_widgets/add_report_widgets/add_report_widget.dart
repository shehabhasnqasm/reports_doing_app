// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reports_doing_app/core/services/global_widgets/loader.dart';
import 'package:reports_doing_app/core/services/utils/global_dialogs.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/report_model.dart';
import 'package:reports_doing_app/core/constants/constants.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/add_admin_email/add_admin_email_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/add_report/add_report_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_admin_emails/get_admin_emails_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_report_today/get_report_today_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/provider/task_provider.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/pages_widgets/add_report_widgets/add_task.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/pages_widgets/add_report_widgets/form_wdgt_email.dart';
import 'package:url_launcher/url_launcher.dart';

class AddReportWidget extends StatefulWidget {
  final ReportModel? report;
  const AddReportWidget(
      {super.key,
      required this.report,
      required this.focusedDay,
      required this.tasksNum});

  final DateTime focusedDay;
  final int tasksNum;
  @override
  State<AddReportWidget> createState() => _AddReportWidgetState();
}

class _AddReportWidgetState extends State<AddReportWidget>
    with TickerProviderStateMixin {
  static Color dartBlue = const Color(0xFF00325A);

  // size animation
  late AnimationController _sizeTransationController;
  late Animation<double> _sizeTransationAnimation;
  // slide animation
  late AnimationController _slideTransationController;
  late Animation<double> _slideTransationAnimation;

  var begin = const Offset(1.0, 0.0);
  var end = Offset.zero; // Offset(1.0, 0.0)
  var tween;
  var offestAnimation;
  var begin2 = const Offset(0.0, 0.0);
  var tween2;
  var offestAnimation2;
  late ReportModel todayReportModel;

  //_______________________________________________
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startFunction();
      // setState(() {});
    });
    _sizeTransationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _sizeTransationAnimation = CurvedAnimation(
        parent: _sizeTransationController, curve: Curves.easeInOut);
    //
    _slideTransationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _slideTransationAnimation = CurvedAnimation(
        parent: _slideTransationController, curve: Curves.easeInOut);
    tween = Tween(begin: begin, end: end);
    offestAnimation = _slideTransationAnimation.drive(tween);
    //
    tween2 = Tween(begin: begin2, end: end);
    offestAnimation2 = _slideTransationAnimation.drive(tween2);
    //_slideTransationController.reset();
    _slideTransationController.forward();
  }

//________________________________________________________
  @override
  void dispose() {
    _sizeTransationController.dispose();
    _slideTransationController.dispose();
    super.dispose();
  }

  int selectedTile = -1;
  bool reportIsNull = true;
  //_______________________
  Future<void> refresh() async {
    setState(() {
      _sizeTransationController.reverse();
    });
  }
//_____________________________

  void startFunction() {
    if (widget.report != null) {
      reportIsNull = false;
    }
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.startestFun();
    if (widget.report != null) {
      taskProvider.startReadDataFromD(widget.report!);
    }
  }

  //--------------------------------------------
  // send to  Email
  void mailTo(String email, String name) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    // String email = 'shihab.g79@gmail.com';
    // var url = 'mailto:$email';
    var date = DateTime.now();
    String title = "${date.year} /${date.month} /${date.day}";
    String body =
        'Hello my manger : $name \n\n There is my report for [$title] day.\n\n';
    for (int i = 0; i < taskProvider.tempTasks.length; i++) {
      String v = '''
Task ${i + 1}:-
 [Title]:  ${taskProvider.tempTasks[i].taskTitle}.     <> [Detail]:  ${taskProvider.tempTasks[i].taskDetail}.    <> [is Complate]: ${taskProvider.tempTasks[i].taskCopmlated.toString()}
 ''';
      body += '''
________________________
''';
      body += v;
    }
    body += "\n\n With Regards";
    String theEmail = email;
    var url = 'mailto:$theEmail?subject=Report $title&body=$body';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Error occured couldn\'t open link';
    }
  }
  //--------------------------------------------

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final taskProvider = Provider.of<TaskProvider>(
      context,
    );

    // if (widget.report != null) {
    //   print("widget.report.tasks.length:${widget.report!.tasks!.length}");
    // }
    var today = DateTime.utc(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var selectedDay = DateTime.utc(
        widget.focusedDay.year, widget.focusedDay.month, widget.focusedDay.day);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: dartBlue,
        elevation: 1.0,
        title: Text(
          "Tasks count : ${widget.tasksNum}",
          style: TextStyle(color: dartBlue),
        ),
        centerTitle: true,
      ),
      body: contentWidgets(context, taskProvider, size),
      floatingActionButton: selectedDay == today
          ? floatingActionBtn(taskProvider)
          : const Center(child: Text('')),
      bottomNavigationBar: BlocBuilder<AddReportCubit, AddReportState>(
          builder: (context, state) {
        if (state is LoadingAddedState) {
          return const LoadingCircularProgressWidget();
        } else if (state is SuccessAddedReportState) {
          return bottomWidget(context, taskProvider, size);
        } else if (state is FailurAddedReportState) {
          GlobalDialogs.showErrorDialog(
              error: state.errorMsg, context: context);
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text(state.errorMsg)));
          return bottomWidget(context, taskProvider, size);
        }
        return bottomWidget(context, taskProvider, size);
      }),
    );
  }

//____________________floatingActionBtn ________________________
  Widget floatingActionBtn(TaskProvider taskProvider) {
    return FloatingActionButton(
      // foregroundColor:
      //     taskProvider.data.length < 6 ? Colors.white : Colors.grey,
      foregroundColor: Colors.white,
      backgroundColor:
          taskProvider.data.length < 6 ? const Color(0xFF1F4069) : Colors.grey,

      elevation: 4.0,
      onPressed: taskProvider.data.length < 6
          ? () {
              if (taskProvider.data.isEmpty || taskProvider.data.length < 6) {
                if (taskProvider.data.length == taskProvider.tempTasks.length) {
                  taskProvider.addItemToData(taskProvider.data.length);
                  selectedTile = taskProvider.tempTasks.length;
                  setState(() {
                    _slideTransationController.reset();
                    _slideTransationController.forward();
                    _sizeTransationController.reset();
                    _sizeTransationController.forward();
                  });
                } else if (taskProvider.data.length >
                    taskProvider.tempTasks.length) {
                  selectedTile = taskProvider.tempTasks.length;
                  setState(() {
                    _slideTransationController.reset();
                    _slideTransationController.forward();
                    _sizeTransationController.reset();
                    _sizeTransationController.forward();
                    selectedTile = taskProvider.tempTasks.length;
                  });
                }
              } else {
                Fluttertoast.showToast(
                    msg: "Only 6 tasks allowed  🥲 ",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.yellow,
                    textColor: dartBlue,
                    fontSize: 16.0);
              }
            }
          //: null,
          : () {
              Fluttertoast.showToast(
                  msg: "Only 6 tasks allowed  🥲 ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.pink,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
      child: const Icon(Icons.add),
    );
  }

//--------------------------------------------------------------------
//______ bottomNavigationBar ------------------------------------------
  Widget bottomWidget(
      BuildContext context, TaskProvider taskProvider, Size size) {
    var today = DateTime.utc(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var selectedDay = DateTime.utc(
        widget.focusedDay.year, widget.focusedDay.month, widget.focusedDay.day);

    return selectedDay == today
        ? Container(
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
                  topRight: Radius.circular(size.height * (50 / size.height)),
                  topLeft: Radius.circular(size.height * (50 / size.height)),
                ),
                // color: const Color(0xFFEDE7DC),
                color: dartBlue //Colors.black12
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                    shape: const StadiumBorder(),
                    color: Colors.white,
                    splashColor: Colors.orange,
                    onPressed: () async {
                      await BlocProvider.of<AddReportCubit>(context)
                          .addReport(taskProvider.tempTasks);
                      BlocProvider.of<GetReportTodayByDateCubit>(context)
                          .getReportsforDate(widget.focusedDay);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: dartBlue),
                    )),
                MaterialButton(
                    shape: const StadiumBorder(),
                    color: Colors.white,
                    splashColor: Colors.orange,
                    onPressed: () {
                      showEmailListDialog(size);
                    },
                    child: Text(
                      "send",
                      style: TextStyle(color: dartBlue),
                    )),
                MaterialButton(
                    shape: const StadiumBorder(),
                    color: Colors.white,
                    splashColor: Colors.orange,
                    onPressed: () {
                      showAddAdminEmailDialog();
                    },
                    child: Text(
                      "add email",
                      style: TextStyle(color: dartBlue),
                    ))
              ],
            ),
          )
        : Container(
            child: const Text(""),
          );
  }

//-------------------------------------------------------
//------------- body -------------------------
  Widget contentWidgets(
      BuildContext context, TaskProvider taskProvider, Size size) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<TaskProvider>(
                builder: (_, taskConsumer, child) => Expanded(
                    child: ListView.builder(
                  key: Key(selectedTile.toString()),
                  shrinkWrap: true,
                  itemCount:
                      taskConsumer.data.isEmpty ? 0 : taskConsumer.data.length,
                  itemBuilder: (ctx, i) {
                    //   var index = i + 1;
                    return SlideTransition(
                      position: offestAnimation,
                      child: Card(
                          elevation: 2,
                          shadowColor: i < taskProvider.tempTasks.length
                              ? taskProvider.tempTasks[i].taskCopmlated == true
                                  ? Colors.green.shade300
                                  : Colors.orange.shade900
                              : Colors.yellow.shade200,
                          child: ExpansionTile(
                            textColor: dartBlue,
                            collapsedTextColor: dartBlue,
                            iconColor: dartBlue,
                            collapsedIconColor: dartBlue,
                            controlAffinity: ListTileControlAffinity.leading,
                            childrenPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            maintainState: true,
                            title: i < taskProvider.tempTasks.length
                                ? taskProvider.tempTasks[i].taskCopmlated ==
                                        true
                                    ? Text(
                                        "task ${taskProvider.tempTasks[i].taskNumber} ",
                                      )
                                    : Text(
                                        "task ${taskProvider.tempTasks[i].taskNumber}")
                                : Text(
                                    "task ${taskConsumer.data[i][taskTitle]}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _sizeTransationController.reverse();
                                    selectedTile = -1;
                                    if (i < taskConsumer.tempTasks.length) {
                                      taskConsumer.removeTaskInTempTasks(i);
                                      taskConsumer.removeTaskInData(i);
                                    } else {
                                      taskConsumer.removeTaskInData(i);
                                    }
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: size.width * (25 / size.width), //25
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * (20 / size.width), // 20,
                                  //MediaQuery.of(context).size.width / 34.4,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * (1 / size.width),
                                      vertical:
                                          size.height * (1 / size.height)),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: InkWell(
                                    onTap: null,
                                    child: i < taskProvider.tempTasks.length
                                        ? taskProvider.tempTasks[i]
                                                    .taskCopmlated ==
                                                true
                                            ? Icon(
                                                Icons.check_circle_outlined,
                                                color: Colors.green.shade800,
                                              )
                                            : Icon(
                                                Icons.edit_attributes_outlined,
                                                color: Colors.amber.shade800)
                                        : Icon(
                                            Icons.add_task_sharp,
                                            color: Colors.yellow.shade800,
                                          ),
                                  ),
                                )
                              ],
                            ),
                            key: Key(i.toString()),
                            initiallyExpanded: i == selectedTile,
                            onExpansionChanged: ((newState) {
                              if (newState == true) {
                                // selectedTile = i;
                                setState(() {
                                  _sizeTransationController.reset();
                                  _sizeTransationController.forward();
                                  selectedTile = i;
                                });
                              } else {
                                setState(() {
                                  _sizeTransationController.reverse();
                                  _sizeTransationController.reset();
                                  selectedTile = -1;
                                });
                              }
                            }),
                            children: [
                              SingleChildScrollView(
                                child: SizeTransition(
                                  sizeFactor: _sizeTransationAnimation,
                                  child: AddTask(
                                    i: i,
                                    fct: () async {
                                      await refresh();
                                      setState(() {
                                        selectedTile = -1;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )),
                    );

                    //
                  },
                )),
              ),
            ]));
  }
//----------------------------------------------

//____________show emails Dialog __________________
  void showEmailListDialog(Size size) {
    showDialog(
        context: context,
        builder: (ctx) {
          BlocProvider.of<GetAdminEmailsCubit>(context)
              .getAdminEmailsforCurntUser();
          return AlertDialog(
            title: Text(
              "Choose email:",
              style: TextStyle(color: Colors.deepOrange.shade900, fontSize: 20),
            ),
            content: SizedBox(
                width: size.width * 0.9,
                child: ConstrainedBox(
                  constraints: BoxConstraints.loose(size),
                  child: BlocBuilder<GetAdminEmailsCubit, GetAdminEmailsState>(
                    builder: (context, state) {
                      if (state is LoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.pink,
                          ),
                        );
                      } else if (state is SuccessGetAdminEmailsState) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.emails.length,
                          itemBuilder: (BuildContext context, int index) {
                            // var data = state.emails[index];
                            return InkWell(
                              onTap: () {
                                mailTo(state.emails[index].email,
                                    state.emails[index].name);
                                Navigator.canPop(context)
                                    ? Navigator.pop(context)
                                    : null;
                              },
                              child: ListTile(
                                title: Text(
                                  state.emails[index].name,
                                  style: const TextStyle(
                                      color: Color(0xFF00325A), //0xFF00325A
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic),
                                ),
                                leading: Icon(
                                  Icons.check_circle,
                                  color: Colors.red.shade400,
                                ),
                                subtitle: Text(state.emails[index].email),
                              ),
                            );
                          },
                        );
                      } else if (state is FailureGetAdminEmailsState) {
                        return const Center(child: Text(" Error"));
                      }
                      return const Center(
                          child: Text("Empty ;; please add Email."));
                    },
                  ),
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: dartBlue),
                  )),
            ],
          );
        });
  }

//-----------------------------------------------
//__________ adding user's manager emails
  void showAddAdminEmailDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Add email:",
              style: TextStyle(color: Colors.deepOrange.shade900, fontSize: 20),
            ),
            content: BlocConsumer<AddAdminEmailCubit, AddAdminEmailState>(
                listener: (context, state) {
              if (state is SuccessAddAdminEmailStatee) {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              }
            }, builder: (context, state) {
              if (state is LoadingAddAdminEmailState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: dartBlue,
                  ),
                );
              } else if (state is FailurAddAdminEmailState) {
                return const Center(
                  child: Text("An Error happend !"),
                );
              } else if (state is SuccessAddAdminEmailStatee) {
                // return const FormWidgetAdminEmail();
              }
              return const FormWidgetAddMangwrEmail();
            }),

            //  content: const FormWidgetAdminEmail(),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: dartBlue),
                  )),
            ],
          );
        });
  }
  //______________________________________________
}
