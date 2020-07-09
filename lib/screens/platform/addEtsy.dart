import 'package:flutter/material.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/platform/authBrowser.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/requests.dart';

class AddEtsy extends StatefulWidget {
  final String _token;

  AddEtsy(this._token);

  @override
  _AddEtsyState createState() => _AddEtsyState();
}

class _AddEtsyState extends State<AddEtsy> {
  final TextEditingController _shopNameController = TextEditingController();

  bool enableButton = false;

  @override
  void dispose() {
    _shopNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Connect Etsy",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "SFM",
          ),
        ),
      ),
      backgroundColor: new Color(0xfff9efe7),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/etsy_small.png'),
                  width: 100,
                ),
                DotLoading(
                    dotOneColor: Colors.redAccent,
                    dotTwoColor: Colors.orange,
                    dotThreeColor: Colors.orangeAccent,
                    duration: const Duration(milliseconds: 1000),
                    dotType: DotType.circle),
                Image(
                  image: AssetImage('assets/images/fulfill_fy.png'),
                  width: 200,
                ),
              ],
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
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller: _shopNameController,
                    onChanged: (value) {
                      if (value.length > 2) {
                        setState(() {
                          enableButton = true;
                        });
                      } else {
                        setState(() {
                          enableButton = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Etsy Shop Name',
                      labelStyle: TextStyle(
                          color: Colors.grey[800], fontFamily: "SFCR"),
                      focusColor: Colors.grey[500],
                      hoverColor: Colors.grey[500],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: 200,
                      height: 50,
                      child: RaisedButton(
                        color: orange(),
                        onPressed: enableButton
                            ? () async {
                                var shopName = _shopNameController.text;
                                var authLink = await postAuthData(
                                    '$SERVER_IP/etsy/token/request',
                                    {'shop': shopName},
                                    widget._token);
                                if (authLink != null) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AuthBrowser(
                                              authLink['login_url'],
                                              widget._token)));
                                } else {}
                              }
                            : null,
                        child: Text(
                          "Authorize",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "SFCM"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 50, right: 50, top: 5),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: "SFCR",
                      color: Colors.grey[800],
                    ),
                    children: [
                      TextSpan(text: "How Authorization Works:\n"),
                      TextSpan(
                          text:
                              "We do not store any passwords, authorization is done through "),
                      TextSpan(
                          text: "Etsy.",
                          style: TextStyle(color: Colors.orange)),
                      TextSpan(
                          text:
                              "They will notify you of what parts of your shop FromYama will have access to.")
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
