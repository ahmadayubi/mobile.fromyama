import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/utils/cColor.dart';
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
      _validName = true,
      _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                onChanged: (value) {
                  setState(() {
                    _validName = true;
                  });
                },
                decoration: InputDecoration(
                    errorText: _validName ? null : "Invalid Name",
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
                    focusColor: Colors.grey[500],
                    hoverColor: Colors.grey[500],
                    labelText: 'Name'),
              ),
              TextField(
                controller: _lengthController,
                onChanged: (value) {
                  setState(() {
                    _validLength = true;
                  });
                },
                decoration: InputDecoration(
                    errorText: _validLength ? null : "Invalid Length",
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
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
                onChanged: (value) {
                  setState(() {
                    _validWidth = true;
                  });
                },
                decoration: InputDecoration(
                    errorText: _validWidth ? null : "Invalid Length",
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
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
                onChanged: (value) {
                  setState(() {
                    _validHeight = true;
                  });
                },
                decoration: InputDecoration(
                    errorText: _validHeight ? null : "Invalid Length",
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
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
                onChanged: (value) {
                  setState(() {
                    _validWeight = true;
                  });
                },
                decoration: InputDecoration(
                    errorText: _validWeight ? null : "Invalid Length",
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
                      "Add Parcel",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "SFCM"),
                    ),
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      var name = _nameController.text;
                      var length = _lengthController.text;
                      var width = _widthController.text;
                      var height = _heightController.text;
                      var weight = _weightController.text;

                      var response = await postAuthData(
                          '$SERVER_IP/company/parcel/add',
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
                          Navigator.pop(context);
                          break;
                        default:
                          break;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Visibility(
                visible: _loading,
                child: DotLoading(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
