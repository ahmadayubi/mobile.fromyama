import 'package:flutter/material.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/screens/dashboard/shopifyOrderDetails.dart';
import 'package:fromyama/widgets/slideLeft.dart';

Widget shopifyOrderWidget(
    ShopifyOrder order, BuildContext context, String token) {
  return ListTile(
    title: Text(order.orderID),
    subtitle: Text(order.total.toString()),
    leading: Image(
      image: AssetImage('assets/images/shopify_small.png'),
      width: 20,
      height: 20,
    ),
    onTap: () {
      Navigator.push(
        context,
        SlideLeft(
          exitPage: MainDash(token),
          enterPage: ShopifyOrderDetails(order.total),
        ),
      );
    },
  );
}
