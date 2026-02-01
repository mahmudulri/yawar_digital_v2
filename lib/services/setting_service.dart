import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/setting_model.dart';
import '../utils/api_endpoints.dart';

class SettingServiceApi {
  final box = GetStorage();
  Future<SettingModel> fetchsetting() async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.appsetting}",
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final settingModel = SettingModel.fromJson(json.decode(response.body));

      return settingModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}
