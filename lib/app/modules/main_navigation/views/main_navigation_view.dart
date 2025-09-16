import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sls_app/app/modules/home/views/home_view.dart';
import 'package:sls_app/app/modules/more/views/more_view.dart';
import 'package:sls_app/app/modules/requests/views/requests_view.dart';
import 'package:sls_app/app/modules/summary/views/summary_view.dart';
import '../../home/controllers/location_controller.dart';
import '../controllers/main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  MainNavigationView({super.key});
  final MainNavigationController navController = Get.put(
    MainNavigationController(),
  );
  final LocationController locationController = Get.find<LocationController>();
  final List<Widget> pages = [
    HomeView(),
    SummaryView(),
    RequestsView(),
    MoreView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: navController.currentIndex.value,
          children: pages,
        ),
      ), // fotter sls_app
      bottomNavigationBar: Obx(() {
        // --- بداية التعديل ---
        // 3. الحصول على حالة التحميل الحالية
        final bool isLoading = locationController.isLoading.value;
        // --- نهاية التعديل ---

        return BottomNavigationBar(
          backgroundColor: Colors.grey[50],
          iconSize: 30.0,
          selectedFontSize: 18.0,
          unselectedFontSize: 16.0,
          selectedItemColor: Colors.black,

          // 4. تغيير لون العناصر غير النشطة بناءً على حالة التحميل
          unselectedItemColor: isLoading
              ? Colors.grey[300]
              : const Color(0xFF5e4eaf),

          type: BottomNavigationBarType.fixed,
          currentIndex: navController.currentIndex.value,

          // 5. تعطيل الضغط على الشريط بالكامل أثناء التحميل
          onTap: isLoading ? null : (index) => navController.changePage(index),

          items: [
            BottomNavigationBarItem(
              label: 'home'.tr,
              icon: const Icon(Icons.fingerprint_sharp),
            ),
            BottomNavigationBarItem(
              label: 'summary'.tr,
              icon: const Icon(Icons.speed_sharp),
            ),
            BottomNavigationBarItem(
              label: 'requests'.tr,
              icon: const Icon(Icons.auto_awesome_motion_outlined),
            ),
            BottomNavigationBarItem(
              label: 'more'.tr,
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        );
      }),
    );
  }
}
