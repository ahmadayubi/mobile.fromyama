import 'package:flutter/material.dart';

class ShopifyOrderDetails extends StatelessWidget {
  final int index;

  ShopifyOrderDetails(this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('This is the details for $index'),
      ),
    );
  }
}
