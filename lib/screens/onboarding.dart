import 'dart:io';
import 'package:arzan_digital/controllers/country_list_controller.dart';
import 'package:arzan_digital/controllers/dashboard_controller.dart';
import 'package:arzan_digital/controllers/history_controller.dart';
import 'package:arzan_digital/controllers/sign_in_controller.dart';
import 'package:arzan_digital/helpers/language_helper.dart';
import 'package:arzan_digital/routes/routes.dart';
import 'package:arzan_digital/utils/colors.dart';
import 'package:arzan_digital/utils/mystring.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global_controller/languages_controller.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  // Controllers for both draggable sheets
  late DraggableScrollableController _signInController;
  late DraggableScrollableController _registerController;

  // Variables to track icon state
  bool isSignInOpen = false;
  bool isRegisterOpen = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.defaultColor,
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
    _signInController = DraggableScrollableController();
    _registerController = DraggableScrollableController();
  }

  @override
  void dispose() {
    _signInController.dispose();
    _registerController.dispose();
    super.dispose();
  }

  void _toggleSignInSheet() {
    setState(() {
      if (_signInController.size < 0.9) {
        _signInController.animateTo(
          0.9,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        isSignInOpen = true; // Sheet is expanded, set to true
      } else {
        _signInController.animateTo(
          0.2,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        isSignInOpen = false; // Sheet is collapsed, set to false
      }
    });
  }

  void _toggleRegisterSheet() {
    setState(() {
      if (_registerController.size < 0.9) {
        _registerController.animateTo(
          0.9,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        isRegisterOpen = true; // Sheet is expanded, set to true
      } else {
        _registerController.animateTo(
          0.1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        isRegisterOpen = false; // Sheet is collapsed, set to false
      }
    });
  }

  double inisize = 0.2;

  int currentPage = 0;

  List pagelist = [pageOne(), pageTwo(), pageThree()];
  final _pageController = PageController();

  final box = GetStorage();

  whatsapp() async {
    var contact = "+93788078985";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      print("not found");
    }
  }

  final SignInController signInController = Get.put(SignInController());
  final CountryListController countryListController = Get.put(
    CountryListController(),
  );

  final historyController = Get.find<HistoryController>();
  final dashboardController = Get.find<DashboardController>();
  final languageController = Get.find<LanguagesController>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(languageController.tr("EXIT_APP")),
              content: Text(languageController.tr("DO_YOU_WANT_TO_EXIT_APP")),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(languageController.tr("NO")),
                ),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text(languageController.tr("YES")),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          backgroundColor: AppColors.tealGreenColor,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Container(
                      height: 600,
                      width: screenWidth,
                      child: Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              physics: BouncingScrollPhysics(),
                              controller: _pageController,
                              itemCount: pagelist.length,
                              onPageChanged: (value) {
                                setState(() {
                                  currentPage = value;
                                });
                              },
                              itemBuilder: (context, index) {
                                return pagelist[index];
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(3, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: 10,
                                  width: currentPage == index ? 50 : 10,
                                  decoration: BoxDecoration(
                                    color: currentPage == index
                                        ? Colors.white
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Sign In Draggable Scrollable Sheet
              DraggableScrollableSheet(
                key: ValueKey("sign_in_sheet"),
                shouldCloseOnMinExtent: true,
                controller: _signInController,
                initialChildSize: 0.2,
                minChildSize: 0.2,
                maxChildSize: 0.9,
                builder: (context, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: screenWidth,
                  child: ListView(
                    controller: scrollController,
                    children: [
                      GestureDetector(
                        onTap: _toggleSignInSheet,
                        child: Icon(FontAwesomeIcons.chevronUp),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Text(languageController.tr("SIGN_IN"))),
                        ],
                      ),
                      SizedBox(height: 40),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        height: 300,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1,
                            color: AppColors.defaultColor,
                          ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                languageController.tr("ENTER_YOUR_CREDENTIAL"),

                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 20),

                              Obx(
                                () => TextField(
                                  controller:
                                      signInController.usernameController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: languageController.tr("USERNAME"),

                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.person_2_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Obx(
                                () => TextField(
                                  controller:
                                      signInController.passwordController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: languageController.tr("PASSWORD"),

                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),

                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     Text(
                              //       "Forgot Password ?",
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.w400,
                              //         color: Colors.white54,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              GestureDetector(
                                onTap: () async {
                                  historyController.initialpage = 1;

                                  if (signInController
                                          .usernameController
                                          .text
                                          .isEmpty ||
                                      signInController
                                          .passwordController
                                          .text
                                          .isEmpty) {
                                    Get.snackbar(
                                      languageController.tr("ERROR"),
                                      languageController.tr("FILL_THE_DATA"),
                                      colorText: Colors.white,
                                      duration: Duration(seconds: 1),
                                    );
                                  } else {
                                    await signInController.signIn();

                                    if (signInController.loginsuccess.value ==
                                        false) {
                                      countryListController.fetchCountryData();

                                      dashboardController.fetchDashboardData();
                                      Get.toNamed(bottomnavscreen);
                                    } else {
                                      print("Navigation conditions not met.");
                                    }
                                  }
                                },
                                child: Container(
                                  height: 48,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: AppColors.mintColor,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        signInController.isLoading.value ==
                                                false
                                            ? languageController.tr("SIGN_IN")
                                            : languageController.tr(
                                                "PLEASE_WAIT",
                                              ),

                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          // color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  whatsapp();
                                },
                                child: Container(
                                  height: 30,
                                  child: Image.asset(
                                    "assets/icons/whatsapp.png",
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Obx(
                                () => Text(
                                  languageController.tr("SUPPORT"),

                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Register Draggable Scrollable Sheet
              DraggableScrollableSheet(
                key: ValueKey("register_sheet"),
                controller: _registerController,
                initialChildSize: 0.1,
                minChildSize: 0.1,
                maxChildSize: 0.9,
                builder: (context, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: AppColors.mintColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: screenWidth,
                  child: ListView(
                    controller: scrollController,
                    children: [
                      GestureDetector(
                        onTap: _toggleRegisterSheet,
                        child: Icon(
                          FontAwesomeIcons.chevronUp,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            languageController.tr("REGISTER"),

                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        height: 350,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.tealColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                languageController.tr(
                                  "ENTER_YOUR_DATA_TO_REGISTER",
                                ),

                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              Obx(
                                () => TextField(
                                  controller:
                                      signInController.passwordController,
                                  style: TextStyle(color: Colors.white54),
                                  decoration: InputDecoration(
                                    hintText: languageController.tr("NAME"),

                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white54,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 7),
                              Obx(
                                () => TextField(
                                  controller:
                                      signInController.passwordController,
                                  style: TextStyle(color: Colors.white54),
                                  decoration: InputDecoration(
                                    hintText: languageController.tr("EMAIL"),

                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white54,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 7),
                              Obx(
                                () => TextField(
                                  controller:
                                      signInController.passwordController,
                                  style: TextStyle(color: Colors.white54),
                                  decoration: InputDecoration(
                                    hintText: languageController.tr("PASSWORD"),

                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white54,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              GestureDetector(
                                onTap: () {
                                  // Get.toNamed(newsigninscreen);
                                },
                                child: Container(
                                  height: 50,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Center(
                                    child: Text(
                                      languageController.tr("REGISTER"),

                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class pageOne extends StatelessWidget {
  pageOne({super.key});
  String scantext =
      "Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. ";

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(height: 40),
        Container(height: 250, child: Image.asset('assets/images/slide-1.png')),
        SizedBox(height: 20),
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to ${MyString.appname}",
                          style: GoogleFonts.oswald(
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.055,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Order everywhere, everytime",
                          style: GoogleFonts.oswald(
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.055,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            textAlign: TextAlign.start,
            scantext,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class pageTwo extends StatelessWidget {
  pageTwo({super.key});
  String scantext =
      "Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. ";

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(height: 40),
        Container(
          height: 250,
          // color: Colors.amber,
          child: Image.asset('assets/images/slide-2.png'),
        ),
        SizedBox(height: 20),
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to ${MyString.appname}",
                          style: GoogleFonts.oswald(
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.055,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Order everywhere, everytime",
                          style: GoogleFonts.oswald(
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.055,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            textAlign: TextAlign.start,
            scantext,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class pageThree extends StatelessWidget {
  pageThree({super.key});
  String scantext =
      "Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. ";

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(height: 40),
        Container(
          height: 250,
          // color: Colors.amber,
          child: Image.asset('assets/images/slide-3.png'),
        ),
        SizedBox(height: 20),
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to ${MyString.appname}",
                          style: GoogleFonts.oswald(
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.055,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Order everywhere, everytime",
                          style: GoogleFonts.oswald(
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.055,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            textAlign: TextAlign.start,
            scantext,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
