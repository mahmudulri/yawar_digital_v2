import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/dashboard_data_model.dart';
import '../models/sub_reseller_model.dart';
import '../models/transaction_model.dart';
import '../utils/api_endpoints.dart';

class TransactionApi {
  final box = GetStorage();
  Future<TransactionModel> fetchTransaction(int pageNo) async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl +
          ApiEndPoints.otherendpoints.transactions +
          "?page=$pageNo&items_per_page=300&search=${box.read("transactiontype")}${box.read("category")}${box.read("purpose")}${box.read("startdate")}${box.read("enddate")}",
    );

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final transactionModel = TransactionModel.fromJson(
        json.decode(response.body),
      );

      return transactionModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}
