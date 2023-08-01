import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:reports_doing_app/core/errors/reports/report_exceptions.dart';
import 'package:reports_doing_app/core/errors/reports/report_failures.dart';
import 'package:reports_doing_app/features/reports/data_layer/datasources/remot_data/remot_data_firebase.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/email_user_model.dart';
import 'package:reports_doing_app/features/reports/data_layer/models/report_model.dart';
import 'package:reports_doing_app/features/reports/domin_layer/entityes/task_entity.dart';
import 'package:reports_doing_app/features/reports/domin_layer/repo/report_repo.dart';

class ReportRepoImpl extends ReportRepo {
  RemoteDataFirebase remoteDataFirebase;

  ReportRepoImpl({required this.remoteDataFirebase});

//--------------------------------------------
  @override
  Future<Either<ReportFailure, Unit>> addTodayReport(
      List<TaskEntity> reportTasks) async {
    try {
      await remoteDataFirebase.addReport(reportTasks);
      return right(unit);
    } on SocketException {
      return left(OfflineReportFailure());
    } on PublicErrorException {
      final error = PublicErrorException().message;
      return left(PublicErrorFailure().setError(error));
    }
  }

//----------------------------------------------------
  @override
  Either<ReportFailure, Future<ReportModel>> getArchiveReportByID(
      String reportId) {
    try {
      final report = remoteDataFirebase.getArchiveReportByID(reportId);
      return Right(report);
    } on SocketException {
      return left(OfflineReportFailure());
    } on PublicErrorException {
      final error = PublicErrorException().message;
      return left(PublicErrorFailure().setError(error));
    }
  }

//--------------------------------------
  @override
  Either<ReportFailure, Future<List<ReportModel>>> getReportsOfDate(
      DateTime date) {
    try {
      final report = remoteDataFirebase.getReportsOfDate(date);
      return Right(report);
    } on SocketException {
      return left(OfflineReportFailure());
    } on PublicErrorException {
      final error = PublicErrorException().message;
      return left(PublicErrorFailure().setError(error));
    }
  }

//---------------------------------------
  @override
  Either<ReportFailure, Stream<List<ReportModel>>> getRepoertsForMonth(
      DateTime dateTime) {
    try {
      final reports = remoteDataFirebase.getRepoertsForMonth(dateTime);
      return Right(reports);
    } on SocketException {
      return left(OfflineReportFailure());
    } on PublicErrorException {
      final error = PublicErrorException().message;
      return left(PublicErrorFailure().setError(error));
    }
  }

//--------------------------------------
  @override
  Future<Either<ReportFailure, Unit>> addAdminEmailToCurrentUser(
      String email, String name) async {
    try {
      await remoteDataFirebase.addAdminEmailToCurrentUser(email, name);
      return right(unit);
    } on SocketException {
      return left(OfflineReportFailure());
    } on PublicErrorException {
      final error = PublicErrorException().message;
      return left(PublicErrorFailure().setError(error));
    }
  }

//------------------------------------------------------
  @override
  Future<Either<ReportFailure, List<EmailUserModel>>>
      getAdminEmailsForCurrentUser() async {
    try {
      final report = await remoteDataFirebase.getAdminEmailsForCurrentUser();
      return Right(report);
    } on SocketException {
      return left(OfflineReportFailure());
    } on PublicErrorException {
      final error = PublicErrorException().message;
      return left(PublicErrorFailure().setError(error));
    }
  }
  //------------------------------------------
}
