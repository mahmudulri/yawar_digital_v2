import 'package:get/get.dart';
import 'package:yawar_digital/models/bundle_model.dart';
import 'package:yawar_digital/models/isocode_model.dart';
import 'package:yawar_digital/models/language_model.dart';
import 'package:yawar_digital/services/isocode_service.dart';
import 'package:yawar_digital/services/language_service.dart';

class IscoCodeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  var isLoading = false.obs;

  var allisoCodeData = IsoCodeModel().obs;

  void fetchisoCode() async {
    try {
      isLoading(true);
      await IsoCodeApi().fetchIsoCode().then((value) {
        allisoCodeData.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
