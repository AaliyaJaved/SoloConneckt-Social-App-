

import 'package:get/get.dart';

import 'NewsFeedController.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NewsFeedController());
    // Get.put(Websockets_());
  }
}
