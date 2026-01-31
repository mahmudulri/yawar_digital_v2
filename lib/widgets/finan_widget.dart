import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class finanWidget extends StatelessWidget {
  String? boxname;
  String? balance;
  Color? mycolor;
  String? imagelink;
  String? itemName1;
  String? itemName2;

  finanWidget({
    super.key,
    this.boxname,
    this.balance,
    this.mycolor,
    this.imagelink,
    this.itemName1,
    this.itemName2,
  });

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // shadow color
              spreadRadius: 2, // spread radius
              blurRadius: 2, // blur radius
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    imagelink.toString(),
                    height: 20,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    boxname.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    itemName1.toString() + " : ",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${box.read("currency_code")} : ",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                      locale: 'en_US',
                      symbol: '',
                      decimalDigits: 2,
                    ).format(
                      double.parse(
                        balance.toString(),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    itemName2.toString() + " : ",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${box.read("currency_code")} : ",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                      locale: 'en_US',
                      symbol: '',
                      decimalDigits: 2,
                    ).format(
                      double.parse(
                        balance.toString(),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
