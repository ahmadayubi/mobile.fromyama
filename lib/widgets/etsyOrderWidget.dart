import 'package:flutter/material.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/screens/dashboard/etsyOrderDetails.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/widgets/slideLeft.dart';

Widget etsyOrderWidget(ShopifyOrder order, BuildContext context, String token) {
  return ListTile(
    title: Text(order.orderID),
    subtitle: Text(order.total.toString()),
    leading: Image(
      image: AssetImage('assets/images/etsy_small.png'),
      width: 40,
      height: 40,
    ),
    onTap: () {
      Navigator.push(
        context,
        SlideLeft(
          exitPage: MainDash(token),
          enterPage: EtsyOrderDetails(order.total),
        ),
      );
    },
  );
}
