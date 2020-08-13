import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fromyama/data/amazonOrder.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';
import 'dart:convert';

import 'package:fromyama/widgets/addressWidget.dart';
import 'package:fromyama/widgets/receiptWidget.dart';

class AmazonOrderDetails extends StatefulWidget {
  final AmazonOrder _order;
  final String _token;

  AmazonOrderDetails(this._order, this._token);

  @override
  _AmazonOrderDetailsState createState() => _AmazonOrderDetailsState();
}

class _AmazonOrderDetailsState extends State<AmazonOrderDetails> {
  void initState() {
    super.initState();
    // initial load
    print(widget._order.items);
    _locationFuture = getLocations();
  }

  Future<Map<String, dynamic>> getLocations() async {
    return getAuthData('$SERVER_IP/shopify/locations', widget._token);
  }

  bool _fulfilled = false;
  var _locationValue;
  var _postalServiceValue;
  bool _enableTracking = false;
  bool _fulfillable = false;

  void fuilfillable(bool val) {
    setState(() {
      _fulfillable = val;
    });
  }

  Future<Map<String, dynamic>> _locationFuture;
  final TextEditingController _trackingNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image(
                  image: AssetImage('assets/images/amazon_small.png'),
                  width: 35,
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "${widget._order.name}",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "SFCM",
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: widget._order.was_paid
                      ? new Color(0xffD6E198)
                      : new Color(0xffFFC58B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                  child: Text(
                    widget._order.was_paid ? "PAID" : "PENDING",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "SFCM",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ), //Text("${widget._order.name}"),
      ),
      backgroundColor: new Color(0xfff9efe7),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: new Color(0xffD6E198),
                child: ListView(
                  children: [
                    ReceiptWidget(widget._order, fuilfillable),
                    SizedBox(
                      height: 15,
                    ),
                    widget._order.shipping_info == null
                        ? SizedBox()
                        : AddressWidget(widget._order.shipping_info),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
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
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Fulfilling Amazon Order",
                                style: TextStyle(
                                  fontFamily: "SFCM",
                                  fontSize: 18,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey,
                            height: 6,
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "SFCR",
                                  color: Colors.grey[800]),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        "Amazon doesn't allow third-party applications access to order shipping addresses"),
                                TextSpan(
                                    text:
                                        ', this prevents FromYama in providing a useful fulfillment option. We do allow you to'),
                                TextSpan(
                                    text:
                                        ' view as much of the order details as possible.'),
                                TextSpan(
                                    text:
                                        "\n\nTo fulfill the order please visit your Amazon Seller dashboard."),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
