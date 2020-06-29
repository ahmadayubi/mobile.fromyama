import 'package:flutter/material.dart';
import 'package:fromyama/data/user.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/platform/addShopify.dart';

class MainDrawer extends StatelessWidget {
  User user;
  String _token;

  MainDrawer(this.user, this._token);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: user == null
          ? DotLoading()
          : ListView(
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      Text(
                        "Welcome Back, ",
                        style: TextStyle(
                          fontFamily: 'Kaoly',
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        user.name,
                        style: TextStyle(
                          fontFamily: 'Kaoly',
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(color: new Color(0xfffaebd7)),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text(user.company),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text(user.email),
                ),
                ListTile(
                  leading: Icon(Icons.perm_identity),
                  title: Text(user.user_id),
                ),
                user.platforms.contains('Shopify')
                    ? ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: Text("Shopify Store Added"),
                      )
                    : ListTile(
                        leading: Icon(
                          Icons.add_circle,
                          color: Colors.green,
                        ),
                        title: Text("Add Shopify Store"),
                        onTap: () => {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddShopify(_token)))
                        },
                      ),
                user.platforms.contains('Amazon')
                    ? ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: Text("Amazon Store Added"),
                      )
                    : ListTile(
                        leading: Icon(
                          Icons.add_circle,
                          color: Colors.green,
                        ),
                        title: Text("Add Amazon Store"),
                      ),
                user.platforms.contains('Etsy')
                    ? ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: Text("Etsy Store Added"),
                      )
                    : ListTile(
                        leading: Icon(
                          Icons.add_circle,
                          color: Colors.green,
                        ),
                        title: Text("Add Etsy Store"),
                      ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                )
              ],
            ),
    );
  }
}
