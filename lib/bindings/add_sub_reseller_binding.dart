import 'package:arzan_digital/controllers/add_sub_reseller_controller.dart';
import 'package:arzan_digital/controllers/currency_controller.dart';
import 'package:arzan_digital/controllers/district_controller.dart';
import 'package:arzan_digital/controllers/province_controller.dart';
import 'package:get/get.dart';

class AddSubResellerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProvinceController>(() => ProvinceController());

    Get.lazyPut<CurrencyListController>(() => CurrencyListController());

    Get.lazyPut<DistrictController>(() => DistrictController());

    Get.lazyPut<AddSubResellerController>(() => AddSubResellerController());
  }
}
