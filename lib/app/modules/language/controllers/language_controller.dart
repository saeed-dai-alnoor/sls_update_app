import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final getStorage = GetStorage();
  final _defaultLang = ''.obs;
  String get defaultLang => _defaultLang.value;
  void setDefaultLang(String defaultLang) {
    _defaultLang.value = defaultLang;
  }

  @override
  void onInit() {
    super.onInit();
    if (getStorage.read('lang') == 'ar' || getStorage.read('lang') == null) {
      _defaultLang.value = 'ar';
    } else {
      _defaultLang.value = 'en';
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var currentLanguage = 'en'.obs; // Observable language code

  void changeLanguage(String langCode, String countryCode) {
    currentLanguage.value = langCode;
    Get.updateLocale(Locale(langCode, countryCode));
  }
}
