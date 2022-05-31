import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soloconneckt/Views/CreateAccount/index.dart';
import 'package:soloconneckt/Views/MainPage/index.dart';
import 'Controllers/globalBinding.dart';

import 'Styles/theme.dart';
import 'Views/Nfc.dart';
import 'Views/SplashScreen/index.dart';

Future<void> main() async {
   GlobalBindings().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Solo Conneckt',
      theme: Themes.light,
      // theme: ThemeData(
      //   fontFamily: "Poppins",
      // ),
      darkTheme: Themes.dark,
      //  themeMode: ThemeService().theme, 
      home:  SplashScreen(),
    );
  }
}
