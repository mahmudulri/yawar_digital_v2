import 'package:yawar_digital/routes/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:yawar_digital/controllers/bundles_controller.dart';
import 'package:yawar_digital/controllers/confirm_pin_controller.dart';
import 'package:yawar_digital/controllers/language_controller.dart';
import 'package:yawar_digital/controllers/place_order_controller.dart';
import 'package:yawar_digital/controllers/service_controller.dart';
import 'package:yawar_digital/helpers/price.dart';
import 'package:yawar_digital/screens/confirm_pin.dart';
import 'package:yawar_digital/widgets/auth_textfield.dart';
import 'package:yawar_digital/widgets/default_button.dart';
import 'package:yawar_digital/widgets/rechange_number_box.dart';

import '../controllers/operator_controller.dart';
import '../global_controller/languages_controller.dart';
import '../utils/colors.dart';

class SocialRechargeScreen extends StatefulWidget {
  SocialRechargeScreen({super.key});

  @override
  State<SocialRechargeScreen> createState() => _SocialRechargeScreenState();
}

class _SocialRechargeScreenState extends State<SocialRechargeScreen> {
  int selectedIndex = -1;
  int duration_selectedIndex = -1;

  List<Map<String, String>> duration = [
    {"Name": "All", "Value": ""},
    {"Name": "Unllimited", "Value": "unlimited"},
    {"Name": "Monthly", "Value": "monthly"},
    {"Name": "Weekly", "Value": "weekly"},
    {"Name": "Daily", "Value": "daily"},
    {"Name": "Hourly", "Value": "hourly"},
    {"Name": "Nightly", "Value": "nightly"},
  ];

  final serviceController = Get.find<ServiceController>();
  final languageController = Get.find<LanguagesController>();
  final bundleController = Get.find<BundleController>();
  final confirmPinController = Get.find<ConfirmPinController>();
  final box = GetStorage();

  TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String search = "";
  String inputNumber = "";

