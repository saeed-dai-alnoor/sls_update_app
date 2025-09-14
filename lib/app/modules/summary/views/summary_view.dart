import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

import 'package:get/get.dart';
import 'package:sls_app/app/modules/calenar/views/calenar_view.dart';
import 'package:sls_app/app/modules/home/controllers/home_controller.dart';

import '../controllers/summary_controller.dart';

class SummaryView extends GetView<SummaryController> {
  SummaryView({super.key});
  final summarryController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('summary'.tr),
        centerTitle: true,
        // shadowColor: Colors.grey[800],
        backgroundColor: Color(0xFFf7f7f7),
        leading: IconButton(
          icon: const Icon(Icons.person_outlined, size: 32),
          onPressed: () {
            Get.toNamed('/person-info');
          },
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 32),
            onPressed: () {
              Get.toNamed('/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.date_range_sharp, size: 32),
            onPressed: () {
              // Get.toNamed('/calendar');
              Get.to(() => CalenarView());
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              // Obx لتحديث الواجهة تلقائيًا عند تغيير القيم
              // final dateCtrl = Get.find<SummaryController>();
              final today = summarryController.loginTimeDuration.value;
              final currentWeekDates = List.generate(7, (index) {
                if (today == null) {
                  // Fallback to current date if null
                  return DateTime.now().subtract(
                    Duration(days: DateTime.now().weekday - index),
                  );
                } else {
                  // Use the provided date if available
                  return today.subtract(Duration(days: today.weekday - index));
                }
              });

              return Column(
                children: [
                  // أسماء أيام الأسبوع (أحد، اثنين، ...)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      final dayNames = [
                        'sun'.tr,
                        'mon'.tr,
                        'tue'.tr,
                        'wed'.tr,
                        'thu'.tr,
                        'fri'.tr,
                        'sat'.tr,
                      ];
                      return NameOfWeek(name: dayNames[index]);
                    }),
                  ),
                  const SizedBox(height: 16),
                  // عرض التواريخ مع تظليل اليوم المحدد
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      final date = currentWeekDates[index];
                      return Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color:
                              date.day == DateTime.now().day &&
                                  date.month == DateTime.now().month
                              ? Colors.blue
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: .8),
                        ),
                        child: Center(
                          child: Text(
                            date.day == DateTime.now().day &&
                                    date.month == DateTime.now().month
                                ? '${date.day.toString()}/${date.month.toString()}' // رقم اليوم مع علامة النجمة
                                : date.day.toString(), // رقم اليوم (مثل ٢٥)
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  date.day == DateTime.now().day &&
                                      date.month == DateTime.now().month
                                  ? Colors
                                        .white // لون النص للأيام المحددة
                                  : Colors.black, // لون النص للأيام الأخرى
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            }),
            // bottom: PreferredSize(
            //   preferredSize: const Size.fromHeight(90),
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       children: [
            //         // Weekday names row
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
            //           children: [
            //             NameOfWeek(name: 'sun'.tr),
            //             NameOfWeek(name: 'mon'.tr),
            //             NameOfWeek(name: 'tue'.tr),
            //             NameOfWeek(name: 'wed'.tr),
            //             NameOfWeek(name: 'thu'.tr),
            //             NameOfWeek(name: 'fri'.tr),
            //             NameOfWeek(name: 'sat'.tr),
            //           ],
            //         ),
            //         const SizedBox(height: 16),
            //         // Dates row
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
            //           children: [
            //             NumberOfWeek(num: 31),
            //             NumberOfWeek(num: 30),
            //             NumberOfWeek(num: 29),
            //             NumberOfWeek(num: 28),
            //             NumberOfWeek(num: 27),
            //             NumberOfWeek(num: 26),
            //             NumberOfWeek(num: 25),
            //           ],
            //         ),
            //       ],
            //     ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 40),

              child: Column(
                children: [
                  Icon(
                    Icons.history, // Icon name
                    color: Colors.red, // Icon color
                    size: 22.0, // Icon size
                  ),
                  Text('workingHours'.tr, style: TextStyle(fontSize: 21)),
                  SizedBox(height: 8),
                  Obx(
                    () => Text(
                      summarryController.workingHours.value,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  summarryController.convertTimeStringToDouble() > 4.8
                      ? Text(
                          'hero'.tr,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedRadialGauge(
              duration: const Duration(seconds: 2),
              radius: 160,
              value: summarryController.convertTimeStringToDouble() * 10,

              axis: GaugeAxis(
                min: 0,
                max: 100,
                degrees: 180,
                style: const GaugeAxisStyle(thickness: 17),

                progressBar: const GaugeProgressBar.rounded(
                  color: Color(0xFFde6a6b),
                ),
                pointer: GaugePointer.needle(
                  height: 0,
                  width: 17,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomIconTextButton(
                          icon: Icons.login_outlined,
                          iconColor: Colors.green,

                          title: 'checkedIn'.tr,
                          subtitle: Obx(
                            () => Text(
                              summarryController.loginTime.value,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          lastTitle: '---',

                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),

                      Expanded(
                        child: CustomIconTextButton(
                          icon: Icons.logout_rounded,
                          iconColor: Color(0xFFde6a6b),
                          title: 'checkedOut'.tr,
                          subtitle: Obx(
                            () => Text(
                              summarryController.logoutTime.value.isEmpty
                                  ? '00:00:00'
                                  : summarryController.logoutTime.value,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          lastTitle: '',

                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFde6a6b),
                      padding: EdgeInsets.symmetric(
                        horizontal: 90,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'submit'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NameOfWeek extends StatelessWidget {
  final String name;
  const NameOfWeek({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(name, style: TextStyle(fontWeight: FontWeight.bold));
  }
}

class NumberOfWeek extends StatelessWidget {
  final int num;
  const NumberOfWeek({super.key, required this.num});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('$num')),
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.grey[300]!, width: 1),
        shape: BoxShape.circle,
      ),
    );
  }
}

class CustomIconTextButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget subtitle;
  final String lastTitle;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final VoidCallback onPressed;

  const CustomIconTextButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.lastTitle,
    required this.onPressed,
    required this.iconColor,
    this.backgroundColor,
    this.textColor,

    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: TextStyle(fontSize: 21)),
                subtitle,
                Text(
                  lastTitle,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFde6a6b),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
