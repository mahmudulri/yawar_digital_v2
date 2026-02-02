import 'package:arzan_digital/controllers/bundles_controller.dart';
import 'package:arzan_digital/controllers/categories_list_controller.dart';
import 'package:arzan_digital/controllers/country_list_controller.dart';
import 'package:arzan_digital/controllers/reserve_digit_controller.dart';
import 'package:arzan_digital/controllers/service_controller.dart';
import 'package:arzan_digital/global_controller/languages_controller.dart'
    show LanguagesController;
import 'package:arzan_digital/routes/routes.dart';
import 'package:arzan_digital/screens/social_recharge.dart';
import 'package:arzan_digital/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/language_controller.dart';
import 'recharge_screen.dart';

class NewServiceScreen extends StatefulWidget {
  NewServiceScreen({super.key});

  @override
  State<NewServiceScreen> createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends State<NewServiceScreen> {
  final languageController = Get.find<LanguagesController>();

  final categorisListController = Get.find<CategorisListController>();

  final ACategorisListController aCategorisListController = Get.put(
    ACategorisListController(),
  );

  final box = GetStorage();

  final countryListController = Get.find<CountryListController>();

  final bundleController = Get.find<BundleController>();

  final serviceController = Get.find<ServiceController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // aCategorisListController.fetchcategories();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Color(0xffEFF3F4),
      backgroundColor: AppColors.defaultColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Color(0xffEFF3F4),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          languageController.tr("SERVICES"),

          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Color(0xffEFF3F4),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Obx(
            () =>
                categorisListController.isLoading.value == false &&
                    countryListController.isLoading.value == false
                ? ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Obx(
                        () => aCategorisListController.isLoading.value == false
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                      childAspectRatio: 1.0,
                                    ),
                                itemCount: aCategorisListController
                                    .finalArrayCatList
                                    .length,
                                itemBuilder: (context, index) {
                                  final data = aCategorisListController
                                      .finalArrayCatList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      serviceController.reserveDigit.clear();

                                      box.write(
                                        "maxlength",
                                        data["phoneNumberLength"],
                                      );

                                      bundleController.finalList.clear();
                                      box.write("validity_type", "");
                                      box.write("company_id", "");
                                      box.write("search_tag", "");
                                      box.write(
                                        "country_id",
                                        data["countryId"],
                                      );

                                      box.write(
                                        "service_category_id",
                                        data["categoryId"],
                                      );
                                      bundleController.initialpage = 1;

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RechargeScreen(),
                                        ),
                                      );

                                      ///////.....................................//
                                      // print(box.read("country_id"));
                                      // print(box.read("service_category_id"));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
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
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                5.0,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                          data["countryImage"],
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(data["categoryName"]),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : SizedBox(),
                      ),
                      SizedBox(height: 10),
                      ...categorisListController
                          .allcategorieslist
                          .value!
                          .data!
                          .servicecategories!
                          .where((category) => category.type == "social")
                          .map((category) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.categoryName.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 3.0,
                                        mainAxisSpacing: 3.0,
                                        childAspectRatio: 0.9,
                                      ),
                                  itemCount: category.services?.length ?? 0,
                                  itemBuilder: (context, serviceIndex) {
                                    final service =
                                        category.services![serviceIndex];
                                    return GestureDetector(
                                      onTap: () {
                                        bundleController.finalList.clear();
                                        // print(service.companyId.toString());
                                        box.write("validity_type", "");
                                        box.write(
                                          "company_id",
                                          service.companyId.toString(),
                                        );
                                        box.write("search_tag", "");
                                        box.write(
                                          "country_id",
                                          service.company!.countryId.toString(),
                                        );

                                        box.write(
                                          "service_category_id",
                                          category.id.toString(),
                                        );
                                        bundleController.initialpage = 1;

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SocialRechargeScreen(),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        child: Container(
                                          width: 152,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                  0.2,
                                                ),
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Text(
                                                //   service.company!.countryId
                                                //       .toString(),
                                                //   style: TextStyle(
                                                //     fontSize: 8,
                                                //     fontWeight: FontWeight.bold,
                                                //     color: Colors.black,
                                                //   ),
                                                // ),
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                        service
                                                            .company!
                                                            .companyLogo
                                                            .toString(),
                                                      ),
                                                ),
                                                SizedBox(height: 8),
                                                // Text(
                                                //   service.serviceCategoryId
                                                //       .toString(),
                                                //   style: TextStyle(
                                                //     fontSize: 8,
                                                //     fontWeight: FontWeight.bold,
                                                //     color: Colors.black,
                                                //   ),
                                                // ),
                                                Text(
                                                  service.company!.companyName
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          })
                          .toList(),
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
