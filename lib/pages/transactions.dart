import 'package:arzan_digital/widgets/custom_text.dart';
import 'package:arzan_digital/widgets/default_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:arzan_digital/controllers/language_controller.dart';
import 'package:arzan_digital/utils/colors.dart';

import '../controllers/transaction_controller.dart';
import '../global_controller/languages_controller.dart';

class TransactionsPage extends StatefulWidget {
  TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final box = GetStorage();

  final TextEditingController dateController = TextEditingController();

  final languageController = Get.find<LanguagesController>();

  final transactionController = Get.find<TransactionController>();

  final RxString selectedOrderStatus = "".obs;

  final List<Map<String, String>> orderStatus = [
    {"titleKey": "CREDIT", "value": "credit"},
    {"titleKey": "DEBIT", "value": "debit"},
  ];

  final RxString selectedCategoryType = "".obs;

  final List<Map<String, String>> categoryType = [
    {"titleKey": "ADMIN_TO_RESELLER", "value": "admin-reseller"},
    {"titleKey": "RESELLER_TO_ADMIN", "value": "reseller-subreseller"},
  ];
  final RxString selectedPurposeType = "".obs;
  final List<Map<String, String>> purposeType = [
    {"titleKey": "ORDER", "value": "order"},
    {"titleKey": "MONEY_TRANSFER", "value": "money"},
  ];
  bool isFilterOpen = false;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  Future<void> pickStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      startDate.value = picked;
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      print("Selected Start Date: $formattedDate");
      box.write("startdate", "&filter_startdate=$formattedDate");

