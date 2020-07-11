import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:fromyama/screens/signup/signUpCompany.dart';
import 'package:fromyama/screens/signup/signUpUser.dart';
import 'package:fromyama/utils/cColor.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            SignUpUser(),
            SignUpCompany(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: TabBar(
            unselectedLabelColor: Colors.grey[500],
            labelColor: Colors.grey[800],
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: blue(),
            tabs: [
              Tab(
                text: "Employee Signup",
              ),
              Tab(
                text: "Company Registration",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
