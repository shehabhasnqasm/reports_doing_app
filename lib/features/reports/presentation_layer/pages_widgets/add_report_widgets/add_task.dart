import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reports_doing_app/features/reports/domin_layer/entityes/task_entity.dart';
import 'package:reports_doing_app/core/constants/constants.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/provider/task_provider.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/pages_widgets/from_all_pages/text_widget.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    super.key,
    required this.i,
    required this.fct,
  });
  final int i;
  final Function fct;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    var index = widget.i + 1;
    return Column(
      children: [
        Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //----------------
                // title field
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.i < taskProvider.tempTasks.length
                        ? TextWidget(
                            lableText:
                                'Task ${taskProvider.tempTasks[widget.i].taskNumber} Title* :')
                        : TextWidget(lableText: 'Task $index Title* :'),
                    widget.i < taskProvider.tempTasks.length
                        ? TextButton(
                            onPressed: () {
                              if (widget.i < taskProvider.tempTasks.length) {
                                formKey.currentState?.reset();
                                taskProvider.reset(widget.i);
                              }
                            },
                            child: Text(
                              "reset",
                              style: TextStyle(color: dartBlue),
                            ))
                        : const SizedBox(),
                  ],
                ),
                TextFormField(
                  onEditingComplete: () {
                    if (formKey.currentState != null) {
                      formKey.currentState!.save();
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "You must enter task's title ";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    if (newValue != null) {
                      taskProvider.data[widget.i][taskTitle] = newValue;
                    }
                  },
                  onChanged: (value) {
                    if (formKey.currentState != null) {
                      formKey.currentState!.save();
                    }
                  },
                  initialValue: widget.i < taskProvider.tempTasks.length
                      ? taskProvider.tempTasks[widget.i].taskTitle
                      : taskProvider.data[widget.i][taskTitle],
                  keyboardAppearance: Brightness.dark,
                  style: TextStyle(color: dartBlue),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: InputDecoration(
                      hintText: "title",
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink.shade500)),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
                ),

                //_______________________
                // detaile field
                widget.i < taskProvider.tempTasks.length
                    ? TextWidget(
                        lableText:
                            'Task ${taskProvider.tempTasks[widget.i].taskNumber} Details* :')
                    : TextWidget(lableText: 'Task $index Detail* :'),

                TextFormField(
                  onEditingComplete: () {
                    if (formKey.currentState != null) {
                      formKey.currentState!.save();
                    }
                  },
                  initialValue: widget.i < taskProvider.tempTasks.length
                      ? taskProvider.tempTasks[widget.i].taskDetail
                      : taskProvider.data[widget.i][taskDetail],
                  onSaved: (newValue) {
                    if (newValue != null) {
                      taskProvider.data[widget.i][taskDetail] = newValue;
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "You must enter task's detail ";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (formKey.currentState != null) {
                      formKey.currentState!.save();
                    } else {}
                  },

                  maxLines: 4,
                  // maxLength: 200,
                  showCursor: true,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: dartBlue),
                  decoration: InputDecoration(
                      hintText: "detailes",
                      //label: 'detailes',
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink.shade500)),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
                ),
                //_________________
                ///  task is complated ??
                widget.i < taskProvider.tempTasks.length
                    ? TextWidget(
                        lableText:
                            'Task ${taskProvider.tempTasks[widget.i].taskNumber} is complated ?')
                    : TextWidget(lableText: 'Task $index is complated ?'),
                Consumer<TaskProvider>(
                    builder: (_, provider, ch) => Switch(
                        value: provider.data[widget.i][taskIsComplated],
                        onChanged: (bool newValue) {
                          if (formKey.currentState != null) {
                            formKey.currentState!.save();
                          }
                          taskProvider.editTaskIsComplateInData(
                              widget.i, newValue);
                          setState(() {});
                        })),
              ],
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: crudOnTask(
              context, MediaQuery.of(context).size, widget.i, taskProvider),
        ),
      ],
    );
  }

