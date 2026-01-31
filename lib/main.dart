import 'package:yawar_digital/dependency_injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:yawar_digital/draftcode.dart';
import 'package:yawar_digital/routes/routes.dart';
import 'package:yawar_digital/splash_screen.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/time_zone_controller.dart';
import 'global_controller/languages_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();
  DependencyInjection.init();
  Get.put(LanguagesController(), permanent: true);

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('fa', 'IR'),
        Locale('ar', 'AE'),
        Locale('ps', 'AF'),
        Locale('tr', 'TR'),
        Locale('bn', 'BD'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  final TimeZoneController timeZoneController = Get.put(TimeZoneController());
  @override
  void initState() {
    super.initState();
    initTimezone();
  }

  void initTimezone() {
    Duration offset = DateTime.now().timeZoneOffset;

    timeZoneController.sign = offset.isNegative ? "-" : "+";
    timeZoneController.hour = offset.inHours.abs().toString().padLeft(2, '0');
    timeZoneController.minute = (offset.inMinutes.abs() % 60)
        .toString()
        .padLeft(2, '0');

    print(
      "Offset = ${timeZoneController.sign}${timeZoneController.hour}:${timeZoneController.minute}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: splash,
      getPages: myroutes,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Schedule locale update after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.updateLocale(context.locale);
    });
  }
}
