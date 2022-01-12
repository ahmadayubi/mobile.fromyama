import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/loading/processLoading.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/fyButton.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/widgets/addressWidget.dart';
import 'package:fromyama/widgets/postageRateWidget.dart';
import 'package:fromyama/utils/address.dart';
import 'package:fromyama/controllers/postage/canadapost.dart';

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
  int _purchaseResponse = -1;
  String _purchaseMessage = "";
  int _indexOfSelected = -1;
  var rates = [];
  bool _loading = false;

  void initState() {
    super.initState();
    getShippingInfo();
    widget._dest['country_code'] =
        countryToCountryCode(widget._dest['country']);
  }

  void buyShippingLabel() async {
    setState(() {
      _purchaseResponse = 0;
      _purchaseMessage = "Processing label purchase.";
    });
    var parcel, weight;
    for (int i = 0; i < _parcels.length; i++) {
      if (_parcels[i]['id'] == _parcelId) {
        parcel = _parcels[i];
        break;
      }
    }
    weight =
        parcel['weight'] / 1000 + (double.parse(_weightController.text) / 1000);

    var resp = await postAuthData('$SERVER_IP/postage/buy/canadapost',
        {
          "name": "Fram",
          "street": "113 springbeauty ave",
          "city": "Ottawa",
          "province_code": "ON",
          "postal_code": "K2E7E8",
          "country_code": "CA",
          "phone": "6136003774",
          "service_code": rates[_indexOfSelected]['service-code'],
          'weight': weight.toStringAsFixed(2),
          'length': parcel['length'].toString(),
          'width': parcel['width'].toString(),
          'height': parcel['height'].toString()
        }, widget._token);

    switch (resp['status_code']) {
      case 200:
        setState(() {
          _purchaseResponse = 200;
          _purchaseMessage = "Label purchased.";
        });
        break;
      default:
        break;
    }
  }

  void getShippingInfo() async {
    var shippingInfo =
        await getAuthData('$SERVER_IP/company/shipper', widget._token);
    if (this.mounted) {
      try {
        setState(() {
          _parcels = shippingInfo['parcels'];
          _shipper = shippingInfo['address'];
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
                //AddressWidget(widget._dest),
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
                            value: parcel['id'],
                            child: Text(parcel['name']),
                          );
                        }).toList(),
                      ),
                      TextField(
                        autofocus: false,
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
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FYButton(
                          text: "Check Rates",
                          onPressed: () async {
                            var parcel, weight;
                            for (int i = 0; i < _parcels.length; i++) {
                              if (_parcels[i]['id'] == _parcelId) {
                                parcel = _parcels[i];
                                break;
                              }
                            }
                            weight = parcel['weight'] / 1000 +
                                (double.parse(_weightController.text) / 1000);
                            if (weight > 30) {
                            } else {
                              setState(() {
                                _loading = true;
                              });
                              var result = await getCanadaPostRates(
                                  widget._dest['postal_code'],
                                  parcel['length'].toString(),
                                  parcel['width'].toString(),
                                  parcel['height'].toString(),
                                  weight.toStringAsFixed(2),
                                  widget._token);
                              print(result);
                              setState(() {
                                this.rates = result['data'];
                                _loading = false;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _loading
                    ? Padding(padding: EdgeInsets.all(20), child: DotLoading())
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                splashColor: blue(),
                                onTap: () => {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                                child: Container(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                  Text(
                                                    "${rates[index]['service-name']}",
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Base ",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "SFCM",
                                                        ),
                                                      ),
                                                      Text(
                                                        "${rates[index]['price-details']['base']}",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "SFCM",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "GST ",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "SFCM",
                                                        ),
                                                      ),
                                                      Text(
                                                        "${rates[index]['price-details']['gst']}",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "SFCM",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "PST ",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "SFCM",
                                                        ),
                                                      ),
                                                      Text(
                                                        "${rates[index]['price-details']['pst']}",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "SFCM",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "HST ",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "SFCM",
                                                        ),
                                                      ),
                                                      Text(
                                                        "${rates[index]['price-details']['hst']}",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "SFCM",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: rates[index]
                                                                ['price-details']
                                                            ['adjustments']
                                                        .map<Widget>(
                                                      (adj) {
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "${adj['adjustment-name']} ",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "SFCM",
                                                              ),
                                                            ),
                                                            Text(
                                                              "${adj['adjustment-cost']}",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "SFCM",
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ).toList(),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("Total ",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontFamily: "SFCM",
                                                        ),
                                                      ),
                                                      Text("${rates[index]['price-details']['due']} CAD",
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
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                          setState(() {
                                                            _indexOfSelected = index;
                                                          });
                                                          buyShippingLabel();
                                                        },
                                                        child: Text("Purchase"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text("Cancel"),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                                ));
                                          })
                                    },
                                child: postageRateWidget(rates[index], context, widget._token));
                          },
                          itemCount: rates.length,
                        ),
                      ),
              ],
            ),
          ),
          ProcessLoading(responseStatus: _purchaseResponse, message: _purchaseMessage,),
        ],
      ),
    );
  }
}
