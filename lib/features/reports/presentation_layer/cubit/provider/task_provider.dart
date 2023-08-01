import 'package:flutter/material.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/report_model.dart';
import 'package:reports_doing_app/features/reports/domin_layer/entityes/task_entity.dart';

class TaskProvider with ChangeNotifier {
  static const String taskId = 'id';
  static const String taskTitle = 'title';
  static const String taskDetail = 'detail';
  static const String taskIsComplated = 'isComplated';
  static const String taskNumber = 'taskNumber';

  List<Map<String, dynamic>> data = [];
  List<TaskEntity> tempTasks = [];

  reset(int index) {
    data[index][taskIsComplated] = tempTasks[index].taskCopmlated;

    notifyListeners();
  }

  void startestFun() {
    data = [];
    tempTasks.clear();
  }

  void startReadDataFromD(ReportModel report) {
    var tasksfromDb = report.tasks;
    //startestFun();
    // data = [];
    if (tasksfromDb == null || tasksfromDb.isEmpty) {
    } else {
      for (int i = 0; i < tasksfromDb.length; i++) {
        var length = data.length;
        if (i < length) {
          data[i] = {
            taskId: tasksfromDb[i].taskId,
            taskTitle: tasksfromDb[i].taskTitle,
            taskDetail: tasksfromDb[i].taskDetail,
            taskIsComplated: tasksfromDb[i].taskCopmlated
          };
        } else {
          data.add({
            taskId: tasksfromDb[i].taskId,
            taskTitle: tasksfromDb[i].taskTitle,
            taskDetail: tasksfromDb[i].taskDetail,
            taskIsComplated: tasksfromDb[i].taskCopmlated
          });
        }
      }
      tempTasks = tasksfromDb;
    }
    notifyListeners();
  }

//--------------------------------------------------
  void addItemToData(int index) {
    //var i = int.parse(index); //int.parse(index.substring(1, 2))
    data.insert(index, {
      taskId: index + 1,
      taskTitle: '',
      taskDetail: '',
      taskIsComplated: true,
      // taskNumber:index+1
    });
    notifyListeners();
  }

//----------------------------------------------------
  void editItemInData(
      int index, String title, String detail, bool isComplated) {
    data[index] = {
      taskId: index + 1,
      taskTitle: title,
      taskDetail: detail,
      taskIsComplated: isComplated
    };
    notifyListeners();
  }

//-----------------------------------------
  void editTaskIsComplateInData(int index, bool newValue) {
    data[index][taskIsComplated] = newValue;

    //   notifyListeners();
  }

//-----------------------------------------
  void removeTaskInData(int index) {
    data.removeAt(index);
    notifyListeners();
  }

//-------------------------------------
  void addItemToTempTasks(TaskEntity taskEntity) {
    int index =
        int.parse(taskEntity.taskId!); //int.parse(index.substring(1, 2))
    tempTasks.insert(index - 1, taskEntity);
    notifyListeners();
  }

//---------------------------------------
  void editItemInTempTasks(int index, TaskEntity taskEntity) {
    tempTasks[index] = taskEntity;
    notifyListeners();
  }

//----------------------------------------
  void removeTaskInTempTasks(int index) {
    tempTasks.removeAt(index);
    notifyListeners();
  }
  //-------------------------------------------
}
