import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sls_app/app/modules/theme/controllers/theme_controller.dart';

class LocationController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => ThemeController());
  }

  final RxBool isLoading = false.obs;
  final RxBool isSuccess = false.obs;

  Future<void> verifyLocation() async {
    isLoading.value = true;
    isSuccess.value = false;

    try {
      final LocationSettings locationSettings;

      if (defaultTargetPlatform == TargetPlatform.android) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          forceLocationManager: true,
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          pauseLocationUpdatesAutomatically: true, // مثال لإعدادات iOS
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        );
      }

      // --- هذا هو التصحيح ---
      // الآن نحن نمرر الإعدادات التي أنشأناها إلى الدالة
      Position pos = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings, // <--- تم تمرير المتغير هنا
      ).timeout(const Duration(seconds: 15));
      // --- نهاية التصحيح ---

      const target = LatLng(15.647403, 32.622151);

      double distance = _calculateDistance(
        pos.latitude,
        pos.longitude,
        target.latitude,
        target.longitude,
      );
      // 5. التحقق من النطاق
      if (distance <= 300) {
        isSuccess.value = true;
        Get.snackbar(
          "نجاح",
          "أنت داخل نطاق العمل. المسافة: ${distance.toStringAsFixed(2)} متر.",
        );
      } else {
        isSuccess.value = false;
        // سنعرض رسالة الخطأ من هنا بدلاً من الواجهة
        Get.defaultDialog(
          title: "📍 أنت خارج النطاق",
          middleText:
              "المسافة الحالية من موقع العمل هي ${distance.toStringAsFixed(2)} متر، وهي أكبر من النطاق المسموح به (300 متر).",
          textConfirm: 'حسناً',
          confirmTextColor: Colors.white,
          onConfirm: () => Get.back(),
        );
      }
      // print(
      //   "📏 المسافة المحسوبة من موقع العمل: ${distance.toStringAsFixed(2)} متر",
      // );
    } on TimeoutException catch (_) {
      Get.snackbar(
        "خطأ",
        "لم نتمكن من تحديد موقعك في الوقت المناسب. يرجى المحاولة في مكان مفتوح.",
      );
      isSuccess.value = false;
    } on LocationServiceDisabledException catch (_) {
      Get.snackbar("خطأ", "يرجى تفعيل خدمة الموقع (GPS) في جهازك.");
      isSuccess.value = false;
    } on PermissionDeniedException catch (e) {
      String message =
          "تم رفض إذن الوصول للموقع. يرجى السماح به من إعدادات التطبيق.";
      if (e.message != null && e.message!.contains('permanently denied')) {
        message =
            "تم رفض إذن الموقع بشكل دائم. يرجى الذهاب إلى إعدادات التطبيق وتفعيله يدوياً.";
      }
      Get.snackbar("خطأ", message);
      isSuccess.value = false;
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ غير متوقع: ${e.toString()}");
      isSuccess.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
