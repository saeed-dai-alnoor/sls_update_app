import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sls_app/app/modules/theme/controllers/theme_controller.dart';

class HomeController extends GetxController {
  // --- المتغيرات الأساسية ---
  final box = GetStorage();
  var isLoggedIn = false.obs;
  var greetingKey = ''.obs;
  var duration = '00:00:00'.obs; // لإظهار المدة في CheckDoneView
  RxMap<DateTime, bool> attendanceRecords = <DateTime, bool>{}.obs;
  // --- متغيرات الجلسة الحية ---
  var loginTime = '00:00:00'.obs;
  var logoutTime = '00:00:00'.obs;
  var workingHours = '00:00:00'.obs;
  var loginTimeDuration = Rxn<DateTime>();

  // --- متغيرات التحكم في الواجهة ---
  var selectedDate = DateTime.now().obs; // للتقويم في PannelUp
  var selectedSummaryDate = DateTime.now().obs; // لصفحة الملخص

  // --- (الحل النهائي) متغير "المحفز" ---
  var summaryViewUpdater = 0.obs;

  void markAttendance(DateTime date) {
    attendanceRecords[date] = true;
    update(); // لتحديث الواجهة (إذا كان هناك واجهة تستمع لهذا التغيير)
  }

  String _translate(String unit, String locale) {
    return {
      'ar': {'hours': 'ساعات', 'minutes': 'دقائق', 'seconds': 'ثواني'},
      'en': {'hours': 'hours', 'minutes': 'minutes', 'seconds': 'seconds'},
    }[locale]![unit]!;
  }

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => ThemeController());
    _updateGreetingKey();
  }

  // --- دوال دورة العمل ---

  void logIn(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    loginTime.value = DateFormat('hh:mm:ss a', locale).format(DateTime.now());
    loginTimeDuration.value = DateTime.now();
    logoutTime.value = '';
    workingHours.value = '00:00:00';

    // حفظ السجل المبدئي
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Map<String, dynamic> initialData = {
      'loginTime': loginTime.value,
      'logoutTime': '',
      'workingHours': '00:00:00',
      'date': DateTime.now().toIso8601String(),
    };
    box.write(todayKey, initialData);
    // print("✅ [LogIn] تم حفظ سجل الحضور المبدئي.");

    // تحديث "المحفز"
    summaryViewUpdater.value++;
  }

  void logOut(BuildContext context) {
    if (loginTimeDuration.value == null) return;

    final locale = Localizations.localeOf(context).languageCode;
    logoutTime.value = DateFormat('hh:mm:ss a', locale).format(DateTime.now());

    final diff = DateTime.now().difference(loginTimeDuration.value!);
    // --- بداية التعديل ---
    // إعادة حساب duration هنا
    duration.value =
        '${diff.inHours} ${_translate('hours', locale)} '
        '${diff.inMinutes.remainder(60)} ${_translate('minutes', locale)} '
        '${diff.inSeconds.remainder(60)} ${_translate('seconds', locale)}';
    // --- نهاية التعديل ---
    workingHours.value =
        '${diff.inHours}:${diff.inMinutes.remainder(60)}:${diff.inSeconds.remainder(60)}';

    // تحديث السجل في قاعدة البيانات
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Map<String, dynamic> existingData = box.read(todayKey) ?? {};
    existingData['logoutTime'] = logoutTime.value;
    existingData['workingHours'] = workingHours.value;
    box.write(todayKey, existingData);
    // print("✅ [LogOut] تم تحديث سجل الخروج.");

    // تحديث "المحفز"
    summaryViewUpdater.value++;
  }

  void resetDay() {
    isLoggedIn.value = false;
    loginTime.value = '00:00:00';
    logoutTime.value = '00:00:00';
    workingHours.value = '00:00:00';
    loginTimeDuration.value = null;

    // تحديث "المحفز" لضمان تصفير الواجهة
    summaryViewUpdater.value++;
  }

  // --- دوال مساعدة ---

  void toggleAuth() {
    isLoggedIn.toggle();
  }

  void changeSelectedSummaryDate(DateTime newDate) {
    selectedSummaryDate.value = newDate;
  }

  void _updateGreetingKey() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greetingKey.value = 'morning';
    } else if (hour < 17) {
      greetingKey.value = 'afternoon';
    } else {
      greetingKey.value = 'evening';
    }
  }
}
