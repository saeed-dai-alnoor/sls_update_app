import 'package:get/get.dart';

import 'package:sls_app/app/modules/home/controllers/location_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(() => LocationController());
    Get.lazyPut<HomeController>(() => HomeController());
  
  }
}
