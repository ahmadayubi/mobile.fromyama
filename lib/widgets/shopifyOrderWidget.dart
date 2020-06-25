import 'package:flutter/material.dart';
import 'package:fromyama/data/shopifyOrder.dart';

Widget shopifyOrderWidget(ShopifyOrder order) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Image(
          image: AssetImage('assets/images/shopify_small.png'),
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
