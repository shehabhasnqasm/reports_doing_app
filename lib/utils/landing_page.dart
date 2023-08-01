import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reports_doing_app/core/routing/rout_with_animation.dart';
import 'package:reports_doing_app/core/services/utils/global_dialogs.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/cubit/auth_cubit/auth_cubit.dart';
import 'package:reports_doing_app/core/services/global_widgets/loader.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/pages/auth/login_page.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/pages/home_page.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/landing-page';
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, authState) {
                if (authState is AuthenticatedState) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      SlideTransitionAnimation(
                          page: HomePage(
                        userEntity: authState.userEntity,
                      )),
                      (route) => false);
                } else if (authState is UnAuthenticatedState) {
                  Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (BuildContext context) => const LoginPage(),
                  ));
                } else if (authState is ErrorMsgFirestoreState) {
                  GlobalDialogs.showErrorDialog(
                      error: authState.errorMsg, context: context);
                } else if (authState is NotGetInfoFromFirestoreState) {
                  BlocProvider.of<AuthCubit>(context).deleteUserAuth();
                }
              },
              builder: (context, authState) {
                if (authState is LoadingAuthState) {
                  return const LoadingCircularProgressWidget();
                } else if (authState is UnAuthenticatedState) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    alignment: Alignment.center,
                    child: const Text(
                      "...",
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }

                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  alignment: Alignment.center,
                  child: const Text(
                    "something happen error , please try again ",
                    style: TextStyle(color: Colors.black),
                  ),
                );
              },
            )));
  }
}
