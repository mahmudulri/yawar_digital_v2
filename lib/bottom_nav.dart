import 'package:arzan_digital/controllers/categories_list_controller.dart';
import 'package:arzan_digital/controllers/dashboard_controller.dart';
import 'package:arzan_digital/routes/routes.dart';
import 'package:arzan_digital/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/country_list_controller.dart';
import 'controllers/history_controller.dart';
import 'controllers/language_controller.dart';
import 'controllers/order_list_controller.dart';
import 'controllers/sub_reseller_controller.dart';
import 'controllers/transaction_controller.dart';
import 'global_controller/languages_controller.dart';
import 'pages/homepage.dart';
import 'pages/orders.dart';
import 'pages/sub_reseller_screen.dart';
import 'pages/transaction_type.dart';
import 'pages/transactions.dart';

class BottomNavScreen extends StatefulWidget {
  BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  List pages = [
    Homepage(),
    TransactionsType(),
    OrdersPage(),
    SubResellerScreen(),
  ];

  int currentIndex = 0;

  final orderlistController = Get.find<OrderlistController>();
  final transactionController = Get.find<TransactionController>();
  final historyController = Get.find<HistoryController>();
  final languageController = Get.find<LanguagesController>();
  final subresellerController = Get.find<SubresellerController>();
  final countryListController = Get.find<CountryListController>();
  final dashboardController = Get.find<DashboardController>();

  final ACategorisListController aCategorisListController = Get.put(
    ACategorisListController(),
  );

  final CategorisListController categorisListController = Get.put(
    CategorisListController(),
  );

  final box = GetStorage();

  final PageStorageBucket bucket = PageStorageBucket();

  Widget currentPage = Homepage();

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // await  exit(0);

                    SystemNavigator.pop();
                  },
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showExitPopup();
        return shouldExit;
      },
      child: Scaffold(
        body: PageStorage(bucket: bucket, child: currentPage),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.defaultColor,
          onPressed: () {
            categorisListController.fetchcategories();
            aCategorisListController.fetchcategories();

            Get.toNamed(newservicescreen);
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SafeArea(
          child: Container(
            color: AppColors.backgroundColor,
            height: 67,
            child: BottomAppBar(
              elevation: 1.0,
              shape: AutomaticNotchedShape(
                RoundedRectangleBorder(),
                StadiumBorder(),
              ),
              notchMargin: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          box.write("orderstatus", "");
                          setState(() {
                            // dashboardController.fetchDashboardData();

                            currentPage = Homepage();

                            currentIndex = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/homeicon.png",
                              height: 25,
                              color: currentIndex == 0
                                  ? AppColors.defaultColor
                                  : Colors.black,
                            ),
                            Text(
                              languageController.tr("HOME"),

                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: currentIndex == 0
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: currentIndex == 0
                                    ? AppColors.defaultColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          box.write("orderstatus", "");
                          setState(() {
                            // historyController.initialpage = 1;
                            // historyController.finalList.clear();

                            currentPage = TransactionsType();
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/transactionsicon.png",
                              height: 25,
                              color: currentIndex == 1
                                  ? AppColors.defaultColor
                                  : Colors.black,
                            ),
                            Text(
                              languageController.tr("TRANSACTIONS"),

                              style: TextStyle(
                                fontSize: 10,
                                color: currentIndex == 1
                                    ? AppColors.defaultColor
                                    : Colors.black,
                                fontWeight: currentIndex == 1
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 25, width: 10),
                      // Text("Recharge", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: [
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          box.write("orderstatus", "");

                          setState(() {
                            // historyController.finalList.clear();
                            // orderlistController.finalList.clear();
                            currentPage = OrdersPage();
                            currentIndex = 2;
                          });
                          // orderlistController.fetchOrderlistdata();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/notificationicon.png",
                              height: 25,
                              color: currentIndex == 2
                                  ? AppColors.defaultColor
                                  : Colors.black,
                            ),
                            Text(
                              languageController.tr("ORDERS"),

                              style: TextStyle(
                                fontSize: 10,
                                color: currentIndex == 2
                                    ? AppColors.defaultColor
                                    : Colors.black,
                                fontWeight: currentIndex == 2
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          box.write("orderstatus", "");
                          setState(() {
                            currentPage = SubResellerScreen();
                            currentIndex = 3;
                            orderlistController.finalList.clear();
                            orderlistController.initialpage = 1;
                            historyController.finalList.clear();
                            historyController.initialpage = 1;

                            // print(orderlistController.initialpage);
                            // print(orderlistController.finalList.length);
                          });
                          subresellerController.fetchSubReseller();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/sub_reseller.png",
                              height: 25,
                              color: currentIndex == 3
                                  ? AppColors.defaultColor
                                  : Colors.black,
                            ),
                            Text(
                              languageController.tr("SUB_RESELLER"),

                              style: TextStyle(
                                fontSize: 10,
                                color: currentIndex == 3
                                    ? AppColors.defaultColor
                                    : Colors.black,
                                fontWeight: currentIndex == 3
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
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
    );
  }
}
