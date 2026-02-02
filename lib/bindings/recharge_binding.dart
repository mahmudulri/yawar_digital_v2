import 'package:arzan_digital/controllers/bundles_controller.dart';
import 'package:arzan_digital/controllers/place_order_controller.dart';
import 'package:arzan_digital/controllers/service_controller.dart';
import 'package:get/get.dart';

class RechargeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceController>(() => ServiceController());
    Get.lazyPut<BundleController>(() => BundleController());
    Get.lazyPut<PlaceOrderController>(() => PlaceOrderController());
  }
}
