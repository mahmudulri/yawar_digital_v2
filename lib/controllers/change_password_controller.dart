import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../utils/api_endpoints.dart';

class ChangePasswordController extends GetxController {
  final box = GetStorage();

  TextEditingController currentpassController = TextEditingController();
  TextEditingController newpassController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();

  RxBool isLoading = false.obs;

  dynamic _safeJsonDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  Future<void> change() async {
    http.Response? response;

    try {
      isLoading.value = true;

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}',
      };

      final url = Uri.parse("${ApiEndPoints.baseUrl}change_password");

      final body = {
        'current_password': currentpassController.text.trim(),
        'new_password': newpassController.text.trim(),
        'confirm_new_password': confirmpassController.text.trim(),
      };

      response = await http.post(url, headers: headers, body: jsonEncode(body));

      // ✅ ALWAYS PRINT STATUS CODE
      print("ChangePassword StatusCode: ${response.statusCode}");

      final result = _safeJsonDecode(response.body);

      switch (response.statusCode) {
        /// ✅ HTTP 200 (success or logical failure)
        case 200:
          if (result != null && result["success"] == true) {
            currentpassController.clear();
            newpassController.clear();
            confirmpassController.clear();

            Fluttertoast.showToast(
              msg: result["message"] ?? "Password changed successfully",
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          } else {
            Get.snackbar(
              result?["errors"],
              result?["message"] ?? "Invalid current password",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
          break;

        /// ❌ VALIDATION ERROR
        case 422:
          final errors = result?["errors"] as Map<String, dynamic>?;
          if (errors != null) {
            final message = errors.values
                .map((e) => (e as List).first.toString())
                .join("\n");

            Get.snackbar(
              "Validation Error",
              message,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
          break;

        /// ❌ UNAUTHORIZED
        case 401:
          Get.snackbar(
            result?["errors"] ?? "error",
            result?["message"] ?? "Invalid current password",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          break;

        /// ❌ FORBIDDEN
        case 403:
          Get.snackbar(
            "Forbidden",
            "You do not have permission to perform this action",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          break;

        /// ❌ NOT FOUND
        case 404:
          Get.snackbar(
            "Not Found",
            "Service not available",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          break;

        /// ❌ SERVER ERROR
        case 500:
          Get.snackbar(
            "Server Error",
            "Something went wrong on the server. Please try again later.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          break;

        /// ❌ ANY OTHER STATUS
        default:
          Get.snackbar(
            "Error",
            "Unexpected error (${response.statusCode})",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
      }
    }
    /// ❌ UNKNOWN ERROR
    catch (e) {
      print("ChangePassword StatusCode: UNKNOWN ERROR");

      Get.snackbar(
        "Error",
        "Unexpected error occurred",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