  @override
  void initState() {
    super.initState();
    scrollController.addListener(refresh);
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchservices();
      bundleController.fetchallbundles();
    });
  }

  Future<void> refresh() async {
    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination!.totalPages ??
        0;
    final int currentPage = bundleController.initialpage;

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
      bundleController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (bundleController.initialpage <= totalPages) {
        print("Load More...................");
        bundleController.fetchallbundles();
      } else {
        bundleController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        confirmPinController.numberController.clear();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.defaultColor,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              confirmPinController.numberController.clear();
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          backgroundColor: AppColors.defaultColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            languageController.tr("RECHARGE"),

            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 45,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        maxLength: 200,
                        style: TextStyle(color: Colors.white),
                        controller: confirmPinController.numberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: languageController.tr("ENTER_YOUR_NUMBER"),

                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          height: 50,
                          width: screenWidth,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: TextField(
                              onChanged: (value) {
                                bundleController.finalList.clear();
                                bundleController.initialpage = 1;
                                box.write("search_tag", value.toString());
                                bundleController.fetchallbundles();
                                print(value.toString());
                              },
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    // bundleController.finalList.clear();
                                    // box.write("search_tag", "1.5");
                                    // bundleController.fetchallbundles();
                                  },
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                ),
                                border: InputBorder.none,
                                hintText: languageController.tr("SEARCH"),

                                hintStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Obx(
                        //   () => bundleController.isLoading.value == false
                        //       ? Container(
                        //           child: bundleController.allbundleslist
                        //                   .value.data!.bundles!.isNotEmpty
                        //               ? SizedBox()
                        //               : Center(
                        //                   child: Column(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.center,
                        //                     children: [
                        //                       Image.asset(
                        //                         "assets/icons/empty.png",
                        //                         height: 80,
                        //                       ),
                        //                       Text("No Data found"),
                        //                     ],
                        //                   ),
                        //                 ),
                        //         )
                        //       : SizedBox(),
                        // ),
                        Expanded(
                          child: Obx(
                            () =>
                                bundleController.isLoading.value == false &&
                                    bundleController.finalList.isNotEmpty
                                ? RefreshIndicator(
                                    onRefresh: refresh,
                                    child: GridView.builder(
                                      shrinkWrap: false,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      controller: scrollController,
                                      itemCount:
                                          bundleController.finalList.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 8.0,
                                            mainAxisSpacing: 7.0,
                                            childAspectRatio: 0.45,
                                          ),
                                      itemBuilder: (context, index) {
                                        final data =
                                            bundleController.finalList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            if (confirmPinController
                                                .numberController
                                                .text
                                                .isEmpty) {
                                              Fluttertoast.showToast(
                                                msg: languageController.tr(
                                                  "ENTER_YOUR_NUMBER",
                                                ),

                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            } else {
                                              box.write(
                                                "bundleID",
                                                data.id.toString(),
                                              );
                                              Get.toNamed(confirmpinscreen);
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                        0.2,
                                                      ), // Color of the shadow
                                                  spreadRadius:
                                                      2, // How much the shadow spreads
                                                  blurRadius:
                                                      5, // The blur radius of the shadow
                                                  offset: Offset(
                                                    0,
                                                    3,
                                                  ), // The offset of the shadow
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                            topRight:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Center(
                                                            child: Text(
                                                              data
                                                                  .service!
                                                                  .company!
                                                                  .companyName
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                image: CachedNetworkImageProvider(
                                                                  data
                                                                      .service!
                                                                      .company!
                                                                      .companyLogo
                                                                      .toString(),
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            // child: Image.asset(
                                                            //   "assets/images/pubg.png",
                                                            // ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                            bottomRight:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: 80,
                                                            width: 80,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                              image: DecorationImage(
                                                                image: CachedNetworkImageProvider(
                                                                  data
                                                                      .service!
                                                                      .company!
                                                                      .companyLogo
                                                                      .toString(),
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                data.bundleTitle
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              PriceTextView(
                                                                price: data
                                                                    .sellingPrice
                                                                    .toString(),
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                " ${box.read("currency_code")}",
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                data.validityType
                                                                            .toString() ==
                                                                        "unlimited"
                                                                    ? languageController.tr(
                                                                        "UNLIMITED",
                                                                      )
                                                                    : data.validityType
                                                                              .toString() ==
                                                                          "monthly"
                                                                    ? languageController.tr(
                                                                        "MONTHLY",
                                                                      )
                                                                    : data.validityType
                                                                              .toString() ==
                                                                          "weekly"
                                                                    ? languageController.tr(
                                                                        "WEEKLY",
                                                                      )
                                                                    : data.validityType
                                                                              .toString() ==
                                                                          "daily"
                                                                    ? languageController.tr(
                                                                        "DAILY",
                                                                      )
                                                                    : data.validityType
                                                                              .toString() ==
                                                                          "hourly"
                                                                    ? languageController.tr(
                                                                        "HOURLY",
                                                                      )
                                                                    : data.validityType
                                                                              .toString() ==
                                                                          "nightly"
                                                                    ? languageController.tr(
                                                                        "NIGHTLY",
                                                                      )
                                                                    : "",
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
                                                          SizedBox(height: 10),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    languageController
                                                                        .tr(
                                                                          "BUY",
                                                                        ),

                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          8,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SPriceTextView(
                                                                    price: data
                                                                        .buyingPrice
                                                                        .toString(),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 2,
                                                                  ),
                                                                  Text(
                                                                    " ${box.read("currency_code")}",
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          8,
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

                                                          // GestureDetector(
                                                          //   onTap: () {
                                                          //     showDialog(
                                                          //       context:
                                                          //           context,
                                                          //       builder:
                                                          //           (context) {
                                                          //         return AlertDialog(
                                                          //           content:
                                                          //               Container(
                                                          //             height:
                                                          //                 160,
                                                          //             width:
                                                          //                 screenWidth,
                                                          //             decoration:
                                                          //                 BoxDecoration(
                                                          //               color:
                                                          //                   Colors.white,
                                                          //             ),
                                                          //             child:
                                                          //                 Column(
                                                          //               children: [
                                                          //                 Text(
                                                          //                   languageController.alllanguageData.value.languageData!["BUNDLE_DETAILS"].toString(),
                                                          //                   style: TextStyle(
                                                          //                     fontSize: 17,
                                                          //                     fontWeight: FontWeight.w600,
                                                          //                   ),
                                                          //                 ),
                                                          //                 Divider(
                                                          //                   thickness: 1,
                                                          //                   color: Colors.grey,
                                                          //                 ),
                                                          //                 SizedBox(
                                                          //                   height: 20,
                                                          //                 ),
                                                          //                 Row(
                                                          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                   children: [
                                                          //                     Text(
                                                          //                       languageController.alllanguageData.value.languageData!["BUNDLE_TITLE"].toString(),
                                                          //                     ),
                                                          //                     Text("${data.bundleTitle}"),
                                                          //                   ],
                                                          //                 ),
                                                          //                 Row(
                                                          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                   children: [
                                                          //                     Text(
                                                          //                       languageController.alllanguageData.value.languageData!["VALIDITY"].toString(),
                                                          //                     ),
                                                          //                     Text("${data.validityType}"),
                                                          //                   ],
                                                          //                 ),
                                                          //                 Row(
                                                          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                   children: [
                                                          //                     Text(
                                                          //                       languageController.alllanguageData.value.languageData!["BUYING_PRICE"].toString(),
                                                          //                     ),
                                                          //                     Spacer(),
                                                          //                     Text(
                                                          //                       NumberFormat.currency(
                                                          //                         locale: 'en_US',
                                                          //                         symbol: '',
                                                          //                         decimalDigits: 2,
                                                          //                       ).format(
                                                          //                         double.parse(
                                                          //                           data.buyingPrice.toString(),
                                                          //                         ),
                                                          //                       ),
                                                          //                     ),
                                                          //                     Text(
                                                          //                       " ${box.read("currency_code")}",
                                                          //                       style: TextStyle(
                                                          //                         fontSize: 13,
                                                          //                         fontWeight: FontWeight.w500,
                                                          //                         color: Colors.black,
                                                          //                       ),
                                                          //                     ),
                                                          //                   ],
                                                          //                 ),
                                                          //               ],
                                                          //             ),
                                                          //           ),
                                                          //         );
                                                          //       },
                                                          //     );
                                                          //   },
                                                          //   child: Text(
                                                          //     languageController
                                                          //         .alllanguageData
                                                          //         .value
                                                          //         .languageData![
                                                          //             "VIEW_DETAILS"]
                                                          //         .toString(),
                                                          //     style:
                                                          //         TextStyle(
                                                          //       fontWeight:
                                                          //           FontWeight
                                                          //               .w600,
                                                          //       fontSize: 12,
                                                          //     ),
                                                          //   ),
                                                          // )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : bundleController.finalList.isEmpty
                                ? SizedBox()
                                : RefreshIndicator(
                                    onRefresh: refresh,
                                    child: GridView.builder(
                                      shrinkWrap: false,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      controller: scrollController,
                                      itemCount:
                                          bundleController.finalList.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 8.0,
                                            mainAxisSpacing: 7.0,
                                            childAspectRatio: 0.45,
                                          ),
                                      itemBuilder: (context, index) {
                                        final data =
                                            bundleController.finalList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            if (confirmPinController
                                                .numberController
                                                .text
                                                .isEmpty) {
                                              Fluttertoast.showToast(
                                                msg: languageController.tr(
                                                  "ENTER_YOUR_NUMBER",
                                                ),

                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            } else {
                                              box.write(
                                                "bundleID",
                                                data.id.toString(),
                                              );
                                              Get.toNamed(confirmpinscreen);
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                        0.2,
                                                      ), // Color of the shadow
                                                  spreadRadius:
                                                      2, // How much the shadow spreads
                                                  blurRadius:
                                                      5, // The blur radius of the shadow
                                                  offset: Offset(
                                                    0,
                                                    3,
                                                  ), // The offset of the shadow
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                            topRight:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Center(
                                                            child: Text(
                                                              data
                                                                  .service!
                                                                  .company!
                                                                  .companyName
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                image: CachedNetworkImageProvider(
                                                                  data
                                                                      .service!
                                                                      .company!
                                                                      .companyLogo
                                                                      .toString(),
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            // child: Image.asset(
                                                            //   "assets/images/pubg.png",
                                                            // ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                            bottomRight:
                                                                Radius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: 80,
                                                            width: 80,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                              image: DecorationImage(
                                                                image: CachedNetworkImageProvider(
                                                                  data
                                                                      .service!
                                                                      .company!
                                                                      .companyLogo
                                                                      .toString(),
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                data.bundleTitle
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              PriceTextView(
                                                                price: data
                                                                    .sellingPrice
                                                                    .toString(),
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                " ${box.read("currency_code")}",
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                data.validityType
                                                                            .toString() ==
                                                                        "unlimited"
                                                                    ? languageController.tr(
                                                                        "UNLIMITED",
                                                                      )
                                                                    : data.validityType
                                                                              .toString() ==
                                                                          "monthly"
                                                                    ? languageController.tr(
                                                                        "MONTHLY",
                                                                      )
                                                                    : data.validityType
                                                                              .toString() ==
                                                                          "weekly"
                                                                    ? languageController.tr(
                                                                        "WEEKLY",
                                                                      )
                                                                    : data.validityType
                                                                              .toString() ==
                                                                          "daily"
                                                                    ? languageController.tr(
                                                                        "DAILY",
                                                                      )
                                                                    : data.validityType
                                                                              .toString() ==
                                                                          "hourly"
                                                                    ? languageController.tr(
                                                                        "HOURLY",
                                                                      )
                                                                    : data.validityType
                                                                              .toString() ==
                                                                          "nightly"
                                                                    ? languageController.tr(
                                                                        "NIGHTLY",
                                                                      )
                                                                    : "",
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
                                                          SizedBox(height: 10),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    languageController
                                                                        .tr(
                                                                          "BUY",
                                                                        ),

                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          8,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SPriceTextView(
                                                                    price: data
                                                                        .buyingPrice
                                                                        .toString(),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 2,
                                                                  ),
                                                                  Text(
                                                                    " ${box.read("currency_code")}",
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          8,
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

                                                          // GestureDetector(
                                                          //   onTap: () {
                                                          //     showDialog(
                                                          //       context:
                                                          //           context,
                                                          //       builder:
                                                          //           (context) {
                                                          //         return AlertDialog(
                                                          //           content:
                                                          //               Container(
                                                          //             height:
                                                          //                 160,
                                                          //             width:
                                                          //                 screenWidth,
                                                          //             decoration:
                                                          //                 BoxDecoration(
                                                          //               color:
                                                          //                   Colors.white,
                                                          //             ),
                                                          //             child:
                                                          //                 Column(
                                                          //               children: [
                                                          //                 Text(
                                                          //                   languageController.alllanguageData.value.languageData!["BUNDLE_DETAILS"].toString(),
                                                          //                   style: TextStyle(
                                                          //                     fontSize: 17,
                                                          //                     fontWeight: FontWeight.w600,
                                                          //                   ),
                                                          //                 ),
                                                          //                 Divider(
                                                          //                   thickness: 1,
                                                          //                   color: Colors.grey,
                                                          //                 ),
                                                          //                 SizedBox(
                                                          //                   height: 20,
                                                          //                 ),
                                                          //                 Row(
                                                          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                   children: [
                                                          //                     Text(
                                                          //                       languageController.alllanguageData.value.languageData!["BUNDLE_TITLE"].toString(),
                                                          //                     ),
                                                          //                     Text("${data.bundleTitle}"),
                                                          //                   ],
                                                          //                 ),
                                                          //                 Row(
                                                          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                   children: [
                                                          //                     Text(
                                                          //                       languageController.alllanguageData.value.languageData!["VALIDITY"].toString(),
                                                          //                     ),
                                                          //                     Text("${data.validityType}"),
                                                          //                   ],
                                                          //                 ),
                                                          //                 Row(
                                                          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                   children: [
                                                          //                     Text(
                                                          //                       languageController.alllanguageData.value.languageData!["BUYING_PRICE"].toString(),
                                                          //                     ),
                                                          //                     Spacer(),
                                                          //                     Text(
                                                          //                       NumberFormat.currency(
                                                          //                         locale: 'en_US',
                                                          //                         symbol: '',
                                                          //                         decimalDigits: 2,
                                                          //                       ).format(
                                                          //                         double.parse(
                                                          //                           data.buyingPrice.toString(),
                                                          //                         ),
                                                          //                       ),
                                                          //                     ),
                                                          //                     Text(
                                                          //                       " ${box.read("currency_code")}",
                                                          //                       style: TextStyle(
                                                          //                         fontSize: 13,
                                                          //                         fontWeight: FontWeight.w500,
                                                          //                         color: Colors.black,
                                                          //                       ),
                                                          //                     ),
                                                          //                   ],
                                                          //                 ),
                                                          //               ],
                                                          //             ),
                                                          //           ),
                                                          //         );
                                                          //       },
                                                          //     );
                                                          //   },
                                                          //   child: Text(
                                                          //     languageController
                                                          //         .alllanguageData
                                                          //         .value
                                                          //         .languageData![
                                                          //             "VIEW_DETAILS"]
                                                          //         .toString(),
                                                          //     style:
                                                          //         TextStyle(
                                                          //       fontWeight:
                                                          //           FontWeight
                                                          //               .w600,
                                                          //       fontSize: 12,
                                                          //     ),
                                                          //   ),
                                                          // )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ),
                        Obx(
                          () => bundleController.isLoading.value == true
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: AppColors.defaultColor,
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ),
                      ],
                    ),
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
