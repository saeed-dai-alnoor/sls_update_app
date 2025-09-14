import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sls_app/app/modules/check_done/views/check_done_view.dart';
import 'package:sls_app/app/modules/home/controllers/location_controller.dart';
import 'package:sls_app/app/modules/home/views/pannel_up_screen_view.dart';

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
      body: SlidingUpPanel(
        maxHeight: pannelMaxHeight,
        minHeight: panelMinHeight,

        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        parallaxEnabled: true,
        parallaxOffset: 0.5,

        panelBuilder: (sc) =>
            SingleChildScrollView(controller: sc, child: PannelUpScreenView()),
        // main sls_app
        body: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 16,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Center(
                      child: Text(
                        'intelligence'.tr,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/fingerprint.png',
                        height: 200,
                        width: 200,
                      ),
                      Obx(() {
                        if (locationController.isLoading.value) {
                          return SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.grey,
                              ),
                            ),
                          );
                        }
                        return Text(
                          !homeController.isLoggedIn.value
                              ? 'checkedIn'.tr
                              : 'checkedOut'.tr,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                    ],
                  ),
                  onPressed: () async {
                    await locationController.verifyLocation();

                    if (!homeController.isLoggedIn.value &&
                        locationController.isSuccess.value) {
                      homeController.logIn(
                        context,
                      ); // Log out if already logged in
                      homeController.markAttendance(
                        homeController.selectedDate.value,
                      ); // Mark attendance for today
                      homeController.toggleAuth(); // Toggle login/logout state
                    } else if (homeController.isLoggedIn.value &&
                        locationController.isSuccess.value) {
                      homeController.toggleAuth();
                      homeController.logOut(context); // Log in if not logged in
                      // Toggle login/logout state
                      Future.delayed(Duration.zero, () {
                        print(
                          'Checked out successfully: ${homeController.logoutTime.value}',
                        );
                        Get.to(() => CheckDoneView());
                      });
                    } else {
                      // 👇 Show dialog ONLY ONCE when out of range (before showing text)
                      Future.delayed(Duration(seconds: 50), () {
                        Get.defaultDialog(
                          title: "📍 Oops!",
                          middleText: 'messageScope'.tr,
                          textConfirm: 'ok'.tr,
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            Get.back(); // Close the dialog
                          },
                        );
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      // appBar sls_app
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.toNamed('/person-info');
          },
          icon: const Icon(Icons.person_outlined, size: 32),
        ),
        title: Text('afternoor'.tr + ' User'),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/notifications');
            },
            icon: const Icon(Icons.notifications_outlined, size: 32),
          ),
        ],
      ),
    );
  }
}
