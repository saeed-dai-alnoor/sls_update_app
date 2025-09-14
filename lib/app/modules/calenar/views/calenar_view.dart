import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../controllers/calenar_controller.dart';

class CalenarView extends GetView<CalenarController> {
  const CalenarView({super.key});
  String _formatMonthBilingual(DateTime date) {
    final arabicMonth = DateFormat('MMMM', 'ar').format(date);
    final englishMonthNumber = date.month;
    return '$arabicMonth ($englishMonthNumber)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('calendar'.tr)),
      body: Obx(
        () => ListView.builder(
          physics: NeverScrollableScrollPhysics(),
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
                  Text(
                    'عدد الساعات: ${_calculateHours(month)}',
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
        // بناء كل خلية يوم بشكل مخصص
        defaultBuilder: (context, day, focusedDay) {
          return Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ), // دائرة حول الرقم
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
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ), // دائرة زرقاء لليوم
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  int _calculateHours(DateTime month) {
    // هنا يمكنك إضافة منطق حساب الساعات (مثال: من قاعدة بيانات)
    return 0; // قيمة افتراضية
  }
}
