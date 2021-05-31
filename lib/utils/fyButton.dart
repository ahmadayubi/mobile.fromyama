import 'package:flutter/material.dart';
import 'package:fromyama/utils/cColor.dart';

class FYButton extends StatelessWidget {
  const FYButton(
      {this.onPressed,
        this.text,
        this.fontSize = 15.0});

  final GestureTapCallback onPressed;
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: blue(),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
          color: Colors.white,fontSize: fontSize, fontFamily: "SFCM"),
        ),
      ),
    );
  }
}
