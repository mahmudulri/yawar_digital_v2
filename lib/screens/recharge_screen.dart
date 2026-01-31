import 'package:yawar_digital/routes/routes.dart';
import 'package:yawar_digital/widgets/number_textfield.dart';
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
import 'package:yawar_digital/controllers/language_controller.dart';
import 'package:yawar_digital/controllers/place_order_controller.dart';
import 'package:yawar_digital/controllers/service_controller.dart';
import 'package:yawar_digital/helpers/price.dart';
import 'package:yawar_digital/screens/confirm_pin.dart';
import 'package:yawar_digital/widgets/auth_textfield.dart';
import 'package:yawar_digital/widgets/default_button.dart';
import 'package:yawar_digital/widgets/rechange_number_box.dart';

import '../controllers/confirm_pin_controller.dart';
import '../controllers/operator_controller.dart';
import '../global_controller/languages_controller.dart';
import '../utils/colors.dart';

class RechargeScreen extends StatefulWidget {
  RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  int selectedIndex = -1;
  int duration_selectedIndex = 0;

  final languageController = Get.find<LanguagesController>();

  List<Map<String, String>> duration = [];
  void initializeDuration() {
    duration = [
      {"Name": languageController.tr("ALL"), "Value": ""},
      {"Name": languageController.tr("UNLIMITED"), "Value": "unlimited"},
      {"Name": languageController.tr("MONTHLY"), "Value": "monthly"},
      {"Name": languageController.tr("WEEKLY"), "Value": "weekly"},
      {"Name": languageController.tr("DAILY"), "Value": "daily"},
      {"Name": languageController.tr("HOURLY"), "Value": "hourly"},
      {"Name": languageController.tr("NIGHTLY"), "Value": "nightly"},
    ];
  }

  final serviceController = Get.find<ServiceController>();

  final bundleController = Get.find<BundleController>();
  final box = GetStorage();
  final confirmPinController = Get.find<ConfirmPinController>();

  TextEditingController searchController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  String search = "";
  String inputNumber = "";

  // @override
  // void initState() {
  //   serviceController.fetchservices();
  //   bundleController.fetchbundles();
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();
    serviceController.fetchservices();
    bundleController.fetchallbundles();
    confirmPinController.numberController.addListener(_onTextChanged);
    initializeDuration();
    scrollController.addListener(refresh);
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void _onTextChanged() {
    if (!mounted) return;

    setState(() {
      inputNumber = confirmPinController.numberController.text;

      // Print debug information
      print("Input Number: $inputNumber");

      if (inputNumber.isEmpty) {
        box.write("company_id", "");
        bundleController.initialpage = 1;
        bundleController.finalList.clear();
        bundleController.fetchallbundles();
        // Handle case where text field is cleared
        print("Text field is empty. Showing all services.");

        // Clear the company_id from the box

        // Reset bundleController and fetch all bundles
      } else if (inputNumber.length == 3 || inputNumber.length == 4) {
        final services = serviceController.allserviceslist.value.data!.services;

        // Print number of services for debugging
        print("Number of services: ${services.length}");

        bool matchFound = false;

        for (var service in services) {
          for (var code in service.company!.companycodes!) {
            // Print reservedDigit for debugging
            print("Checking reservedDigit: ${code.reservedDigit}");

            if (code.reservedDigit == inputNumber) {
              box.write("company_id", service.companyId);
              bundleController.initialpage = 1;
              bundleController.finalList.clear();
              setState(() {
                bundleController.fetchallbundles();
              });

              print("Matched company_id: ${service.companyId}");
              matchFound = true;
              break; // Exit the inner loop
            }
          }
          if (matchFound) break; // Exit the outer loop
        }

        if (!matchFound) {
          print("No match found for input number: $inputNumber");
        }
      }
    });
  }

