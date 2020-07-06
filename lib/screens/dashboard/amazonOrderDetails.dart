import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fromyama/data/amazonOrder.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                                "Shipping From",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Source: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "SFCR",
                                    color: Colors.grey[800],
                                  ),
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: FutureBuilder(
                                  future: _locationFuture,
                                  builder: (context, locationData) {
                                    switch (locationData.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        return DotLoading();
                                      default:
                                        //_locations.addAll(locationData.data['locations']);
                                        return DropdownButton<String>(
                                          isExpanded: true,
                                          value: _locationValue,
                                          icon: Icon(Icons.arrow_downward),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontFamily: "SFCR"),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.grey[500],
                                          ),
                                          onChanged: (String newLocation) {
                                            setState(() {
                                              _locationValue = newLocation;
                                            });
                                          },
                                          items: locationData.data['locations']
                                              .map<DropdownMenuItem<String>>(
                                                  (var location) {
                                            return DropdownMenuItem<String>(
                                              value: location['id'].toString(),
                                              child: Text(location['name']),
                                            );
                                          }).toList(),
                                        );
                                    }
                                  },
                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Carrier: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "SFCR",
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _postalServiceValue,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontFamily: "SFCR"),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.grey[500],
                                  ),
                                  onChanged: (String newService) {
                                    setState(() {
                                      _enableTracking = true;
                                      _postalServiceValue = newService;
                                    });
                                  },
                                  items: <String>[
                                    "Canada Post",
                                    "FedEx",
                                    "Purolator",
                                    "USPS",
                                    "UPS",
                                    "DHL Express"
                                  ].map<DropdownMenuItem<String>>(
                                      (String postalService) {
                                    return DropdownMenuItem<String>(
                                      value: postalService,
                                      child: Text(postalService),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: _trackingNumberController,
                            enabled: _enableTracking,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusColor: Colors.grey[500],
                                hoverColor: Colors.grey[500],
                                labelText:
                                    'Tracking Number, Leave Blank if None'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        child: _fulfilled
                            ? Icon(
                                Icons.check_circle,
                                color: new Color(0xffbbd984),
                                size: 60.0,
                              )
                            : SizedBox(
                                width: double.infinity,
                                height: 75,
                                child: FlatButton(
                                  color: new Color(0xffbbd984),
                                  onPressed: _locationValue == null ||
                                          !_fulfillable
                                      ? null
                                      : () async {
                                          Map fulfillment = {
                                            'location_id': _locationValue,
                                            'tracking_number':
                                                _trackingNumberController.text,
                                            'tracking_company':
                                                _postalServiceValue,
                                            'notify_customer': "true"
                                          };
                                          if (_trackingNumberController.text ==
                                              "") {
                                            fulfillment
                                                .remove('tracking_company');
                                            fulfillment
                                                .remove('tracking_number');
                                          }
                                          var fulfillStatus = await postAuthData(
                                              '$SERVER_IP/shopify/order/fulfill/${widget._order.order_id}',
                                              fulfillment,
                                              widget._token);
                                          if (fulfillStatus['status_code'] ==
                                              200) {
                                            setState(() {
                                              _fulfilled = true;
                                            });
                                          }
                                        },
                                  disabledColor: Colors.grey,
                                  child: Text(
                                    "Fulfill",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontFamily: "SFCR",
                                    ),
                                  ),
                                ),
                              ),
                      ),
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
