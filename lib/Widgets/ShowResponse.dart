import 'package:flutter/material.dart';

void ShowResponse(String Response, context) {
  final snackBar = SnackBar(content: Text(Response),backgroundColor: Colors.grey.shade300,);

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
