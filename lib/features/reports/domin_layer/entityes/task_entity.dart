//

//
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskEntity {
  final String? taskId;
  final String taskTitle;
  final String? taskDetail;
  final bool taskCopmlated;
  final Timestamp createdAt;
  final String? taskNumber;
  const TaskEntity(
      {this.taskId,
      required this.taskTitle,
      required this.taskDetail,
      this.taskCopmlated = false,
      required this.createdAt,
      this.taskNumber});
}
