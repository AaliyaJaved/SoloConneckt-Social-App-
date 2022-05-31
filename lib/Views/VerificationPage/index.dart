import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:soloconneckt/Services/ApiCalling.dart';
import 'package:soloconneckt/Services/ApiClient.dart';
import 'package:soloconneckt/Views/ForgetPassword/NewPassword.dart';
import 'package:soloconneckt/Views/SignUp/index.dart';

import '../../Styles/ThemeHelper.dart';
import '../../Styles/palette.dart';
import 'Numpad.dart';

class VerificationPage extends StatelessWidget {
  String email, password, name, number;
  File? imageFile;
  bool isforgetPassword;
  var interest;
  VerificationPage(
      { this.email="",
       this.name="",
       this.password="",
       this.number="",
       this.imageFile,
       this.isforgetPassword=false,
       this.interest,
      key})
      : super(key: key);

       final CodeController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
     var code;
    getrandom(){
       var rng = new Random();
       code = rng.nextInt(900000) + 100000;
        
       HttpService().sendMail(email, isforgetPassword?"Forget Password":"Email Verification", code,context);
       print(code);

    }
    getrandom();
    
   
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
              Icon(
                Icons.email_outlined,
                color: Colors.black,
                size: 70,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Verification",
                style: ThemeHelper().TextStyleMethod2(
                    18, context, FontWeight.w900, Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "The verification code has been sent by email to " + email,
                  textAlign: TextAlign.center,
                  style: ThemeHelper().TextStyleMethod2(
                      12, context, FontWeight.bold, Colors.black),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: CodeController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: ThemeHelper().TextStyleMethod2(
                      25, context, FontWeight.bold, Colors.black),
                  // onFieldSubmitted: (value) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => const SignUp()),
                  //   );
                  // },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Please wait within 28 second to resend.",
                  textAlign: TextAlign.center,
                  style: ThemeHelper().TextStyleMethod2(
                      12, context, FontWeight.bold, Colors.black),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              NumPad(
                buttonSize: 45,
                buttonColor: Palette.dimGrey,
                iconColor: Colors.black,
                controller: CodeController,
                delete: () {
                  CodeController.text = CodeController.text
                      .substring(0, CodeController.text.length - 1);
                },
                // do something with the input numbers
                onSubmit: () {
                
                  if(code==int.parse(CodeController.text)){
                    print("done true");
                    if(isforgetPassword){
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => NewPassword(
                                  email: email,
                                )),
                          );
                    }
                    else{
                    ApiCall().RegisterUser(
                      name, email, number, password, imageFile,interest, context);

                    }
                  }
                  


                  // debugPrint('Your code: ${CodeController.text}');
                  // showDialog(
                  //     context: context,
                  //     builder: (_) => AlertDialog(
                  //           content: Text(
                  //             "You code is ${CodeController.text}",
                  //             style: const TextStyle(fontSize: 30),
                  //           ),
                  //         ));
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InkWell(
                  onTap: (){
                    getrandom();
                  },
                  child: Text(
                    "Resend Optp",
                    textAlign: TextAlign.center,
                    style: ThemeHelper().TextStyleMethod2(
                        12, context, FontWeight.bold, Colors.black),
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
