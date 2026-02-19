import 'package:fluttertoast/fluttertoast.dart';
import 'package:arzan_digital/controllers/country_list_controller.dart';
import 'package:arzan_digital/controllers/custom_recharge_controller.dart';
import 'package:arzan_digital/controllers/dashboard_controller.dart';
import 'package:arzan_digital/controllers/language_controller.dart';
import 'package:arzan_digital/controllers/operator_controller.dart';
import 'package:arzan_digital/screens/custom_order_details.dart';
import 'package:arzan_digital/utils/colors.dart';
import 'package:arzan_digital/widgets/default_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../controllers/company_controller.dart';
import '../controllers/currency_controller.dart';
import '../controllers/custom_history_controller.dart';
import '../controllers/recharge_config_controller.dart';
import '../global_controller/conversation_controller.dart';
import '../global_controller/languages_controller.dart';
import '../helpers/language_helper.dart';

class CustomRechargeScreen extends StatefulWidget {
  CustomRechargeScreen({super.key});

  @override
  State<CustomRechargeScreen> createState() => _CustomRechargeScreenState();
}

class _CustomRechargeScreenState extends State<CustomRechargeScreen> {
  final languageController = Get.find<LanguagesController>();
  final countryListController = Get.find<CountryListController>();

  final customhistoryController = Get.find<CustomHistoryController>();
  final customrechargeController = Get.find<CustomRechargeController>();
  final dashboardController = Get.find<DashboardController>();
  final currencyController = Get.find<CurrencyListController>();
  final configController = Get.find<RechargeConfigController>();
  final companyController = Get.find<CompanyController>();

  ConversationController conversationController = Get.put(
    ConversationController(),
  );

  int selectedIndex = 0;

  final box = GetStorage();
  final ScrollController scrollController = ScrollController();

