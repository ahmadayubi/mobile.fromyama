import 'package:flutter/material.dart';
import 'package:fromyama/screens/platform/authShopify.dart';
import 'package:fromyama/utils/requests.dart';

class AddShopify extends StatelessWidget {
  final TextEditingController _shopNameController = TextEditingController();
  final String _token;

  AddShopify(this._token);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _shopNameController,
            decoration: InputDecoration(labelText: 'Shopify Shop Name'),
          ),
          FlatButton(
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
                        builder: (context) =>
                            AuthShopify(authLink['authLink'], _token)));
              } else {}
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }
}
