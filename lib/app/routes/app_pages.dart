import 'package:get/get.dart';

import '../modules/calenar/bindings/calenar_binding.dart';
import '../modules/calenar/views/calenar_view.dart';
import '../modules/check_done/bindings/check_done_binding.dart';
import '../modules/check_done/views/check_done_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/language/bindings/language_binding.dart';
import '../modules/language/views/language_view.dart';
import '../modules/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/main_navigation/views/main_navigation_view.dart';
import '../modules/more/bindings/more_binding.dart';
import '../modules/more/views/more_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/person_info/bindings/person_info_binding.dart';
import '../modules/person_info/views/person_info_view.dart';
import '../modules/requests/bindings/requests_binding.dart';
import '../modules/requests/views/requests_view.dart';
import '../modules/summary/bindings/summary_binding.dart';
import '../modules/summary/views/summary_view.dart';
import '../modules/theme/bindings/theme_binding.dart';
import '../modules/theme/views/theme_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () =>  HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CALENAR,
      page: () =>  CalenarView(),
      binding: CalenarBinding(),
    ),
    GetPage(
      name: _Paths.CHECK_DONE,
      page: () =>  CheckDoneView(),
      binding: CheckDoneBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGE,
      page: () =>  LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_NAVIGATION,
      page: () =>  MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: _Paths.MORE,
      page: () => const MoreView(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.PERSON_INFO,
      page: () => const PersonInfoView(),
      binding: PersonInfoBinding(),
    ),
    GetPage(
      name: _Paths.REQUESTS,
      page: () => const RequestsView(),
      binding: RequestsBinding(),
    ),
    GetPage(
      name: _Paths.SUMMARY,
      page: () =>  SummaryView(),
      binding: SummaryBinding(),
    ),
    GetPage(
      name: _Paths.THEME,
      page: () =>  ThemeView(),
      binding: ThemeBinding(),
    ),
  ];
}
