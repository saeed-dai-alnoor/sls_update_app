import 'package:get/get.dart';

class CalenarController extends GetxController {
  final currentDate = DateTime.now().obs;
  final monthsList = <DateTime>[].obs;

  void _generateMonths() {
    monthsList.clear();
    // Add all months from January (1) to current month
    for (int i = 1; i <= currentDate.value.month; i++) {
      monthsList.add(DateTime(currentDate.value.year, i));
    }
  }

  @override
  void onInit() {
    super.onInit();
    _generateMonths();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
