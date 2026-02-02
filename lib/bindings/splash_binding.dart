import 'package:arzan_digital/controllers/dashboard_controller.dart';
import 'package:arzan_digital/controllers/history_controller.dart';
import 'package:arzan_digital/controllers/iso_code_controller.dart';
import 'package:arzan_digital/controllers/language_controller.dart';
import 'package:arzan_digital/controllers/slider_controller.dart';
import 'package:get/get.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IscoCodeController>(() => IscoCodeController());
    Get.lazyPut<SliderController>(() => SliderController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
