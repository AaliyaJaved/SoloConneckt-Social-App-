import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloconneckt/Services/ApiCalling.dart';
import 'package:soloconneckt/Styles/palette.dart';

import '../../Styles/ThemeHelper.dart';
import '../../Widgets/textFeildDecoration.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

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
    );
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
  final captionController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
   String usename = "", email = "", image = "",id="";
  bool islogin = false;

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usename = prefs.getString("user_name")!;
    email = prefs.getString("user_email")!;
    image = prefs.getString("image")!;
    id = prefs.getString("user_id")!;
    // String? islogin2 = prefs.getString("is_logged_in");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState\
    addStringToSF();
    super.initState();
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
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_new_sharp)),
                    Text(
                      "New Post",
                      style: ThemeHelper()
                          .TextStyleMethod1(18, context, FontWeight.w600),
                    ),
                    Text(
                      "Profile",
                      style: ThemeHelper().TextStyleMethod2(18, context,
                          FontWeight.w600, Theme.of(context).backgroundColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350,
                height: 350,
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: imageFile != null
                      ? DecorationImage(
                          image: FileImage(
                            imageFile!,
                          ),
                          fit: BoxFit.cover)
                      : null,
                  // border: Border.all(width: 5, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
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
                      controller: captionController,
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
                height: 15,
              ),
              InkWell(
                onTap: () {
                  if(imageFile==null)
                  _showChoiceDialog(context);
                  else {
                      if (_formKey.currentState!.validate()) {
                         var now = new DateTime.now();
                        ApiCall().CreatePost(id,now.toString(), captionController.text,imageFile, context);
                      }
                  }
                },
                child: Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryVariant,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Center(
                    child: Text(
                      imageFile==null?"Add Post":"Post",
                      style: ThemeHelper().TextStyleMethod2(16, context,
                          FontWeight.bold, Theme.of(context).backgroundColor),
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
