import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/theme_controller.dart';

class ThemeView extends GetView<ThemeController> {
  ThemeView({super.key});
  final ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Demo'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              Get.isDarkMode
                  ? Get.changeTheme(ThemeData.light())
                  : Get.changeTheme(ThemeData.dark());
            },
          ),
        ],
      ),
      body: Center(
        child: Text(Get.isDarkMode ? 'App in dark mode' : 'App in light mode'),
      ),
    );
  }
}
