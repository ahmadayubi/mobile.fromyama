import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fromyama/data/amazonOrder.dart';
import 'package:fromyama/data/etsyOrder.dart';
import 'package:fromyama/data/order.dart';

import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/screens/dashboard/amazonOrderDetails.dart';
import 'package:fromyama/screens/dashboard/etsyOrderDetails.dart';
import 'package:fromyama/screens/dashboard/orderDetails.dart';
import 'package:fromyama/screens/dashboard/shopifyOrderDetails.dart';

class OrderTile extends StatelessWidget {
  OrderTile(this.order, this.token, this.callback);

  final Order order;
  final String token;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1, 6, 1, 5),
      child: Tooltip(
        message: "${order.total} ${order.currency}",
        child: InkWell(
          splashColor: new Color(order.color),
          onTap: () => {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) {
                  return OrderDetails(order, token, callback);
                },
              ),
            )
          },
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.1,
                  blurRadius: 2,
                  offset: Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            padding: const EdgeInsets.all(9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 2, 8, 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${order.name}',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "SFM",
                          color: Colors.grey[800], //new Color(0xff1a1a1a),
                        ),
                      ),
                      Container(
                        decoration: ShapeDecoration(
                          color: order.was_paid
                              ? new Color(0xffD6E198)
                              : new Color(0xffFFC58B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                          child: Text(
                            (order.was_paid ? "PAID" : "PENDING") + " +${order.total} ${order.currency}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: "SFCM",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 6,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                          child: Image(
                            image: AssetImage(order.imagePath),
                            width: 42,
                            height: 42,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${order.shipping_address == null ? "No Name" : order.shipping_address['name']}",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontFamily: "SFCR",
                                    color: Colors.grey[800]),
                              ),
                              Text(
                                'PLACED ${order.created_at.split('T')[0]} @ ${order.created_at.split('T')[1].split('-')[0]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "SFCM",
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_backspace,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}