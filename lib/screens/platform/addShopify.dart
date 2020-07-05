import 'package:flutter/material.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/platform/authBrowser.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/requests.dart';

class AddShopify extends StatelessWidget {
  final TextEditingController _shopNameController = TextEditingController();
  final String _token;

  AddShopify(this._token);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Connect Shopify",
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
                  image: AssetImage('assets/images/shopify_small.png'),
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
                      labelText: 'Shopify Shop Name',
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
                              '$SERVER_IP/shopify/get_auth_url',
                              {'shop': shopName},
                              _token);
                          if (authLink != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthBrowser(
                                        authLink['authLink'], _token)));
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
                          text: "Shopify.",
                          style: TextStyle(color: Colors.green)),
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
