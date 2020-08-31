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
        title: Text("Purchase Shipping Label"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              AddressWidget(testDest),
              DropdownButton<String>(
                isExpanded: true,
                value: _parcelId,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
                underline: Container(
                  height: 2,
                  color: Colors.grey[500],
                ),
                onChanged: (String newParcel) {
                  setState(() {
                    _parcelId = newParcel;
                  });
                },
                items: _parcels.map<DropdownMenuItem<String>>((var parcel) {
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
                    errorText: _validWeight ? null : "Invalid Weight",
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
                    focusColor: Colors.grey[500],
                    hoverColor: Colors.grey[500],
                    labelText: 'Weight'),
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
                              'zip': testDest['zip'], //widget._dest['zip'],
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
              Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return postageRateWidget(
                        rates[index], context, widget._token);
                  },
                  itemCount: rates.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
