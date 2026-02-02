import 'package:lottie/lottie.dart';
import 'package:arzan_digital/routes/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:arzan_digital/controllers/bundles_controller.dart';
import 'package:arzan_digital/controllers/place_order_controller.dart';
import 'package:arzan_digital/controllers/language_controller.dart';
import 'package:arzan_digital/controllers/place_order_controller.dart';
import 'package:arzan_digital/controllers/service_controller.dart';
import 'package:arzan_digital/helpers/price.dart';
import 'package:arzan_digital/screens/confirm_pin.dart';
import 'package:arzan_digital/widgets/auth_textfield.dart';
import 'package:arzan_digital/widgets/default_button.dart';
import 'package:arzan_digital/widgets/rechange_number_box.dart';

import '../controllers/country_list_controller.dart';
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
  PlaceOrderController placeOrderController = Get.put(PlaceOrderController());
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
        placeOrderController.numberController.clear();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.defaultColor,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              placeOrderController.numberController.clear();
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
                  height: 50,
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
                        controller: placeOrderController.numberController,

                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: languageController.tr("ENTER_ID_OR_NUMBER"),

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
                                            if (placeOrderController
                                                .numberController
                                                .text
                                                .isEmpty) {
                                              Fluttertoast.showToast(
                                                msg: languageController.tr(
                                                  "ENTER_ID_OR_NUMBER",
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
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.all(0),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            17,
                                                          ),
                                                    ),
                                                    content: SocialdialogBox(
                                                      companyname: data
                                                          .service!
                                                          .company!
                                                          .companyName
                                                          .toString(),
                                                      title: data.bundleTitle,
                                                      validity:
                                                          data.validityType,
                                                      buyingprice:
                                                          data.buyingPrice,
                                                      sellingprice:
                                                          data.sellingPrice,
                                                      imagelink: data
                                                          .service!
                                                          .company!
                                                          .companyLogo
                                                          .toString(),
                                                    ),
                                                  );
                                                },
                                              );
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
                                            if (placeOrderController
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
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.all(0),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            17,
                                                          ),
                                                    ),
                                                    content: SocialdialogBox(
                                                      companyname: data
                                                          .service!
                                                          .company!
                                                          .companyName
                                                          .toString(),
                                                      title: data.bundleTitle,
                                                      validity:
                                                          data.validityType,
                                                      buyingprice:
                                                          data.buyingPrice,
                                                      sellingprice:
                                                          data.sellingPrice,
                                                      imagelink: data
                                                          .service!
                                                          .company!
                                                          .companyLogo
                                                          .toString(),
                                                    ),
                                                  );
                                                },
                                              );
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

class SocialdialogBox extends StatefulWidget {
  SocialdialogBox({
    super.key,
    this.title,
    this.validity,
    this.buyingprice,
    this.sellingprice,
    this.imagelink,
    this.companyname,
  });

  String? companyname;
  String? title;
  String? validity;
  String? buyingprice;
  String? sellingprice;
  String? imagelink;

  @override
  State<SocialdialogBox> createState() => _SocialdialogBoxState();
}

class _SocialdialogBoxState extends State<SocialdialogBox> {
  String selectedCode = "+93";

  final countrylistController = Get.find<CountryListController>();

  PlaceOrderController placeOrderController = Get.put(PlaceOrderController());

  final box = GetStorage();

  final FocusNode _focusNode = FocusNode();

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 520,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Obx(
        () => placeOrderController.isLoading.value == false
            ? ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.defaultColor,

                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff1890FF).withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Company Logo
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Image.network(
                                widget.imagelink.toString(),
                                height: 60,
                              ),
                            ),
                            SizedBox(height: 8),

                            // Company Name
                            Text(
                              widget.companyname.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 5),

                            // Bundle Title
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    languagesController.tr("BUNDLE_TITLE"),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    widget.title.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),

                            // Pricing Info
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Color(0xff1890FF),
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        languagesController.tr("BUY"),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        widget.buyingprice.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        box.read("currency_code"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 5,
                                    color: Colors.grey.shade200,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.sell_outlined,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        languagesController.tr("SALE"),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        widget.sellingprice.toString(),
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        box.read("currency_code"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // ID Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_android,
                              color: Color(0xff1890FF),
                              size: 22,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller:
                                    placeOrderController.numberController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: languagesController.tr("ENTER_ID"),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    // PIN Input
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 50,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1.5,
                            color: Colors.grey.shade200,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              maxLength: 4,
                              controller: placeOrderController.pinController,
                              keyboardType: TextInputType.phone,
                              textAlign: TextAlign.center,
                              obscureText: true,
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: languagesController.tr("PIN"),
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () {
                              if (placeOrderController
                                  .numberController
                                  .text
                                  .isEmpty) {
                                Fluttertoast.showToast(
                                  msg: languagesController.tr("ENTER_ID"),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }

                              if (placeOrderController
                                  .pinController
                                  .text
                                  .isEmpty) {
                                Fluttertoast.showToast(
                                  msg: languagesController.tr("ENTER_YOUR_PIN"),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }

                              print("ready for recharge...");
                              placeOrderController.placeOrder(context);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    languagesController.tr("CONFIRMATION"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.grey.shade700,
                                    size: 20,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    languagesController.tr("CANCEL"),
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Center(
                child: Container(
                  height: 250,
                  width: 250,
                  child: Lottie.asset('assets/loties/recharge.json'),
                ),
              ),
      ),
    );
  }
}
