import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class NewsFeedController extends GetxController {
  RxBool isDrawerOpen = false.obs;
  var theme = "Light".obs;
  RxBool isSwitched = false.obs;
  RxBool realEstateProfile = false.obs;
  RxBool forexProfile = false.obs;
  RxBool personalProfile = false.obs;
  RxInt start=40.obs;

  // @override
  // void onInit() {
  //   // called immediately after the widget is allocated memory
  //   gettheme();
  //   super.onInit();
  // }

  // gettheme() {
  //   var brightness = SchedulerBinding.instance!.window.platformBrightness;
  //   bool isDarkMode = brightness == Brightness.dark;
  //   if (isDarkMode) {
  //     theme.value = "Dark";
  //     isSwitched.value=true;
  //   } else {
  //     theme.value = "Light";
  //      isSwitched.value=false;
  //   }
  // }

  
}
