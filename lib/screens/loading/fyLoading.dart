import 'package:flutter/material.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';

class FYLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/fulfill_fy.png'),
            height: 70,
          ),
          DotLoading(),
        ],
      ),
    );
  }
}
