import 'package:get/get.dart';
import '../models/setting_model.dart';
import '../services/setting_service.dart';

class SettingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchsettingdata();
  }

  var isLoading = false.obs;

  var allsettings = SettingModel().obs;

  void fetchsettingdata() async {
    try {
      isLoading(true);
      await SettingServiceApi().fetchsetting().then((value) {
        allsettings.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
