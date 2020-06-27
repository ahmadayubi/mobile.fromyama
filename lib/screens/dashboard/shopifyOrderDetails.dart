import 'package:flutter/material.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/widgets/fyLoading.dart';

class ShopifyOrderDetails extends StatelessWidget {
  final int index;

  ShopifyOrderDetails(this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getAuthData('$SERVER_IP/order/$index', "index"),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return FYLoading();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text("HERE");
                }
            }
          },
        ),
      ),
    );
  }
}
