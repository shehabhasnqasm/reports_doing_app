import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reports_doing_app/core/services/utils/global_dialogs.dart';
import 'package:reports_doing_app/core/constants/constants.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/add_admin_email/add_admin_email_cubit.dart';

class FormWidgetAddMangwrEmail extends StatefulWidget {
  const FormWidgetAddMangwrEmail({super.key});

  @override
  State<FormWidgetAddMangwrEmail> createState() => _FormWidgetAdminEmailState();
}

class _FormWidgetAdminEmailState extends State<FormWidgetAddMangwrEmail> {
  late TextEditingController _emailTextController;
  late TextEditingController _fullNameController;
  final _adminFormKey = GlobalKey<FormState>();
  final FocusNode _fullnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailTextController.dispose();
    _fullNameController.dispose();
    _fullnameFocusNode.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _emailTextController = TextEditingController();
    _fullNameController = TextEditingController();
    super.initState();
  }

//________ submit Form Adding user's Mangers Emails ____________
  void submitFormAddingMangerEmail() async {
    final isValid = _adminFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        var email = _emailTextController.text.toLowerCase().trim();
        var name = _fullNameController.text;
        BlocProvider.of<AddAdminEmailCubit>(context).addAdminEmail(name, email);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        GlobalDialogs.showErrorDialog(error: e.toString(), context: context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: "Sorry ! ; form not valid .",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      _isLoading = false;
    });
  }

//_____________________________________
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
            key: _adminFormKey,
            child: Column(
              children: [
                // email field
                TextFormField(
                  focusNode: _emailFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_fullnameFocusNode),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid Email address';
                    }
                    return null;
                  },
                  controller: _emailTextController,
                  style: const TextStyle(color: Colors.black),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: dartBlue),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: dartBlue)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink.shade700)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
                ),

                const SizedBox(height: 10),
                TextFormField(
                  focusNode: _fullnameFocusNode,
                  textInputAction: TextInputAction.next,
                  // onEditingComplete: () =>
                  //     FocusScope.of(context).requestFocus(_emailFocusNode),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field can\'t be missing';
                    }
                    return null;
                  },
                  controller: _fullNameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      // labelText: 'name',
                      hintText: 'Full Name',
                      hintStyle: TextStyle(color: dartBlue),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: dartBlue)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink.shade700)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
                ),
              ],
            )),
        const SizedBox(
          height: 40,
        ),
        _isLoading
            //loader
            ? Center(
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator(
                    color: dartBlue,
                  ),
                ),
              )
            // Register btn
            : MaterialButton(
                onPressed: () {
                  submitFormAddingMangerEmail();
                },
                color: const Color.fromARGB(255, 211, 20, 84),
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide.none),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    "add email",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ],
    );
  }
}
