import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:reports_doing_app/core/errors/reports/report_exceptions.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/email_user_model.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/report_model.dart';
import 'package:reports_doing_app/features/reports/domin_layer/entityes/task_entity.dart';
import 'package:uuid/uuid.dart';

abstract class RemoteDataFirebase {
  Future<Unit> addAdminEmailToCurrentUser(String email, String name);
  Future<List<EmailUserModel>> getAdminEmailsForCurrentUser();
  Stream<List<ReportModel>> getRepoertsForMonth(DateTime dateTime);
  Future<List<ReportModel>> getReportsOfDate(DateTime date);
  Future<ReportModel> getArchiveReportByID(String reportId);
  Future<Unit> addReport(List<TaskEntity> reportTasks);
  Future<Unit> editReport(
      ReportModel reportModel, List<TaskEntity> reportTasks);
}

class RemoteDateFirebaseImpl implements RemoteDataFirebase {
  FirebaseAuth auth;
  FirebaseFirestore firestore;
  FirebaseStorage firebaseStorage;
  RemoteDateFirebaseImpl(
      {required this.auth,
      required this.firestore,
      required this.firebaseStorage});

  //________________________________________________________________

  @override
  Future<Unit> addAdminEmailToCurrentUser(String email, String name) async {
    try {
      //__________________________
      if (auth.currentUser != null) {
        //
        final uid = auth.currentUser!.uid;
        await firestore
            .collection("admin-emails")
            .doc(uid)
            .collection("emails")
            .doc(email)
            .get()
            .then((value) {
          if (value.exists) {
          } else if (!value.exists) {
            firestore
                .collection("admin-emails")
                .doc(uid)
                .collection("emails")
                .doc(email)
                .set(EmailUserModel(
                  email: email,
                  name: name,
                  // reportTasks[i].taskNumber
                ).toDocument());
          }
        });
      }
      return Future.value(unit);
    } on SocketException catch (e) {
      throw SocketException(e.message);
    } catch (e) {
      throw PublicErrorException().setError(e.toString());
    }
  }

  //-------------------------------------------------------------------
  @override
  Future<List<EmailUserModel>> getAdminEmailsForCurrentUser() async {
    List<EmailUserModel> emails = [];
    try {
      if (auth.currentUser != null) {
        final uid = auth.currentUser!.uid;
        await firestore
            .collection("admin-emails")
            .doc(uid)
            .collection("emails")
            .get()
            .then((value) {
          for (var element in value.docs) {
            //var f = element.get("email");
            var model = EmailUserModel.fromSnapshot(element);
            emails.add(model);
          }
        });
      } else {
        print("error: auth.currentUser == null");
      }
      return emails;
    } on SocketException catch (e) {
      throw SocketException(e.message);
    } catch (e) {
      throw "Error :${e.toString()}";
    }
  }

  //_______________________________________________________________

