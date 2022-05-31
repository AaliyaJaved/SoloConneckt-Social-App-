
 import 'package:flutter/material.dart';

import '../Styles/palette.dart';

InputDecoration TextFormFeildDecoration() {
    return InputDecoration(
        contentPadding: EdgeInsets.all(15),
        filled: true,
        fillColor: Palette.lightGrey,
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(15.0),
        // ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.blue, width: 1)),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Palette.dimGrey, width: 4)));
  }