//____________________  Operation on tasks _______________
  Widget crudOnTask(
      BuildContext context, Size size, int i, TaskProvider taskProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // add or edit task
        i < taskProvider.tempTasks.length
            ? MaterialButton(
                color: Theme.of(context).scaffoldBackgroundColor,
                splashColor: Colors.orange,
                onPressed: () {
                  addOrEditTask(context, i, "Edit", taskProvider);
                },
                child: Text(
                  'Edit',
                  style: TextStyle(
                      color: dartBlue,
                      fontStyle: FontStyle.italic,
                      fontSize: 20.0),
                ))
            : MaterialButton(
                color: Theme.of(context).scaffoldBackgroundColor,
                splashColor: Colors.orange,
                onPressed: () {
                  //  Navigator.pop(context);
                  addOrEditTask(context, i, "Add", taskProvider);
                },
                child: Text(
                  'Add',
                  style: TextStyle(
                      color: dartBlue,
                      fontStyle: FontStyle.italic,
                      fontSize: 20.0),
                )),
        //______________
        // show the task
        MaterialButton(
            color: Theme.of(context).scaffoldBackgroundColor,
            splashColor: Colors.orange,
            onPressed: () {
              if (i < taskProvider.tempTasks.length) {
                showTaskInfoDialog(size, taskProvider.tempTasks[i], null);
              } else {
                showTaskInfoDialog(size, null, taskProvider.data[i]);
              }
            },
            child: Text(
              'Show',
              style: TextStyle(
                  color: dartBlue, fontStyle: FontStyle.italic, fontSize: 20.0),
            )),
        //_________________
        // remove task
        i < taskProvider.tempTasks.length
            ? MaterialButton(
                color: Colors.red.shade800,
                splashColor: Colors.orange,
                onPressed: () {
                  taskProvider.removeTaskInTempTasks(i);
                  taskProvider.removeTaskInData(i);

                  widget.fct();
                },
                child: const Text(
                  'Remove',
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 20.0),
                ))
            : Container(),
      ],
    );
  }

//_____________ Add or Edit tasks _______________________
  void addOrEditTask(BuildContext context, int i, String addOrEdit,
      TaskProvider taskProvider) async {
    if (formKey.currentState != null) {
      var id = i + 1;
      final isValid = formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        formKey.currentState!.save();
        try {
          var oneTask = TaskEntity(
            taskId: id.toString(),
            taskTitle: taskProvider.data[i][taskTitle],
            taskDetail: taskProvider.data[i][taskDetail],
            taskCopmlated: taskProvider.data[i][taskIsComplated],
            createdAt: Timestamp.fromMicrosecondsSinceEpoch(
              DateTime.now().microsecondsSinceEpoch,
            ),
            taskNumber: id.toString(),
          );

          if (addOrEdit == "Add") {
            taskProvider.addItemToTempTasks(oneTask);
          } else if (addOrEdit == "Edit") {
            taskProvider.editItemInTempTasks(i, oneTask);
          }
        } catch (e) {
          //throw Text("data");
          Fluttertoast.showToast(
              msg: "Error : ${e.toString()} ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          throw 'error: ${e.toString()}';
        } finally {
          widget.fct();
          FocusScope.of(context).unfocus();
          // Fluttertoast.showToast(
          //     msg: "successfully hhhhhhhhh",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.green,
          //     textColor: Colors.white,
          //     fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "form not valid",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Form  must not be null",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
//______________ Show Task Information Dialog ___________________

  void showTaskInfoDialog(Size size, TaskEntity? task, Map? data) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Task info :",
              style: TextStyle(color: Colors.deepOrange.shade900, fontSize: 20),
            ),
            content: SizedBox(
              width: size.width * 0.9,
              //height: double.maxFinite,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
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
                          width: 5,
                        ),
                        task != null
                            ? Flexible(
                                child: Text(
                                  task.taskTitle
                                  //
                                  ,
                                  style: const TextStyle(
                                      color: Color(0xFF00325A), //0xFF00325A
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            : Flexible(
                                child: Text(
                                  data![taskTitle]
                                  //
                                  ,
                                  style: const TextStyle(
                                      color: Color(0xFF00325A), //0xFF00325A
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                      ],
                    ),
                    const SizedBox(
                      height: 7.0,
                    ),
                    const Text(
                      "Detail :",
                      style: TextStyle(
                          color: Color(0xFF00325A), //0xFF00325A
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              task != null
                                  ? Flexible(
                                      child: Text(
                                        ''' ${task.taskDetail} ''',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color:
                                                Color(0xFF00325A), //0xFF00325A
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  : Flexible(
                                      child: Text(
                                        ''' ${data![taskDetail]} ''',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color:
                                                Color(0xFF00325A), //0xFF00325A
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 7.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Is Complated ?:",
                          style: TextStyle(
                              color: Color(0xFF00325A), //0xFF00325A
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        task != null
                            ? Text(
                                "${task.taskCopmlated}",
                                style: const TextStyle(
                                    color: Color(0xFF00325A), //0xFF00325A
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic),
                              )
                            : Text(
                                "${data![taskIsComplated]}",
                                style: const TextStyle(
                                    color: Color(0xFF00325A), //0xFF00325A
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic),
                              ),
                        const SizedBox(
                          width: 5,
                        ),
                        task != null
                            ? task.taskCopmlated
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green.shade800,
                                  )
                                : Icon(
                                    Icons.close,
                                    color: Colors.green.shade800,
                                  )
                            : data![taskIsComplated]
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
                  ]),
            ),
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
}
