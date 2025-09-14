import 'package:get/get.dart';

import '../controllers/person_info_controller.dart';

class PersonInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonInfoController>(
      () => PersonInfoController(),
    );
  }
}
