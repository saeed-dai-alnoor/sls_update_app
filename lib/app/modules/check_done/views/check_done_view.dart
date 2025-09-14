import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/check_done_controller.dart';
import '../../home/controllers/home_controller.dart';

class CheckDoneView extends GetView<CheckDoneController> {
  CheckDoneView({super.key});
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.4,
        ), // 50% of screen
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear, color: Colors.white),

            onPressed: () => Get.back(),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ), // Example style
            ),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Text(
                      'hero'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 34),
                    ),
                  ),
                  SizedBox(height: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'finished'.tr,
                        style: TextStyle(color: Colors.white, fontSize: 31),
                      ),
                      Obx(
                        () => Text(
                          homeController.duration.value,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),

        physics: NeverScrollableScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkedIn'.tr + ':',
                style: TextStyle(fontSize: 26, color: Colors.black),
              ),
              Obx(
                () => Text(
                  homeController.loginTime.value,
                  style: TextStyle(fontSize: 26, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkedOut'.tr + ':',
                style: TextStyle(fontSize: 26, color: Colors.black),
              ),
              Obx(
                () => Text(
                  homeController.logoutTime.value,
                  style: TextStyle(fontSize: 26, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('how'.tr, style: TextStyle(fontSize: 26, color: Colors.black)),
          SizedBox(height: 20),
          Row(
            children: [
              TextButton(
                child: Text('\u{1F60E}', style: TextStyle(fontSize: 30)),
                onPressed: () {},
              ),
              TextButton(
                child: Text('\u{1F642}', style: TextStyle(fontSize: 30)),
                onPressed: () {},
              ),
              TextButton(
                child: Text('\u{1F610}', style: TextStyle(fontSize: 30)),
                onPressed: () {},
              ),
              TextButton(
                child: Text(' \uD83D\uDE41', style: TextStyle(fontSize: 30)),
                onPressed: () {},
              ),
              TextButton(
                child: Text('\uD83D\uDE21', style: TextStyle(fontSize: 30)),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // homeController.isLoggedIn.value = true;
              Get.back();
            },
            child: Text('done'.tr, style: TextStyle(fontSize: 28)),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
