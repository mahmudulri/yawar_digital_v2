import 'package:yawar_digital/controllers/bundles_controller.dart';
import 'package:yawar_digital/controllers/confirm_pin_controller.dart';
import 'package:yawar_digital/controllers/service_controller.dart';
import 'package:get/get.dart';

class RechargeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceController>(() => ServiceController());
    Get.lazyPut<BundleController>(() => BundleController());
    Get.lazyPut<ConfirmPinController>(() => ConfirmPinController());
  }
}
