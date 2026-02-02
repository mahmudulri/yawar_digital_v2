import 'package:arzan_digital/models/slider_model.dart';
import 'package:arzan_digital/services/slider_service.dart';
import 'package:get/get.dart';

class SliderController extends GetxController {
  @override
  void onInit() {
    fetchSliderData();
    super.onInit();
  }

  var isLoading = false.obs;

  var allsliderlist = SliderModel().obs;

  void fetchSliderData() async {
    try {
      isLoading(true);
      await SlidersApi().fetchSliders().then((value) {
        allsliderlist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
