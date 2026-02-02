import 'package:arzan_digital/helpers/language_helper.dart';
import 'package:arzan_digital/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:arzan_digital/controllers/dashboard_controller.dart';
import 'package:arzan_digital/controllers/history_controller.dart';
import 'package:arzan_digital/utils/colors.dart';
import 'package:arzan_digital/widgets/auth_textfield.dart';
import 'package:arzan_digital/widgets/default_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../global_controller/languages_controller.dart';
import '../widgets/myprofile_box_widget.dart';
import 'change_pin.dart';
import 'edit_profile_screen.dart';

class MyprofileScreen extends StatelessWidget {
  MyprofileScreen({super.key});
  final languageController = Get.find<LanguagesController>();
  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),

        centerTitle: true,
        title: Text(
          languageController.tr("PERSONAL_INFO"),

          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       Get.to(() => EditProfileScreen());
        //     },
        //     child: Icon(
        //       FontAwesomeIcons.penToSquare,
        //       color: Colors.black,
        //     ),
        //   ),
        //   SizedBox(
        //     width: 15,
        //   ),
        // ],
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              SizedBox(height: 20),
              dashboardController
                          .alldashboardData
                          .value
                          .data!
                          .userInfo!
                          .profileImageUrl !=
                      null
                  ? Container(
                      height: 120,
                      width: 120,
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
                    )
                  : Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                    ),

              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: "Name",
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .userInfo!
                    .resellerName
                    .toString(),
              ),
              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: "Email",
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .userInfo!
                    .email
                    .toString(),
              ),
              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: "Name",
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .userInfo!
                    .phone
                    .toString(),
              ),
              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: "Balance",
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .userInfo!
                    .balance
                    .toString(),
              ),
              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: "Loan Balance",
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .userInfo!
                    .loanBalance
                    .toString(),
              ),
              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: "Total sold amount",
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .totalSoldAmount
                    .toString(),
              ),
              SizedBox(height: 5),
              MyProfileboxwidget(
                boxname: "Total revenue",
                title: dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .totalRevenue
                    .toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
