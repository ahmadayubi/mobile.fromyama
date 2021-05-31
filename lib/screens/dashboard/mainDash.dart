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
import 'package:fromyama/screens/loading/fyLoading.dart';
import 'package:fromyama/widgets/orderTile.dart';
import 'package:fromyama/controllers/dashboard/mainDash.dart';

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
  bool _approved = false;

  Future<void> _getData() async {
    if (this.mounted) {
      setState(() {
        _loading = true;
        getOrders();
      });
    }
  }

  void getUser() async {
    User user = await getUserDetails(widget._token);
    if (user.is_approved) {
      if (this.mounted) {
        try {
          setState(() {
            _approved = true;
            this.user = user;
          });
        } catch (error) {}
      }
      getOrders();
    }
  }

  void getOrders() async {
    platforms = await getPlatforms(widget._token);
    List<dynamic> sortedList =
        await getUnfulfilledOrders(widget._token, platforms);
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
            child: _approved
                ? Column(
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
                                        itemBuilder: (BuildContext context, int index) {
                                          return OrderTile(_orders[index], widget._token, getOrders);
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
                  )
                : user == null ? Text("Not Approved Yet.") : DotLoading(),
          ),
        ),
      );
}