  @override
  Future<Unit> addReport(List<TaskEntity> reportTasks) async {
    try {
      if (auth.currentUser != null) {
        final uid = auth.currentUser!.uid;
        //final dateTimeStamp = Timestamp.fromDate(DateTime.now());
        DateTime dateTime = DateTime.now();

        await firestore
            .collection("reports")
            //.where("date", isEqualTo: dateTimeStamp) // or
            .where("year", isEqualTo: dateTime.year)
            .where("month", isEqualTo: dateTime.month)
            .where("day", isEqualTo: dateTime.day)
            // .where("userId", isEqualTo: uid)
            .where("userId",
                isEqualTo: uid) // //.orderBy("date", descending: false)
            .get()
            .then((value) async {
          if (value.docs.isNotEmpty) {
            var doc = value.docs.first;

            final refCollection = firestore.collection("reports");
            await firestore
                .collection("reports")
                .doc(doc.id)
                .collection("tasks")
                .get()
                .then((value) {
              for (var element in value.docs) {
                element.reference.delete();
              }
            });
            for (int i = 0; i < reportTasks.length; i++) {
              var taskId = const Uuid().v4();
              await refCollection
                  .doc(doc.id)
                  .collection("tasks")
                  .doc(taskId)
                  .set(TaskModel(
                    taskId: taskId,
                    taskTitle: reportTasks[i].taskTitle,
                    taskDetail: reportTasks[i].taskDetail,
                    taskCopmlated: reportTasks[i].taskCopmlated,
                    createdAt: reportTasks[i].createdAt,
                    taskNumber: (i + 1).toString(), // reportTasks[i].taskNumber
                  ).toDocument());
            }
            // List tasks = [];
            // var end = refCollection.doc(doc.id).collection("tasks").get().then(
            //   (value) {
            //     for (var element in value.docs) {
            //       tasks.add(TaskModel.fromSnapshot(element));
            //     }
            //   },
            // );

            //return;
          } else if (value.docs.isEmpty) {
            // add new report to firestore
            final refCollection = firestore.collection("reports");
            final reportId = const Uuid().v4();
            bool isHolidy = false;

            String tody = DateFormat.EEEE().format(DateTime.now()); //sunday
            if (tody == 'Friday' || tody == 'Saturday') {
              isHolidy = true;
            } else {
              isHolidy = false;
            }

            if (isHolidy == false) {
              var reportModel = ReportModel(
                date: DateTime.now(), //2023-01-05 03:09:51.112110
                day: DateTime.now().day,
                month: DateTime.now().month,
                year: DateTime.now().year,
                dayName: tody, // DateFormat.EEEE().format(DateTime.now()),
                isHolidy: isHolidy,
                reportId: reportId,
                userId: uid,
                departmentName: "Programming", // user.departmentName ,
                commited: false,
                tasks: [],
                // createdAt: Timestamp.now()
              ).toDocument();

              refCollection.doc(reportId).set(reportModel);
              for (int i = 0; i < reportTasks.length; i++) {
                var taskId = const Uuid().v4();
                refCollection.doc(reportId).collection("tasks").doc(taskId).set(
                    TaskModel(
                            taskId: taskId,
                            taskTitle: reportTasks[i].taskTitle,
                            taskDetail: reportTasks[i].taskDetail,
                            taskCopmlated: reportTasks[i].taskCopmlated,
                            createdAt: reportTasks[i].createdAt,
                            taskNumber: reportTasks[i].taskNumber)
                        .toDocument());
              }
            } else if (isHolidy == true) {
              print("today is holidy");
            }
          }
        });
      }
      return Future.value(unit);
    } on SocketException catch (e) {
      throw SocketException(e.message);
    } catch (e) {
      throw PublicErrorException().setError(e.toString());
    }
  }
//-------------------------

//----------------------------------------------
  @override
  Future<Unit> editReport(
      ReportModel reportModel, List<TaskEntity> reportTasks) async {
    try {
      //__________________________
      if (auth.currentUser != null) {
        await firestore
            .collection("reports")
            .doc(reportModel.reportId)
            .get()
            .then((value) async {
          if (value.exists) {
            var reportData = ReportModel(
                date: reportModel.date,
                reportId: reportModel.reportId,
                userId: reportModel.userId,
                departmentName: reportModel.departmentName,
                commited: reportModel.commited,
                tasks: []);
            await firestore
                .collection("reports")
                .doc(reportModel.reportId)
                .update(reportData.toDocument());

            for (int i = 0; i < reportTasks.length; i++) {
              var taskId = const Uuid().v4();
              await firestore
                  .collection("reports")
                  .doc(reportModel.reportId)
                  .collection("tasks")
                  .doc(taskId)
                  .set(TaskModel(
                    taskId: taskId,
                    taskTitle: reportTasks[i].taskTitle,
                    taskDetail: reportTasks[i].taskDetail,
                    taskCopmlated: reportTasks[i].taskCopmlated,
                    createdAt: reportTasks[i].createdAt,
                    taskNumber: (i + 1)
                        .toString(), // reportTasks[i].taskNumber//reportTasks[i].taskNumber
                  ).toDocument());
            }
          } else {}
        });
      }
      return Future.value(unit);
    } on SocketException catch (e) {
      throw SocketException(e.message);
    } catch (e) {
      throw PublicErrorException().setError(e.toString());
    }
  }

//------------------------------------------
  @override
  Stream<List<ReportModel>> getRepoertsForMonth(DateTime dateTime) {
    try {
      //Stream<List<ReportModel> data;
      final uid = auth.currentUser!.uid;

      var thirtyDaysAgo = dateTime.subtract(const Duration(days: 30));
      final start = Timestamp.fromDate(thirtyDaysAgo);
      final end = Timestamp.fromDate(DateTime.now());

      return firestore
          .collection("reports")
          .where("date", isGreaterThanOrEqualTo: start)
          .where("date", isLessThanOrEqualTo: end)
          .where("userId", isEqualTo: uid)
          .orderBy("date", descending: false)
          .snapshots()
          .map((querySnap) => querySnap.docs
              .map((docSnap) => ReportModel.fromSnapshot(docSnap, []))
              .toList());
    } on SocketException catch (e) {
      throw SocketException(e.message);
    } catch (e) {
      throw PublicErrorException().setError(e.toString());
    }
  }

