import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:soloconneckt/Views/CreateAccount/ProfilePicture.dart';
import 'package:soloconneckt/Views/SignUp/index.dart';
import 'package:soloconneckt/Views/VerificationPage/index.dart';
import 'package:soloconneckt/Widgets/ShowResponse.dart';
import 'package:soloconneckt/Widgets/textFeildDecoration.dart';
import 'package:http/http.dart' as http;

import '../../Services/constants.dart';
import '../../Styles/ThemeHelper.dart';
import '../../Styles/palette.dart';

class NewPassword extends StatelessWidget {
  String email;
  NewPassword({this.email = "", key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passwordController = new TextEditingController();
    final passwordController2 = new TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 30,
                            ))
                      ],
                    ),
                    Hero(
                        tag: "pic",
                        child: Image.asset(
                          "assets/images/whitelogo.png",
                          width: 300,
                          height: 300,
                        )),
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
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
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
                      height: 5,
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
                          TextFormField(
                            controller: passwordController2,
                            obscureText: true,
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: <Widget>[
                    //     Text(
                    //       "Any Login Problems?",
                    //       style: TextStyle(
                    //           fontFamily: "Montserrat",
                    //           decoration: TextDecoration.underline,
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.bold,
                    //           color: Palette.blue),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (passwordController2.text ==
                              passwordController.text) {
                            ProgressDialog dialog = new ProgressDialog(context);
                            dialog.style(message: 'Please wait...');
                            await dialog.show();
                            var url =
                                Uri.parse(base_url + "/User/editPassword.php");
                            var request = http.MultipartRequest('POST', url);
                            request.fields['user_password'] =
                                passwordController.text;
                            request.fields['user_email'] = email;
                             request.fields['auth_key'] = auth_key;

                            var response =
                                await request.send().then((result) async {
                              http.Response.fromStream(result)
                                  .then((response) async {
                                // ShowResponse(response.body);
                                var data = json.decode(response.body);
                                var code = data[0]['code'];
                                if (code == 1) {
                                  await dialog.hide();
                                  ShowResponse(
                                      "Password has been changed", context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()),
                                  );
                                } else {
                                  await dialog.hide();
                                  ShowResponse(
                                    response.body,
                                      // "Something went wrong. Recheck you email and internet connectivity.",
                                      context);
                                }
                              });
                            });
                          } else {
                            ShowResponse("password does not match", context);
                          }
                        }
                      },
                      child: Container(
                        height: 58,
                        width: 350,
                        decoration: BoxDecoration(
                            color: Palette.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Center(
                          child: Text(
                            "Change Password",
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
              ),
            ),
          ),
        ));
  }
}
