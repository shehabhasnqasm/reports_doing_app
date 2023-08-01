import 'package:reports_doing_app/features/reports/domin_layer/entityes/task_entity.dart';

class Report {
  DateTime date;
  int? day;
  int? month;
  int? year;
  String? dayName;
  String reportId;
  String userId;
  String departmentName;
  bool? isHolidy;
  bool commited;
  List<TaskEntity>? tasks;
  // Timestamp createdAt;
  Report({
    required this.date,
    this.day,
    this.month,
    this.year,
    this.dayName,
    required this.reportId,
    required this.userId,
    required this.departmentName,
    this.isHolidy = false,
    this.commited = false,
    this.tasks,
    // required this.createdAt
  });
}
