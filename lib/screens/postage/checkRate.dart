import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/widgets/addressWidget.dart';
import 'package:fromyama/widgets/postageRateWidget.dart';

class CheckRate extends StatefulWidget {
  final String _token;
  final Map<String, dynamic> _dest;

  CheckRate(this._token, this._dest);

  @override
  _CheckRateState createState() => _CheckRateState();
}

class _CheckRateState extends State<CheckRate> {
  final TextEditingController _weightController = TextEditingController();
  List _parcels = [];
  Map<String, dynamic> _shipper;
  var _parcelId;
  bool _validWeight = true;
  bool _showDialog = false;
  int _purchaseResponse = 0;
  int _indexOfSelected = 0;
  var rates = [];

  Map<String, dynamic> testDest = {'zip': 'V5H3Z7'};

  void initState() {
    super.initState();
    getShippingInfo();
  }

  void getShippingInfo() async {
    var shippingInfo =
        await getAuthData('$SERVER_IP/company/shipper', widget._token);
    if (this.mounted) {
      try {
        setState(() {
          this._parcels = shippingInfo['parcels'];
          this._shipper = shippingInfo['shipper'];
        });
      } catch (error) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: Text(
          "Purchase Shipping Label",
          style: TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
        ),
      ),
      backgroundColor: beige(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                AddressWidget(widget._dest),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 10,
                    right: 10,
                  ),
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
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        hint: Text("Select Parcel Type"),
                        isExpanded: true,
                        value: _parcelId,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: Colors.grey[800], fontFamily: "SFCR"),
                        underline: Container(
                          height: 2,
                          color: Colors.grey[500],
                        ),
                        onChanged: (String newParcel) {
                          setState(() {
                            _parcelId = newParcel;
                          });
                        },
                        items: _parcels
                            .map<DropdownMenuItem<String>>((var parcel) {
                          return DropdownMenuItem<String>(
                            value: parcel['_id'],
                            child: Text(parcel['name']),
                          );
                        }).toList(),
                      ),
                      TextField(
                        controller: _weightController,
                        onChanged: (value) {
                          setState(() {
                            _validWeight = true;
                          });
                        },
                        decoration: InputDecoration(
                            suffixText: "grams",
                            errorText: _validWeight ? null : "Invalid Weight",
                            labelStyle: TextStyle(
                                color: Colors.grey[800], fontFamily: "SFCR"),
                            focusColor: Colors.grey[500],
                            hoverColor: Colors.grey[500],
                            labelText: 'Item Weight'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          width: 200,
                          height: 50,
                          child: RaisedButton(
                            color: blue(),
                            child: Text(
                              "Check Rates",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "SFCM"),
                            ),
                            onPressed: () async {
                              var parcel, weight;
                              for (int i = 0; i < _parcels.length; i++) {
                                if (_parcels[i]['_id'] == _parcelId) {
                                  parcel = _parcels[i];
                                  break;
                                }
                              }

                              weight = double.parse(parcel['weight']) +
                                  (double.parse(_weightController.text) / 1000);

                              var result = await postAuthData(
                                  '$SERVER_IP/postage/canadapost/rates',
                                  {
                                    'parcel': {
                                      'weight': weight.toStringAsFixed(2),
                                      'length': parcel['length'],
                                      'width': parcel['width'],
                                      'height': parcel['height']
                                    },
                                    'dest': {
                                      'zip': testDest[
                                          'zip'], //widget._dest['zip'],
                                    },
                                  },
                                  widget._token);
                              setState(() {
                                this.rates = result['quotes'];
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          splashColor: blue(),
                          onTap: () => {
                                setState(() {
                                  _indexOfSelected = index;
                                  _showDialog = true;
                                })
                              },
                          child: postageRateWidget(
                              rates[index], context, widget._token));
                    },
                    itemCount: rates.length,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _showDialog && rates.length > 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: new Color(0x77000000),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                      left: 15,
                      right: 15,
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: const Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                    child: rates.length > 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize:
                                MainAxisSize.max, // To make the card compact
                            children: [
                              Text(
                                "${rates[_indexOfSelected]['service-name']}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "SFCM",
                                ),
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
                                  Text(
                                    "Base ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "SFCM",
                                    ),
                                  ),
                                  Text(
                                    "${rates[_indexOfSelected]['price-details']['base']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "SFCM",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "GST ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "SFCM",
                                    ),
                                  ),
                                  Text(
                                    "${rates[_indexOfSelected]['price-details']['taxes']['gst']['_']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "SFCM",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "PST ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "SFCM",
                                    ),
                                  ),
                                  Text(
                                    "${rates[_indexOfSelected]['price-details']['taxes']['pst']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "SFCM",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "HST ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "SFCM",
                                    ),
                                  ),
                                  Text(
                                    "${rates[_indexOfSelected]['price-details']['taxes']['hst']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "SFCM",
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: rates[_indexOfSelected]
                                            ['price-details']['adjustments']
                                        ['adjustment']
                                    .map<Widget>(
                                  (adj) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${adj['adjustment-name']} ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "SFCM",
                                          ),
                                        ),
                                        Text(
                                          "${adj['adjustment-cost']}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "SFCM",
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList(),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "SFCM",
                                    ),
                                  ),
                                  Text(
                                    "${rates[_indexOfSelected]['price-details']['due']} CAD",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "SFCM",
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FlatButton(
                                    onPressed: () async {
                                      var parcel, weight;
                                      for (int i = 0;
                                          i < _parcels.length;
                                          i++) {
                                        if (_parcels[i]['_id'] == _parcelId) {
                                          parcel = _parcels[i];
                                          break;
                                        }
                                      }
                                      weight = double.parse(parcel['weight']) +
                                          (double.parse(
                                                  _weightController.text) /
                                              1000);
                                      await postAuthData(
                                          '$SERVER_IP/postage/canadapost/buy',
                                          {
                                            "amount":
                                                "${double.parse(rates[_indexOfSelected]['price-details']['due']) * 100}",
                                            "currency": "cad",
                                            "dest": widget._dest,
                                            "service_code":
                                                rates[_indexOfSelected]
                                                    ['service-code'],
                                            "parcel": {
                                              'weight':
                                                  weight.toStringAsFixed(2),
                                              'length': parcel['length'],
                                              'width': parcel['width'],
                                              'height': parcel['height']
                                            },
                                          },
                                          widget._token);
                                    },
                                    child: Text("Purchase"),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        _showDialog = false;
                                        _indexOfSelected = 0;
                                      });
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  Visibility(
                                    visible: _purchaseResponse == 200,
                                    child: SizedBox(
                                        height: 80, child: DotLoading()),
                                  ),
                                  Visibility(
                                    visible: _purchaseResponse == 200,
                                    child: SizedBox(
                                      height: 80,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: new Color(0xffbbd984),
                                            size: 60.0,
                                          ),
                                          Text(
                                            "Label Purchased",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontFamily: "SFCM",
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _purchaseResponse == 500,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 20.0,
                                        ),
                                        Text(
                                          "Error Purchasing Label",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: "SFCM",
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Text("Error"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
