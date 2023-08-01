import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:reports_doing_app/core/network/check_internet.dart';
import 'package:reports_doing_app/features/employees/data_layer/datasources/remote_data/remote_data_firebase.dart';
import 'package:reports_doing_app/features/employees/data_layer/repo_implementation/user_repo_impl.dart';
import 'package:reports_doing_app/features/employees/domin_layer/repo/user_repo.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/check_user_usecase.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/get_curent_user_id_usecase.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/get_users_usecase.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/register_user_usecase.dart';
import 'package:reports_doing_app/features/employees/domin_layer/usecases/sign_out_usecase.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/cubit/auth_cubit/auth_cubit.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/cubit/user_cubit/user_cubit.dart';
import 'package:reports_doing_app/features/reports/data_layer/datasources/remot_data/remot_data_firebase.dart';
import 'package:reports_doing_app/features/reports/data_layer/repo_impl/report_repo_impl.dart';
import 'package:reports_doing_app/features/reports/domin_layer/repo/report_repo.dart';
import 'package:reports_doing_app/features/reports/domin_layer/usecases/add_email_to_crnt_usr_usecase.dart';
import 'package:reports_doing_app/features/reports/domin_layer/usecases/add_today_report_usecase.dart';
import 'package:reports_doing_app/features/reports/domin_layer/usecases/get_admin_emails_for_crnt_usr_uc.dart';
import 'package:reports_doing_app/features/reports/domin_layer/usecases/get_archive_report_by_id_use_case.dart';
import 'package:reports_doing_app/features/reports/domin_layer/usecases/get_reports_month_usecase.dart';
import 'package:reports_doing_app/features/reports/domin_layer/usecases/get_today_report_by_date_usecase.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/add_admin_email/add_admin_email_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/add_report/add_report_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_admin_emails/get_admin_emails_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_archive_report_day/get_archive_report_day_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_report_today/get_report_today_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_reports_month/get_reports_month_cubit.dart';

import '../features/employees/domin_layer/usecases/delete_user_f_auth_usecase.dart';
import '../features/employees/domin_layer/usecases/get_user_info.dart';
import '../features/employees/domin_layer/usecases/is_sign_in_usecase.dart';
import '../features/employees/domin_layer/usecases/sign_in_user_usecase .dart';

final sl = GetIt.instance;

Future<void> serviceLocator() async {
// core
  sl.registerLazySingleton<CheckInternet>(
      () => CheckInternetImplement(connectionChecker: sl()));

// feacher
//_______________________________________________
// puplic
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  // InternetConnectionChecker connectionChecker = InternetConnectionChecker();
  // sl.registerLazySingleton(() => connectionChecker);  // or
  sl.registerSingleton(InternetConnectionChecker());

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => firestore);
  sl.registerLazySingleton(() => firebaseStorage);
//_________________________________________________-
// data source
  sl.registerLazySingleton<RemoteData>(
      () => RemoteDataImp(auth: sl(), firestore: sl(), firebaseStorage: sl()));
  sl.registerLazySingleton<RemoteDataFirebase>(() => RemoteDateFirebaseImpl(
      auth: sl(), firestore: sl(), firebaseStorage: sl()));
//____________________________________
// repositoy
  sl.registerLazySingleton<UserRepo>(
      () => UserRepoImpl(remoteDataFirebase: sl(), checkInternet: sl()));
  sl.registerLazySingleton<ReportRepo>(
      () => ReportRepoImpl(remoteDataFirebase: sl()));
//_________________________________
// use cases
// authentication
  sl.registerLazySingleton(() => IsSignInUseCase(userRepo: sl()));
  sl.registerLazySingleton(() => SignOutUseCase(userRepo: sl()));
  sl.registerLazySingleton(() => GetCurrentUserIdUseCase(userRepo: sl()));
  sl.registerLazySingleton(() => GetUserInfoUseCase(userRepo: sl()));
  sl.registerLazySingleton(() => SignInUserUseCase(userRepo: sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(userRepo: sl()));
  sl.registerLazySingleton(() => DeleteUserFromAuthUseCase(userRepo: sl()));
  sl.registerLazySingleton(() => CheckUserUseCase(userRepo: sl()));
  sl.registerLazySingleton(() => GetUsersUseCase(userRepo: sl()));
//reports
  sl.registerLazySingleton(() => AddTodayReportUseCase(reportRepo: sl()));
  sl.registerLazySingleton(() => GetTodayReportByDateUseCase(reportRepo: sl()));
  sl.registerLazySingleton(() => GetReportForMonthUseCase(reportRepo: sl()));
  sl.registerLazySingleton(() => GetArchiveReportByIdUseCase(reportRepo: sl()));
  sl.registerLazySingleton(
      () => AddAdminEmailToCurrentUserUseCase(reportRepo: sl()));
  sl.registerLazySingleton(
      () => GetAdminEmailsForCurrentUserUseCase(reportRepo: sl()));
//_______________________________________________________
//cubit state management

// authentication
  sl.registerFactory(() => AuthCubit(
      getCurrentUserIdUseCase: sl(),
      getUserInfoUseCase: sl(),
      isSignInUseCase: sl(),
      signOutUseCase: sl(),
      deleteUserFromAuthUseCase: sl()));
  sl.registerFactory(() => UserCubit(
      signInUserUseCase: sl(),
      registerUserUseCase: sl(),
      deleteUserFromAuthUseCase: sl()));

  // reports cubit
  sl.registerFactory(
      () => GetReportsMonthCubit(getReportForMonthUseCase: sl()));
  sl.registerFactory(() => AddReportCubit(addTodayReportUseCase: sl()));
  sl.registerFactory(
      () => GetReportTodayByDateCubit(getReportByDateUseCase: sl()));
  sl.registerFactory(
      () => GetArchiveReportDayCubit(getArchiveReportByIdUseCase: sl()));
  sl.registerFactory(() => GetAdminEmailsCubit(
        getAdminEmailsForCurrentUserUseCase: sl(),
      ));
  sl.registerFactory(() => AddAdminEmailCubit(
        addAdminEmailToCurrentUserUseCase: sl(),
      ));

//
}
