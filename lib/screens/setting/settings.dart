import 'package:flutter/material.dart';
import 'package:fromyama/data/user.dart';
import 'package:fromyama/screens/setting/companySetting.dart';
import 'package:fromyama/screens/setting/userSetting.dart';

class Settings extends StatelessWidget {
  final String _token;
  final User _user;

  Settings(this._token, this._user);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Settings",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "SFM",
            ),
          ),
        ),
        body: TabBarView(
          children: [
            UserSetting(_token, _user),
            CompanySetting(_token),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: new Color(0xfff9efe7),
          child: TabBar(
            unselectedLabelColor: Colors.grey[500],
            labelColor: Colors.grey[800],
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.orangeAccent,
            tabs: [
              Tab(
                text: "User Settings",
              ),
              Tab(
                text: "Company Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
