import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:sls_app/app/core/lang/ar.dart';
import 'package:sls_app/app/core/lang/en.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'ar':ar
      };
}