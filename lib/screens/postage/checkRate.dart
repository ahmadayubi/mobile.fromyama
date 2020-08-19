import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/widgets/addressWidget.dart';

class CheckRate extends StatefulWidget {
  final String _token;
  final Map<String, dynamic> dest;

  CheckRate(this._token, this.dest);

  @override
  _CheckRateState createState() => _CheckRateState();
}

class _CheckRateState extends State<CheckRate> {
  List _parcels = [];
  Map<String, dynamic> _shipper;
  var _parcelId;

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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            AddressWidget(widget.dest),
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
          ],
        ),
      ),
    );
  }
}
