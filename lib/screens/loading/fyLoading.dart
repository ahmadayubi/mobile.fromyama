import 'package:flutter/material.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';

class FYLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/fromyama.png'),
            ),
            DotLoading(),
          ],
        ),
      ),
    );
  }
}
