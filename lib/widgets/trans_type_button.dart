import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_controller/languages_controller.dart';

class TransTypeButton extends StatelessWidget {
  TransTypeButton({
    super.key,
    this.buttonName,
    this.mycolor,
    this.onpressed,
    this.imagelink,
  });

  LanguagesController languagesController = Get.put(LanguagesController());

  String? buttonName;
  String? imagelink;
  Color? mycolor;
  VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 75,
      width: screenWidth,
      child: GestureDetector(
        onTap: onpressed,
        child: Container(
          decoration: BoxDecoration(
            // color: mycolor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.grey.shade400),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(10),
                  //   gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //     colors: [
                  //       Colors.white.withOpacity(0.3), // উপরের দিকের হালকা সাদা
                  //       Colors.transparent, // নিচে স্বচ্ছ
                  //     ],
                  //   ),
                  // ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            imagelink.toString(),
                            height: 30,
                            color: mycolor,
                          ),
                          Text(
                            buttonName.toString(),
                            style: TextStyle(
                              color: mycolor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
