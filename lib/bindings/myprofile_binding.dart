import 'package:yawar_digital/controllers/change_pin_controller.dart';
import 'package:get/get.dart';

class MyProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePinController>(() => ChangePinController());
  }
}
