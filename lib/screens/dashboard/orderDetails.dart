import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fromyama/data/order.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/loading/processLoading.dart';
import 'package:fromyama/screens/postage/checkRate.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/requests.dart';

import 'package:fromyama/widgets/addressWidget.dart';
import 'package:fromyama/widgets/receiptWidget.dart';

class OrderDetails extends StatefulWidget {
  final Order _order;
  final String _token;
  final Function callback;

  OrderDetails(this._order, this._token, this.callback);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  void initState() {
    super.initState();
    if(widget._order.type == "shopify") _locationFuture = getLocations();
  }

  Future<Map<String, dynamic>> getLocations() async {
    return getAuthData('$SERVER_IP/shopify/locations', widget._token);
  }

  bool _fulfilled = false;
  var _locationValue;
  var _postalServiceValue;
  bool _enableTracking = false;
  bool _fulfillable = false;
  int _fulfillResponse = -1;
  String _fulfillMessage = "Temporary default.";
  bool _showDialog = false;

  void fuilfillable(bool val) {
    setState(() {
      _fulfillable = val;
    });
  }

  Future<Map<String, dynamic>> _locationFuture;
  final TextEditingController _trackingNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        toolbarHeight: 45,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image(
                  image: AssetImage(widget._order.imagePath),
                  width: 25,
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "${widget._order.name}",
                    style: TextStyle(
                      fontSize: 17,
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
                      fontSize: 13,
                      fontFamily: "SFCM",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: beige(),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: new Color(widget._order.color),
                    child: ListView(
                      children: [
                        ReceiptWidget(widget._order, fuilfillable),
                        SizedBox(
                          height: 15,
                        ),
                        widget._order.shipping_address != null ?
                            Column(
                              children: [
                                AddressWidget(widget._order.shipping_address),
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
                                        offset:
                                        Offset(1, 1), // changes position of shadow
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                    return SizedBox(
                                                      height: 47.5,
                                                      child: DotLoading(),
                                                    );
                                                  default:
                                                  //_locations.addAll(locationData.data['locations']);
                                                    return DropdownButton<String>(
                                                      hint: Text("Select A Location"),
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
                                                      items: locationData
                                                          .data['locations']
                                                          .map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                              (var location) {
                                                            return DropdownMenuItem<String>(
                                                              value:
                                                              location['id'].toString(),
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                              hint: Text("Select A Carrier"),
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
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _trackingNumberController,
                                              enabled: _enableTracking,
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontFamily: "SFCR",
                                                    fontSize: 15,
                                                  ),
                                                  focusColor: Colors.grey[500],
                                                  hoverColor: Colors.grey[500],
                                                  labelText:
                                                  'Tracking Number, Leave Blank if None'),
                                            ),
                                          ),
                                          FlatButton(
                                            color: white(),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => CheckRate(
                                                          widget._token,
                                                          widget._order
                                                              .shipping_address)));
                                            },
                                            child: Text(
                                              "Or Purchase Label",
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 15,
                                                fontFamily: "SFCR",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 75,
                                    child: FlatButton(
                                      color: new Color(0xffbbd984),
                                      onPressed: _locationValue == null ||
                                          !_fulfillable ||
                                          _showDialog
                                          ? null
                                          : () async {
                                        setState(() {
                                          _fulfillResponse = 0;
                                          _fulfillMessage = "Fulfilling ${widget._order.type} order";
                                        });
                                        Map fulfillment = {
                                          'location_id': _locationValue,
                                          'tracking_number':
                                          _trackingNumberController.text,
                                          'tracking_company': _postalServiceValue,
                                          'notify_customer': "true",
                                        };
                                        if (_trackingNumberController.text == "") {
                                          fulfillment.remove('tracking_company');
                                          fulfillment.remove('tracking_number');
                                        }
                                        var fulfillStatus = await postAuthData(
                                            '$SERVER_IP/${widget._order.type}/fulfill/${widget._order.order_id}',
                                            fulfillment,
                                            widget._token);
                                        if (fulfillStatus['status_code'] == 200) {
                                          setState(() {
                                            _fulfilled = true;
                                            _fulfillResponse = 200;
                                            _fulfillMessage = "Order fulfilled.";
                                          });
                                          widget.callback();
                                        } else {
                                          setState(() {
                                            _fulfillResponse = 500;
                                            _fulfillMessage = "Error fulfilling order.";
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
                              ]
                            ) :
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ProcessLoading(responseStatus: _fulfillResponse, message: _fulfillMessage),
        ],
      ),
    );
  }
}
