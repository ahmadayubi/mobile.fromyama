import 'package:flutter/material.dart';

class FulfillOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/fromyama.png'),
            ),
            Text("Order Fulfilled"),
          ],
        ),
      ),
    );
  }
}
