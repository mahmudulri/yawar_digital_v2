import 'package:arzan_digital/controllers/dashboard_controller.dart';
import 'package:arzan_digital/controllers/history_controller.dart';
import 'package:arzan_digital/controllers/slider_controller.dart';
import 'package:arzan_digital/global_controller/languages_controller.dart';
import 'package:arzan_digital/routes/routes.dart';
import 'package:arzan_digital/utils/mystring.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:arzan_digital/controllers/iso_code_controller.dart';
import 'package:arzan_digital/controllers/language_controller.dart';

import 'package:arzan_digital/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () => checkData());

    super.initState();
  }

  final languageController = Get.find<LanguagesController>();
  final iscoCodeController = Get.find<IscoCodeController>();
  final sliderController = Get.find<SliderController>();
  final historyController = Get.find<HistoryController>();
  final dashboardController = Get.find<DashboardController>();

  // checkData() async {
  //   if (box.read('userToken') == null) {
  //     box.write("isoCode", "fa");
  //     box.write("direction", "rtl");

  //     // languageController.fetchlanData(box.read("isoCode"));

  //     setState(() {
  //       EasyLocalization.of(context)!.setLocale(Locale('ar', 'AE'));
  //     });

  //     Get.toNamed(onboardingscreen);
  //   } else {
  //     sliderController.fetchSliderData();
  //     historyController.finalList.clear();
  //     historyController.initialpage = 1;
  //     historyController.fetchHistory();
  //     dashboardController.fetchDashboardData();

  //     Get.toNamed(bottomnavscreen);
  //   }
  // }

  checkData() async {
    String languageShortName = box.read("language") ?? "Fa";

    // Find selected language details from the list
    final matchedLang = languageController.alllanguagedata.firstWhere(
      (lang) => lang["name"] == languageShortName,
      orElse: () => {"isoCode": "fa", "direction": "rtl"},
    );

    final isoCode = matchedLang["isoCode"] ?? "fa";
    final direction = matchedLang["direction"] ?? "rtl";

    // Save language and direction
    box.write("language", languageShortName);
    box.write("direction", direction);

    // Load translations manually
    languageController.changeLanguage(languageShortName);

    // Set EasyLocalization locale using proper region code
    Locale locale;
    switch (isoCode) {
      case "fa":
        locale = Locale("fa", "IR");
        break;
      case "en":
        locale = Locale("en", "US");
        break;
      case "ar":
        locale = Locale("ar", "AE");
        break;
      case "ps":
        locale = Locale("ps", "AF");
        break;
      case "tr":
        locale = Locale("tr", "TR");
        break;
      case "bn":
        locale = Locale("bn", "BD");
        break;
      default:
        locale = Locale("fa", "IR");
    }

    setState(() {
      EasyLocalization.of(context)!.setLocale(locale);
    });

    // If no token, go to onboarding
    if (box.read('userToken') == null) {
      Get.toNamed(onboardingscreen);
    } else {
      // Fetch initial data
      // dashboardController.fetchDashboardData();

      Get.toNamed(bottomnavscreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor:
            AppColors.defaultColor, // Optional: makes status bar transparent
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.defaultColor,
      // backgroundColor: Color(0xffD2D2D2),
      body: Center(
        child: GestureDetector(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "WELCOME TO",
                style: GoogleFonts.bebasNeue(
                  // color: Color(0xff46558A),
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                MyString.appname,
                style: GoogleFonts.bebasNeue(
                  // color: Color(0xff46558A),
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              Lottie.asset(
                'assets/loties/loading-02.json',
                height: 200,
                width: 200,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
