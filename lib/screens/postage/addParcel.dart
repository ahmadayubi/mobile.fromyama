import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/loading/processLoading.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/fyButton.dart';
import 'package:fromyama/utils/requests.dart';

class AddParcel extends StatefulWidget {
  final String _token;

  AddParcel(this._token);

  @override
  _AddParcelState createState() => _AddParcelState();
}

class _AddParcelState extends State<AddParcel> {
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _validLength = true,
      _validWidth = true,
      _validHeight = true,
      _validWeight = true,
      _validName = true;
  String _demImage = "none";
  int _responseStatus = -1;
  String _responseMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: Text(
          "Add Custom Parcel",
          style: TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
        ),
      ),
      backgroundColor: beige(),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  Image(
                    image: AssetImage('assets/images/parcel_$_demImage.png'),
                    height: 300,
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
                        TextField(
                          controller: _nameController,
                          onTap: () {
                            setState(() {
                              _demImage = "none";
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _validName = true;
                            });
                          },
                          decoration: InputDecoration(
                              errorText: _validName ? null : "Invalid Name",
                              labelStyle: TextStyle(
                                  color: Colors.grey[800], fontFamily: "SFCR"),
                              focusColor: Colors.grey[500],
                              hoverColor: Colors.grey[500],
                              labelText: 'Parcel Name (Internal Use)'),
                        ),
                        TextField(
                          controller: _lengthController,
                          onTap: () {
                            setState(() {
                              _demImage = "length";
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _validLength = true;
                            });
                          },
                          decoration: InputDecoration(
                              suffixText: "cm",
                              errorText: _validLength
                                  ? null
                                  : "Invalid Length (must be greater than 5, less than 200)",
                              labelStyle: TextStyle(
                                  color: Colors.grey[800], fontFamily: "SFCR"),
                              focusColor: Colors.grey[500],
                              hoverColor: Colors.grey[500],
                              labelText: 'Length'),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
                        TextField(
                          controller: _widthController,
                          onTap: () {
                            setState(() {
                              _demImage = "width";
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _validWidth = true;
                            });
                          },
                          decoration: InputDecoration(
                              suffixText: "cm",
                              errorText: _validWidth
                                  ? null
                                  : "Invalid Width (must be greater than 5, less than 200)",
                              labelStyle: TextStyle(
                                  color: Colors.grey[800], fontFamily: "SFCR"),
                              focusColor: Colors.grey[500],
                              hoverColor: Colors.grey[500],
                              labelText: 'Width'),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
                        TextField(
                          controller: _heightController,
                          onTap: () {
                            setState(() {
                              _demImage = "height";
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _validHeight = true;
                            });
                          },
                          decoration: InputDecoration(
                              suffixText: "cm",
                              errorText: _validHeight
                                  ? null
                                  : "Invalid Height (must be greater than 5, less than 200)",
                              labelStyle: TextStyle(
                                  color: Colors.grey[800], fontFamily: "SFCR"),
                              focusColor: Colors.grey[500],
                              hoverColor: Colors.grey[500],
                              labelText: 'Height'),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
                        TextField(
                          controller: _weightController,
                          onTap: () {
                            setState(() {
                              _demImage = "none";
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _validWeight = true;
                            });
                          },
                          decoration: InputDecoration(
                              suffixText: "grams",
                              errorText: _validWeight
                                  ? null
                                  : "Invalid Weight (must be greater than 0, less than 30,000)",
                              labelStyle: TextStyle(
                                  color: Colors.grey[800], fontFamily: "SFCR"),
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
                          child: FYButton(onPressed: () async {
                            var name = _nameController.text;
                            var length = _lengthController.text;
                            var width = _widthController.text;
                            var height = _heightController.text;
                            var weight = _weightController.text;
                            if (name == "") setState(() => _validName = false);
                            if (length == "" ||
                                double.parse(length) <= 5 ||
                                double.parse(length) > 200)
                              setState(() => _validLength = false);
                            if (width == "" ||
                                double.parse(width) <= 5 ||
                                double.parse(width) > 200)
                              setState(() => _validWidth = false);
                            if (height == "" ||
                                double.parse(height) <= 5 ||
                                double.parse(height) > 200)
                              setState(() => _validHeight = false);
                            if (weight == "" ||
                                double.parse(weight) <= 0 ||
                                double.parse(weight) > 30000)
                              setState(() => _validWeight = false);
                            if (_validHeight &&
                                _validLength &&
                                _validName &&
                                _validWeight &&
                                _validWidth) {
                              setState(() {
                                _responseStatus = 0;
                                _responseMessage = "Adding parcel.";
                              });
                              var response = await postAuthData(
                                  '$SERVER_IP/company/add/parcel',
                                  {
                                    'name': name,
                                    'length': length,
                                    'width': width,
                                    'height': height,
                                    'weight': weight,
                                  },
                                  widget._token);

                              switch (response['status_code']) {
                                case 201:
                                  setState(() {
                                    _responseStatus = 200;
                                    _responseMessage = "Parcel added.";
                                  });
                                  break;
                                default:
                                  _responseStatus = 500;
                                  _responseMessage = "Error adding parcel.";
                                  break;
                              }
                            }
                          }, text: "Add Parcel"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ProcessLoading(responseStatus: _responseStatus, message: _responseMessage),
          ],
        ),
      ),
    );
  }
}
