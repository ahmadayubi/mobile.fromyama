import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/screens/dashboard/shopifyOrderDetails.dart';
import 'package:fromyama/widgets/slideLeft.dart';

Widget shopifyOrderWidget(
    ShopifyOrder order, BuildContext context, String token, Function cb) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(1, 6, 1, 5),
    child: Tooltip(
      message: "${order.total} ${order.currency}",
      child: InkWell(
        splashColor: new Color(0xffD6E198),
        onTap: () => {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) {
                return ShopifyOrderDetails(order, token, cb);
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
                padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.name}',
                      style: TextStyle(
                        fontSize: 20,
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
                          order.was_paid ? "PAID" : "PENDING",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
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
                          image: AssetImage('assets/images/shopify_small.png'),
                          width: 45,
                          height: 45,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${order.shipping_info == null ? "No Name" : order.shipping_info['name']}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "SFCR",
                                  color: Colors.grey[800]),
                            ),
                            Text(
                              'PLACED ${order.created_at.split('T')[0]} @ ${order.created_at.split('T')[1].split('-')[0]}',
                              style: TextStyle(
                                fontSize: 13,
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
