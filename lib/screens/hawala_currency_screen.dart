import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/hawala_currency_controller.dart';

import '../global_controller/languages_controller.dart';
import '../utils/colors.dart';

class HawalaCurrencyScreen extends StatefulWidget {
  const HawalaCurrencyScreen({super.key});

  @override
  State<HawalaCurrencyScreen> createState() => _HawalaCurrencyScreenState();
}

class _HawalaCurrencyScreenState extends State<HawalaCurrencyScreen> {
  final box = GetStorage();

  HawalaCurrencyController hawalacurrencycontroller = Get.put(
    HawalaCurrencyController(),
  );
  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  void initState() {
    super.initState();
    hawalacurrencycontroller.fetchcurrency();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
          languagesController.tr("HAWALA_RATES"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(height: 10),

            Expanded(
              child: Obx(
                () => hawalacurrencycontroller.isLoading.value == false
                    ? SingleChildScrollView(
                        // vertical scroll only
                        child: DataTable(
                          columnSpacing: 10,
                          headingRowHeight: 36,
                          dataRowMinHeight: 34,
                          dataRowMaxHeight: 40,
                          headingRowColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                          border: TableBorder.all(
                            color: AppColors.defaultColor,
                            width: 1,
                          ),

                          // 👇 This aligns text vertically in the middle
                          headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),

                          // 👇 Forces centered header text alignment
                          columns: [
                            DataColumn(
                              label: Text(
                                languagesController.tr("AMOUNT"),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Center(
                                  child: Text(
                                    languagesController.tr("FROM"),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Center(
                                  child: Text(
                                    languagesController.tr("TO"),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Center(
                                  child: Text(
                                    languagesController.tr("BUY"),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Center(
                                  child: Text(
                                    languagesController.tr("SELL"),
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],

                          rows: hawalacurrencycontroller
                              .allcurrencylist
                              .value
                              .data!
                              .rates!
                              .map(
                                (data) => DataRow(
                                  cells: [
                                    DataCell(
                                      Center(
                                        child: Text(
                                          data.amount.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          data.fromCurrency?.name ?? "-",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          data.toCurrency?.name ?? "-",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          "${data.buyRate ?? '-'} ${data.toCurrency?.symbol ?? ''}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          "${data.sellRate ?? '-'} ${data.toCurrency?.symbol ?? ''}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
