import 'package:flutter/material.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';
import 'package:fromyama/utils/cColor.dart';

class CompanySetting extends StatefulWidget {
  final String _token;
  final bool _isHead;

  CompanySetting(this._token, this._isHead);

  @override
  _CompanySettingState createState() => _CompanySettingState();
}

class _CompanySettingState extends State<CompanySetting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: beige(),
      child: SafeArea(
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Company Info",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: "SFCR",
                      fontSize: 17,
                    ),
                  ),
                  TextField(
/*                     enabled: editText,
                    controller: _nameController, */
                    decoration: InputDecoration(
                      labelText: 'Company Name',
                      labelStyle: TextStyle(
                          color: Colors.grey[800], fontFamily: "SFCR"),
                      focusColor: Colors.grey[500],
                      hoverColor: Colors.grey[500],
                    ),
                  ),
                  Visibility(
                    visible: widget._isHead,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        color: blue(),
                        onPressed: () async {
                          /* if (!editText) {
                            setState(() {
                              editText = true;
                            });
                          } else {
                            await postAuthData(
                                '$SERVER_IP/user/update',
                                {
                                  "email": _emailController.text,
                                  "name": _nameController.text
                                },
                                widget._token);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) {
                              return Boot();
                            }));
                          } */
                        },
                        child: Text(
                          "Update",
                          //editText ? "Update" : "Edit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: "SFCM"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Details",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: "SFCR",
                      fontSize: 17,
                    ),
                  ),
/*                   Text(
                    "ID: ${widget._user.user_id}",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: "SFCR",
                    ),
                  ),
                  Text(
                    "Head of Company: ${widget._user.is_head}",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: "SFCR",
                    ),
                  ), */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
