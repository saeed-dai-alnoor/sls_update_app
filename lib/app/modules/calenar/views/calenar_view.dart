import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../controllers/calenar_controller.dart';

class CalenarView extends GetView<CalenarController> {
  CalenarView({super.key});
  String _formatMonthBilingual(DateTime date) {
    final arabicMonth = DateFormat('MMMM', 'ar').format(date);
    final englishMonthNumber = date.month;
    return '$arabicMonth ($englishMonthNumber)';
  }

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 25),
        ),
        title: Text(
          'calendar'.tr,
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
        backgroundColor: Color(0xFF5e4eaf),
      ),
      body: Obx(
        () => ListView.builder(
          // physics: NeverScrollableScrollPhysics(),
          itemCount: controller.monthsList.length,
          itemBuilder: (context, index) {
            final month = controller.monthsList[index];
            return Card(
              child: Column(
                children: [
                  Text(
                    _formatMonthBilingual(month), // Displays "مايو (5)"
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildCalendar(month),
                  const SizedBox(height: 10),
                  // عرض إجمالي الساعات للشهر
                  Text(
                    '${'totalHours'.tr}: ${_calculateTotalHoursForMonth(month)}', // استخدم دالة جديدة
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // دالة لحساب الساعات
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCalendar(DateTime month) {
    return TableCalendar(
      firstDay: DateTime(month.year, month.month, 1),
      lastDay: DateTime(month.year, month.month + 1, 0),
      focusedDay: month,
      startingDayOfWeek: StartingDayOfWeek.saturday, // يبدأ الأسبوع بالسبت
      headerVisible: false,
      calendarFormat: CalendarFormat.month,
      daysOfWeekHeight: 30, // ارتفاع عمود أيام الأسبوع
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false, // إخفاء أيام الشهور الأخرى
        defaultDecoration: BoxDecoration(), // إزالة الديكور الافتراضي
        todayDecoration: BoxDecoration(), // إزالة ديكور اليوم
        selectedDecoration: BoxDecoration(), // إزالة ديكور اليوم المحدد
        defaultTextStyle: TextStyle(fontSize: 16),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          // 1. إنشاء مفتاح لليوم الحالي في الحلقة
          String dayKey = DateFormat('yyyy-MM-dd').format(day);

          // 2. قراءة البيانات من GetStorage
          Map<String, dynamic>? dayData = box.read(dayKey);

          // 3. تحديد لون الدائرة بناءً على وجود بيانات
          bool hasData = dayData != null;

          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // إذا كان هناك بيانات (تم الحضور)، لوّنها بالأخضر
              color: hasData
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.transparent,
              border: Border.all(color: Colors.grey, width: 1),
            ),
            alignment: Alignment.center,
            child: Text('${day.day}'),
          );
        },
        todayBuilder: (context, day, focusedDay) {
          return Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF5e4eaf),
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ), // دائرة زرقاء لليوم
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  // --- دالة جديدة لحساب إجمالي الساعات للشهر ---
  String _calculateTotalHoursForMonth(DateTime month) {
    double totalMinutes = 0;
    // الحصول على كل المفاتيح (الأيام) المخزنة
    List<String> allKeys = box.getKeys().cast<String>().toList();

    for (String key in allKeys) {
      // التحقق مما إذا كان اليوم يخص الشهر الحالي
      if (key.startsWith(DateFormat('yyyy-MM').format(month))) {
        Map<String, dynamic>? dayData = box.read(key);
        if (dayData != null && dayData['workingHours'] != null) {
          List<String> parts = dayData['workingHours'].split(':');
          int hours = int.parse(parts[0]);
          int minutes = int.parse(parts[1]);
          totalMinutes += (hours * 60) + minutes;
        }
      }
    }

    if (totalMinutes == 0) return '0';

    int totalHours = totalMinutes ~/ 60;
    int remainingMinutes = (totalMinutes % 60).toInt();

    return '$totalHours ساعة و $remainingMinutes دقيقة';
  }
}
