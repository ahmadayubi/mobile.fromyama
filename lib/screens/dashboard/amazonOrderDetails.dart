import 'package:flutter/material.dart';

class AmazonOrderDetails extends StatelessWidget {
  final int index;

  AmazonOrderDetails(this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('This is the details for $index'),
      ),
    );
  }
}
