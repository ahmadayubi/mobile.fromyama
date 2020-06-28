import 'package:flutter/material.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';

class ShopifyOrderDetails extends StatefulWidget {
  final String _orderID;
  final String _token;

  ShopifyOrderDetails(this._orderID, this._token);

  @override
  _ShopifyOrderDetailsState createState() => _ShopifyOrderDetailsState();
}

class _ShopifyOrderDetailsState extends State<ShopifyOrderDetails> {
  void initState() {
    super.initState();

    // initial load
    _locationFuture = getLocations();
    _orderFuture = getOrder();
  }

  Future<Map<String, dynamic>> getLocations() async {
    return getAuthData('$SERVER_IP/shopify/locations', widget._token);
  }

  Future<Map<String, dynamic>> getOrder() async {
    return getAuthData(
        '$SERVER_IP/shopify/order/detail/${widget._orderID}', widget._token);
  }

  bool _fulfilled = false;
  var _locationValue;
  var _postalServiceValue;
  bool _enableTracking = false;

  Future<Map<String, dynamic>> _orderFuture;
  Future<Map<String, dynamic>> _locationFuture;
  final TextEditingController _trackingNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: _orderFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Expanded(child: FYLoading());
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      //print(snapshot.data);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              snapshot.data['order']['financial_status'] ==
                                      'paid'
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 40.0,
                                    )
                                  : Icon(
                                      Icons.access_time,
                                      color: Colors.yellow,
                                      size: 40.0,
                                    ),
                              Text(snapshot.data['order']['id'].toString()),
                            ],
                          ),
                          Text(
                              snapshot.data['order']['total_price'].toString()),
                        ],
                      );
                    }
                }
              },
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
                          .map<DropdownMenuItem<String>>((var location) {
                        return DropdownMenuItem<String>(
                          value: location['id'].toString(),
                          child: Text(location['name']),
                        );
                      }).toList(),
                    );
                }
              },
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
              ].map<DropdownMenuItem<String>>((String postalService) {
                return DropdownMenuItem<String>(
                  value: postalService,
                  child: Text(postalService),
                );
              }).toList(),
            ),
            TextField(
              controller: _trackingNumberController,
              enabled: _enableTracking,
              decoration: InputDecoration(
                  labelText: 'Tracking Number, Leave Blank if None'),
            ),
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: _fulfilled
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 60.0,
                    )
                  : FlatButton(
                      onPressed: () async {
                        if (_locationValue == null) {
                        } else {
                          Map fulfillment = {
                            'location_id': _locationValue,
                            'tracking_number': _trackingNumberController.text,
                            'tracking_company': _postalServiceValue,
                            'notify_customer': "true"
                          };
                          var fulfillStatus = await postAuthData(
                              '$SERVER_IP/shopify/order/fulfill/${widget._orderID}',
                              fulfillment,
                              widget._token);
                          if (fulfillStatus['status_code'] == 200) {
                            setState(() {
                              _fulfilled = true;
                            });
                          }
                        }
                      },
                      child: Text("Fulfill"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
