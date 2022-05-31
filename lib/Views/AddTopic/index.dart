import 'dart:io';

import 'package:flutter/material.dart';
import 'package:soloconneckt/Styles/ThemeHelper.dart';
import 'package:soloconneckt/Styles/palette.dart';
import 'package:soloconneckt/Views/VerificationPage/index.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soloconneckt/Widgets/textFeildDecoration.dart';

import '../../Services/ApiCalling.dart';
import '../../Widgets/ShowResponse.dart';

class AddTopic extends StatefulWidget {
  String id;
  AddTopic(
      {required this.id,
      key})
      : super(key: key);

  @override
  State<AddTopic> createState() => _AddTopicState();
}

class _AddTopicState extends State<AddTopic> {
  final nameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text(
                        "Add Topic",
                        style: ThemeHelper()
                            .TextStyleMethod1(18, context, FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 50,
              ),
              Stack(
                children: [
                  Container(
                    width: 150,
                    height: 150,
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
                        ? Icon(
                            Icons.person,
                            color: Colors.grey.shade300,
                            size: 70.0,
                          )
                        : Container(),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(60, 60, 0, 0),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Caption*",
                        style: ThemeHelper().TextStyleMethod2(
                            12,
                            context,
                            FontWeight.w600,
                            Theme.of(context).colorScheme.primaryVariant),
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
                        style: TextStyle(
                            color: Palette.darkGrey,
                            fontFamily: "Montserrat",
                            fontSize: 16),
                        decoration: TextFormFeildDecoration(),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  if (imageFile != null) {
                    if (_formKey.currentState!.validate()){
                         var now = new DateTime.now();
                      ApiCall().CreateTopic(widget.id,now.toString(), nameController.text,imageFile, context);
                    }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => VerificationPage(
                    //             email: widget.email,
                    //             name: widget.name,
                    //             password: widget.password,
                    //             number: widget.number,
                    //             imageFile: imageFile,
                    //           )),
                    // );
                  } else {
                    ShowResponse("Please select an image.", context);
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
                      "Add Topic",
                      style: ThemeHelper().TextStyleMethod2(
                          16, context, FontWeight.bold, Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
