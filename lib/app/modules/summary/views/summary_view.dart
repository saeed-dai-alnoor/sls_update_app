import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sls_app/app/modules/calenar/views/calenar_view.dart';
import 'package:sls_app/app/modules/home/controllers/home_controller.dart';
import '../controllers/summary_controller.dart';

// --- الواجهة الرئيسية ---
class SummaryView extends GetView<SummaryController> {
  SummaryView({super.key});

  final homeController = Get.find<HomeController>();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('summary'.tr),
        centerTitle: true,
        backgroundColor: const Color(0xFF5e4eaf),
        foregroundColor: Colors.white,
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
      ),
      body: Column(
        children: [
          const WeekViewWidget(),
          Expanded(
            child: Stack(
              children: [
                // --- ساعات العمل والمقياس ---
                Align(
                  alignment: Alignment.topCenter,
                  child: Obx(() {
                    // قراءة "المحفز" لتسجيل المراقب
                    final _ = homeController.summaryViewUpdater.value;

                    // قراءة البيانات
                    final dateKey = DateFormat(
                      'yyyy-MM-dd',
                    ).format(homeController.selectedSummaryDate.value);
                    final data = box.read(dateKey);
                    final workingHours = data?['workingHours'] ?? '00:00:00';
                    final hoursValue = _convertTimeStringToDouble(workingHours);

                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.history,
                                color: Color(0xFF5e4eaf),
                                size: 22.0,
                              ),
                              Text(
                                'workingHours'.tr,
                                style: const TextStyle(fontSize: 21),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                workingHours,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedRadialGauge(
                          duration: const Duration(seconds: 2),
                          radius: 160,
                          value: hoursValue * 10,
                          axis: const GaugeAxis(
                            min: 0,
                            max: 100,
                            degrees: 180,
                            style: GaugeAxisStyle(thickness: 17),
                            progressBar: GaugeProgressBar.rounded(
                              color: Color(0xFF5e4eaf),
                            ),
                            pointer: GaugePointer.needle(
                              height: 0,
                              width: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                // --- أزرار الدخول والخروج ---
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
                              subtitle: Obx(() {
                                final _ =
                                    homeController.summaryViewUpdater.value;
                                final dateKey = DateFormat('yyyy-MM-dd').format(
                                  homeController.selectedSummaryDate.value,
                                );
                                final data = box.read(dateKey);
                                final loginTime =
                                    data?['loginTime'] ?? '00:00:00';
                                return Text(
                                  loginTime,
                                  style: const TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                            ),
                          ),
                          Expanded(
                            child: CustomIconTextButton(
                              icon: Icons.logout_rounded,
                              iconColor: const Color(0xFFde6a6b),
                              title: 'checkedOut'.tr,
                              subtitle: Obx(() {
                                final _ =
                                    homeController.summaryViewUpdater.value;
                                final dateKey = DateFormat('yyyy-MM-dd').format(
                                  homeController.selectedSummaryDate.value,
                                );
                                final data = box.read(dateKey);
                                final logoutTime =
                                    data?['logoutTime'] ?? '00:00:00';
                                return Text(
                                  logoutTime.isEmpty ? '00:00:00' : logoutTime,
                                  style: const TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5e4eaf),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 90,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'submit'.tr,
                          style: const TextStyle(
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

  double _convertTimeStringToDouble(String time) {
    if (time == '00:00:00') return 0.0;
    List<String> parts = time.split(':');
    if (parts.length < 2) return 0.0;
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return hours + (minutes / 60);
  }
}

// --- ويدجت عرض الأسبوع ---
class WeekViewWidget extends StatelessWidget {
  const WeekViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return Container(
      color: const Color(0xFFf7f7f7),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                [
                      'sun'.tr,
                      'mon'.tr,
                      'tue'.tr,
                      'wed'.tr,
                      'thu'.tr,
                      'fri'.tr,
                      'sat'.tr,
                    ]
                    .map(
                      (dayName) => Text(
                        dayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final today = DateTime.now();
            final currentWeekDates = List.generate(7, (index) {
              final dayOfWeek = today.weekday % 7;
              return today.subtract(Duration(days: dayOfWeek - index));
            });
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final date = currentWeekDates[index];
                final isSelected = homeController.selectedSummaryDate.value
                    .isSameDate(date);
                return GestureDetector(
                  onTap: () => homeController.changeSelectedSummaryDate(date),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF5e4eaf)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: .8),
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

// --- ويدجت الزر المخصص ---
class CustomIconTextButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget subtitle;
  final Color? iconColor;
  const CustomIconTextButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
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
              Text(title, style: const TextStyle(fontSize: 21)),
              subtitle,
            ],
          ),
        ],
      ),
    );
  }
}

// --- دالة مساعدة لمقارنة التاريخ ---
extension on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
