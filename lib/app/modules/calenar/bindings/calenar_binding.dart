import 'package:get/get.dart';

import '../controllers/calenar_controller.dart';

class CalenarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalenarController>(
      () => CalenarController(),
    );
  }
}
