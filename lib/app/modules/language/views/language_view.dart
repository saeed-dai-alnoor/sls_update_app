// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sls_app/app/modules/language/controllers/language_controller.dart';

// ignore: must_be_immutable
class LanguageView extends GetView<LanguageController> {
  LanguageView({super.key});
  // double? margin;
  final getStorage = GetStorage();
  final LanguageController langController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AlertDialog(
        title: Text('selectLanguage'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => RadioListTile(
                title: Text('العربية'),
                value: 'ar',

                groupValue: langController.defaultLang,
                onChanged: (value) {
                  getStorage.write('lang', 'ar');
                  controller.setDefaultLang('ar');
                  Get.updateLocale(Locale('ar'));
                },
              ),
            ),
            Obx(
              () => RadioListTile(
                title: Text('English'),
                value: 'en',
                groupValue: langController.defaultLang,
                onChanged: (value) {
                  getStorage.write('lang', 'en');
                  controller.setDefaultLang('en');
                  Get.updateLocale(Locale('en'));
                },
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () => Get.back(), icon: Icon(Icons.done)),
        ],
      ),
    );
  }
}
