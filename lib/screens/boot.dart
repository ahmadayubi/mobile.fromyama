import 'package:flutter/material.dart';
import 'package:fromyama/controllers/boot/bootController.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/screens/login/loginForm.dart';

const SERVER_IP = 'https://92a1d28ff629.ngrok.io';

class Boot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: alreadyLoggedIn(SERVER_IP),
            builder: (BuildContext context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == "") {
                    return LoginForm();
                  } else {
                    return MainDash(snapshot.data);
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
