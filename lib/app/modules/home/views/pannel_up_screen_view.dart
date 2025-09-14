import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sls_app/app/modules/home/bar_graph/bar_graph.dart';
import 'package:sls_app/app/modules/home/controllers/home_controller.dart';
import 'package:table_calendar/table_calendar.dart';

extension DateTimeCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

// ignore: must_be_immutable
class PannelUpScreenView extends GetView {
  PannelUpScreenView({super.key});
  List<double> weeklySummary = [4.40, 2.50, 42.42, 10.50, 100.20, 88.99, 90.10];
  final pannelController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return ListView(
      clipBehavior: Clip.none,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,

      children: [
        Icon(Icons.keyboard_arrow_up_sharp, size: 40, color: Color(0xff0071bc)),
        Column(
          children: [
            Container(
              height: 200.0,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        '${'checkedIn'.tr}:',
                        style: TextStyle(fontSize: 20),
                      ),
                      Obx(
                        () => Text(
                          pannelController.loginTime.value,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0071bc),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/download.jpeg',
                        height: 100,
                        width: 100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('calendar'.tr, style: TextStyle(fontSize: 18)),
            ),
            Obx(() {
              final controller = Get.find<HomeController>();
              return TableCalendar(
                firstDay: DateTime(2000),
                lastDay: DateTime(2100),
                focusedDay: controller.selectedDate.value,
                selectedDayPredicate: (day) {
                  return isSameDay(controller.selectedDate.value, day);
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    shape: BoxShape.circle,
                  ),
                  // To mark dates, use eventLoader or calendarBuilders instead of markedDates.
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  controller.selectedDate.value = selectedDay;
                },
              );
            }),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('average'.tr, style: TextStyle(fontSize: 18)),
            ),
            SizedBox(
              height: 200,
              child: MyBarGraph(weeklySummary: weeklySummary),
            ),
          ],
        ),
      ],
    );
  }
}
