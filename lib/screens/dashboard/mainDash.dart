import 'package:flutter/material.dart';
import 'package:fromyama/data/amazonOrder.dart';
import 'package:fromyama/data/user.dart';
import 'package:fromyama/screens/dashboard/mainDrawer.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/login/loginForm.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/widgets/etsyOrderWidget.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';
import 'package:fromyama/widgets/shopifyOrderWidget.dart';
import 'package:fromyama/widgets/amazonOrderWidget.dart';

class MainDash extends StatefulWidget {
  final _token;

  MainDash(this._token);

  @override
  _MainDashState createState() => _MainDashState();
}

class _MainDashState extends State<MainDash> {
  void initState() {
    super.initState();
    getUser();
  }

  List<dynamic> _orders = [];
  bool _checked = false;
  User user;

  Future<void> _getData() async {
    setState(() {
      getOrders();
    });
  }

  void getUser() async {
    var result = await getAuthData('$SERVER_IP/user/details', widget._token);
    try {
      setState(() {
        user = User.fromJson(result);
      });
    } catch (error) {}
    getOrders();
  }

  void getOrders() async {
    var amazonList = [], shopifyList = [], etsyList = [];
    if (user.platforms.contains("Shopify")) {
      var shopifyOrders = await getAuthData(
          '$SERVER_IP/shopify/order/unfulfilled', widget._token);
      if (shopifyOrders['status_code'] == 200) {
        shopifyList = shopifyOrders['orders'].map((order) {
          return ShopifyOrder.fromJson(order);
        }).toList();
      }
    }
    if (user.platforms.contains("Amazon")) {
      var amazonOrders = await getAuthData(
          '$SERVER_IP/amazon/order/unfulfilled', widget._token);
      if (amazonOrders['status_code'] == 200) {
        amazonList = amazonOrders['orders'].map((order) {
          return AmazonOrder.fromJson(order);
        }).toList();
      }
    }
    if (user.platforms.contains("Etsy")) {
      var etsyOrders =
          await getAuthData('$SERVER_IP/etsy/order/unfulfilled', widget._token);
    }
    List<dynamic> sortedList = shopifyList + amazonList + etsyList;
    try {
      setState(() {
        _orders = sortedList;
        _checked = true;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Unfulfilled Orders",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "SFM",
            ),
          ),
        ),
        drawer: MainDrawer(user, widget._token),
        backgroundColor: beige(),
        body: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: _orders.length != 0
                      ? RefreshIndicator(
                          child: ListView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: _orders.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (_orders[index] is ShopifyOrder) {
                                  return shopifyOrderWidget(
                                      _orders[index], context, widget._token);
                                } else if (_orders[index] is AmazonOrder) {
                                  return amazonOrderWidget(
                                      _orders[index], context, widget._token);
                                } else {
                                  return Text("Error");
                                }
                              }),
                          onRefresh: _getData,
                        )
                      : _checked
                          ? RefreshIndicator(
                              child: Stack(
                                children: [
                                  ListView(
                                    children: [Center(child: Text(""))],
                                  ),
                                  Center(
                                    child: Text(
                                      "No Unfulfilled Orders",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "SFCR",
                                          color: Colors.grey[800]),
                                    ),
                                  )
                                ],
                              ),
                              onRefresh: _getData,
                            )
                          : Center(child: DotLoading()),
                ),
              ],
            ),
          ),
        ),
      );
}
