import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reports_doing_app/core/services/constants/color_constant.dart';
import 'package:reports_doing_app/core/services/utils/global_dialogs.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_data.dart';
import 'package:reports_doing_app/features/employees/presentation_layer/cubit/user_cubit/user_cubit.dart';

class FormWidgetSignUp extends StatefulWidget {
  const FormWidgetSignUp({super.key});

  @override
  State<FormWidgetSignUp> createState() => _FormWidgetSignUpState();
}

class _FormWidgetSignUpState extends State<FormWidgetSignUp> {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  late TextEditingController _fullNameController;
  late TextEditingController _positionController;
  late TextEditingController _phoneController;
  bool _obsecureText = true;
  final _signUpFormKey = GlobalKey<FormState>();
  final FocusNode _fullnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _positionFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  String? fileImage;
  bool _isLoading = false;
  String? url;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _fullNameController.dispose();
    _positionController.dispose();
    _phoneController.dispose();
    _fullnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _fullNameController = TextEditingController();
    _positionController = TextEditingController();
    _phoneController = TextEditingController();

    super.initState();
  }

//-------------------------------------------------------------
  void submitFormOnSignUp() async {
    final isValid = _signUpFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (fileImage == null) {
        GlobalDialogs.showErrorDialog(
            error: 'please pick up an image', context: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        var email = _emailTextController.text.toLowerCase().trim();
        var password = _passwordTextController.text.trim();
        UserData userData = UserData(
            name: _fullNameController.text,
            email: email,
            password: password,
            phoneNumber: _phoneController.text,
            profileUrl: fileImage,
            positionInCompany: _positionController.text);
        BlocProvider.of<UserCubit>(context).registerNewUser(userData);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        GlobalDialogs.showErrorDialog(error: e.toString(), context: context);
      }
    } else {
      print("form not valid");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Form(
            key: _signUpFormKey,
            child: Column(
              children: [
                // name and profile user
                Row(
                  children: [
                    // name field
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        focusNode: _fullnameFocusNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_emailFocusNode),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field can\'t be missing';
                          }
                          return null;
                        },
                        controller: _fullNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            // labelText: 'name',
                            hintText: 'Full Name',
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.pink.shade700)),
                            errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red))),
                      ),
                    ),
                    // add user's image
                    Flexible(
                        flex: 1,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.width * 0.24,
                                width: size.width * 0.24,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(16)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  // child: fileImage == null
                                  // ? Image.network(
                                  //     'https://cdn-icons-png.flaticon.com/512/747/747376.png',
                                  //     fit: BoxFit.fill,
                                  //   )
                                  // : Image.file(File(fileImage!),
                                  //     fit: BoxFit.fill),

                                  child: fileImage == null
                                      ? Image.asset(
                                          'assets/images/auth/person_img.png',
                                          fit: BoxFit.fill)
                                      : Image.file(
                                          File(fileImage!),
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  _showAddImageDialog();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.pink,
                                      border: Border.all(
                                          width: 2, color: Colors.white),
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      fileImage == null
                                          ? Icons.add_a_photo
                                          : Icons.edit_outlined,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
                const SizedBox(height: 10),
                // email field
                TextFormField(
                  focusNode: _emailFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid Email address';
                    }
                    return null;
                    //return null;
                  },
                  controller: _emailTextController,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.next,
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
                const SizedBox(
                  height: 10,
                ),
                // password field
                TextFormField(
                  focusNode: _passwordFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_phoneFocusNode),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Please enter a valid Password ';
                    }
                    return null;
                    // return null;
                  },
                  controller: _passwordTextController,
                  obscureText: _obsecureText,
                  keyboardType: TextInputType.visiblePassword,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      // suffixIcon: StatefulBuilder(
                      //   builder: (context, setState) {
                      //     return GestureDetector(
                      //       onTap: () {
                      //         setState(() {
                      //           _obsecureText = !_obsecureText;
                      //         });
                      //       },
                      //       child: Icon(
                      //         _obsecureText
                      //             ? Icons.visibility
                      //             : Icons.visibility_off,
                      //         color: Colors.white,
                      //       ),
                      //     );
                      //   },
                      // ),
                      //  or
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obsecureText = !_obsecureText;
                          });
                        },
                        child: Icon(
                          _obsecureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
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
                const SizedBox(height: 10),
                // phone field
                TextFormField(
                  focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_positionFocusNode),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field can\'t be missing';
                    }
                    return null;
                    // return null;
                  },
                  onChanged: (v) {
                    // print(
                    //     ' _phoneController.text ${_phoneController.text}');
                  },
                  controller: _phoneController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'Phone number',
                      hintStyle: const TextStyle(color: Colors.white),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink.shade700)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
                ),
                const SizedBox(height: 10),
                //position in company field
                InkWell(
                  onTap: () {
                    showJobsDialog(size);
                  },
                  child: TextFormField(
                    enabled: false,
                    controller: _positionController,
                    focusNode: _positionFocusNode,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: submitFormOnSignUp,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field can\'t be missing';
                      }
                      return null;
                      //  return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Position in the company',
                        hintStyle: const TextStyle(color: Colors.white),
                        disabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.pink.shade700)),
                        errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                  ),
                ),
              ],
            )),
        const SizedBox(
          height: 40,
        ),
        _isLoading
            //loader
            ? const Center(
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator(),
                ),
              )
            // Register btn
            : MaterialButton(
                onPressed: submitFormOnSignUp,
                color: const Color.fromARGB(255, 211, 20, 84),
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide.none),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        "Register",
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
              ),
      ],
    );
  }

//___________________________________
  void _cropImage(fileImagePath) async {
    final cropImage = await ImageCropper().cropImage(sourcePath: fileImagePath,
        // maxHeight: 1080,
        //maxWidth: 1080,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ], uiSettings: [
      AndroidUiSettings(toolbarTitle: "cropper"),
      // IOSUiSettings(title: "cropper")
    ]);

    if (cropImage != null) {
      setState(() {
        fileImage = cropImage.path;
      });
    }
  }

//__________________________________
  final ImagePicker _picker = ImagePicker();
  void _pickImageWithCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      _cropImage(pickedFile!.path);
      Navigator.canPop(context) ? Navigator.pop(context) : null;
    } catch (e) {
      // setState(() {
      //   _pickImageError = e;
      // });
    }
  }

//_______________________________________
  void _pickImageWithGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      _cropImage(pickedFile!.path);
      Navigator.pop(context);
    } catch (e) {
      // setState(() {
      //   _pickImageError = e;
      // });
    }
  }

//________________________________________
  void _showAddImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'choose an option',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _pickImageWithCamera();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.4),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                        SizedBox(width: 7.0),
                        Text(
                          'Camera',
                          style: TextStyle(color: Colors.purple),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _pickImageWithGallery();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.4),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                        SizedBox(width: 7.0),
                        Text(
                          'Gallery',
                          style: TextStyle(color: Colors.purple),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

//____________________________________
  void showJobsDialog(size) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Jobs",
              style: TextStyle(color: Colors.pink.shade400, fontSize: 20),
            ),
            content: SizedBox(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.jobsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _positionController.text = Constants.jobsList[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.red.shade400,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.jobsList[index],
                              style: const TextStyle(
                                  color: Color(0xFF00325A), //0xFF00325A
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text('Close')),
              TextButton(onPressed: () {}, child: const Text('Cancel filter'))
            ],
          );
        });
  }
  //______________________________________-
}
