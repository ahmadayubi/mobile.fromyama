import 'package:flutter/material.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/platform/authBrowser.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/requests.dart';

class AddEtsy extends StatelessWidget {
  final TextEditingController _shopNameController = TextEditingController();
  final String _token;

  AddEtsy(this._token);

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
                DotLoading(),
                Image(
                  image: AssetImage('assets/images/fromyama.png'),
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
                        onPressed: () async {
                          var shopName = _shopNameController.text;
                          var authLink = await postAuthData(
                              '$SERVER_IP/etsy/token/request',
                              {'shop': shopName},
                              _token);
                          if (authLink != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthBrowser(
                                        authLink['login_url'], _token)));
                          } else {}
                        },
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
