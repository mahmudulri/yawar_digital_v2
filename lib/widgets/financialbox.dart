import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class financialbox extends StatelessWidget {
  String? boxname;
  String? balance;
  Color? mycolor;
  String? imagelink;

  financialbox({
    super.key,
    this.boxname,
    this.balance,
    this.mycolor,
    this.imagelink,
  });

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 200,
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
          child: Row(
            children: [
              Image.asset(
                imagelink.toString(),
                height: 25,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    boxname.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
