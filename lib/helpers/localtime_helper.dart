import 'package:arzan_digital/controllers/time_zone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final TimeZoneController timeZoneController = Get.put(TimeZoneController());
String convertToDate(String utcTimeString) {
  try {
    DateTime utcTime = DateTime.parse(utcTimeString);

    Duration offset = DateTime.now().timeZoneOffset;

    DateTime localTime = utcTime.add(offset);

    return DateFormat('yyyy-MM-dd', 'en_US').format(localTime);
  } catch (e) {
    return "";
  }
}

String convertToLocalTime(String utcTimeString) {
  try {
    DateTime utcTime = DateTime.parse(utcTimeString);

    Duration offset = DateTime.now().timeZoneOffset;

    DateTime localTime = utcTime.add(offset);

    return DateFormat('hh:mm:ss a', 'en_US').format(localTime);
  } catch (e) {
    return "";
  }
}
