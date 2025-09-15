import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sls_app/app/modules/home/views/home_view.dart';
import 'package:sls_app/app/modules/more/views/more_view.dart';
import 'package:sls_app/app/modules/requests/views/requests_view.dart';
import 'package:sls_app/app/modules/summary/views/summary_view.dart';
import '../controllers/main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  MainNavigationView({super.key});
  final MainNavigationController navController = Get.put(
    MainNavigationController(),
  );

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
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          // 1. لتغيير لون الخلفية
          backgroundColor: Colors.grey[50], // نفس لون AppBar
          // 2. لتكبير حجم الأيقونات
          iconSize: 30.0, // حجم أكبر للأيقونات (كان الافتراضي 24)
          // 3. لتكبير حجم النص
          selectedFontSize: 18.0, // حجم النص للعنصر المختار
          unselectedFontSize: 16.0, // حجم النص للعناصر الأخرى
          // fixedColor: Color(0xFF5e4eaf),
          selectedItemColor: Colors.black,
          unselectedItemColor: Color(0xFF5e4eaf),
          type: BottomNavigationBarType.fixed,
          currentIndex: navController.currentIndex.value,
          onTap: (index) => navController.changePage(index),
          items: [
            BottomNavigationBarItem(
              label: 'home'.tr,
              icon: Icon(Icons.fingerprint_sharp),
            ),
            BottomNavigationBarItem(
              label: 'summary'.tr,
              icon: Icon(Icons.speed_sharp),
            ),
            BottomNavigationBarItem(
              label: 'requests'.tr,
              icon: Icon(Icons.auto_awesome_motion_outlined),
            ),

            BottomNavigationBarItem(
              label: 'more'.tr,
              icon: Icon(Icons.more_horiz),
            ),
          ],
        ),
      ),
    );
  }
}
