import 'package:flutter/material.dart';

class ThemeHelper {

  TextStyle TextStyleMethod1(double fontsize,context,FontWeight fontWeight) {
    return TextStyle(
        fontSize: fontsize, fontWeight: fontWeight,fontFamily: "Montserrat");
  }
  TextStyle TextStyleMethod2(double fontsize,context,FontWeight fontWeight,Color color) {
    return TextStyle(
        fontSize: fontsize, fontWeight: fontWeight,color: color,fontFamily: "Montserrat");
  }
}
