import 'package:flutter/material.dart';

class EtsyOrderDetails extends StatelessWidget {
  final int index;

  EtsyOrderDetails(this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('This is the details for $index'),
      ),
    );
  }
}
