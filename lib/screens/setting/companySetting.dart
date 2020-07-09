import 'package:flutter/material.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';

class CompanySetting extends StatelessWidget {
  final String _token;

  CompanySetting(this._token);

  @override
  Widget build(BuildContext context) {
    return FYLoading();
    /* Container(
      color: new Color(0xfff9efe7),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [],
          ),
        ),
      ),
    ); */
  }
}