      // Reset end date if it's before start date
      if (endDate.value != null && endDate.value!.isBefore(picked)) {
        endDate.value = null;
      }
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    if (startDate.value == null) {
      Get.snackbar(
        languageController.tr("WARNING"),
        languageController.tr("SELECT_START_DATE_FIRST"),
      );
      return;
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.value!,
      firstDate: startDate.value!, // 👈 important
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      endDate.value = picked;
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      print("Selected Start Date: $formattedDate");
      box.write("enddate", "&filter_enddate=$formattedDate");
    }
  }

  String defaultValue = "";

  String secondDropDown = "";

  @override
  void initState() {
    super.initState();
    box.write("transactiontype", "");
    box.write("category", "");
    box.write("purpose", "");
    box.write("startdate", "");
    box.write("enddate", "");
    transactionController.fetchTransactionData();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white10,

        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.backgroundColor,
          centerTitle: true,
          title: Text(
            languageController.tr("TRANSACTIONS"),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        body: Container(
          color: AppColors.backgroundColor,
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 50,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: AppColors.defaultColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.white),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            languageController.tr("FILTER_TRANSACTION"),
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFilterOpen = !isFilterOpen;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                isFilterOpen
                                    ? FontAwesomeIcons.chevronUp
                                    : FontAwesomeIcons.chevronDown,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isFilterOpen,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,

                    width: screenWidth,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: isFilterOpen
                        ? Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                child: Column(
                                  children: [
                                    //............................Type............//
                                    Row(
                                      children: [
                                        Text(
                                          languageController.tr("TYPE"),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: Obx(
                                            () => DropdownButton<String>(
                                              value:
                                                  selectedOrderStatus
                                                      .value
                                                      .isEmpty
                                                  ? null
                                                  : selectedOrderStatus.value,
                                              isExpanded: true,
                                              hint: KText(
                                                text: languageController.tr(
                                                  "ALL",
                                                ),
                                                fontSize: screenWidth * 0.040,
                                              ),
                                              items: [
                                                // ALL option
                                                DropdownMenuItem<String>(
                                                  value: "",
                                                  child: KText(
                                                    text: languageController.tr(
                                                      "ALL",
                                                    ),
                                                    fontSize:
                                                        screenWidth * 0.040,
                                                  ),
                                                ),

                                                // Order status options
                                                ...orderStatus.map<
                                                  DropdownMenuItem<String>
                                                >((data) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: data['value'],
                                                    child: KText(
                                                      text: languageController
                                                          .tr(
                                                            data['titleKey']!,
                                                          ),
                                                      fontSize:
                                                          screenWidth * 0.040,
                                                    ),
                                                  );
                                                }).toList(),
                                              ],
                                              onChanged: (value) {
                                                selectedOrderStatus.value =
                                                    value ?? "";

                                                print(value.toString());
                                                box.write(
                                                  "transactiontype",
                                                  "&filter_transactiontype=$value",
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    //............................Category............//
                                    Row(
                                      children: [
                                        Text(
                                          languageController.tr(
                                            "SELECT_CATEGORY",
                                          ),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: Obx(
                                            () => DropdownButton<String>(
                                              value:
                                                  selectedCategoryType
                                                      .value
                                                      .isEmpty
                                                  ? null
                                                  : selectedCategoryType.value,
                                              isExpanded: true,
                                              hint: KText(
                                                text: languageController.tr(
                                                  "ALL",
                                                ),
                                                fontSize: screenWidth * 0.040,
                                              ),
                                              items: [
                                                // ALL
                                                DropdownMenuItem<String>(
                                                  value: "",
                                                  child: KText(
                                                    text: languageController.tr(
                                                      "ALL",
                                                    ),
                                                    fontSize:
                                                        screenWidth * 0.040,
                                                  ),
                                                ),

                                                // Category Type items
                                                ...categoryType.map<
                                                  DropdownMenuItem<String>
                                                >((data) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: data['value'],
                                                    child: KText(
                                                      text: languageController
                                                          .tr(
                                                            data['titleKey']!,
                                                          ),
                                                      fontSize:
                                                          screenWidth * 0.040,
                                                    ),
                                                  );
                                                }).toList(),
                                              ],
                                              onChanged: (value) {
                                                selectedCategoryType.value =
                                                    value ?? "";
                                                print(value.toString());
                                                box.write(
                                                  "category",
                                                  "&filter_transactioncategory=$value",
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    //............................Purpose............//
                                    Row(
                                      children: [
                                        Text(
                                          languageController.tr(
                                            "SELECT_PURPOSE",
                                          ),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: Obx(
                                            () => DropdownButton<String>(
                                              value:
                                                  selectedPurposeType
                                                      .value
                                                      .isEmpty
                                                  ? null
                                                  : selectedPurposeType.value,
                                              isExpanded: true,
                                              hint: KText(
                                                text: languageController.tr(
                                                  "ALL",
                                                ),
                                                fontSize: screenWidth * 0.040,
                                              ),
                                              items: [
                                                // ALL
                                                DropdownMenuItem<String>(
                                                  value: "",
                                                  child: KText(
                                                    text: languageController.tr(
                                                      "ALL",
                                                    ),
                                                    fontSize:
                                                        screenWidth * 0.040,
                                                  ),
                                                ),

                                                // Purpose Type options
                                                ...purposeType.map<
                                                  DropdownMenuItem<String>
                                                >((data) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: data['value'],
                                                    child: KText(
                                                      text: languageController
                                                          .tr(
                                                            data['titleKey']!,
                                                          ),
                                                      fontSize:
                                                          screenWidth * 0.040,
                                                    ),
                                                  );
                                                }).toList(),
                                              ],
                                              onChanged: (value) {
                                                selectedPurposeType.value =
                                                    value ?? "";

                                                print(value.toString());
                                                box.write(
                                                  "purpose",
                                                  "&filter_transactionpurpose=$value",
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        /// START DATE
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              // open start date picker
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Obx(
                                                      () => KText(
                                                        text:
                                                            startDate.value ==
                                                                null
                                                            ? languageController
                                                                  .tr(
                                                                    "START_DATE",
                                                                  )
                                                            : DateFormat(
                                                                'yyyy/MM/dd',
                                                              ).format(
                                                                startDate
                                                                    .value!,
                                                              ),

                                                        fontSize:
                                                            screenWidth * 0.040,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          pickStartDate(
                                                            context,
                                                          ),

                                                      child: Icon(
                                                        Icons.calendar_month,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        /// END DATE
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              // open end date picker
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Obx(
                                                      () => KText(
                                                        text:
                                                            endDate.value ==
                                                                null
                                                            ? languageController
                                                                  .tr(
                                                                    "END_DATE",
                                                                  )
                                                            : DateFormat(
                                                                'yyyy/MM/dd',
                                                              ).format(
                                                                endDate.value!,
                                                              ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          pickEndDate(context),
                                                      child: Icon(
                                                        Icons.calendar_month,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    // Container(
                                    //   height: 50,
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(
                                    //       8,
                                    //     ),
                                    //     border: Border.all(
                                    //       width: 1,
                                    //       color: Colors.grey.shade300,
                                    //     ),
                                    //   ),
                                    //   child: Padding(
                                    //     padding: EdgeInsets.symmetric(
                                    //       horizontal: 10,
                                    //     ),
                                    //     child: Row(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment
                                    //               .spaceBetween,
                                    //       children: [
                                    //         Icon(
                                    //           Icons.search_sharp,
                                    //           color: Colors.grey,
                                    //           size: screenHeight * 0.040,
                                    //         ),
                                    //         SizedBox(width: 10),
                                    //         Expanded(
                                    //           child: Obx(
                                    //             () => TextField(
                                    //               decoration: InputDecoration(
                                    //                 hintText:
                                    //                     languageController.tr(
                                    //                       "SEARCH_BY_PHOENUMBER",
                                    //                     ),
                                    //                 border:
                                    //                     InputBorder.none,
                                    //                 hintStyle: TextStyle(
                                    //                   color: Colors.grey,
                                    //                   fontSize:
                                    //                       screenWidth *
                                    //                       0.040,
                                    //                   fontFamily:
                                    //                       box
                                    //                               .read(
                                    //                                 "language",
                                    //                               )
                                    //                               .toString() ==
                                    //                           "Fa"
                                    //                       ? Get.find<
                                    //                               FontController
                                    //                             >()
                                    //                             .currentFont
                                    //                       : null,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(height: 10),
                                    Obx(
                                      () => Container(
                                        height: 45,
                                        width: screenWidth,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: GestureDetector(
                                                onTap: () {
                                                  transactionController
                                                      .fetchTransactionData();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: KText(
                                                      text: languageController
                                                          .tr("APPLY_FILTER"),
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          screenWidth * 0.035,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              flex: 5,
                                              child: GestureDetector(
                                                onTap: () {
                                                  selectedOrderStatus.value =
                                                      "";
                                                  selectedCategoryType.value =
                                                      "";
                                                  selectedPurposeType.value =
                                                      "";
                                                  startDate.value = null;
                                                  endDate.value = null;
                                                  box.write(
                                                    "transactiontype",
                                                    "",
                                                  );
                                                  box.write("category", "");
                                                  box.write("purpose", "");
                                                  box.write("startdate", "");
                                                  box.write("enddate", "");
                                                  transactionController
                                                      .fetchTransactionData();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Color(0xffFF6A60),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: KText(
                                                      text: languageController
                                                          .tr("REMOVE_FILTER"),
                                                      color: Color(0xffFF6A60),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          screenWidth * 0.035,
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
                            ],
                          )
                        : SizedBox(),
                  ),
                ),
                SizedBox(height: 10),

                Obx(() {
                  if (transactionController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final transactions = transactionController
                      .alltransactionlist
                      .value
                      .data
                      ?.resellerBalanceTransactions;

                  if (transactions == null || transactions.isEmpty) {
                    return Center(
                      child: Text(
                        languageController.tr("NO_DATA_FOUND"),

                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  // If data exists but you don't want to show a list
                  return const SizedBox();
                }),

                SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      // color: Colors.cyan,
                      child: Obx(
                        () => transactionController.isLoading.value == false
                            ? ListView.separated(
                                padding: EdgeInsets.all(0),
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 5);
                                },
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: transactionController
                                    .alltransactionlist
                                    .value
                                    .data!
                                    .resellerBalanceTransactions!
                                    .length,
                                itemBuilder: (context, index) {
                                  final data = transactionController
                                      .alltransactionlist
                                      .value
                                      .data!
                                      .resellerBalanceTransactions![index];
                                  return Container(
                                    height: 120,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: data.status.toString() == "debit"
                                            ? Colors.red.withOpacity(0.4)
                                            : Colors.green.withOpacity(0.4),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  data.status.toString() ==
                                                      "debit"
                                                  ? Colors.red.withOpacity(0.12)
                                                  : Colors.green.withOpacity(
                                                      0.12,
                                                    ),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  KText(
                                                    text: data
                                                        .reseller!
                                                        .resellerName
                                                        .toString(),
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        screenHeight * 0.020,
                                                  ),
                                                  KText(
                                                    text:
                                                        DateFormat(
                                                          "dd-MM-yyyy",
                                                        ).format(
                                                          DateTime.parse(
                                                            data.createdAt
                                                                .toString(),
                                                          ),
                                                        ),
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        screenHeight * 0.020,
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
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(
                                                  10,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      KText(
                                                        text: languageController
                                                            .tr(
                                                              "TRANSACTION_TYPE",
                                                            ),
                                                        color: Colors
                                                            .grey
                                                            .shade700,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            screenHeight *
                                                            0.020,
                                                      ),
                                                      Obx(
                                                        () => Container(
                                                          decoration: BoxDecoration(
                                                            color:
                                                                data.status
                                                                        .toString() ==
                                                                    "debit"
                                                                ? Colors.red
                                                                      .withOpacity(
                                                                        0.12,
                                                                      )
                                                                : Colors.green
                                                                      .withOpacity(
                                                                        0.12,
                                                                      ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 6,
                                                                ),
                                                            child: KText(
                                                              text:
                                                                  data.status
                                                                          .toString() ==
                                                                      "debit"
                                                                  ? languageController
                                                                        .tr(
                                                                          "DEBIT",
                                                                        )
                                                                  : languageController
                                                                        .tr(
                                                                          "CREDIT",
                                                                        ),
                                                              color:
                                                                  data.status
                                                                          .toString() ==
                                                                      "debit"
                                                                  ? Colors.red
                                                                  : Colors
                                                                        .green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.020,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Obx(
                                                        () => KText(
                                                          text:
                                                              languageController
                                                                  .tr("AMOUNT"),
                                                          color: Colors
                                                              .grey
                                                              .shade700,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize:
                                                              screenHeight *
                                                              0.020,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          KText(
                                                            text:
                                                                NumberFormat.currency(
                                                                  locale:
                                                                      'en_US',
                                                                  symbol: '',
                                                                  decimalDigits:
                                                                      2,
                                                                ).format(
                                                                  double.parse(
                                                                    data.amount
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                            fontSize:
                                                                screenHeight *
                                                                0.015,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                data.status
                                                                        .toString() ==
                                                                    "debit"
                                                                ? Colors.black
                                                                : Colors.black,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            "${box.read("currency_code")} ",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.015,
                                                              color:
                                                                  data.status
                                                                          .toString() ==
                                                                      "debit"
                                                                  ? Colors.black
                                                                  : Colors
                                                                        .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
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
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Center(child: SizedBox()),
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
