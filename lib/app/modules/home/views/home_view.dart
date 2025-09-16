// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sls_app/app/modules/check_done/views/check_done_view.dart';
import 'package:sls_app/app/modules/home/controllers/location_controller.dart';
import 'package:sls_app/app/modules/home/views/pannel_up_screen_view.dart';
import 'package:sls_app/app/widgets/loading_overlay.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final double coverHeight = 280.0;
  final double profileHeight = 144.0;
  double get top => coverHeight - profileHeight / 2;

  final locationController = Get.put(LocationController());
  final homeController = Get.put(HomeController()); // Retrieve the controller

  @override
  Widget build(BuildContext context) {
    final pannelMaxHeight = MediaQuery.of(context).size.height * 0.8;
    final panelMinHeight = MediaQuery.of(context).size.height * 0.2;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(() {
        return LoadingOverlay(
          isLoading: locationController.isLoading.value,
          child: SlidingUpPanel(
            maxHeight: pannelMaxHeight,
            minHeight: panelMinHeight,

            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            parallaxEnabled: true,
            border: Border.all(color: Colors.black12, width: 2),
            parallaxOffset: 0.5,

            panelBuilder: (sc) => SingleChildScrollView(
              controller: sc,
              child: PannelUpScreenView(),
            ),
            // main sls_app
            body: Stack(
              alignment: Alignment.center, // توسيط كل العناصر في الـ Stack
              children: [
                Positioned(
                  top: -5,
                  child: Container(
                    margin: EdgeInsets.only(top: 12),
                    child: SizedBox(
                      height: 100,
                      width: 300,

                      child: Card(
                        color: Colors.grey[50],
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16), // الزوايا
                          side: BorderSide(
                            color: Colors.black12, // لون البوردر
                            width: 2, // سماكة البوردر
                          ),
                        ),

                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              'intelligence'.tr,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 1. أيقونة Lottie (الطبقة السفلية)
                // هذا هو الزر الفعلي
                Positioned(
                  top: 40,
                  child: GestureDetector(
                    onTap: locationController.isLoading.value
                        ? null
                        : () async {
                            // 1. أظهر التحميل
                            locationController.isLoading.value = true;
                            // 2. تحقق من الموقع
                            await locationController.verifyLocation();

                            // --- بداية التعديل ---
                            // 3. نفّذ الإجراء فقط في حالة النجاح
                            if (locationController.isSuccess.value) {
                              // إذا كان المستخدم مسجل دخوله بالفعل (يريد تسجيل الخروج)
                              if (homeController.isLoggedIn.value) {
                                homeController.logOut(context);
                                Get.to(() => CheckDoneView());
                              }
                              // إذا كان المستخدم غير مسجل (يريد تسجيل الدخول)
                              else {
                                homeController.logIn(context);
                                homeController.markAttendance(
                                  homeController.selectedDate.value,
                                );
                              }
                              // قم بتبديل الحالة فقط إذا نجحت العملية
                              homeController.toggleAuth();
                            }
                            locationController.isLoading.value = false;
                          },
                    child: Lottie.asset(
                      'assets/animations/fingerprint.json',
                      width: 300,
                      height: 320,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                // 2. النص (الطبقة العلوية)
                // نستخدم Positioned لتحديد مكان النص بدقة
                Positioned(
                  top:
                      coverHeight -
                      profileHeight /
                          81, // <--- المسافة من أسفل الـ Stack (تحكم فيها كما تريد)
                  child: Obx(() {
                    if (locationController.isLoading.value) {
                      // حاوية فارغة لإخفاء النص
                      return const SizedBox.shrink();
                    }
                    return Text(
                      !homeController.isLoggedIn.value
                          ? 'checkedIn'.tr
                          : 'checkedOut'.tr,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // تأكد من أن لون النص واضح
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      }),

      // appBar sls_app
      appBar: AppBar(
        backgroundColor: Color(0xFF5e4eaf),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.toNamed('/person-info');
          },
          icon: const Icon(
            Icons.person_outlined,
            size: 28,
            color: Colors.white,
          ),
        ),
        title: Obx(() {
          return Text(
            '${controller.greetingKey.value.tr} user', // استخدام المتغير من الـ controller
            style: const TextStyle(fontSize: 22, color: Colors.white),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/notifications');
            },
            icon: const Icon(
              Icons.notifications_outlined,
              size: 28,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
