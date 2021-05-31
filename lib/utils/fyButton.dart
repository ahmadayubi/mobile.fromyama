import 'package:flutter/material.dart';
import 'package:fromyama/utils/cColor.dart';

class FYButton extends StatelessWidget {
  const FYButton({this.onPressed, this.text});

  final GestureTapCallback onPressed;
  final String text;

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
              color: Colors.white,
              fontSize: 15,
              fontFamily: "SFCM"),
        ),
      ),
    );
  }
}
