import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/widgets/etsyOrderWidget.dart';
import 'package:fromyama/widgets/fyLoading.dart';
import 'package:fromyama/widgets/shopifyOrderWidget.dart';
import 'package:fromyama/widgets/amazonOrderWidget.dart';

final storage = FlutterSecureStorage();

class MainDash extends StatefulWidget {
  final _token;

  MainDash(this._token);

  @override
  _MainDashState createState() => _MainDashState();
}

class _MainDashState extends State<MainDash> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SafeArea(
            child: FutureBuilder(
              future: getAuthData('$SERVER_IP/order/all', widget._token),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return FYLoading();
                  default:
                    //user is not authorized by the company yet
                    if (snapshot.data['status_code'] == 403) {
                      return Text("Not Yet Authorized By The Company.");
                    }
                    List<ShopifyOrder> sOrderList = [];
                    for (int i = 0; i < snapshot.data['products'].length; i++) {
                      var temp =
                          ShopifyOrder.fromJson(snapshot.data['products'][i]);
                      sOrderList.add(temp);
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return new ListView.builder(
                        itemCount: snapshot.data['products'].length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index >= snapshot.data['products'].length / 2) {
                            return shopifyOrderWidget(
                                sOrderList[index], context, widget._token);
                          } else if (index <
                                  snapshot.data['products'].length / 2 &&
                              index >= 2) {
                            return etsyOrderWidget(
                                sOrderList[index], context, widget._token);
                          }
                          return amazonOrderWidget(
                              sOrderList[index], context, widget._token);
                        },
                      );
                    }
                }
              },
            ),
          ),
        ),
      );
}
