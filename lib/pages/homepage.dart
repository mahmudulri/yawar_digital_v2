import 'dart:async';

import 'package:arzan_digital/controllers/country_list_controller.dart';
import 'package:arzan_digital/controllers/dashboard_controller.dart';
import 'package:arzan_digital/controllers/history_controller.dart';
import 'package:arzan_digital/controllers/language_controller.dart';
import 'package:arzan_digital/controllers/slider_controller.dart';

import 'package:arzan_digital/routes/routes.dart';
import 'package:arzan_digital/screens/order_details.dart';
import 'package:arzan_digital/utils/colors.dart';
import 'package:arzan_digital/widgets/custom_text.dart';
import 'package:arzan_digital/widgets/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';

import '../controllers/company_controller.dart';
import '../global_controller/languages_controller.dart';
import '../widgets/contactbox.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final box = GetStorage();
  int currentindex = 0;

  final companyController = Get.find<CompanyController>();

  PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
  );

  int currentSliderindex = 0;

  Timer? _timer;
  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (currentSliderindex <
          dashboardController
                  .alldashboardData
                  .value
                  .data!
                  .advertisementSliders!
                  .length -
              1) {
        currentSliderindex++;
      } else {
        currentSliderindex = 0;
      }
      _pageController.animateToPage(
        currentSliderindex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {});
    });
  }

  String permission = "yes";
  @override
  void initState() {
    super.initState();
    // _startAutoSlide();
    _checkforUpdate();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.defaultColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    historyController.finalList.clear();
    historyController.initialpage = 1;
    historyController.fetchHistory();
    companyController.fetchCompany();
    dashboardController.fetchDashboardData();
  }

  Future<void> refresh() async {
    final int totalPages =
        historyController.allorderlist.value.payload?.pagination!.totalPages ??
        0;
    final int currentPage = historyController.initialpage;

    // Prevent loading more pages if we've reached the last page
    if (currentPage >= totalPages) {
      print(
        "End..........................................End.....................",
      );
      return;
    }

    // Check if the scroll position is at the bottom
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      historyController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (historyController.initialpage <= totalPages) {
        print("Load More...................");
        historyController.fetchHistory();
      } else {
        historyController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  final dashboardController = Get.find<DashboardController>();
  final historyController = Get.find<HistoryController>();
  final languageController = Get.find<LanguagesController>();

  final countryListController = Get.find<CountryListController>();

  final ScrollController scrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _checkforUpdate() async {
    print("checking");
    await InAppUpdate.checkForUpdate()
        .then((info) {
          setState(() {
            if (info.updateAvailability == UpdateAvailability.updateAvailable) {
              print("update available");
              _update();
            }
          });
        })
        .catchError((error) {
          print(error.toString());
        });
  }

  void _update() async {
    print("Updating");
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    print('.........' + dashboardController.deactiveStatus.toString());
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      if (dashboardController.isLoading.value) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator(color: Colors.grey)),
        );
      } else if (dashboardController.deactiveStatus.value
              .toString()
              .trim()
              .toLowerCase() ==
          "deactivated") {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dashboardController.deactiveStatus.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            contentPadding: EdgeInsets.all(0),
                            content: ContactDialogBox(),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 45,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: AppColors.defaultColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/icons/whatsapp.png", height: 30),
                          SizedBox(width: 20),
                          KText(
                            text: languageController.tr("CONTACTUS"),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          content: LogoutDialogBox(),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: Text(
                        languageController.tr("LOGOUT"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    dashboardController.fetchDashboardData();
                    historyController.finalList.clear();
                    historyController.initialpage = 1;
                    historyController.fetchHistory();
                    companyController.fetchCompany();
                  },
                  child: Icon(Icons.refresh, size: 35),
                ),
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          drawer: DrawerWidget(),
          key: _scaffoldKey,
          body: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(color: AppColors.backgroundColor),
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: screenWidth,
                  decoration: BoxDecoration(color: AppColors.backgroundColor),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.defaultColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: Icon(Icons.sort, color: Colors.white),
                          ),
                          SizedBox(width: 20),
                          Obx(
                            () => dashboardController.isLoading.value == false
                                ? Text(
                                    dashboardController
                                        .alldashboardData
                                        .value
                                        .data!
                                        .userInfo!
                                        .resellerName
                                        .toString(),
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.defaultColor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 0),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  // color: Colors.black,
                                ),
                                height: 180,
                                child: Obx(
                                  () =>
                                      dashboardController.isLoading.value ==
                                          false
                                      ? PageView.builder(
                                          itemCount: dashboardController
                                              .alldashboardData
                                              .value
                                              .data!
                                              .advertisementSliders!
                                              .length,
                                          physics: BouncingScrollPhysics(),
                                          controller: _pageController,
                                          onPageChanged: (value) {
                                            currentindex = value;
                                            setState(() {});
                                          },
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: screenWidth,
                                              margin: EdgeInsets.all(8),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: dashboardController
                                                        .alldashboardData
                                                        .value
                                                        .data!
                                                        .advertisementSliders![index]
                                                        .adSliderImageUrl
                                                        .toString(),
                                                    fit: BoxFit.fill,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.defaultColor,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 150,
                            width: screenWidth,
                            child: Obx(
                              () => dashboardController.isLoading.value == false
                                  ? Column(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Card(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                  0.2,
                                                                ), // shadow color
                                                            spreadRadius:
                                                                2, // spread radius
                                                            blurRadius:
                                                                2, // blur radius
                                                            offset: Offset(
                                                              0,
                                                              0,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 10,
                                                              right: 8,
                                                            ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment.center,
                                                              children: [
                                                                Image.asset(
                                                                  "assets/icons/balance-sheet.png",
                                                                  height: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text(
                                                                  languageController
                                                                      .tr(
                                                                        "BALANCE",
                                                                      ),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 5),
                                                            Row(
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  NumberFormat.currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double.parse(
                                                                      dashboardController
                                                                          .alldashboardData
                                                                          .value
                                                                          .data!
                                                                          .balance
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text(
                                                                  "${box.read("currency_code")}",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Card(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                  0.2,
                                                                ), // shadow color
                                                            spreadRadius:
                                                                2, // spread radius
                                                            blurRadius:
                                                                2, // blur radius
                                                            offset: Offset(
                                                              0,
                                                              0,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 10,
                                                              right: 8,
                                                            ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment.center,
                                                              children: [
                                                                Image.asset(
                                                                  "assets/icons/investment.png",
                                                                  height: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text(
                                                                  languageController.tr(
                                                                    "LOAN_BALANCE",
                                                                  ),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 5),
                                                            Row(
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  NumberFormat.currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double.parse(
                                                                      dashboardController
                                                                          .alldashboardData
                                                                          .value
                                                                          .data!
                                                                          .loanBalance
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text(
                                                                  "${box.read("currency_code")}",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   height: 5,
                                        // ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Card(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                  0.2,
                                                                ), // shadow color
                                                            spreadRadius:
                                                                2, // spread radius
                                                            blurRadius:
                                                                2, // blur radius
                                                            offset: Offset(
                                                              0,
                                                              0,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 10,
                                                              right: 8,
                                                            ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment.center,
                                                              children: [
                                                                Image.asset(
                                                                  "assets/icons/sales.png",
                                                                  height: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text(
                                                                  languageController
                                                                      .tr(
                                                                        "SALE",
                                                                      ),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 2),
                                                            Row(
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  languageController.tr(
                                                                    "TODAY_SALE",
                                                                  ),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  NumberFormat.currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double.parse(
                                                                      dashboardController
                                                                          .alldashboardData
                                                                          .value
                                                                          .data!
                                                                          .todaySale
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text(
                                                                  "${box.read("currency_code")}",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  languageController.tr(
                                                                    "TOTAL_SALE",
                                                                  ),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  NumberFormat.currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double.parse(
                                                                      dashboardController
                                                                          .alldashboardData
                                                                          .value
                                                                          .data!
                                                                          .totalSoldAmount
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text(
                                                                  "${box.read("currency_code")}",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   width: 5,
                                                // ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Card(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                  0.2,
                                                                ), // shadow color
                                                            spreadRadius:
                                                                2, // spread radius
                                                            blurRadius:
                                                                2, // blur radius
                                                            offset: Offset(
                                                              0,
                                                              0,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 10,
                                                              right: 8,
                                                            ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          // crossAxisAlignment:
                                                          //     CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment.center,
                                                              children: [
                                                                Image.asset(
                                                                  "assets/icons/profits.png",
                                                                  height: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text(
                                                                  languageController
                                                                      .tr(
                                                                        "PROFIT",
                                                                      ),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 2),
                                                            Row(
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  languageController.tr(
                                                                    "TODAY_PROFIT",
                                                                  ),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  NumberFormat.currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double.parse(
                                                                      dashboardController
                                                                          .alldashboardData
                                                                          .value
                                                                          .data!
                                                                          .todayProfit
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text(
                                                                  "${box.read("currency_code")}",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  languageController.tr(
                                                                    "TOTAL_PROFIT",
                                                                  ),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  NumberFormat.currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double.parse(
                                                                      dashboardController
                                                                          .alldashboardData
                                                                          .value
                                                                          .data!
                                                                          .totalRevenue
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Text(
                                                                  "${box.read("currency_code")}",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
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
                                    )
                                  : SizedBox(),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13),
                            child: GestureDetector(
                              onTap: () async {
                                Get.toNamed(customrechargescreen);
                              },
                              child: Container(
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.defaultColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Center(
                                    child: Text(
                                      languageController.tr("DIRECT_RECHARGE"),

                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Obx(
                            () => historyController.isLoading.value == false
                                ? Container(
                                    child:
                                        historyController
                                            .allorderlist
                                            .value
                                            .data!
                                            .orders
                                            .isNotEmpty
                                        ? SizedBox()
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/empty.png",
                                                  height: 80,
                                                ),
                                                Text("No Data found"),
                                              ],
                                            ),
                                          ),
                                  )
                                : SizedBox(),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: Obx(
                              () =>
                                  historyController.isLoading.value == false &&
                                      historyController.finalList.isNotEmpty
                                  ? RefreshIndicator(
                                      onRefresh: refresh,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 13,
                                        ),
                                        child: ListView.separated(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: false,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          controller: scrollController,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 5);
                                          },
                                          itemCount: historyController
                                              .finalList
                                              .length,
                                          itemBuilder: (context, index) {
                                            final data = historyController
                                                .finalList[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetailsScreen(
                                                          createDate: data
                                                              .createdAt
                                                              .toString(),
                                                          status: data.status
                                                              .toString(),
                                                          rejectReason: data
                                                              .rejectReason
                                                              .toString(),
                                                          companyName: data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyName
                                                              .toString(),
                                                          bundleTitle: data
                                                              .bundle!
                                                              .bundleTitle!
                                                              .toString(),
                                                          rechargebleAccount: data
                                                              .rechargebleAccount!
                                                              .toString(),
                                                          validityType: data
                                                              .bundle!
                                                              .validityType!
                                                              .toString(),
                                                          sellingPrice: data
                                                              .bundle!
                                                              .sellingPrice
                                                              .toString(),
                                                          orderID: data.id!
                                                              .toString(),
                                                          resellerName:
                                                              dashboardController
                                                                  .alldashboardData
                                                                  .value
                                                                  .data!
                                                                  .userInfo!
                                                                  .contactName
                                                                  .toString(),
                                                          resellerPhone:
                                                              dashboardController
                                                                  .alldashboardData
                                                                  .value
                                                                  .data!
                                                                  .userInfo!
                                                                  .phone
                                                                  .toString(),
                                                          companyLogo: data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 60,
                                                width: screenWidth,
                                                decoration: BoxDecoration(
                                                  // border: Border.all(
                                                  //   width: 1,
                                                  //   color: Colors.grey,
                                                  // ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors
                                                      .listbuilderboxColor,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    5.0,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: CachedNetworkImageProvider(
                                                              data
                                                                  .bundle!
                                                                  .service!
                                                                  .company!
                                                                  .companyLogo
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 5,
                                                              ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  data
                                                                      .bundle!
                                                                      .bundleTitle
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                data.rechargebleAccount
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              NumberFormat.currency(
                                                                locale: 'en_US',
                                                                symbol: '',
                                                                decimalDigits:
                                                                    2,
                                                              ).format(
                                                                double.parse(
                                                                  data
                                                                      .bundle!
                                                                      .sellingPrice
                                                                      .toString(),
                                                                ),
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              " " +
                                                                  box.read(
                                                                    "currency_code",
                                                                  ),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 11,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              // Icon(
                                                              //   Icons.check,
                                                              //   color: Colors.green,
                                                              //   size: 14,
                                                              // ),
                                                              Text(
                                                                data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? languageController.tr(
                                                                        "PENDING",
                                                                      )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? languageController.tr(
                                                                        "CONFIRMED",
                                                                      )
                                                                    : languageController.tr(
                                                                        "REJECTED",
                                                                      ),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              // Text(
                                                              //   "2 days ago",
                                                              //   style: TextStyle(
                                                              //     color: Colors.green,
                                                              //     fontSize: 10,
                                                              //     fontWeight:
                                                              //         FontWeight.w600,
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
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
                                    )
                                  : historyController.finalList.isEmpty
                                  ? SizedBox()
                                  : RefreshIndicator(
                                      onRefresh: refresh,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 13,
                                        ),
                                        child: ListView.separated(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: false,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          controller: scrollController,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 5);
                                          },
                                          itemCount: historyController
                                              .finalList
                                              .length,
                                          itemBuilder: (context, index) {
                                            final data = historyController
                                                .finalList[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetailsScreen(
                                                          createDate: data
                                                              .createdAt
                                                              .toString(),
                                                          status: data.status
                                                              .toString(),
                                                          rejectReason: data
                                                              .rejectReason
                                                              .toString(),
                                                          companyName: data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyName
                                                              .toString(),
                                                          bundleTitle: data
                                                              .bundle!
                                                              .bundleTitle!
                                                              .toString(),
                                                          rechargebleAccount: data
                                                              .rechargebleAccount!
                                                              .toString(),
                                                          validityType: data
                                                              .bundle!
                                                              .validityType!
                                                              .toString(),
                                                          sellingPrice: data
                                                              .bundle!
                                                              .sellingPrice
                                                              .toString(),
                                                          orderID: data.id!
                                                              .toString(),
                                                          resellerName:
                                                              dashboardController
                                                                  .alldashboardData
                                                                  .value
                                                                  .data!
                                                                  .userInfo!
                                                                  .contactName
                                                                  .toString(),
                                                          resellerPhone:
                                                              dashboardController
                                                                  .alldashboardData
                                                                  .value
                                                                  .data!
                                                                  .userInfo!
                                                                  .phone
                                                                  .toString(),
                                                          companyLogo: data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 60,
                                                width: screenWidth,
                                                decoration: BoxDecoration(
                                                  // border: Border.all(
                                                  //   width: 1,
                                                  //   color: Colors.grey,
                                                  // ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors
                                                      .listbuilderboxColor,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    5.0,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: CachedNetworkImageProvider(
                                                              data
                                                                  .bundle!
                                                                  .service!
                                                                  .company!
                                                                  .companyLogo
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 5,
                                                              ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  data
                                                                      .bundle!
                                                                      .bundleTitle
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                data.rechargebleAccount
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              NumberFormat.currency(
                                                                locale: 'en_US',
                                                                symbol: '',
                                                                decimalDigits:
                                                                    2,
                                                              ).format(
                                                                double.parse(
                                                                  data
                                                                      .bundle!
                                                                      .sellingPrice
                                                                      .toString(),
                                                                ),
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              " " +
                                                                  box.read(
                                                                    "currency_code",
                                                                  ),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 11,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              // Icon(
                                                              //   Icons.check,
                                                              //   color: Colors.green,
                                                              //   size: 14,
                                                              // ),
                                                              Text(
                                                                data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? languageController.tr(
                                                                        "PENDING",
                                                                      )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? languageController.tr(
                                                                        "CONFIRMED",
                                                                      )
                                                                    : languageController.tr(
                                                                        "REJECTED",
                                                                      ),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),

                                                              // Text(
                                                              //   "2 days ago",
                                                              //   style: TextStyle(
                                                              //     color: Colors.green,
                                                              //     fontSize: 10,
                                                              //     fontWeight:
                                                              //         FontWeight.w600,
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
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
                                    ),
                            ),
                          ),

                          Obx(
                            () => historyController.isLoading.value == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.defaultColor,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ),
                          // SizedBox(
                          //   height: 22,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
