import 'package:flutter/material.dart';

import '../utils/colors.dart';

class AuthTextField extends StatelessWidget {
  String? hintText;
  final TextEditingController? controller;
  final IconData? mycion;
  AuthTextField({
    super.key,
    this.hintText,
    this.controller,
    this.mycion,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 55,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: AppColors.borderColor,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: TextField(
            keyboardType: hintText == "Enter your amount"
                ? TextInputType.phone
                : TextInputType.name,
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(mycion),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
