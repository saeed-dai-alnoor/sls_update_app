import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sls_app/app/core/lang/languages.dart';

import 'app/modules/calenar/controllers/calenar_controller.dart';
import 'app/modules/home/controllers/home_controller.dart';
import 'app/modules/main_navigation/views/main_navigation_view.dart';
import 'app/modules/summary/controllers/summary_controller.dart';
import 'app/routes/app_pages.dart';

void main()  async{
 WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await GetStorage.init();
  final getStorage = GetStorage();
  Get.put(SummaryController());
  Get.put(HomeController());
  Get.put(CalenarController());
  runApp(
    GetMaterialApp(
      title: "Application",
      // initialRoute: AppPages.INITIAL,
      locale: getStorage.read('lang') == 'ar' || getStorage.read('lang') == null
          ? const Locale('ar')
          : const Locale('en'),
      translations: Languages(),
      fallbackLocale: Locale('en'),
      supportedLocales: [Locale('en'), Locale('ar')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: MainNavigationView(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}