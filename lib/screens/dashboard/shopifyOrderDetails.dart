import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

import 'package:fromyama/widgets/addressWidget.dart';
import 'package:fromyama/widgets/receiptWidget.dart';

class ShopifyOrderDetails extends StatefulWidget {
  final ShopifyOrder _order;
  final String _token;

  ShopifyOrderDetails(this._order, this._token);

  @override
  _ShopifyOrderDetailsState createState() => _ShopifyOrderDetailsState();
}

class _ShopifyOrderDetailsState extends State<ShopifyOrderDetails> {
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
                  image: AssetImage('assets/images/shopify_small.png'),
                  width: 40,
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "${widget._order.name}",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "SFM",
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: widget._order.financial_status == 'paid'
                      ? new Color(0xffD6E198)
                      : new Color(0xf2c993),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                  child: Text(
                    widget._order.financial_status == 'paid'
                        ? "PAID"
                        : "PENDING",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontFamily: "SFM",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ), //Text("${widget._order.name}"),
      ),
      backgroundColor: new Color(0xfff9efe7),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    ReceiptWidget(widget._order),
                    SizedBox(
                      height: 10,
                    ),
                    widget._order.shipping_info == null
                        ? Text("")
                        : AddressWidget(widget._order.shipping_info),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Shipping From",
                                style: TextStyle(
                                  fontFamily: "SFM",
                                  fontSize: 25,
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
                                  "SOURCE: ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "SF",
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
                                              color: Colors.deepPurple),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.deepPurpleAccent,
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
                                  "SHIPPING INFO: ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "SF",
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
                                  style: TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
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
                          TextField(
                            controller: _trackingNumberController,
                            enabled: _enableTracking,
                            decoration: InputDecoration(
                                labelText:
                                    'Tracking Number, Leave Blank if None'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        child: _fulfilled
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 60.0,
                              )
                            : SizedBox(
                                width: double.infinity,
                                height: 100,
                                child: FlatButton(
                                  color: new Color(0xffD6E198),
                                  onPressed: _locationValue == null
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
                                      fontSize: 35,
                                      fontFamily: "SF",
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
