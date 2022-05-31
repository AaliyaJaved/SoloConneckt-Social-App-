import 'package:flutter/material.dart';
import 'package:soloconneckt/Styles/palette.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: Palette.backgroundColour,
    scaffoldBackgroundColor:  Palette.backgroundColour,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    colorScheme: ColorScheme(
        primary: Color(0xFFB6B6B6),
        primaryVariant: Colors.black,
        secondary: Color(0xFFB6B6B6),
        secondaryVariant: Color.fromARGB(246, 244, 244, 244),//for bottom bar
        surface: Color(0xFFB6B6B6),
        background: Colors.black,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Color(0xFFF4F4F4),
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
        brightness:Brightness.light),
  );
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
     iconTheme: IconThemeData(
      color: Colors.white,
    ),
    colorScheme: ColorScheme(
        primary: Color(0xFF363739),
        primaryVariant: Colors.white,
        secondary: Colors.black45,
        secondaryVariant: Color(0xFF363739),
        surface: Colors.black,
        background: Colors.white,
        error: Colors.red,
        onPrimary: Colors.black,
        onSecondary: Color(0xFF363739),
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.black,
        brightness:Brightness.dark),
    // buttonColor: Colors.red,
  );
}
