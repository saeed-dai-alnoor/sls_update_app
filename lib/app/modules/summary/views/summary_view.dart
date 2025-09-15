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
        backgroundColor: Color(0xFF5e4eaf), // لون مختلف للـ AppBar
        foregroundColor: Colors.white, // لون الأيقونات والنص في AppBar
        leading: IconButton(
          icon: const Icon(Icons.person_outlined),
          onPressed: () => Get.toNamed('/person-info'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Get.toNamed('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.date_range_sharp),
            onPressed: () => Get.to(() => CalenarView()),
          ),
        ],
        // تم حذف خاصية 'bottom' من هنا
      ),

      body: Column(
        children: [
          const WeekViewWidget(),
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),

                    child: Column(
                      children: [
                        Icon(
                          Icons.history, // Icon name
                          color: Color(0xFF5e4eaf), // Icon color
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
                        color: Color(0xFF5e4eaf),
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
                              lastTitle: '',

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
                          backgroundColor: Color(0xFF5e4eaf),
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
              ],
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
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.grey[300]!, width: 1),
        shape: BoxShape.circle,
      ),
      child: Center(child: Text('$num')),
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

    super.key,
  });

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
                    color: Color(0xFF5e4eaf),
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

// --- بداية التعديل: فصل عرض الأسبوع إلى Widget خاص به ---
class WeekViewWidget extends StatelessWidget {
  const WeekViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    // استخدام Container لتوفير خلفية منفصلة
    return Container(
      color: const Color(0xFFf7f7f7), // لون الخلفية الخاص بعرض الأسبوع
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Obx(() {
        final today = homeController.loginTimeDuration.value ?? DateTime.now();
        final currentWeekDates = List.generate(7, (index) {
          // تعديل بسيط للمنطق ليكون أكثر أماناً
          final dayOfWeek = today.weekday == 7 ? 0 : today.weekday; // الأحد = 0
          return today.subtract(Duration(days: dayOfWeek - index));
        });

        final dayNames = [
          'sun'.tr,
          'mon'.tr,
          'tue'.tr,
          'wed'.tr,
          'thu'.tr,
          'fri'.tr,
          'sat'.tr,
        ];

        return Column(
          children: [
            // أسماء أيام الأسبوع
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                7,
                (index) => NameOfWeek(name: dayNames[index]),
              ),
            ),
            const SizedBox(height: 16),
            // أرقام الأيام
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final date = currentWeekDates[index];
                final isToday =
                    date.day == DateTime.now().day &&
                    date.month == DateTime.now().month;

                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isToday
                        ? const Color(0xFF5e4eaf)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: .8),
                  ),
                  child: Center(
                    child: Text(
                      isToday
                          ? '${date.day}/${date.month}'
                          : date.day.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isToday ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
//