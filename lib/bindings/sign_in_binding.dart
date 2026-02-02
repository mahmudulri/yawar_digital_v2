import 'package:arzan_digital/controllers/country_list_controller.dart';
import 'package:arzan_digital/controllers/history_controller.dart';
import 'package:arzan_digital/controllers/sign_in_controller.dart';
import 'package:arzan_digital/controllers/transaction_controller.dart';
import 'package:get/get.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<CountryListController>(() => CountryListController());
  }
}
