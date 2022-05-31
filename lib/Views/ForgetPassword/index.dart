import 'package:flutter/material.dart';
import 'package:soloconneckt/Views/CreateAccount/ProfilePicture.dart';
import 'package:soloconneckt/Views/VerificationPage/index.dart';
import 'package:soloconneckt/Widgets/textFeildDecoration.dart';

import '../../Styles/ThemeHelper.dart';
import '../../Styles/palette.dart';

class ForgetPassword extends StatelessWidget {
  
  ForgetPassword(
      { key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = new TextEditingController();
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
                            "Enter your Email*",
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
                            keyboardType: TextInputType.emailAddress,
                            style: ThemeHelper().TextStyleMethod2(
                                16, context, FontWeight.bold, Palette.Black),
                            decoration: TextFormFeildDecoration(),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
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
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => VerificationPage(
                                  email: emailController.text,
                                  isforgetPassword: true,
                                )),
                          );
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
                            "Next",
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
