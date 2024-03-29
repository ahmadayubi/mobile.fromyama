import 'package:flutter/material.dart';
import 'package:fromyama/controllers/boot/bootController.dart';
import 'package:fromyama/screens/dashboard/approveEmployee.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/screens/login/loginForm.dart';
import 'package:fromyama/screens/platform/addShopify.dart';
import 'package:fromyama/screens/signup/signUpCompany.dart';
import 'package:fromyama/screens/signup/signUpUser.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';

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
                  return FYLoading();
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == "") {
                    return LoginForm();
                  } else {
                    //return SignUpCompany();
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
