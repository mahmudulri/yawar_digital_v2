import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:yawar_digital/controllers/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import '../global_controller/languages_controller.dart';

/// Use this GlobalKey in your widget to wrap the part you want to capture.
GlobalKey catpureKey = GlobalKey();

final languageController = Get.find<LanguagesController>();

Future<void> capturePng(GlobalKey captureKey) async {
  try {
    RenderRepaintBoundary? boundary =
        captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      debugPrint("❌ No boundary found.");
      return;
    }

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      debugPrint("❌ Failed to convert image to bytes.");
      return;
    }

    Uint8List pngBytes = byteData.buffer.asUint8List();
    final result = await ImageGallerySaverPlus.saveImage(
      pngBytes,
      quality: 100,
      name: "screenshot_${DateTime.now().millisecondsSinceEpoch}",
    );

    if (result['isSuccess'] == true) {
      Get.snackbar(
        languageController.tr("SUCCESS"),
        languageController.tr("IMAGE_SAVED_TO_GALLERY"),
      );
    } else {
      Get.snackbar("FAILED", "Could not save image.");
    }
  } catch (e) {
    debugPrint("⚠️ Error while capturing: $e");
    Get.snackbar(
      languageController.tr("ERROR"),
      languageController.tr("FAILED_TO_CAPTURE_IMAGE"),
    );
  }
}
