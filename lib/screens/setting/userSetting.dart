import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fromyama/data/user.dart';
import 'package:fromyama/screens/boot.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/fyButton.dart';
import 'package:fromyama/utils/requests.dart';

class UserSetting extends StatefulWidget {
  final String _token;
  final User _user;

  UserSetting(this._token, this._user);

  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool editText = false;

  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController(text: '${widget._user.name}');
    _emailController = new TextEditingController(text: '${widget._user.email}');
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
                    "Profile Info",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: "SFCR",
                      fontSize: 17,
                    ),
                  ),
                  TextField(
                    enabled: editText,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                          color: Colors.grey[800], fontFamily: "SFCR"),
                      focusColor: Colors.grey[500],
                      hoverColor: Colors.grey[500],
                    ),
                  ),
                  TextField(
                    enabled: editText,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          color: Colors.grey[800], fontFamily: "SFCR"),
                      focusColor: Colors.grey[500],
                      hoverColor: Colors.grey[500],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FYButton(
                      onPressed: () async {
                        if (!editText) {
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
                        }
                      },
                      text: editText ? "Update" : "Edit",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ID: ${widget._user.id}",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontFamily: "SFCR",
                        ),
                      ),
                      Container(
                        width: 40,
                        child: TextButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: widget._user.id));
                          },
                          child: Icon(
                            Icons.copy,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Role: ${widget._user.is_head ? "Head":"Employee"}",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: "SFCR",
                    ),
                  ),
                  Text(
                    "Approval Status: ${widget._user.is_approved ? "Approved":"Pending"}",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: "SFCR",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