  @override
  void dispose() {
    confirmPinController.numberController.removeListener(_onTextChanged);

    super.dispose();
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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        confirmPinController.numberController.clear();
        return true;
      },
      child: SafeArea(
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
            title: GestureDetector(
              onTap: () {
                print(box.read("maxlength"));
              },
              child: Text(
                languageController.tr("RECHARGE"),

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: Container(
            height: screenHeight,
            width: screenWidth,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.defaultColor),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: ListView(
                        children: [
                          CustomTextField(
                            confirmPinController:
                                confirmPinController.numberController,
                            // numberLength: widget.numberlength,
                            languageData: languageController.tr(
                              "ENTER_YOUR_NUMBER",
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 50,
                            color: Colors.transparent,
                            width: screenWidth,
                            child: Obx(() {
                              // Check if the allserviceslist is not null and contains data
                              final services =
                                  serviceController
                                      .allserviceslist
                                      .value
                                      .data
                                      ?.services ??
                                  [];

                              // Show all services if input is empty, otherwise filter
                              final filteredServices = inputNumber.isEmpty
                                  ? services
                                  : services.where((service) {
                                      return service.company?.companycodes?.any(
                                            (code) {
                                              final reservedDigit =
                                                  code.reservedDigit ?? '';
                                              return inputNumber.startsWith(
                                                reservedDigit,
                                              );
                                            },
                                          ) ??
                                          false;
                                    }).toList();

                              return serviceController.isLoading.value == false
                                  ? Center(
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(width: 5);
                                        },
                                        scrollDirection: Axis.horizontal,
                                        itemCount: filteredServices.length,
                                        itemBuilder: (context, index) {
                                          final data = filteredServices[index];

                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                bundleController.initialpage =
                                                    1;
                                                bundleController.finalList
                                                    .clear();
                                                selectedIndex = index;
                                                box.write(
                                                  "company_id",
                                                  data.companyId,
                                                );
                                                bundleController
                                                    .fetchallbundles();
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                color: selectedIndex == index
                                                    ? Color(0xff34495e)
                                                    : Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                  vertical: 5,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      data
                                                          .company
                                                          ?.companyLogo ??
                                                      '',
                                                  placeholder: (context, url) {
                                                    print(
                                                      'Loading image: $url',
                                                    );
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                            color: Colors.white,
                                                          ),
                                                    );
                                                  },
                                                  errorWidget:
                                                      (context, url, error) {
                                                        print(
                                                          'Error loading image: $url, error: $error',
                                                        );
                                                        return Icon(
                                                          Icons.error,
                                                        );
                                                      },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.grey,
                                        strokeWidth: 1.0,
                                      ),
                                    );
                            }),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: duration.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      duration_selectedIndex = index;
                                      box.write(
                                        "validity_type",
                                        duration[index]["Value"],
                                      );
                                      bundleController.initialpage = 1;
                                      bundleController.finalList.clear();
                                      bundleController.fetchallbundles();
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(),
                                    height: 30,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          duration[index]["Name"]!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                duration_selectedIndex == index
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            height: 50,
                            width: screenWidth,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
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
                          SizedBox(height: 5),
                          Obx(
                            () => bundleController.isLoading.value == false
                                ? Container(
                                    child:
                                        bundleController
                                            .allbundleslist
                                            .value
                                            .data!
                                            .bundles!
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
                          Expanded(
                            child: Obx(
                              () =>
                                  bundleController.isLoading.value == false &&
                                      bundleController.finalList.isNotEmpty
                                  ? RefreshIndicator(
                                      onRefresh: refresh,
                                      child: ListView.separated(
                                        shrinkWrap: false,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        controller: scrollController,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 5);
                                        },
                                        itemCount:
                                            bundleController.finalList.length,
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
                                                  msg: "Enter Number ",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              } else {
                                                if (box.read("permission") ==
                                                        "no" ||
                                                    confirmPinController
                                                            .numberController
                                                            .text
                                                            .length
                                                            .toString() !=
                                                        box
                                                            .read("maxlength")
                                                            .toString()) {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Enter Correct Number ",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                  // Stop further execution if permission is "no"
                                                } else {
                                                  box.write(
                                                    "bundleID",
                                                    data.id.toString(),
                                                  );

                                                  Get.toNamed(confirmpinscreen);
                                                }
                                              }
                                            },
                                            child: Container(
                                              width: screenWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors
                                                    .listbuilderboxColor,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  5.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image:
                                                              CachedNetworkImageProvider(
                                                                (data
                                                                    .service!
                                                                    .company!
                                                                    .companyLogo
                                                                    .toString()),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              left: 20,
                                                              right: 10,
                                                            ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              data.bundleTitle
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12,
                                                              ),
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
                                                                  ? languageController
                                                                        .tr(
                                                                          "WEEKLY",
                                                                        )
                                                                  : data.validityType
                                                                            .toString() ==
                                                                        "daily"
                                                                  ? languageController
                                                                        .tr(
                                                                          "DAILY",
                                                                        )
                                                                  : data.validityType
                                                                            .toString() ==
                                                                        "hourly"
                                                                  ? languageController
                                                                        .tr(
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
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 2),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                languageController
                                                                    .tr("SELL"),

                                                                style: TextStyle(
                                                                  fontSize: 8,
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
                                                                  fontSize: 11,
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
                                                    Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                languageController
                                                                    .tr("BUY"),

                                                                style: TextStyle(
                                                                  fontSize: 8,
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
                                                                    data.buyingPrice
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              Text(
                                                                " ${box.read("currency_code")}",
                                                                style: TextStyle(
                                                                  fontSize: 10,
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
                                                  ],
                                                ),
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
                                      child: ListView.separated(
                                        shrinkWrap: false,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        controller: scrollController,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 5);
                                        },
                                        itemCount:
                                            bundleController.finalList.length,
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
                                                  msg: "Enter Number ",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              } else {
                                                if (box.read("permission") ==
                                                        "no" ||
                                                    confirmPinController
                                                            .numberController
                                                            .text
                                                            .length
                                                            .toString() !=
                                                        box
                                                            .read("maxlength")
                                                            .toString()) {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Enter Correct Number ",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                  // Stop further execution if permission is "no"
                                                } else {
                                                  box.write(
                                                    "bundleID",
                                                    data.id.toString(),
                                                  );

                                                  Get.toNamed(confirmpinscreen);
                                                }
                                              }
                                            },
                                            child: Container(
                                              width: screenWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors
                                                    .listbuilderboxColor,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  5.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image:
                                                              CachedNetworkImageProvider(
                                                                (data
                                                                    .service!
                                                                    .company!
                                                                    .companyLogo
                                                                    .toString()),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              left: 20,
                                                              right: 10,
                                                            ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              data.bundleTitle
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12,
                                                              ),
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
                                                                  ? languageController
                                                                        .tr(
                                                                          "WEEKLY",
                                                                        )
                                                                  : data.validityType
                                                                            .toString() ==
                                                                        "daily"
                                                                  ? languageController
                                                                        .tr(
                                                                          "DAILY",
                                                                        )
                                                                  : data.validityType
                                                                            .toString() ==
                                                                        "hourly"
                                                                  ? languageController
                                                                        .tr(
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
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 2),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                languageController
                                                                    .tr("SELL"),

                                                                style: TextStyle(
                                                                  fontSize: 8,
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
                                                                  fontSize: 11,
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
                                                    Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                languageController
                                                                    .tr("BUY"),

                                                                style: TextStyle(
                                                                  fontSize: 8,
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
                                                                    data.buyingPrice
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              Text(
                                                                " ${box.read("currency_code")}",
                                                                style: TextStyle(
                                                                  fontSize: 10,
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
      ),
    );
  }
}
