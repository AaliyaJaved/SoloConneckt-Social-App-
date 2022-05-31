import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloconneckt/Services/ApiCalling.dart';
import 'package:soloconneckt/Services/constants.dart';
import 'package:soloconneckt/Styles/palette.dart';
import 'package:soloconneckt/Views/phoneNumber/index.dart';
import 'package:soloconneckt/Widgets/textFeildDecoration.dart';

import '../../Styles/ThemeHelper.dart';
import '../../Widgets/ShowResponse.dart';
import '../MainPage/index.dart';
import '../SignUp/index.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final password2Controller = new TextEditingController();
  final numberController = new TextEditingController();
  final nameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool checkboxValue = false;

  String usename = "",
      email = "",
      image = "",
      id = "",
      password = "",
      number = "";
  String islogin = "No";
  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usename = prefs.getString("user_name") == null
        ? ""
        : prefs.getString("user_name")!;
    password = prefs.getString("user_password") == null
        ? ""
        : prefs.getString("user_password")!;
    email = prefs.getString("user_email") == null
        ? ""
        : prefs.getString("user_email")!;
    number = prefs.getString("phone") == null ? "" : prefs.getString("phone")!;
    image = prefs.getString("image") == null ? "" : prefs.getString("image")!;
    id = prefs.getString("user_id") == null ? "" : prefs.getString("user_id")!;
    String? islogin = prefs.getString("is_logged_in");
    emailController.text = email;
    nameController.text = usename;
    passwordController.text = password;
    password2Controller.text = password;
    numberController.text = number;
    setState(() {});
  }

  initState() {
    addStringToSF();
    super.initState();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _getFromGallery();
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _getFromCamera();
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  /// Get from gallery
  _getFromGallery() async {
    // ignore: deprecated_member_use
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    // if (pickedFile != null) {
    //   setState(() {
    //     imageFile = File(pickedFile.path);
    //   });
    // }
    _cropImage(pickedFile?.path);
  }

  _cropImage(filePath) async {
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 1080,
        maxHeight: 1080,
        cropStyle: CropStyle.circle);
    if (croppedImage != null) {
      imageFile = croppedImage;
      setState(() {});
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    // ignore: deprecated_member_use
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    // if (pickedFile != null) {
    //   setState(() {
    //     imageFile = File(pickedFile.path);
    //   });
    // }
    _cropImage(pickedFile?.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      // padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        image: imageFile != null
                            ? DecorationImage(
                                image: FileImage(
                                  imageFile!,
                                ),
                                fit: BoxFit.cover)
                            : null,
                        shape: BoxShape.circle,
                        border: Border.all(width: 5, color: Colors.white),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: imageFile == null
                          ? image == ""
                              ? Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 70.0,
                                )
                              : Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          scale: 2,
                                          image: NetworkImage(imageUrlUser +
                                              image.toString()))),
                                )
                          : Container(),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(65, 60, 0, 0),
                        child: IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.grey.shade700,
                            size: 30.0,
                          ),
                          onPressed: () {
                            _showChoiceDialog(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full Name*",
                        style: ThemeHelper().TextStyleMethod2(
                            12, context, FontWeight.w600, Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value != null && value.trim().length < 3) {
                            return 'This field requires a minimum of 3 characters';
                          }

                          return null;
                        },
                        style: ThemeHelper().TextStyleMethod2(
                            16, context, FontWeight.bold, Palette.Black),
                        decoration: TextFormFeildDecoration(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email Address*",
                        style: ThemeHelper().TextStyleMethod2(
                            12, context, FontWeight.w600, Colors.black),
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter a valid email address";
                          } else if (RegExp(r'\S+@\S+\.\S+').hasMatch(val) ==
                              false) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                        style: ThemeHelper().TextStyleMethod2(
                            16, context, FontWeight.bold, Palette.Black),
                        decoration: TextFormFeildDecoration(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password*",
                        style: ThemeHelper().TextStyleMethod2(
                            12, context, FontWeight.w600, Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        validator: (value) {
                          if (value != null && value.trim().length < 3) {
                            return 'This field requires a minimum of 3 characters';
                          }

                          return null;
                        },
                        style: ThemeHelper().TextStyleMethod2(
                            16, context, FontWeight.bold, Palette.Black),
                        decoration: TextFormFeildDecoration(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Re-type Password*",
                        style: ThemeHelper().TextStyleMethod2(
                            12, context, FontWeight.w600, Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: password2Controller,
                        validator: (value) {
                          if (value != null && value.trim().length < 3) {
                            return 'This field requires a minimum of 3 characters';
                          }

                          return null;
                        },
                        style: ThemeHelper().TextStyleMethod2(
                            16, context, FontWeight.bold, Palette.Black),
                        decoration: TextFormFeildDecoration(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phone No*",
                        style: ThemeHelper().TextStyleMethod2(
                            12, context, FontWeight.w600, Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: numberController,
                        validator: (value) {
                          if (value != null && value.trim().length < 11) {
                            return 'The number must contain 11 digits.';
                          }

                          return null;
                        },
                        keyboardType: TextInputType.number,
                        style: ThemeHelper().TextStyleMethod2(
                            16, context, FontWeight.bold, Palette.Black),
                        decoration: TextFormFeildDecoration(),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (password2Controller.text == passwordController.text) {
                        ApiCall().EditUser(id,nameController.text, emailController.text, numberController.text, passwordController.text,imageFile,"", context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => PhoneNumber(
                        //             email: emailController.text,
                        //             name: nameController.text,
                        //             password: passwordController.text,
                        //           )),
                        // );
                      } else {
                        ShowResponse("password does not match", context);
                      }
                    }
                  },
                  child: Container(
                    height: 58,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: Text(
                        "Save",
                        style: ThemeHelper().TextStyleMethod2(
                            16, context, FontWeight.bold, Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
