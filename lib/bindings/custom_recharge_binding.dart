import 'package:arzan_digital/controllers/country_list_controller.dart';
import 'package:arzan_digital/controllers/custom_history_controller.dart';
import 'package:arzan_digital/controllers/custom_recharge_controller.dart';
import 'package:arzan_digital/controllers/language_controller.dart';
import 'package:arzan_digital/controllers/operator_controller.dart';
import 'package:get/get.dart';

class CustomRechargeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomRechargeController>(() => CustomRechargeController());
    Get.lazyPut<CustomHistoryController>(() => CustomHistoryController());

    Get.lazyPut<CountryListController>(() => CountryListController());
    Get.lazyPut<OperatorController>(() => OperatorController());
  }
}
