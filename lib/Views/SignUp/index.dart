import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloconneckt/Services/ApiCalling.dart';
import 'package:soloconneckt/Services/constants.dart';
import 'package:soloconneckt/Styles/palette.dart';
import 'package:soloconneckt/Views/ForgetPassword/index.dart';
import 'package:soloconneckt/Views/Interests/index.dart';
import 'package:soloconneckt/Widgets/textFeildDecoration.dart';

import '../../Styles/ThemeHelper.dart';
import '../../Widgets/ShowResponse.dart';
import '../MainPage/index.dart';

import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool checkboxValue = false;
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
                  height: 50,
                ),
                Text(
                  "Welcome to solo conneckt".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: ThemeHelper().TextStyleMethod2(
                      30, context, FontWeight.w900, Colors.black),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "An income generating Eco-system built with networking and profit sharing for all in mind.",
                    textAlign: TextAlign.center,
                    style: ThemeHelper().TextStyleMethod2(
                        13, context, FontWeight.w600, Palette.Black),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username, Email & Phone Number*",
                        style: ThemeHelper().TextStyleMethod2(
                            12, context, FontWeight.w600, Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (val) {
                          // print(RegExp(r'\S+@\S+\.\S+').hasMatch(val!)==false);
                          if (val!.isEmpty) {
                            return "Enter a valid email address";
                          } else if (RegExp(r'\S+@\S+\.\S+').hasMatch(val) ==
                              false) {
                            return "Enter a valid email address";
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgetPassword()),
                            );
                      },
                      child: Text(
                        "Forgot Password ?",
                        style: ThemeHelper().TextStyleMethod2(
                            14, context, FontWeight.w700, Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      ApiCall().LoginUser(emailController.text, passwordController.text,context);
                       
                    }
                   
                  },
                  child: Container(
                    height: 60,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: Text(
                        "Sign in",
                        style: ThemeHelper().TextStyleMethod2(
                            16, context, FontWeight.bold, Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     SizedBox(
                //         width: MediaQuery.of(context).size.width*0.3,
                //         child: Divider(
                //           height: 2,
                //           color: Palette.darkGrey,
                //         )),
                //     Text(
                //       "Or Sign up With",
                //       style: ThemeHelper().TextStyleMethod2(
                //           12, context, FontWeight.w600, Palette.Black),
                //     ),
                //     SizedBox(
                //         width: MediaQuery.of(context).size.width*0.3,
                //         child: Divider(
                //           height: 2,
                //           color: Palette.darkGrey,
                //         )),
                //   ],
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       margin: EdgeInsets.all(5),
                //       height: 60,
                //       width: 60,
                //       decoration: BoxDecoration(
                //           border:
                //               Border.all(width: 1, color: Palette.mediumGrey),
                //           color: Palette.dimGrey,
                //           shape: BoxShape.circle),
                //     ),
                //     Container(
                //       margin: EdgeInsets.all(5),
                //       height: 60,
                //       width: 60,
                //       decoration: BoxDecoration(
                //           border:
                //               Border.all(width: 1, color: Palette.mediumGrey),
                //           color: Palette.dimGrey,
                //           shape: BoxShape.circle),
                //     ),
                //     Container(
                //       margin: EdgeInsets.all(5),
                //       height: 60,
                //       width: 60,
                //       decoration: BoxDecoration(
                //           border:
                //               Border.all(width: 1, color: Palette.mediumGrey),
                //           color: Palette.dimGrey,
                //           shape: BoxShape.circle),
                //     )
                //   ],
                // ),
              ],
            ),
          )),
        ),
      ),
    );
  }

}