  Future<void> refresh() async {
    final int totalPages =
        customhistoryController
            .allorderlist
            .value
            .payload
            ?.pagination!
            .totalPages ??
        0;
    final int currentPage = customhistoryController.initialpage;

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
      customhistoryController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (customhistoryController.initialpage <= totalPages) {
        print("Load More...................");
        customhistoryController.fetchHistory();
      } else {
        customhistoryController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    conversationController.resetConversion();
    customhistoryController.finalList.clear();
    customhistoryController.initialpage = 1;

    customhistoryController.fetchHistory();
    currencyController.fetchCurrency();

    scrollController.addListener(refresh);

    customrechargeController.numberController.addListener(() {
      final text = customrechargeController.numberController.text;
      companyController.matchCompanyByPhoneNumber(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            customhistoryController.finalList.clear();
            customhistoryController.initialpage = 1;

            customhistoryController.fetchHistory();
          },
          child: Text(
            languageController.tr("DIRECT_RECHARGE"),

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
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Column(
            children: [
              Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.defaultColor.withOpacity(0.1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  box
                                      .read("afghanistan_flag")
                                      .toString(), // coming from country list service
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 55,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: AppColors.defaultColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Image.asset("assets/icons/phone.png", height: 25),
                              SizedBox(width: 12),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 0,
                                    ),
                                    child: TextField(
                                      maxLength: 10,
                                      keyboardType: TextInputType.number,
                                      controller: customrechargeController
                                          .numberController,
                                      style: TextStyle(fontSize: 18),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        border: InputBorder.none,
                                        hintText: languageController.tr(
                                          "PHONENUMBER",
                                        ),
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() {
                                final company =
                                    companyController.matchedCompany.value;
                                return Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: company == null
                                        ? Colors.transparent
                                        : null,
                                    image: company != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              company.companyLogo ?? '',
                                            ),
                                            fit: BoxFit.contain,
                                          )
                                        : null,
                                  ),
                                  child: company == null
                                      ? Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: Colors.transparent,
                                          ),
                                        )
                                      : null,
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 55,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: AppColors.defaultColor,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Image.asset("assets/icons/money.png", height: 25),
                              SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    conversationController.inputAmount.value =
                                        double.tryParse(value) ?? 0.0;
                                  },
                                  controller:
                                      customrechargeController.amountController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                    CustomAmountFormatter(), // Enforce value >= 1
                                  ],
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    border: InputBorder.none,
                                    hintText: languageController.tr("AMOUNT"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 80,
                        child: Obx(() {
                          final convertedList = conversationController
                              .getConvertedValues();

                          double buyingPrice = 0.0;
                          double sellingPrice = 0.0;
                          String symbol = "";

                          if (convertedList.isNotEmpty) {
                            final item = convertedList.first;
                            symbol = item['symbol'];
                            double baseValue = item['value'];

                            final configData =
                                configController.allsettings.value.data;

                            double adjustPercent =
                                double.tryParse(
                                  configData?.adjustValue ?? "0",
                                ) ??
                                0;

                            bool isIncrease =
                                configData?.adjustType == "increase";

                            buyingPrice = baseValue;

                            double adjustedPrice = isIncrease
                                ? baseValue + (baseValue * adjustPercent / 100)
                                : baseValue - (baseValue * adjustPercent / 100);

                            final sellingType = configData?.sellingAdjustType;
                            final sellingValueStr =
                                configData?.sellingAdjustValue;

                            if (sellingValueStr == null ||
                                sellingValueStr.isEmpty) {
                              sellingPrice =
                                  adjustedPrice + (adjustedPrice * 5 / 100);
                            } else {
                              double sellingPercent =
                                  double.tryParse(sellingValueStr) ?? 0;
                              bool sellingIncrease = sellingType == "increase";

                              sellingPrice = sellingIncrease
                                  ? adjustedPrice +
                                        (adjustedPrice * sellingPercent / 100)
                                  : adjustedPrice -
                                        (adjustedPrice * sellingPercent / 100);
                            }
                          }

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            child: Row(
                              children: [
                                // Buying Price
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.defaultColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Buying",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.orange[700],
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "${symbol}",
                                              style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.orange[400],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Text(
                                          buyingPrice.toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.orange[800],
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: 12),

                                // Selling Price
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.defaultColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Selling",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.green[700],
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "${symbol}",
                                              style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.green[400],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Text(
                                          sellingPrice.toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.green[800],
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: 10),
                      DefaultButton(
                        buttonName: languageController.tr("RECHARGE_NOW"),

                        onPressed: () {
                          if (customrechargeController
                                  .numberController
                                  .text
                                  .isEmpty ||
                              customrechargeController
                                  .amountController
                                  .text
                                  .isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Enter required data",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  content: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            17,
                                          ),
                                          color: Colors.white,
                                        ),
                                        height: 220,
                                        width: screenWidth,
                                        child: Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Obx(
                                            () =>
                                                customrechargeController
                                                        .isLoading
                                                        .value ==
                                                    false
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(height: 8),

                                                      Text(
                                                        languageController.tr(
                                                          "ARE_YOU_SURE",
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 50,
                                                        width: screenWidth,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  customrechargeController
                                                                      .placeOrder(
                                                                        context,
                                                                      );
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .green,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          6,
                                                                        ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      languageController.tr(
                                                                        "CONFIRMATION",
                                                                      ),
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Expanded(
                                                              flex: 2,
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          6,
                                                                        ),
                                                                    border: Border.all(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      languageController.tr(
                                                                        "CANCEL",
                                                                      ),
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container(
                                                    height: 250,
                                                    width: 250,
                                                    child: Lottie.asset(
                                                      'assets/loties/recharge.json',
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Obx(
                () => customhistoryController.isLoading.value == false
                    ? Container(
                        child:
                            customhistoryController
                                .allorderlist
                                .value
                                .data!
                                .orders
                                .isNotEmpty
                            ? SizedBox()
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                    : Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
              ),

              Expanded(
                child: Obx(
                  () =>
                      customhistoryController.isLoading.value == false &&
                          customhistoryController.finalList.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.separated(
                            shrinkWrap: false,
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 5);
                            },
                            itemCount: customhistoryController.finalList.length,
                            itemBuilder: (context, index) {
                              final data =
                                  customhistoryController.finalList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomOrderDetails(
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
                                        amount: data.bundle.amount.toString(),
                                        rechargebleAccount: data
                                            .rechargebleAccount!
                                            .toString(),
                                        // validityType:
                                        //     data.bundle!.validityType!.toString(),
                                        sellingPrice: data.bundle!.sellingPrice
                                            .toString(),
                                        // amount: data.bundle!.amount.toString(),
                                        // buyingPrice:
                                        //     data.bundle!.buyingPrice.toString(),
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
                                child: Container(
                                  height: 55,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.listbuilderboxColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
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
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    data.bundle!.bundleTitle
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  data.rechargebleAccount
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        // Expanded(
                                        //   flex: 2,
                                        //   child: Row(
                                        //     children: [
                                        //       Text(
                                        //         data.bundle!.amount.toString(),
                                        //         style: TextStyle(
                                        //           fontWeight: FontWeight.w500,
                                        //           fontSize: 15,
                                        //           color: Colors.black,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data.status.toString() == "0"
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
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              data.status.toString() == "0"
                                                  ? "assets/icons/pending.png"
                                                  : data.status.toString() ==
                                                        "1"
                                                  ? "assets/icons/success.png"
                                                  : "assets/icons/reject.png",
                                              height: 26,
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
                      : customhistoryController.finalList.isEmpty
                      ? SizedBox()
                      : RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.separated(
                            shrinkWrap: false,
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 5);
                            },
                            itemCount: customhistoryController.finalList.length,
                            itemBuilder: (context, index) {
                              final data =
                                  customhistoryController.finalList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomOrderDetails(
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
                                        amount: data.bundle.amount.toString(),
                                        rechargebleAccount: data
                                            .rechargebleAccount!
                                            .toString(),
                                        // validityType:
                                        //     data.bundle!.validityType!.toString(),
                                        sellingPrice: data.bundle!.sellingPrice
                                            .toString(),
                                        // amount: data.bundle!.amount.toString(),
                                        // buyingPrice:
                                        //     data.bundle!.buyingPrice.toString(),
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
                                child: Container(
                                  height: 55,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.listbuilderboxColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
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
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    data.bundle!.bundleTitle
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  data.rechargebleAccount
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        // Expanded(
                                        //   flex: 2,
                                        //   child: Row(
                                        //     children: [
                                        //       Text(
                                        //         data.bundle!.amount.toString(),
                                        //         style: TextStyle(
                                        //           fontWeight: FontWeight.w500,
                                        //           fontSize: 15,
                                        //           color: Colors.black,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data.status.toString() == "0"
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
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              data.status.toString() == "0"
                                                  ? "assets/icons/pending.png"
                                                  : data.status.toString() ==
                                                        "1"
                                                  ? "assets/icons/success.png"
                                                  : "assets/icons/reject.png",
                                              height: 26,
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
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Check if the input is empty
    if (newValue.text.isEmpty) {
      return TextEditingValue.empty;
    }

    // Parse the input to an integer
    final intValue = int.tryParse(newValue.text);

    // If parsing fails or the value is less than 1, revert to old value
    if (intValue == null || intValue < 1) {
      return oldValue;
    }

    // Allow the new value if it's valid
    return newValue;
  }
}
