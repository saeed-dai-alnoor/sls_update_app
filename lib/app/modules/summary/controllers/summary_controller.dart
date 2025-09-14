import 'package:get/get.dart';

class SummaryController extends GetxController {
  Rx<DateTime> currentDate =
      DateTime.now().obs; // التاريخ الحالي (مُراقَب بواسطة GetX)
  RxList<bool> isCurrentDay = List.filled(
    7,
    false,
  ).obs; // قائمة تحدد أي يوم مُظلّل

  void updateCurrentDate(DateTime newDate) {
    currentDate.value = newDate; // تحديث التاريخ عند الضغط على يوم معين
    updateDayHighlighting(); // تحديث التظليل للأيام
  }

  void updateDayHighlighting() {
    final today = DateTime.now();
    isCurrentDay.value = List.generate(7, (index) {
      final date = today.subtract(Duration(days: today.weekday - index));
      return date.day == currentDate.value.day &&
          date.month == currentDate.value.month &&
          date.year == currentDate.value.year;
    });
  }

  @override
  void onInit() {
    super.onInit();
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
