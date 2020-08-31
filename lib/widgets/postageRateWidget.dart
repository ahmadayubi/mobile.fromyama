import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fromyama/data/amazonOrder.dart';
import 'package:fromyama/screens/dashboard/amazonOrderDetails.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/widgets/slideLeft.dart';

Widget postageRateWidget(Map rate, BuildContext context, String token) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(1, 6, 1, 5),
    child: InkWell(
      splashColor: blue(),
      onTap: () => {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) {
              return MainDash(token);
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
              child: Text(
                '${rate['service-name']}',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "SFM",
                  color: Colors.grey[800], //new Color(0xff1a1a1a),
                ),
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
                        image: AssetImage('assets/images/canada_post.png'),
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
                            "${rate['price-details']['due']} CAD",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "SFCR",
                                color: Colors.grey[800]),
                          ),
                          Visibility(
                            visible: rate['price-details']['options']['option']
                                    ['option-code'] ==
                                "DC",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: green(),
                                ),
                                Text(
                                  "Tracking Included",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "SFCR",
                                      color: Colors.grey[800]),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'ESTIMATED DELIVERY ${rate['service-standard']['expected-delivery-date']}',
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
  );
}
