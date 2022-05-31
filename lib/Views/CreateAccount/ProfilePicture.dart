import 'dart:io';

import 'package:flutter/material.dart';
import 'package:soloconneckt/Styles/ThemeHelper.dart';
import 'package:soloconneckt/Views/Interests/index.dart';
import 'package:soloconneckt/Views/VerificationPage/index.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../Widgets/ShowResponse.dart';

class ProfilePicture extends StatefulWidget {
  String email, password, name, number;
  ProfilePicture(
      {required this.email,
      required this.name,
      required this.password,
      required this.number,
      key})
      : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
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
        child: Column(
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.black,)),
                Text(
                  "Add your Profile pricture",
                  style: ThemeHelper().TextStyleMethod2(
                      18, context, FontWeight.w600, Colors.black),
                ),
                Text(
                  "Profile",
                  style: ThemeHelper().TextStyleMethod2(
                      18, context, FontWeight.w600, Colors.white),
                ),
              ],
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
            Text(
              "Add your profile Picture",
              style:
                  ThemeHelper().TextStyleMethod2(16, context, FontWeight.w600,Colors.black),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                if (imageFile != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Interests(
                              email: widget.email,
                              name: widget.name,
                              password: widget.password,
                              number: widget.number,
                              imageFile: imageFile,
                            )),
                  );
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
                    "Next",
                    style: ThemeHelper().TextStyleMethod2(
                        16, context, FontWeight.bold, Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
