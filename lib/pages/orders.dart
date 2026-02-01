import 'dart:async';

import 'package:yawar_digital/controllers/dashboard_controller.dart';
import 'package:yawar_digital/global_controller/languages_controller.dart';
import 'package:yawar_digital/helpers/localtime_helper.dart';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';
import 'package:yawar_digital/controllers/language_controller.dart';
import 'package:yawar_digital/controllers/order_list_controller.dart';
import 'package:yawar_digital/screens/order_details.dart';
import 'package:yawar_digital/utils/colors.dart';

import 'package:dotted_line/dotted_line.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    orderlistController.finalList.clear();
    orderlistController.initialpage = 1;

    orderlistController.fetchOrderlistdata();

    scrollController.addListener(refresh);
  }

  final box = GetStorage();

  bool isvisible = false;

  List orderStatus = [
    {"title": "Pending", "value": "order_status=0"},
    {"title": "Confirmed", "value": "order_status=1"},
    {"title": "Rejected", "value": "order_status=2"},
  ];
  String defaultValue = "";
  String secondDropDown = "";

  // String selectedStatus = "Select Status";

  TextEditingController searchController = TextEditingController();

  String search = "";

  Future<void> refresh() async {
    final int totalPages =
        orderlistController
            .allorderlist
            .value
            .payload
            ?.pagination!
            .totalPages ??
        0;
    final int currentPage = orderlistController.initialpage;

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
      orderlistController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (orderlistController.initialpage <= totalPages) {
        print("Load More...................");
        orderlistController.fetchOrderlistdata();
      } else {
        orderlistController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  final languageController = Get.find<LanguagesController>();
  final dashboardController = Get.find<DashboardController>();
  final orderlistController = Get.find<OrderlistController>();

  @override
  Widget build(BuildContext context) {
    // orderlistController.fetchOrderlistdata();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            print(orderlistController.initialpage);
            print(orderlistController.finalList.length);
          },
          child: Text(
            languageController.tr("ORDERS"),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: TextField(
                                onChanged: (String? value) {
                                  setState(() {
                                    search = value.toString();
                                  });
                                },
                                controller: searchController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: languageController.tr(
                                    "ENTER_YOUR_NUMBER",
                                  ),

                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          // Icon(
                          //   Icons.search,
                          //   color: Colors.grey,
                          //   size: 30,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isvisible = !isvisible;
                        print(isvisible);
                      });
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        // color: Color(0xff46558A),
                        color: AppColors.defaultColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Text(
                              languageController.tr("FILTER"),

                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              FontAwesomeIcons.filter,
                              color: Colors.white,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0),
              Visibility(
                visible: isvisible,
                child: Container(
                  height: 120,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //     width: 1,
                    //     color: Colors.grey), // color: Colors.black12,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(languageController.tr("ORDER_STATUS")),
                                Container(
                                  height: 40,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isDense: true,
                                        value: defaultValue,
                                        isExpanded: true,
                                        items: [
                                          DropdownMenuItem(
                                            value: "",
                                            child: Text(
                                              languageController.tr(
                                                "SELECT_STATUS",
                                              ),

                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          ...orderStatus
                                              .map<DropdownMenuItem<String>>((
                                                data,
                                              ) {
                                                return DropdownMenuItem(
                                                  value: data['value'],
                                                  child: Text(data['title']),
                                                );
                                              })
                                              .toList(),
                                        ],
                                        onChanged: (value) {
                                          box.write("orderstatus", value);
                                          // print(
                                          //     "selected Value $value");
                                          setState(() {
                                            defaultValue = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(languageController.tr("SELECTED_DATE")),
                                Container(
                                  height: 30,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            languageController.tr(
                                              "SELECTED_DATE",
                                            ),
                                          ),
                                        ),
                                        Icon(Icons.arrow_downward),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  orderlistController.initialpage = 1;
                                  orderlistController.finalList.clear();
                                  orderlistController.fetchOrderlistdata();
                                  print(box.read("orderstatus"));
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: AppColors.defaultColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Center(
                                      child: Text(
                                        languageController.tr("APPLY_FILTER"),

                                        style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  box.write("orderstatus", "");

                                  orderlistController.initialpage = 1;
                                  orderlistController.finalList.clear();

                                  orderlistController.fetchOrderlistdata();

                                  defaultValue = "";
                                  setState(() {
                                    isvisible = !isvisible;
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: AppColors.defaultColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Center(
                                      child: Text(
                                        languageController.tr("CLEAR_FILTER"),

                                        style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
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

              SizedBox(height: 5),

              Expanded(
                child: Obx(
                  () => orderlistController.isLoading.value == false
                      ? RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.builder(
                            shrinkWrap: false,
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            itemCount: orderlistController.finalList.length,
                            itemBuilder: (context, index) {
                              final data = orderlistController.finalList[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderDetailsScreen(
                                        createDate: data.createdAt.toString(),
                                        status: data.status.toString(),
                                        rejectReason: data.rejectReason
                                            .toString(),
                                        companyName: data
                                            .bundle!
                                            .service!
                                            .company!
                                            .companyName
                                            .toString(),
                                        bundleTitle: data.bundle!.bundleTitle!
                                            .toString(),
                                        rechargebleAccount: data
                                            .rechargebleAccount!
                                            .toString(),
                                        validityType: data.bundle!.validityType!
                                            .toString(),
                                        sellingPrice: data.bundle!.sellingPrice
                                            .toString(),
                                        orderID: data.id!.toString(),
                                        resellerName: dashboardController
                                            .alldashboardData
                                            .value
                                            .data!
                                            .userInfo!
                                            .contactName
                                            .toString(),
                                        resellerPhone: dashboardController
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
                                child: Card(
                                  child: Container(
                                    height: 200,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      // color: Colors.grey,
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.listbuilderboxColor,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                  ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Text(
                                                        DateFormat(
                                                          'dd MMM yyyy',
                                                        ).format(
                                                          DateTime.parse(
                                                            data.createdAt
                                                                .toString(),
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    languageController.tr(
                                                          "ORDER_ID",
                                                        ) +
                                                        " ",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    "#${data.id} ",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                  ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        languageController.tr(
                                                          "RECHARGEABLE_ACCOUNT",
                                                        ),

                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      // Icon(
                                                      //   Icons.check,
                                                      //   color: Colors.green,
                                                      // ),
                                                      Text(
                                                        data.status
                                                                    .toString() ==
                                                                "0"
                                                            ? languageController
                                                                  .tr("PENDING")
                                                            : data.status
                                                                      .toString() ==
                                                                  "1"
                                                            ? languageController
                                                                  .tr(
                                                                    "CONFIRMED",
                                                                  )
                                                            : languageController
                                                                  .tr(
                                                                    "REJECTED",
                                                                  ),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        data.rechargebleAccount
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(color: Colors.grey),
                                                  Container(
                                                    height: 52,
                                                    width: screenWidth,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  languageController
                                                                      .tr(
                                                                        "TITLE",
                                                                      ),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  data
                                                                      .bundle!
                                                                      .bundleTitle
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      languageController
                                                                          .tr(
                                                                            "SELL",
                                                                          ),

                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      box.read(
                                                                        "currency_code",
                                                                      ),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      NumberFormat.currency(
                                                                        locale:
                                                                            'en_US',
                                                                        symbol:
                                                                            '',
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
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  languageController
                                                                      .tr(
                                                                        "BUY",
                                                                      ),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      box.read(
                                                                        "currency_code",
                                                                      ),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      NumberFormat.currency(
                                                                        locale:
                                                                            'en_US',
                                                                        symbol:
                                                                            '',
                                                                        decimalDigits:
                                                                            2,
                                                                      ).format(
                                                                        double.parse(
                                                                          data
                                                                              .bundle!
                                                                              .buyingPrice
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        data
                                                            .bundle!
                                                            .validityType
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        convertToLocalTime(
                                                          data.createdAt
                                                              .toString(),
                                                        ),
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
                                ),
                              );
                            },
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.builder(
                            shrinkWrap: false,
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            itemCount: orderlistController.finalList.length,
                            itemBuilder: (context, index) {
                              final data = orderlistController.finalList[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderDetailsScreen(
                                        createDate: data.createdAt.toString(),
                                        status: data.status.toString(),
                                        rejectReason: data.rejectReason
                                            .toString(),
                                        companyName: data
                                            .bundle!
                                            .service!
                                            .company!
                                            .companyName
                                            .toString(),
                                        bundleTitle: data.bundle!.bundleTitle!
                                            .toString(),
                                        rechargebleAccount: data
                                            .rechargebleAccount!
                                            .toString(),
                                        validityType: data.bundle!.validityType!
                                            .toString(),
                                        sellingPrice: data.bundle!.sellingPrice
                                            .toString(),
                                        orderID: data.id!.toString(),
                                        resellerName: dashboardController
                                            .alldashboardData
                                            .value
                                            .data!
                                            .userInfo!
                                            .contactName
                                            .toString(),
                                        resellerPhone: dashboardController
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
                                child: Card(
                                  child: Container(
                                    height: 200,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      // color: Colors.grey,
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.listbuilderboxColor,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                  ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Text(
                                                        DateFormat(
                                                          'dd MMM yyyy',
                                                        ).format(
                                                          DateTime.parse(
                                                            data.createdAt
                                                                .toString(),
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    languageController.tr(
                                                          "ORDER_ID",
                                                        ) +
                                                        " ",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    "#${data.id} ",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                  ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        languageController.tr(
                                                          "RECHARGEABLE_ACCOUNT",
                                                        ),

                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      // Icon(
                                                      //   Icons.check,
                                                      //   color: Colors.green,
                                                      // ),
                                                      Text(
                                                        data.status
                                                                    .toString() ==
                                                                "0"
                                                            ? languageController
                                                                  .tr("PENDING")
                                                            : data.status
                                                                      .toString() ==
                                                                  "1"
                                                            ? languageController
                                                                  .tr(
                                                                    "CONFIRMED",
                                                                  )
                                                            : languageController
                                                                  .tr(
                                                                    "REJECTED",
                                                                  ),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        data.rechargebleAccount
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(color: Colors.grey),
                                                  Container(
                                                    height: 52,
                                                    width: screenWidth,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  languageController
                                                                      .tr(
                                                                        "TITLE",
                                                                      ),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  data
                                                                      .bundle!
                                                                      .bundleTitle
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      languageController
                                                                          .tr(
                                                                            "SELL",
                                                                          ),

                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      box.read(
                                                                        "currency_code",
                                                                      ),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      NumberFormat.currency(
                                                                        locale:
                                                                            'en_US',
                                                                        symbol:
                                                                            '',
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
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  languageController
                                                                      .tr(
                                                                        "BUY",
                                                                      ),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      box.read(
                                                                        "currency_code",
                                                                      ),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      NumberFormat.currency(
                                                                        locale:
                                                                            'en_US',
                                                                        symbol:
                                                                            '',
                                                                        decimalDigits:
                                                                            2,
                                                                      ).format(
                                                                        double.parse(
                                                                          data
                                                                              .bundle!
                                                                              .buyingPrice
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        data
                                                            .bundle!
                                                            .validityType
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        convertToLocalTime(
                                                          data.createdAt
                                                              .toString(),
                                                        ),
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
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),

              Obx(
                () => orderlistController.isLoading.value == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 5),
                          CircularProgressIndicator(
                            color: AppColors.defaultColor,
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
              SizedBox(height: 20),
              // SizedBox(
              //   height: 20,
              // ),
              // MyContainerList(
              //   itemCount: int.parse(
              //     orderlistController
              //         .allorderlist.value.payload!.pagination.totalPages
              //         .toString(),
              //   ),
              // ),
              // SizedBox(
              //   height: 25,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class dotline extends StatelessWidget {
  const dotline({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedLine(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: AppColors.defaultColor,
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.white,
      dashGapRadius: 0.0,
    );
  }
}

class MyContainerList extends StatefulWidget {
  final int itemCount;

  MyContainerList({required this.itemCount});

  @override
  _MyContainerListState createState() => _MyContainerListState();
}

class _MyContainerListState extends State<MyContainerList> {
  int selectedIndex = 0;
  final box = GetStorage();
  final OrderlistController orderlistController = Get.put(
    OrderlistController(),
  );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 40,
      width: screenWidth,
      decoration: BoxDecoration(
        // color: Colors.red,
      ),
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            int myindex = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  box.write("pageNo", "${myindex}");
                  print(box.read("pageNo"));
                  orderlistController.fetchOrderlistdata();
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 5),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: selectedIndex == index ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    myindex.toString(),
                    style: TextStyle(
                      color: selectedIndex == index
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
