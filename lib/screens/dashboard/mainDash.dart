import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  }

  List<dynamic> _orders = [];

  Future<void> _getData() async {
    setState(() {
      getOrders();
    });
  }

  void getOrders() async {
    var result = await getAuthData('$SERVER_IP/order/all', widget._token);
    setState(() {
      _orders = result['products']
          .map((order) => ShopifyOrder.fromJson(order))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
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
                Expanded(
                  child: _orders.length != 0
                      ? RefreshIndicator(
                          child: ListView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: _orders.length,
                              itemBuilder: (BuildContext context, int index) {
                                return shopifyOrderWidget(
                                    _orders[index], context, widget._token);
                              }),
                          onRefresh: _getData,
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ),
      );
}
