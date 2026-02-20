import 'package:get/get.dart';
import 'package:arzan_digital/services/dashboard_service.dart';

import '../models/dashboard_data_model.dart';

class DashboardController extends GetxController {
  // @override
  // void onInit() {
  //   fetchDashboardData();
  //   super.onInit();
  // }

  var isLoading = false.obs;

  final deactiveStatus = ''.obs;
  final deactivateMessage = ''.obs;

  var alldashboardData = DashboardDataModel().obs;

  void setDeactivated(String status, String message) {
    deactiveStatus.value = status;
    deactivateMessage.value = message;
  }

  Future<void> fetchDashboardData() async {
    print(isLoading.toString());

    try {
      isLoading(true);
      print(isLoading.toString());
      await DashboardApi().fetchDashboard().then((value) {
        alldashboardData.value = value;
      });
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading(false);
      print(isLoading.toString());
    }
  }
}
