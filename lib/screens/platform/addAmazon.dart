import 'package:flutter/material.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/platform/authBrowser.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/requests.dart';

class AddAmazon extends StatefulWidget {
  final String _token;

  AddAmazon(this._token);

  @override
  _AddAmazonState createState() => _AddAmazonState();
}

class _AddAmazonState extends State<AddAmazon> {
  final TextEditingController _authController = TextEditingController();
  final TextEditingController _sellerController = TextEditingController();

  bool sellerEnabled = false;
  bool authEnabled = false;
  bool trackingEnabled = false;
  String marketplaceValue;

  @override
  void dispose() {
    _authController.dispose();
    _sellerController.dispose();
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
          "Connect Amazon",
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
                  image: AssetImage('assets/images/amazon_small.png'),
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
                    controller: _sellerController,
                    onChanged: (value) {
                      if (value.length > 2) {
                        setState(() {
                          sellerEnabled = true;
                        });
                      } else {
                        setState(() {
                          sellerEnabled = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Seller ID',
                      labelStyle: TextStyle(
                          color: Colors.grey[800], fontFamily: "SFCR"),
                      focusColor: Colors.grey[500],
                      hoverColor: Colors.grey[500],
                    ),
                  ),
                  TextField(
                    controller: _authController,
                    onChanged: (value) {
                      if (value.length > 2) {
                        setState(() {
                          authEnabled = true;
                        });
                      } else {
                        setState(() {
                          authEnabled = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'MWS Auth Token',
                      labelStyle: TextStyle(
                          color: Colors.grey[800], fontFamily: "SFCR"),
                      focusColor: Colors.grey[500],
                      hoverColor: Colors.grey[500],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Marketplace: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "SFCR",
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: marketplaceValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.grey[800], fontFamily: "SFCR"),
                          underline: Container(
                            height: 2,
                            color: Colors.grey[500],
                          ),
                          onChanged: (String newMarket) {
                            setState(() {
                              trackingEnabled = true;
                              marketplaceValue = newMarket;
                            });
                          },
                          items: <List>[
                            ["mws.amazonservices.ca", "A2EUQ1WTGCTBG2"],
                            ["mws.amazonservices.com", "ATVPDKIKX0DER"],
                          ].map<DropdownMenuItem<String>>((List market) {
                            return DropdownMenuItem<String>(
                              value: market[1],
                              child: Text(
                                market[0],
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: 200,
                      height: 50,
                      child: RaisedButton(
                        color: orange(),
                        onPressed:
                            authEnabled && sellerEnabled && trackingEnabled
                                ? () async {
                                    var authToken = _authController.text;
                                    var sellerID = _sellerController.text;
                                    var marketplace = marketplaceValue;
                                    var response = await postAuthData(
                                        '$SERVER_IP/amazon/authorize',
                                        {
                                          'amazon_seller_id': sellerID,
                                          'amazon_auth_token': authToken,
                                          'amazon_marketplace': marketplace
                                        },
                                        widget._token);
                                    if (response['status_code'] == 200) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MainDash(widget._token),
                                        ),
                                      );
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
            Text(
              "Don't Know Your MWS Auth Token or Seller ID?",
              style: TextStyle(
                fontFamily: "SFCR",
                color: Colors.grey[800],
                fontSize: 19,
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
                      TextSpan(
                          text:
                              "1. Goto your Amazon Seller dashboard\n2. Under Apps & Services, click Discover Apps\n"),
                      TextSpan(
                          text:
                              "3. Search for FromYama\n4. Then Select Authorize Now\n\nAmazon will then provide all the information needed, simply copy the provided information into here.")
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
