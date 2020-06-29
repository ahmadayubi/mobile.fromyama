import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fromyama/data/user.dart';
import 'package:fromyama/screens/dashboard/mainDrawer.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/login/loginForm.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/widgets/etsyOrderWidget.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';
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
  void initState() {
    super.initState();
    getOrders();
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
  }

  void getOrders() async {
    var result =
        await getAuthData('$SERVER_IP/order/unfulfilled/all', widget._token);
    try {
      setState(() {
        _orders = result['orders'].map((order) {
          switch (order['type']) {
            case "Shopify":
              return ShopifyOrder.fromJson(order);
              break;
          }
        }).toList();
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Unfilfulled Orders",
            style: TextStyle(
              fontFamily: 'NewYork',
              fontSize: 30,
            ),
          ),
          backgroundColor: Colors.orangeAccent,
        ),
        drawer: MainDrawer(user, widget._token),
        backgroundColor: new Color(0xfffaebd7),
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
                                } else {
                                  return Text("Error");
                                }
                              }),
                          onRefresh: _getData,
                        )
                      : _checked
                          ? RefreshIndicator(
                              child: ListView(
                                children: [Center(child: Text("No Orders"))],
                              ),
                              onRefresh: _getData,
                            )
                          : Center(child: DotLoading()),
                ),
                FlatButton(
                  onPressed: () async {
                    await storage.deleteAll();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) {
                      return LoginForm();
                    }));
                  },
                  child: Text("Logout"),
                ),
              ],
            ),
          ),
        ),
      );
}
