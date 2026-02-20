import 'dart:async';

import 'package:arzan_digital/controllers/dashboard_controller.dart';
import 'package:arzan_digital/global_controller/languages_controller.dart';
import 'package:arzan_digital/helpers/localtime_helper.dart';
import 'package:arzan_digital/widgets/custom_text.dart';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';
import 'package:arzan_digital/controllers/order_list_controller.dart';
import 'package:arzan_digital/screens/order_details.dart';
import 'package:arzan_digital/utils/colors.dart';

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

    orderStatus = [
      {"title": languageController.tr("PENDING"), "value": "order_status=0"},
      {"title": languageController.tr("CONFIRMED"), "value": "order_status=1"},
      {"title": languageController.tr("REJECTED"), "value": "order_status=2"},
    ];
    box.write("date", "");
    box.write("orderstatus", "");
    box.write("search_target", "");
    orderlistController.finalList.clear();
    orderlistController.initialpage = 1;
    orderlistController.fetchOrderlistdata();

    scrollController.addListener(refresh);
  }

  final box = GetStorage();

  bool isvisible = false;

  String defaultValue = "";
  String secondDropDown = "";

  List orderStatus = [];

  String search = "";

  final RxString selectedDate = ''.obs;

  Timer? _debounce;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // default date
      firstDate: DateTime(2000), // earliest date
      lastDate: DateTime(2100), // latest date
    );

    if (picked != null) {
      // Format the selected date as yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      selectedDate.value = formattedDate;
      print(formattedDate); // Print to console
      box.write("date", "selected_date=" + formattedDate.toString());
      orderlistController.finalList.clear();
      orderlistController.initialpage = 1;
      orderlistController.fetchOrderlistdata();
    }
  }

  // String selectedStatus = "Select Status";

  TextEditingController searchController = TextEditingController();

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
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: AppColors.defaultColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                icon: Icon(
                                  FontAwesomeIcons.chevronDown,
                                  color: Colors.grey,
                                ),
                                isDense: true,
                                value: defaultValue,
                                isExpanded: true,
                                items: [
                                  DropdownMenuItem(
                                    value: "",
                                    child: KText(
                                      text: languageController.tr("ALL"),
                                      fontSize: screenWidth * 0.040,
                                    ),
                                  ),
                                  ...orderStatus.map<DropdownMenuItem<String>>((
                                    data,
                                  ) {
                                    return DropdownMenuItem(
                                      value: data['value'],
                                      child: KText(text: data['title']),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  box.write("orderstatus", value);
                                  orderlistController.finalList.clear();
                                  orderlistController.initialpage = 1;
                                  orderlistController.fetchOrderlistdata();
                                  print("selected Value $value");
                                  setState(() {
                                    defaultValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => KText(
                                    text: selectedDate.value == ""
                                        ? languageController.tr("DATE")
                                        : selectedDate.value.toString(),
                                    fontSize: screenWidth * 0.040,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.search_sharp,
                                  color: Colors.grey,
                                  size: screenHeight * 0.040,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Obx(
                                    () => TextField(
                                      keyboardType: TextInputType.phone,
                                      onChanged: (value) {
                                        // আগের timer থাকলে cancel
                                        if (_debounce?.isActive ?? false)
                                          _debounce!.cancel();

                                        _debounce = Timer(
                                          const Duration(seconds: 1),
                                          () {
                                            orderlistController.finalList
                                                .clear();
                                            orderlistController.initialpage = 1;

                                            box.write("search_target", value);

                                            orderlistController
                                                .fetchOrderlistdata();
                                            print(value);
                                          },
                                        );
                                      },
                                      decoration: InputDecoration(
                                        hintText: languageController.tr(
                                          "SEARCH_BY_PHOENUMBER",
                                        ),
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: screenWidth * 0.040,
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
                        //   height: 10,
                        // ),
                        // Container(
                        //   height: 45,
                        //   width: screenWidth,
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         flex: 5,
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             color: AppColors.primaryColor,
                        //             borderRadius: BorderRadius.circular(25),
                        //           ),
                        //           child: Center(
                        //             child: Obx(
                        //               () => Text(
                        //                 languagesController.tr("APPLY_FILTER"),
                        //                 style: TextStyle(
                        //                   color: Colors.white,
                        //                   fontWeight: FontWeight.w600,
                        //                   fontSize: 11,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         width: 10,
                        //       ),
                        //       Expanded(
                        //         flex: 4,
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             color: Colors.white,
                        //             border: Border.all(
                        //               width: 1,
                        //               color: Colors.red,
                        //             ),
                        //             borderRadius: BorderRadius.circular(25),
                        //           ),
                        //           child: Center(
                        //             child: Obx(
                        //               () => Text(
                        //                 languagesController.tr("REMOVE_FILTER"),
                        //                 style: TextStyle(
                        //                   color: Colors.red,
                        //                   fontWeight: FontWeight.w600,
                        //                   fontSize: 11,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
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
                                    decoration: BoxDecoration(),
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
