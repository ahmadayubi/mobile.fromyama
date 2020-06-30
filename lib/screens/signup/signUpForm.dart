import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:fromyama/screens/signup/signUpCompany.dart';
import 'package:fromyama/screens/signup/signUpUser.dart';

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
          color: new Color(0xfff9efe7),
          child: TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: new BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: Colors.orangeAccent,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
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
