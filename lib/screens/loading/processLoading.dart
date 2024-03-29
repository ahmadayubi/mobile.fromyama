import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/utils/cColor.dart';

class ProcessLoading extends StatelessWidget {
  const ProcessLoading({this.responseStatus, this.message, this.showBackButton = true});

  final String message;
  final int responseStatus;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: responseStatus != -1,
      child: Container(
        padding: const EdgeInsets.all(5),
        color: new Color(0x77000000),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize:
                MainAxisSize.min, // To make the card compact
                children: <Widget>[
                  SizedBox(
                      height: 30,
                      child: (responseStatus >= 200 && responseStatus < 300) ?
                      Icon(
                        Icons.check_circle,
                        color: new Color(0xffbbd984),
                        size: 25.0,
                      ) :  responseStatus == 500 ?
                      Icon(
                        Icons.error,
                        color: red(),
                        size: 25.0,
                      ) : DotLoading()),
                  SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: responseStatus == -1 ? 0.0 : 1.0,
                          duration: Duration(milliseconds: 1000),
                          child: Text(
                            message,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "SFCM",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showBackButton,
                    child: TextButton(
                      onPressed: (responseStatus >= 200 && responseStatus < 300) || responseStatus == 500 ? () {
                        Navigator.of(context).pop();
                      } : null,
                      child: Text("Go Back To Main Dashboard"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
