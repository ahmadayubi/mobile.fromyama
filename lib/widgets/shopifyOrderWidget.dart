import 'package:flutter/material.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/screens/dashboard/shopifyOrderDetails.dart';
import 'package:fromyama/widgets/slideLeft.dart';

Widget shopifyOrderWidget(
    ShopifyOrder order, BuildContext context, String token) {
  return InkWell(
    onTap: () => {
      Navigator.push(
        context,
        SlideLeft(
          exitPage: MainDash(token),
          enterPage: ShopifyOrderDetails(order, token),
        ),
      )
    },
    child: Container(
      padding: const EdgeInsets.all(9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image(
                  image: AssetImage('assets/images/shopify_small.png'),
                  width: 45,
                  height: 45,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${order.name}',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Total: ${order.total} ${order.currency} \nPlaced: ${order.created_at.split('T')[0]} @ ${order.created_at.split('T')[1].split('-')[0]}',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(
            Icons.keyboard_backspace,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    ),
  );

/*   ListTile(
    title: Text(
      '${order.name}',
      style: TextStyle(fontSize: 20),
    ),
    subtitle: Text(
        'Total: ${order.total} ${order.currency} \nPlaced: ${order.created_at.split('T')[0]} @ ${order.created_at.split('T')[1].split('-')[0]}'),
    leading: Image(
      image: AssetImage('assets/images/shopify_small.png'),
      width: 45,
      height: 45,
    ),
    onTap: () {
      Navigator.push(
        context,
        SlideLeft(
          exitPage: MainDash(token),
          enterPage: ShopifyOrderDetails(order, token),
        ),
      );
    },
  ); */
}
