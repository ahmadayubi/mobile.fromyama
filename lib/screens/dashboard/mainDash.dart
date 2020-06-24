import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fromyama/utils/requests.dart';

const SERVER_IP = 'https://92a1d28ff629.ngrok.io';
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
                    return CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(snapshot.data['products'][0]['product']);
                    }
                }
              },
            ),
          ),
        ),
      );
}
