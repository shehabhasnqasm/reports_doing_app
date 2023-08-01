import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reports_doing_app/core/routing/rout_with_animation.dart';
import 'package:reports_doing_app/core/services/global_widgets/loader.dart';
import 'package:reports_doing_app/core/services/utils/global_dialogs.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_data.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/cubit/auth_cubit/auth_cubit.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/cubit/user_cubit/user_cubit.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/pages_widgets/login_page_widgets/background_img.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/pages_widgets/login_page_widgets/forget_password_btn.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/pages_widgets/login_page_widgets/rich_text_widget.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_reports_month/get_reports_month_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login-page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  final _loginFormKey = GlobalKey<FormState>();
  final FocusNode _passwordFocusNode = FocusNode();

  late String email;
  late String password;
  bool _obsecureText = true;

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _passwordFocusNode.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
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
  Widget build(BuildContext ctx) {
    //Size size = MediaQuery.of(ctx).size;
    return Scaffold(
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        body: BlocConsumer<UserCubit, UserState>(
          listener: (context, userState) {
            if (userState is SuccessLoginState) {
              BlocProvider.of<AuthCubit>(context).loggedIn();
            } else if (userState is FailureLoginState) {
              return GlobalDialogs.showErrorDialog(
                  error: userState.errorMsg, context: context);
            }
          },
          builder: (context, userState) {
            if (userState is SuccessLoginState) {
              return BlocConsumer<AuthCubit, AuthState>(
                listener: (context, authState) {
                  if (authState is AuthenticatedState) {
                    BlocProvider.of<GetReportsMonthCubit>(context)
                        .getCurrentMonthReports(DateTime.now());
                    Navigator.pushAndRemoveUntil(
                        context,
                        SlideTransitionAnimation(
                            page: HomePage(
                          userEntity: authState.userEntity,
                        )),
                        (route) => false);
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
                  }
                  return loginWidget(ctx);
                },
              );
            } else if (userState is FailureLoginState) {
              return loginWidget(ctx);
            } else if (userState is LoadingUserState) {
              return const LoadingCircularProgressWidget();
            }
            return loginWidget(ctx); //////
          },
        ));
  }

//---------------------------------------------------------------
  Widget loginWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // background img
        BackgroundImg(
          animationValue: _animation.value,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              const Text(
                "Login ",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 9,
              ),
              // rich text for register
              const RichTextWidget(),
              SizedBox(
                height: size.height * 0.05,
              ),
              formLogin(context),
              const SizedBox(
                height: 15,
              ),
              // forget passowrd btn
              const ForgetPasswordBtnWidget(),
              const SizedBox(
                height: 40,
              ),
              // login btn
              btnLogin(context)
            ],
          ),
        )
      ],
    );
  }

  void submitFormOnLogin() {
    // if (_loginFormKey.currentState != null) {

    // } else {}
    final isValid = _loginFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      email = _emailTextController.text.toLowerCase().trim();
      password = _passwordTextController.text.trim();
      UserData userData = UserData(email: email, password: password);
      BlocProvider.of<UserCubit>(context).login(userData);

      //Navigator.canPop(context) ? Navigator.pop(context) : null;
    } else {
      print("form not valid");
      log("form not valid");
    }
  }

  Widget btnLogin(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        submitFormOnLogin();
      }, //fct(),
      color: const Color.fromARGB(255, 211, 20, 84),
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: BorderSide.none),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Text(
              "login",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 7,
          ),
          Icon(
            Icons.login,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Widget formLogin(BuildContext context) {
    // late String email;
    // late String password;
    return Form(
        key: _loginFormKey,
        child: Column(
          children: [
            // email field
            TextFormField(
              onEditingComplete: () =>
                  Focus.of(context).requestFocus(_passwordFocusNode),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid Email address';
                }
                return null;
                //return null;
              },
              controller: _emailTextController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink.shade700)),
                  errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red))),
            ),
            // password field
            TextFormField(
              focusNode: _passwordFocusNode,
              onEditingComplete: () {
                submitFormOnLogin();
              },
              validator: (value) {
                if (value!.isEmpty || value.trim().length < 5) {
                  return 'Please enter a valid Password ';
                }
                return null;
                //  return null;
              },
              controller: _passwordTextController,
              obscureText: _obsecureText,
              keyboardType: TextInputType.visiblePassword,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        print("obsecureText");
                        _obsecureText = !_obsecureText;
                      });
                    }, // Icons.visibility_off
                    child: _obsecureText == true
                        ? const Icon(Icons.visibility, color: Colors.white)
                        : const Icon(Icons.visibility_off, color: Colors.white),
                  ),
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink.shade700)),
                  errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red))),
            ),
          ],
        ));
  }
}
