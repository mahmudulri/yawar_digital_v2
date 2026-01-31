import 'dart:convert';
import 'package:yawar_digital/controllers/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yawar_digital/utils/api_endpoints.dart';

class ConfirmPinController extends GetxController {
  TextEditingController numberController = TextEditingController();
  final box = GetStorage();

  TextEditingController pinController = TextEditingController();
  final HistoryController historyController = Get.put(HistoryController());

  RxBool isLoading = false.obs;
  RxBool placeingLoading = false.obs;

  RxBool loadsuccess = false.obs;

  Future<bool> verify() async {
    try {
      isLoading.value = true;
      loadsuccess.value = false; // Start with false

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      var url = Uri.parse(
        "${ApiEndPoints.baseUrl}confirm_pin?pin=${pinController.text}",
      );
      print(url.toString());

      http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
      );

      final results = jsonDecode(response.body);

      if (response.statusCode == 200 && results["success"] == true) {
        pinController.clear();
        loadsuccess.value = true;

        // Proceed with placing the order
        return await placeOrder();
      } else {
        handleFailure(results["message"]);
        return false;
      }
    } catch (e) {
      handleFailure(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> placeOrder() async {
    try {
      placeingLoading.value = true;
      var url = Uri.parse("${ApiEndPoints.baseUrl}place_order");
      Map body = {
        'bundle_id': box.read("bundleID"),
        'rechargeble_account': numberController.text,
      };
      print(url);
      print(body.toString());

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read("userToken")}',
        },
      );

      final orderresults = jsonDecode(response.body);
      print(response.statusCode.toString());

      if (response.statusCode == 201 && orderresults["success"] == true) {
        loadsuccess.value = false;
        pinController.clear();
        numberController.clear();
        box.remove("bundleID");
        placeingLoading.value = false;
        return true; // Order placed successfully
      } else {
        handleFailure(orderresults["message"]);
        return false;
      }
    } catch (e) {
      handleFailure(e.toString());
      return false;
    }
  }

  void handleFailure(String message) {
    loadsuccess.value = false;
    placeingLoading.value = false; // Set to false (was mistakenly set to true)
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    pinController.clear();
  }
}
