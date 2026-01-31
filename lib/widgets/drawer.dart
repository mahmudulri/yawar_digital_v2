import 'dart:io';

import 'package:yawar_digital/routes/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yawar_digital/controllers/dashboard_controller.dart';
import 'package:yawar_digital/controllers/history_controller.dart';
import 'package:yawar_digital/controllers/iso_code_controller.dart';
import 'package:yawar_digital/controllers/language_controller.dart';
import 'package:yawar_digital/controllers/sign_in_controller.dart';
import 'package:yawar_digital/screens/add_card_screen.dart';
import 'package:yawar_digital/screens/myprofile_screen.dart';

import 'package:yawar_digital/pages/sub_reseller_screen.dart';
import 'package:yawar_digital/utils/colors.dart';
import 'package:yawar_digital/widgets/profile_menu_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/onboarding.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final box = GetStorage();

  final signInController = Get.find<SignInController>();
  final iscoCodeController = Get.find<IscoCodeController>();
  final languageController = Get.find<LanguageController>();
  final historyController = Get.find<HistoryController>();
  final dashboardController = Get.find<DashboardController>();

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

  @override
  void initState() {
    // dashboardController.fetchDashboardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      height: screenHeight,
      width: screenWidth - 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => languageController.isLoading.value == false
              ? Column(
                  children: [
                    SizedBox(height: 40),
                    Text(
                      languageController
                          .alllanguageData
                          .value
                          .languageData!["PROFILE"]
                          .toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            dashboardController
                                .alldashboardData
                                .value
                                .data!
                                .userInfo!
                                .profileImageUrl
                                .toString(),
                          ),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      dashboardController
                          .alldashboardData
                          .value
                          .data!
                          .userInfo!
                          .resellerName
                          .toString(),
                      style: GoogleFonts.rubik(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      dashboardController
                          .alldashboardData
                          .value
                          .data!
                          .userInfo!
                          .email
                          .toString(),
                      style: GoogleFonts.rubik(
                        color: AppColors.borderColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 15),
                    ProfileMenuWidget(
                      itemName: languageController
                          .alllanguageData
                          .value
                          .languageData!["PERSONAL_INFO"]
                          .toString(),
                      imageLink: "assets/icons/homeicon.png",
                      onPressed: () {
                        Get.toNamed(myprofilescreen);
                      },
                    ),
                    SizedBox(height: 5),
                    ProfileMenuWidget(
                      itemName: languageController
                          .alllanguageData
                          .value
                          .languageData!["ADD_CARD"]
                          .toString(),
                      imageLink: "assets/icons/add_card.png",
                      onPressed: () {
                        Get.toNamed(addcardScreen);
                      },
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // ProfileMenuWidget(
                    //   itemName: languageController
                    //       .alllanguageData.value.languageData!["SUB_RESELLER"]
                    //       .toString(),
                    //   imageLink: "assets/icons/sub_reseller.png",
                    //   onPressed: () {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => SubResellerScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    SizedBox(height: 5),
                    ProfileMenuWidget(
                      itemName: languageController
                          .alllanguageData
                          .value
                          .languageData!["TERMS_AND_CONDITIONS"]
                          .toString(),
                      imageLink: "assets/icons/terms.png",
                      onPressed: () {},
                    ),
                    SizedBox(height: 5),
                    ProfileMenuWidget(
                      itemName: languageController
                          .alllanguageData
                          .value
                          .languageData!["CONTACTUS"]
                          .toString(),
                      imageLink: "assets/icons/support.png",
                      onPressed: () {
                        whatsapp();
                      },
                    ),
                    ProfileMenuWidget(
                      itemName: languageController
                          .alllanguageData
                          .value
                          .languageData!["CHANGE_LANGUAGE"]
                          .toString(),
                      imageLink: "assets/icons/globe.png",
                      onPressed: () {
                        // historyController.finalList.clear();
                        iscoCodeController.fetchisoCode();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              // contentPadding: EdgeInsets.all(0.0),
                              content: Container(
                                height: 300,
                                width: screenWidth,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Obx(
                                        () =>
                                            iscoCodeController
                                                    .isLoading
                                                    .value ==
                                                false
                                            ? ListView.builder(
                                                itemCount: iscoCodeController
                                                    .allisoCodeData
                                                    .value
                                                    .data!
                                                    .languages
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  final data =
                                                      iscoCodeController
                                                          .allisoCodeData
                                                          .value
                                                          .data!
                                                          .languages[index];
                                                  return languageBox(
                                                    lanName: data.languageName,
                                                    onpressed: () {
                                                      historyController
                                                          .finalList
                                                          .clear();
                                                      historyController
                                                              .initialpage =
                                                          1;
                                                      languageController
                                                          .fetchlanData(
                                                            data.language_code
                                                                .toString(),
                                                          );
                                                      box.write(
                                                        "isoCode",
                                                        data.language_code
                                                            .toString(),
                                                      );
                                                      box.write(
                                                        "direction",
                                                        data.direction
                                                            .toString(),
                                                      );

                                                      if (data.direction ==
                                                          "rtl") {
                                                        setState(() {
                                                          EasyLocalization.of(
                                                            context,
                                                          )!.setLocale(
                                                            Locale('ar', 'AE'),
                                                          );
                                                        });
                                                      } else {
                                                        setState(() {
                                                          EasyLocalization.of(
                                                            context,
                                                          )!.setLocale(
                                                            Locale('en', 'US'),
                                                          );
                                                        });
                                                      }
                                                      historyController
                                                          .finalList
                                                          .clear();
                                                      historyController
                                                              .initialpage =
                                                          1;
                                                      historyController
                                                          .fetchHistory();

                                                      Navigator.pop(context);

                                                      // historyController.finalList.clear();
                                                      // historyController.initialpage = 1;
                                                    },
                                                  );
                                                },
                                              )
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(height: 5),
                    ProfileMenuWidget(
                      itemName: languageController
                          .alllanguageData
                          .value
                          .languageData!["LOG_OUT"]
                          .toString(),
                      imageLink: "assets/icons/logout.png",
                      onPressed: () {
                        historyController.finalList.clear();
                        historyController.finalList.clear();
                        Get.toNamed(onboardingscreen);

                        signInController.usernameController.clear();
                        signInController.passwordController.clear();

                        box.remove("userToken");
                        // showDialog(
                        //   context: context,
                        //   builder: (context) {
                        //     return AlertDialog(
                        //       content: Container(
                        //         height: 140,
                        //         width: screenWidth,
                        //         decoration: BoxDecoration(
                        //           color: Colors.white,
                        //         ),
                        //         child: Column(
                        //           children: [
                        //             Text(
                        //               languageController
                        //                   .alllanguageData
                        //                   .value
                        //                   .languageData![
                        //                       "DO_YOU_WANT_TO_LOGOUT"]
                        //                   .toString(),
                        //               style: TextStyle(
                        //                 fontSize: 17,
                        //                 fontWeight: FontWeight.w600,
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               height: 40,
                        //             ),
                        //             Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 GestureDetector(
                        //                   onTap: () {
                        //                     historyController.finalList
                        //                         .clear();
                        //                     Navigator.push(
                        //                       context,
                        //                       MaterialPageRoute(
                        //                         builder: (context) {
                        //                           return SignInScreen();
                        //                         },
                        //                       ),
                        //                     );

                        //                     signInController
                        //                         .usernameController
                        //                         .clear();
                        //                     signInController
                        //                         .passwordController
                        //                         .clear();

                        //                     box.remove("userToken");
                        //                     signInController
                        //                         .loginsuccess.value = true;

                        //                     //...........................
                        //                   },
                        //                   child: Container(
                        //                     height: 40,
                        //                     width: 100,
                        //                     decoration: BoxDecoration(
                        //                       color: AppColors.borderColor,
                        //                       borderRadius:
                        //                           BorderRadius.circular(7),
                        //                     ),
                        //                     child: Center(
                        //                       child: Text(
                        //                         languageController
                        //                             .alllanguageData
                        //                             .value
                        //                             .languageData!["YES"]
                        //                             .toString(),
                        //                         style: TextStyle(
                        //                           color: Colors.white,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 GestureDetector(
                        //                   onTap: () {
                        //                     Navigator.of(context).pop();
                        //                   },
                        //                   child: Container(
                        //                     height: 40,
                        //                     width: 100,
                        //                     decoration: BoxDecoration(
                        //                       color: AppColors.borderColor,
                        //                       borderRadius:
                        //                           BorderRadius.circular(7),
                        //                     ),
                        //                     child: Center(
                        //                       child: Text(
                        //                         languageController
                        //                             .alllanguageData
                        //                             .value
                        //                             .languageData!["NO"]
                        //                             .toString(),
                        //                         style: TextStyle(
                        //                           color: Colors.white,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class languageBox extends StatelessWidget {
  const languageBox({super.key, this.lanName, this.onpressed});
  final String? lanName;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: GestureDetector(
        onTap: onpressed,
        child: Container(
          margin: EdgeInsets.only(bottom: 6),
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              lanName.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
