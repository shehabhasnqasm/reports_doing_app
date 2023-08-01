import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/cubit/auth_cubit/auth_cubit.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/cubit/user_cubit/user_cubit.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/pages/auth/login_page.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/add_admin_email/add_admin_email_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/add_report/add_report_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_admin_emails/get_admin_emails_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_archive_report_day/get_archive_report_day_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_report_today/get_report_today_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_reports_month/get_reports_month_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/provider/task_provider.dart';
import 'package:reports_doing_app/utils/splash_screen.dart';
import 'firebase_options.dart';
import 'utils/service_locator.dart' as locator;

//_____________________________________________
Future<void> initAppSettings() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

//----------
Future<void> initDependencies() async {
  locator.serviceLocator();
}

//___________________________________________________
Future<void> main() async {
  await initAppSettings();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator.sl<AuthCubit>()..appStarted(),
        ),
        BlocProvider(
          create: (context) => locator.sl<UserCubit>(),
        ),
        BlocProvider(
          create: (context) => locator.sl<GetReportsMonthCubit>(),
        ),
        BlocProvider(
          create: (context) => locator.sl<AddReportCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              locator.sl<GetReportTodayByDateCubit>(), //GetReportDayCubit
        ),
        BlocProvider(
          create: (context) =>
              locator.sl<GetArchiveReportDayCubit>(), //GetReportDayCubit
        ),
        BlocProvider(
          create: (context) =>
              locator.sl<GetAdminEmailsCubit>(), //GetReportDayCubit
        ),
        BlocProvider(
          create: (context) =>
              locator.sl<AddAdminEmailCubit>(), //GetReportDayCubit
        ),
      ],
      // ChangeNotifierProvider(
      //  create: (_) => TaskProvider(),
      //),
      child: ChangeNotifierProvider(
        create: (_) => TaskProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // scaffoldBackgroundColor: const Color.fromARGB(
            //     255, 232, 229, 226), // const Color(0xFFEDE7DC),
            scaffoldBackgroundColor: const Color.fromARGB(255, 232, 229, 226),
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashPage(),
          routes: {
            //LandingPage.routeName: (context) => const LandingPage(),
            LoginPage.routeName: (context) => const LoginPage(),
          },
        ),
      ),
    );
  }
}
