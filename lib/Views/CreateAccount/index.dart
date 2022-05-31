import 'package:flutter/material.dart';
import 'package:soloconneckt/Styles/palette.dart';
import 'package:soloconneckt/Views/phoneNumber/index.dart';
import 'package:soloconneckt/Widgets/textFeildDecoration.dart';

import '../../Styles/ThemeHelper.dart';
import '../../Widgets/ShowResponse.dart';
import '../MainPage/index.dart';
import '../SignUp/index.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final password2Controller = new TextEditingController();
  final nameController = new TextEditingController();
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
                  height: 15,
                ),
                Hero(
                    tag: "pic",
                    child: Image.asset(
                      "assets/images/blacklogo.png",
                      width: 150,
                      height: 150,
                    )),
                Text(
                  "Create an Account",
                  style: ThemeHelper().TextStyleMethod2(
                      20, context, FontWeight.w600, Colors.black),
                ),
                Text(
                  "Sign up now to started with an account",
                  style: ThemeHelper().TextStyleMethod2(
                      12, context, FontWeight.normal, Colors.black),
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
                        "Confirm Password*",
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
                FormField<bool>(
                  builder: (state) {
                    return Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.all(
                                    Palette.mediumGrey),
                                value: checkboxValue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onChanged: (value) {
                                  setState(() {
                                    checkboxValue = value!;
                                    state.didChange(value);
                                  });
                                }),
                            Text(
                              "I have read and agree to the\n terms of services",
                              style: ThemeHelper().TextStyleMethod2(12, context,
                                  FontWeight.w700, Palette.darkGrey),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            state.errorText ?? '',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                              fontSize: 10,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  validator: (value) {
                    if (!checkboxValue) {
                      return 'You need to accept terms and conditions';
                    } else {
                      return null;
                    }
                  },
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (password2Controller.text == passwordController.text) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhoneNumber(
                                    email: emailController.text,
                                    name: nameController.text,
                                    password: passwordController.text,
                                  )),
                        );
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
                        "Next",
                        style: ThemeHelper().TextStyleMethod2(
                            16, context, FontWeight.bold, Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Text(
                        "Or Sign In?",
                        style: ThemeHelper().TextStyleMethod2(
                            13, context, FontWeight.w700, Palette.darkGrey),
                      ),
                    ),
                  ],
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
