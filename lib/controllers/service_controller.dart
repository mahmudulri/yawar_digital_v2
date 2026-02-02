import 'package:get/get.dart';
import 'package:arzan_digital/models/categories_service_model.dart';
import 'package:arzan_digital/models/service_model.dart';
import 'package:arzan_digital/services/categoris_service_list.dart';
import 'package:arzan_digital/services/service_service.dart';

class ServiceController extends GetxController {
  @override
  void onInit() {
    fetchservices();
    super.onInit();
  }

  var isLoading = false.obs;

  List reserveDigit = [];

  var allserviceslist = ServiceModel().obs;

  void fetchservices() async {
    try {
      isLoading(true); // Start loading
      await ServiceListApi().fetchservicelist().then((value) {
        allserviceslist.value = value;

        reserveDigit.clear();
        value.data?.services.forEach((service) {
          service.company?.companycodes?.forEach((companycode) {
            if (companycode.reservedDigit != null) {
              reserveDigit.add(companycode.reservedDigit!);
            }
          });
        });
      });
    } catch (e) {
      print(e.toString()); // Log the error
    } finally {
      isLoading(false); // Stop loading in both success and failure
    }
  }
}