  //______________________________________________________________________________

//-----------------------------

  // Stream<List<TaskModel>> getReportTasks(String reportId) async* {
  //   var listTasks =
  //       firestore.collection("reports").doc(reportId).collection("tasks");

  //   yield* listTasks.snapshots().map((querySnapshot) => querySnapshot.docs
  //       .map((documentSnapshot) => TaskModel.fromSnapshot(documentSnapshot))
  //       .toList());
  //   // return null;
  // }

//--------------------------------------------
  @override
  Future<ReportModel> getArchiveReportByID(String reportId) async {
    late ReportModel report;
    try {
      if (auth.currentUser != null) {
        var reportArvData =
            await firestore.collection("reports").doc(reportId).get();
        var tasks = await getTasks(reportId); // or reportArvData.id
        // print(":tasks:$tasks");
        report = ReportModel.fromSnapshot(reportArvData, tasks);
      } else {
        print("error: auth.currentUser == null");
      }

      return report;
//   ---------------------
    } on SocketException catch (e) {
      throw SocketException(e.message);
    } catch (e) {
      throw "Error :${e.toString()}";
    }
  }

//----------------------------------------------
  @override
  Future<List<ReportModel>> getReportsOfDate(DateTime date) async {
    List<ReportModel> allReports = [];
    try {
      if (auth.currentUser != null) {
        final uid = auth.currentUser!.uid;
        var reports = await firestore
            .collection("reports")
            //.where("date", isEqualTo: thDateTimeStamp)
            .where("year", isEqualTo: date.year)
            .where("month", isEqualTo: date.month)
            .where("day", isEqualTo: date.day)
            .where("userId", isEqualTo: uid)
            .get();
        var dataReports = reports.docs;

        for (int i = 0; i < dataReports.length; i++) {
          var tasks = await getTasks(dataReports[i].id);
          allReports.add(ReportModel.fromSnapshot(dataReports[i], tasks));
        }
      } else {
        print("error: auth.currentUser == null");
      }
      return allReports;
    } on SocketException catch (e) {
      throw SocketException(e.message);
    } catch (e) {
      throw "error zzz:${e.toString()}";
    }
  }

//------------------------------------------------------
  Future<List<TaskEntity>> getTasks(String id) async {
    try {
      List<TaskEntity> tasks = [];
      var task = await firestore
          .collection("reports")
          .doc(id)
          .collection("tasks")
          .orderBy("createdAt", descending: false)
          .get();
      for (var docTask in task.docs) {
        var taskModel = TaskModel.fromSnapshot(docTask);
        tasks.add(taskModel);
      }
      return tasks;
    } catch (e) {
      throw Exception("error when get tasks ;;e:$e");
    }
  }
  //---------------------------------------------------------------------
}
