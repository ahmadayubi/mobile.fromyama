import 'package:flutter/material.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

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
      backgroundColor: new Color(0xfffaebd7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.keyboard_backspace),
                        tooltip: 'Increase volume by 10',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Image(
                        image: AssetImage('assets/images/shopify_small.png'),
                        width: 50,
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: Text(
                          widget._order.name,
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'SF',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Image(
                        image: AssetImage('assets/images/receipt_top.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, top: 40.0),
                        child: Text(
                          "Order Summary:",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'SF',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget._order.items.map<Widget>(
                        (item) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '${item['title']} x ${item['quantity']}',
                                      style: TextStyle(
                                        fontFamily: "SF",
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      'per item: \$${item['price']}',
                                      style: TextStyle(
                                        fontFamily: "SF",
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '=>',
                                  style: TextStyle(
                                    fontFamily: "SF",
                                    fontSize: 30,
                                  ),
                                ),
                                Text(
                                  '\$${double.parse(item['price']) * item['quantity']}',
                                  style: TextStyle(
                                    fontFamily: "SF",
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 40, left: 8, right: 8),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order SubTotal:",
                              style: TextStyle(
                                fontFamily: "SF",
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              widget._order.subtotal,
                              style: TextStyle(
                                fontFamily: "SF",
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tax:",
                              style: TextStyle(
                                fontFamily: "SF",
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              widget._order.tax,
                              style: TextStyle(
                                fontFamily: "SF",
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order Total:",
                              style: TextStyle(
                                fontFamily: "SF",
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '${widget._order.total} ${widget._order.currency}',
                              style: TextStyle(
                                fontFamily: "SF",
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Image(
                    image: AssetImage('assets/images/receipt_bottom.png'),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "SHIPPING SOURCE: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "SF",
                          ),
                        ),
                        FutureBuilder(
                          future: _locationFuture,
                          builder: (context, locationData) {
                            switch (locationData.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return CircularProgressIndicator();
                              default:
                                //_locations.addAll(locationData.data['locations']);
                                return DropdownButton<String>(
                                  value: _locationValue,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.deepPurple),
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "SHIPPING INFO: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "SF",
                          ),
                        ),
                        DropdownButton<String>(
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
                      ],
                    ),
                    TextField(
                      controller: _trackingNumberController,
                      enabled: _enableTracking,
                      decoration: InputDecoration(
                          labelText: 'Tracking Number, Leave Blank if None'),
                    ),
                  ],
                ),
              ),
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
                          color: Colors.green,
                          onPressed: () async {
                            if (_locationValue == null) {
                              print(widget._order.total);
                            } else {
                              Map fulfillment = {
                                'location_id': _locationValue,
                                'tracking_number':
                                    _trackingNumberController.text,
                                'tracking_company': _postalServiceValue,
                                'notify_customer': "true"
                              };
                              if (_trackingNumberController.text == "") {
                                fulfillment.remove('tracking_company');
                                fulfillment.remove('tracking_number');
                              }
                              var fulfillStatus = await postAuthData(
                                  '$SERVER_IP/shopify/order/fulfill/${widget._order.order_id}',
                                  fulfillment,
                                  widget._token);
                              if (fulfillStatus['status_code'] == 200) {
                                setState(() {
                                  _fulfilled = true;
                                });
                              }
                            }
                          },
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
    );
  }
}
