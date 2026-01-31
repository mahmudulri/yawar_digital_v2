import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PriceTextView extends StatelessWidget {
  final String price;

  PriceTextView({required this.price});

  @override
  Widget build(BuildContext context) {
    // Convert the price string to a double
    double priceDouble = double.parse(price);
    // Format the double to a string with two decimal places
    String formattedPrice = priceDouble.toStringAsFixed(2);

    return Text(
      NumberFormat.currency(
        locale: 'en_US',
        symbol: '',
        decimalDigits: 2,
      ).format(
        double.parse(
          formattedPrice.toString(),
        ),
      ),
      style: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class SPriceTextView extends StatelessWidget {
  final String price;

  SPriceTextView({required this.price});

  @override
  Widget build(BuildContext context) {
    // Convert the price string to a double
    double priceDouble = double.parse(price);
    // Format the double to a string with two decimal places
    String formattedPrice = priceDouble.toStringAsFixed(2);

    return Text(
      NumberFormat.currency(
        locale: 'en_US',
        symbol: '',
        decimalDigits: 2,
      ).format(
        double.parse(
          formattedPrice.toString(),
        ),
      ),
      style: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
