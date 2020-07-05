import 'package:flutter/material.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthBrowser extends StatelessWidget {
  final String _url;
  final String _token;

  AuthBrowser(this._url, this._token);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Account'),
        backgroundColor: Colors.orange,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MainDash(_token)))),
      ),
      body: WebView(
        initialUrl: _url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
