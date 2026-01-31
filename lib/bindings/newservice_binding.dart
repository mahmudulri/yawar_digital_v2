import 'package:yawar_digital/controllers/bundles_controller.dart';
import 'package:yawar_digital/controllers/categories_list_controller.dart';
import 'package:yawar_digital/controllers/confirm_pin_controller.dart';

import 'package:yawar_digital/controllers/service_controller.dart';
import 'package:get/get.dart';

class NewServiceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BundleController>(() => BundleController());
    Get.lazyPut<CategorisListController>(() => CategorisListController());
    Get.lazyPut<ServiceController>(() => ServiceController());
    // Get.lazyPut<ReserveDigitController>(() => ReserveDigitController());
    Get.lazyPut<ConfirmPinController>(() => ConfirmPinController());
  }
}
