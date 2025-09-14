import 'package:get/get.dart';

import '../controllers/check_done_controller.dart';

class CheckDoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckDoneController>(
      () => CheckDoneController(),
    );
  }
}
