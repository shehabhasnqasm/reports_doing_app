import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reports_doing_app/features/reports/domin_layer/entityes/report_entity.dart';
import 'package:reports_doing_app/features/reports/domin_layer/entityes/task_entity.dart';

class ReportModel extends Report {
  ReportModel({
    required super.date,
    super.day,
    super.month,
    super.year,
    super.dayName,
    required super.reportId,
    required super.userId,
    required super.departmentName,
    super.isHolidy,
    required super.commited,
    super.tasks,
    //required super.createdAt
  });

//----------------------------

  factory ReportModel.fromSnapshot(
      DocumentSnapshot documentSnapshot, List<TaskEntity> reportTasks) {
    final timeStampDate = documentSnapshot.get('date');
    final date = timeStampDate.toDate(); // convert from timestamp to date

    // Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return ReportModel(
      date: date,
      day: documentSnapshot.get('day'),
      month: documentSnapshot.get('month'),
      year: documentSnapshot.get('year'),
      dayName: documentSnapshot.get('dayName'),
      reportId: documentSnapshot.get('reportId'),
      userId: documentSnapshot.get('userId'),
      departmentName: documentSnapshot.get('departmentName'),
      isHolidy: documentSnapshot.get('isHolidy'),
      commited: documentSnapshot.get('commited'),
      tasks: reportTasks,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "date":
          Timestamp.fromDate(date), //, // convert from dateTime to timestamp
      "day": day,
      "month": month,
      "year": year,
      "dayName": dayName,
      "reportId": reportId,
      "userId": userId,
      "departmentName": departmentName,
      "isHolidy": isHolidy,
      "commited": commited,
      "tasks": tasks,
      //"createdAt": createdAt
    };
  }
}

//________________________________________________________________________
class TaskModel extends TaskEntity {
  TaskModel({
    required super.taskId,
    required super.taskTitle,
    super.taskDetail,
    super.taskCopmlated,
    required super.createdAt,
    super.taskNumber,
  });

  factory TaskModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return TaskModel(
      taskId: documentSnapshot.get('taskId'),
      taskTitle: documentSnapshot.get('taskTitle'),
      taskDetail: documentSnapshot.get('taskDetail'),
      taskCopmlated: documentSnapshot.get('taskCopmlated'),
      createdAt: documentSnapshot.get('createdAt'),
      taskNumber: documentSnapshot.get('taskNumber'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "taskId": taskId,
      "taskTitle": taskTitle,
      "taskDetail": taskDetail,
      "taskCopmlated": taskCopmlated,
      "createdAt": createdAt,
      "taskNumber": taskNumber,
    };
  }
}
