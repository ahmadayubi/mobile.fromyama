import 'package:flutter/material.dart';
import 'package:fromyama/data/shopifyOrder.dart';

Widget etsyOrderWidget(ShopifyOrder order) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Image(
          image: AssetImage('assets/images/etsy_small.png'),
          width: 20,
          height: 20,
        ),
        Text(
          order.customerName,
          style: TextStyle(
            color: Colors.green,
          ),
        ),
        Text(order.orderID),
      ],
    ),
  );
}
