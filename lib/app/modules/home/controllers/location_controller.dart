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
    try {
      await Future.delayed(Duration(seconds: 2));
      Position pos = await Geolocator.getCurrentPosition();
      // print("إحداثياتي: ${pos.latitude}, ${pos.longitude}");

      const target = LatLng(15.648026, 32.621937); // إحداثياتك هنا
      double distance = _calculateDistance(
        pos.latitude,
        pos.longitude,
        target.latitude,
        target.longitude,
      );
      // true meter إذا كنت ضمن نطاف 100
      isSuccess.value = distance <= 150; // 150 متر
      print('Is within range: ${isSuccess.value}');
      print('The distance: $distance');
    } catch (e) {
      Get.snackbar("Oops!", e.toString());
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
