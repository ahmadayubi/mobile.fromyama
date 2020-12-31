import 'package:flutter/material.dart';
import 'package:fromyama/data/amazonOrder.dart';
import 'package:fromyama/data/etsyOrder.dart';
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
  bool _loading = false;
  int _numOrders = 0;
  Map<String, dynamic> platforms;
  bool _approved = true;

  Future<void> _getData() async {
    if (this.mounted) {
      setState(() {
        _loading = true;
        getOrders();
      });
    }
  }

  void getUser() async {
    var result = User.fromJson(
        await getAuthData('$SERVER_IP/user/details', widget._token));

    if (result.is_approved) {
      if (this.mounted) {
        try {
          setState(() {
            user = result;
          });
        } catch (error) {}
      }
      getOrders();
    } else {
      setState(() {
        _approved = false;
      });
    }
  }

  void getOrders() async {
    var amazonList = [], shopifyList = [], etsyList = [];
    platforms =
        await getAuthData('$SERVER_IP/company/platforms', widget._token);
    if (platforms["shopify_connected"]) {
      var shopifyOrders =
          await getAuthData('$SERVER_IP/shopify/orders/all', widget._token);
      if (shopifyOrders['status_code'] == 200 &&
          shopifyOrders["orders"] != null) {
        shopifyList = shopifyOrders['orders'].map((order) {
          return ShopifyOrder.fromJson(order);
        }).toList();
      }
    }
    if (platforms["amazon_connected"]) {
      /* var amazonOrders = await getAuthData(
          '$SERVER_IP/amazon/order/unfulfilled', widget._token); */
      var amazonOrders =
          await getAuthData('$SERVER_IP/amazon/orders/all', widget._token);
      if (amazonOrders['status_code'] == 200 &&
          amazonOrders["orders"] != null) {
        amazonList = amazonOrders['orders'].map((order) {
          return AmazonOrder.fromJson(order);
        }).toList();
      }
    }
    if (platforms["etsy_connected"]) {
      var etsyOrders =
          await getAuthData('$SERVER_IP/etsy/orders/all', widget._token);
      if (etsyOrders['status_code'] == 200 && etsyOrders["orders"] != null) {
        etsyList = etsyOrders['orders'].map((order) {
          return EtsyOrder.fromJson(order);
        }).toList();
      }
    }
    List<dynamic> sortedList = shopifyList + amazonList + etsyList;
    if (this.mounted) {
      try {
        setState(() {
          _orders = sortedList;
          _checked = true;
          _loading = false;
          _numOrders = _orders.length;
        });
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Unfulfilled Orders ($_numOrders)',
            style: TextStyle(
              color: Colors.black,
              fontFamily: "SFM",
            ),
          ),
        ),
        drawer: MainDrawer(user, widget._token, platforms),
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
                          child: Stack(
                            children: [
                              Center(
                                child: Visibility(
                                  visible: _loading,
                                  child: DotLoading(),
                                ),
                              ),
                              ListView.builder(
                                  padding: EdgeInsets.all(8),
                                  itemCount: _orders.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (_orders[index] is ShopifyOrder) {
                                      return shopifyOrderWidget(_orders[index],
                                          context, widget._token, getOrders);
                                    } else if (_orders[index] is AmazonOrder) {
                                      return amazonOrderWidget(_orders[index],
                                          context, widget._token);
                                    } else if (_orders[index] is EtsyOrder) {
                                      return etsyOrderWidget(_orders[index],
                                          context, widget._token);
                                    } else {
                                      return Text("Error");
                                    }
                                  }),
                            ],
                          ),
                          onRefresh: _getData,
                        )
                      : _checked
                          ? RefreshIndicator(
                              child: Stack(
                                children: [
                                  Center(
                                    child: Visibility(
                                      visible: _loading,
                                      child: DotLoading(),
                                    ),
                                  ),
                                  ListView(
                                    children: [Center(child: Text(""))],
                                  ),
                                  Center(
                                    child: Visibility(
                                      visible: !_loading,
                                      child: Text(
                                        "No Unfulfilled Orders",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "SFCR",
                                            color: Colors.grey[800]),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              onRefresh: _getData,
                            )
                          : Center(
                              child: DotLoading(),
                            ),
                ),
              ],
            ),
          ),
        ),
      );
}
