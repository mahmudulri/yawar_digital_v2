import 'package:yawar_digital/controllers/categories_list_controller.dart';
import 'package:yawar_digital/controllers/change_status_controller.dart';
import 'package:yawar_digital/controllers/country_list_controller.dart';
import 'package:yawar_digital/controllers/custom_history_controller.dart';
import 'package:yawar_digital/controllers/custom_recharge_controller.dart';
import 'package:yawar_digital/controllers/dashboard_controller.dart';
import 'package:yawar_digital/controllers/delete_sub_reseller.dart';
import 'package:yawar_digital/controllers/history_controller.dart';
import 'package:yawar_digital/controllers/operator_controller.dart';
import 'package:yawar_digital/controllers/order_list_controller.dart';
import 'package:yawar_digital/controllers/sign_in_controller.dart';
import 'package:yawar_digital/controllers/sub_reseller_controller.dart';
import 'package:yawar_digital/controllers/subreseller_details_controller.dart';
import 'package:yawar_digital/controllers/transaction_controller.dart';
import 'package:get/get.dart';

class BaseViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<OrderlistController>(() => OrderlistController());
    Get.lazyPut<TransactionController>(() => TransactionController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<CountryListController>(() => CountryListController());
    Get.lazyPut<SignInController>(() => SignInController());
    Get.lazyPut<TransactionController>(() => TransactionController());
    Get.lazyPut<SubresellerController>(() => SubresellerController());
    Get.lazyPut<SubresellerDetailsController>(
      () => SubresellerDetailsController(),
    );

    Get.lazyPut<DeleteSubResellerController>(
      () => DeleteSubResellerController(),
    );
    Get.lazyPut<ChangeStatusController>(() => ChangeStatusController());

    Get.lazyPut<CategorisListController>(() => CategorisListController());
    Get.lazyPut<CustomRechargeController>(() => CustomRechargeController());
    Get.lazyPut<CustomHistoryController>(() => CustomHistoryController());
    Get.lazyPut<OperatorController>(() => OperatorController());
  }
}
