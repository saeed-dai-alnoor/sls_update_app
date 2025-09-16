import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sls_app/app/modules/theme/controllers/theme_controller.dart';

class HomeController extends GetxController {
  var isLoggedIn = false.obs;
  var greeting = ''.obs; // متغير لتخزين التحية
  final box = GetStorage();

  // وقت الدخول
  var loginTime = '00:00:00'.obs;
  // لحساب المدة بين الدخول والخروج في حالة تغير اللغة
  var loginTimeDuration = Rxn<DateTime>();
  // وقت الخروج
  var logoutTime = '00:00:00'.obs;
  // المدة بين الدخول والخروج
  var duration = '00:00:00'.obs;
  // المدة بين الدخول والخروج من غير عمل فورمات ساعات ودقائق
  var workingHours = '00:00:00'.obs;
  // متغيرات للتحكم في الواجهة
  var isDarkMode = false.obs;
  // إضافة هذه المتغيرات
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxMap<DateTime, bool> attendanceRecords = <DateTime, bool>{}.obs;
  final attendanceDates = <DateTime, dynamic>{}.obs;

  var greetingKey = ''.obs; // متغير لتخزين مفتاح التحية (Key)

  /// دالة لإعادة تعيين حالة اليوم بعد انتهاء العمل.
  void resetDay() {
    // 1. إعادة حالة تسجيل الدخول إلى "مسجل خروج"
    isLoggedIn.value = false;

    // 2. تصفير جميع الأوقات
    loginTime.value = '00:00:00';
    logoutTime.value = '00:00:00';
    duration.value = '00:00:00';
    workingHours.value = '00:00:00';
    loginTimeDuration.value = null;
  }

  // دالة لتحديد التحية بناءً على الوقت
  void _updateGreetingKey() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      greetingKey.value = 'morning'; // خزّن المفتاح فقط
    } else if (hour < 17) {
      greetingKey.value = 'afternoon'; // خزّن المفتاح فقط
    } else {
      greetingKey.value = 'evening'; // خزّن المفتاح فقط
    }
  }

  // دالة لتسجيل الحضور
  void markAttendance(DateTime date) {
    attendanceRecords[date] = true;
    update(); // لتحديث الواجهة
  }

  // دالة للتحقق من وجود حضور في تاريخ معين
  bool isDateMarked(DateTime date) {
    return attendanceRecords[date] ?? false;
  }

  // دالة تسجيل الدخول
  void logIn(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode; // 'ar' or 'en'
    loginTime.value = DateFormat('hh:mm:ss a', locale).format(DateTime.now());
    loginTimeDuration.value = DateTime.now();
    logoutTime.value = '';
    duration.value = '';
  }

  // دالة تسجيل الخروج
  void logOut(BuildContext context) {
    // isLoggedIn.value = false;

    // Get the current locale
    final locale = Localizations.localeOf(context).languageCode; // 'ar' or 'en'

    // Format time with AM/PM based on locale
    logoutTime.value = DateFormat('hh:mm:ss a', locale).format(DateTime.now());

    if (loginTime.value.isNotEmpty) {
      final login = loginTimeDuration.value!;

      final diff = DateTime.now().difference(login);
      duration.value =
          '${diff.inHours} ${_translate('hours', locale)} '
          '${diff.inMinutes.remainder(60)} ${_translate('minutes', locale)} '
          '${diff.inSeconds.remainder(60)} ${_translate('seconds', locale)}';
      workingHours.value =
          '${diff.inHours}:${diff.inMinutes.remainder(60)}:${diff.inSeconds.remainder(60)}';
      String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // 2. إنشاء خريطة (Map) تحتوي على بيانات اليوم
      Map<String, dynamic> attendanceData = {
        'loginTime': loginTime.value,
        'logoutTime': logoutTime.value,
        'workingHours': workingHours.value,
        'date': DateTime.now().toIso8601String(), // حفظ التاريخ كاملاً
      };

      // 3. حفظ الخريطة في GetStorage باستخدام مفتاح اليوم
      box.write(todayKey, attendanceData);
      // print("✅ تم حفظ بيانات يوم $todayKey في GetStorage.");
      // --- نهاية الإضافة الجديدة ---
    }
  }

  // Helper function to translate units
  String _translate(String unit, String locale) {
    return {
      'ar': {'hours': 'ساعات', 'minutes': 'دقائق', 'seconds': 'ثواني'},
      'en': {'hours': 'hours', 'minutes': 'minutes', 'seconds': 'seconds'},
    }[locale]![unit]!;
  }

  // دالة لتبديل حالة الدخول والخروج
  void toggleAuth() {
    isLoggedIn.toggle();
  }

  // دالة لتحويل وقت من نص إلى double
  double convertTimeStringToDouble() {
    List<String> parts = workingHours.value.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return hours + (minutes / 60);
  }

  var selectedSummaryDate = DateTime.now().obs;

  /// البيانات الخاصة باليوم المختار للعرض.
  var displayedAttendanceData = Rxn<Map<String, dynamic>>();
  // --- نهاية الإضافة الجديدة ---

  // ...

  // --- دالة جديدة لتغيير اليوم المعروض ---
  void changeSelectedSummaryDate(DateTime newDate) {
    selectedSummaryDate.value = newDate;
    // ابحث عن بيانات هذا اليوم في GetStorage
    String dateKey = DateFormat('yyyy-MM-dd').format(newDate);
    Map<String, dynamic>? data = box.read(dateKey);

    if (data != null) {
      // إذا وجدت بيانات، قم بتحديث المتغير الخاص بالعرض
      displayedAttendanceData.value = data;
      // print("📊 عرض بيانات يوم: $dateKey");
    } else {
      // إذا لم تجد بيانات، قم بتصفير المتغير
      displayedAttendanceData.value = null;
      // print("📊 لا توجد بيانات ليوم: $dateKey");
    }
  }


 @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => ThemeController());
    _updateGreetingKey(); // استدعاء الدالة لتعيين المفتاح الأوليس
    changeSelectedSummaryDate(DateTime.now());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
