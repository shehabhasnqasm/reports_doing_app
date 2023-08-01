import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reports_doing_app/core/routing/rout_with_animation.dart';
import 'package:reports_doing_app/core/services/global_widgets/loader.dart';
import 'package:reports_doing_app/core/services/utils/global_dialogs.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/cubit/auth_cubit/auth_cubit.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/cubit/user_cubit/user_cubit.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/pages_widgets/signup_page_widgets/background_img_sign_up.dart';

import 'package:reports_doing_app/features/employees/presentation_layer/pages_widgets/signup_page_widgets/form_widget_up.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/pages_widgets/signup_page_widgets/rich_text_widget_up.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/pages_widgets/signup_page_widgets/text_widget_up.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_reports_month/get_reports_month_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/pages/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocConsumer<UserCubit, UserState>(
          listener: (context, userState) {
            if (userState is SuccessRegisterState) {
              log("SuccessRegisterState");
              BlocProvider.of<AuthCubit>(context).loggedIn();
            } else if (userState is FailureRegisterState) {
              log("FailureRegisterState");
              return GlobalDialogs.showErrorDialog(
                  error: userState.errorMsg, context: context);
            }
          },
          builder: (context, userState) {
            if (userState is LoadingUserState) {
              return const LoadingCircularProgressWidget();
            } else if (userState is SuccessRegisterState) {
              return BlocConsumer<AuthCubit, AuthState>(
                listener: (context, authState) {
                  if (authState is AuthenticatedState) {
                    log("AuthenticatedState");
                    BlocProvider.of<GetReportsMonthCubit>(context)
                        .getCurrentMonthReports(DateTime.now());

                    Navigator.pushAndRemoveUntil(
                        context,
                        SlideTransitionAnimation(
                            page: HomePage(
                          userEntity: authState.userEntity,
                        )),
                        (route) => false);
                  } else if (authState is NotGetInfoFromFirestoreState) {
                    // delete the user
                    log("NotGetInfoFromFirestoreState");
                    BlocProvider.of<AuthCubit>(context).deleteUserAuth();
                  } else if (authState is ErrorMsgFirestoreState) {
                    log("ErrorMsgFirestoreState");
                    GlobalDialogs.showErrorDialog(
                        error: authState.errorMsg, context: context);
                  } else if (authState is UnAuthenticatedState) {}
                },
                builder: (context, authState) {
                  if (authState is LoadingAuthState) {
                    return const LoadingCircularProgressWidget();
                  } else if (authState is UnAuthenticatedState) {
                    return signUpWidget(context);
                  }
                  return const Center(
                    child: Text(
                      "error when we need to get user info from firestore",
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                },
              );
            } else if (userState is FailureRegisterState) {
              return signUpWidget(context);
            }
            return signUpWidget(context);
          },
        ));
  }

  Widget signUpWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        //background img (with animation)
        BackgroundImgSignUp(
          animationValue: _animation.value,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              // show text
              const TextWidgetSignUp(),
              const SizedBox(
                height: 9,
              ),
              // rich text for login
              const RichTextWidgetSignUp(),
              SizedBox(
                height: size.height * 0.05,
              ),
              // sign up form and signup btn
              const FormWidgetSignUp(),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        )
      ],
    );
  }
}
