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
import 'package:yawar_digital/screens/change_password_screen.dart';
import 'package:yawar_digital/screens/commission_group_screen.dart';
import 'package:yawar_digital/screens/myprofile_screen.dart';

import 'package:yawar_digital/pages/sub_reseller_screen.dart';
import 'package:yawar_digital/screens/selling_price_screen.dart';
import 'package:yawar_digital/utils/colors.dart';
import 'package:yawar_digital/widgets/profile_menu_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global_controller/languages_controller.dart';
import '../screens/helpscreen.dart';
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
  final languageController = Get.find<LanguagesController>();
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
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text(
              textAlign: TextAlign.center,
              languageController.tr("PROFILE"),

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.red,
                // image: DecorationImage(
                //   image: NetworkImage(
                //     dashboardController
                //         .alldashboardData
                //         .value
                //         .data!
                //         .userInfo!
                //         .profileImageUrl
                //         .toString(),
                //   ),
                //   fit: BoxFit.cover,
                // ),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 5),
            Text(
              textAlign: TextAlign.center,
              dashboardController
                  .alldashboardData
                  .value
                  .data!
                  .userInfo!
                  .resellerName
                  .toString(),
              style: GoogleFonts.rubik(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),

            Text(
              textAlign: TextAlign.center,
              dashboardController.alldashboardData.value.data!.userInfo!.email
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
            SizedBox(height: 10),
            ProfileMenuWidget(
              itemName: languageController.tr("PERSONAL_INFO"),

              imageLink: "assets/icons/homeicon.png",
              onPressed: () {
                Get.toNamed(myprofilescreen);
              },
            ),

            ProfileMenuWidget(
              itemName: languageController.tr("SET_SALE_PRICE"),

              imageLink: "assets/icons/set_sell_price.png",
              onPressed: () {
                Get.to(SellingPriceScreen());
              },
            ),

            ProfileMenuWidget(
              itemName: languageController.tr("COMMISSION_GROUP"),

              imageLink: "assets/icons/set_vendor_sell_price.png",
              onPressed: () {
                Get.to(CommissionGroupScreen());
              },
            ),

            ProfileMenuWidget(
              itemName: languageController.tr("CHANGE_PIN"),

              imageLink: "assets/icons/key.png",
              onPressed: () {
                Get.toNamed(changepinscreen);
              },
            ),

            ProfileMenuWidget(
              itemName: languageController.tr("CHANGE_PASSWORD"),

              imageLink: "assets/icons/key.png",
              onPressed: () {
                Get.to(ChangePasswordScreen());
              },
            ),

            ProfileMenuWidget(
              itemName: languageController.tr("HELP"),

              imageLink: "assets/icons/support.png",
              onPressed: () {
                Get.to(Helpscreen());
              },
            ),

            ProfileMenuWidget(
              itemName: languageController.tr("TERMS_AND_CONDITIONS"),

              imageLink: "assets/icons/terms.png",
              onPressed: () {},
            ),

            ProfileMenuWidget(
              itemName: languageController.tr("CONTACTUS"),

              imageLink: "assets/icons/support.png",
              onPressed: () {
                whatsapp();
              },
            ),
            ProfileMenuWidget(
              itemName: languageController.tr("CHANGE_LANGUAGE"),

              imageLink: "assets/icons/globe.png",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(languageController.tr("LANGUAGES")),
                      content: Container(
                        height: 350,
                        width: screenWidth,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: languageController.alllanguagedata.length,
                          itemBuilder: (context, index) {
                            final data =
                                languageController.alllanguagedata[index];
                            return GestureDetector(
                              onTap: () {
                                final languageName = data["name"].toString();

                                final matched = languageController
                                    .alllanguagedata
                                    .firstWhere(
                                      (lang) => lang["name"] == languageName,
                                      orElse: () => {
                                        "isoCode": "en",
                                        "direction": "ltr",
                                      },
                                    );

                                final languageISO = matched["isoCode"]!;
                                final languageDirection = matched["direction"]!;

                                // Store selected language & direction
                                languageController.changeLanguage(languageName);
                                box.write("language", languageName);
                                box.write("direction", languageDirection);

                                // Set locale based on ISO
                                Locale locale;
                                switch (languageISO) {
                                  case "fa":
                                    locale = Locale("fa", "IR");
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
                                  case "en":
                                  default:
                                    locale = Locale("en", "US");
                                }

                                // Set app locale
                                setState(() {
                                  EasyLocalization.of(
                                    context,
                                  )!.setLocale(locale);
                                });

                                // Pop dialog
                                Navigator.pop(context);

                                print(
                                  "🌐 Language changed to $languageName ($languageISO), Direction: $languageDirection",
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5),
                                height: 45,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Center(
                                        child: Text(
                                          languageController
                                              .alllanguagedata[index]["fullname"]
                                              .toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            SizedBox(height: 5),
            ProfileMenuWidget(
              itemName: languageController.tr("LOG_OUT"),

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
