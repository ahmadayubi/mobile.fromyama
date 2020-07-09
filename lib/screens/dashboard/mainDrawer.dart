import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fromyama/data/user.dart';
import 'package:fromyama/screens/dashboard/approveEmployee.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/login/loginForm.dart';
import 'package:fromyama/screens/platform/addAmazon.dart';
import 'package:fromyama/screens/platform/addEtsy.dart';
import 'package:fromyama/screens/platform/addShopify.dart';
import 'package:fromyama/screens/setting/settings.dart';
import 'package:fromyama/screens/signup/signUpCompany.dart';
import 'package:fromyama/screens/signup/signUpForm.dart';
import 'package:fromyama/screens/signup/signUpUser.dart';

final storage = FlutterSecureStorage();

class MainDrawer extends StatelessWidget {
  final User user;
  final String _token;

  MainDrawer(this.user, this._token);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: user == null
          ? DotLoading()
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 30, left: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back, ",
                              style: TextStyle(
                                fontFamily: 'SFCR',
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              user.name,
                              style: TextStyle(
                                fontFamily: 'SFCM',
                                fontSize: 35,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Divider(
                              color: Colors.grey[700],
                              height: 2,
                              endIndent: 10,
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text(
                          '${user.company}\nID ${user.company_id}',
                          style: TextStyle(
                            fontFamily: 'SFCM',
                            fontSize: 13,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ApproveEmployee(_token)));
                        },
                        leading: Icon(
                          Icons.add_circle,
                          color: new Color(0xffD6E198),
                        ),
                        title: Text(
                          'Accept Employees',
                          style: TextStyle(
                            fontFamily: 'SFCM',
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !user.platforms.contains('Shopify'),
                        child: ListTile(
                          leading: Icon(
                            Icons.add_circle,
                            color: Colors.yellow,
                          ),
                          title: Text(
                            "Connect Shopify",
                            style: TextStyle(
                              fontFamily: 'SFCM',
                              fontSize: 15,
                            ),
                          ),
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddShopify(_token)))
                          },
                        ),
                      ),
                      Visibility(
                        visible: !user.platforms.contains('Amazon'),
                        child: ListTile(
                          leading: Icon(
                            Icons.add_circle,
                            color: Colors.yellow,
                          ),
                          title: Text(
                            "Connect Amazon",
                            style: TextStyle(
                              fontFamily: 'SFCM',
                              fontSize: 15,
                            ),
                          ),
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddAmazon(_token)))
                          },
                        ),
                      ),
                      Visibility(
                        visible: !user.platforms.contains('Etsy'),
                        child: ListTile(
                          leading: Icon(
                            Icons.add_circle,
                            color: Colors.yellow,
                          ),
                          title: Text(
                            "Connect Etsy",
                            style: TextStyle(
                              fontFamily: 'SFCM',
                              fontSize: 15,
                            ),
                          ),
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddEtsy(_token)))
                          },
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text(
                          'Settings',
                          style: TextStyle(
                            fontFamily: 'SFCM',
                            fontSize: 15,
                          ),
                        ),
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Settings(_token, user)))
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text(
                          "Logout",
                          style: TextStyle(
                            fontFamily: 'SFCM',
                            fontSize: 15,
                          ),
                        ),
                        onTap: () async {
                          await storage.deleteAll();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) {
                            return LoginForm();
                          }));
                        },
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpForm()));
                        },
                        leading: Icon(
                          Icons.add_circle,
                          color: new Color(0xffD6E198),
                        ),
                        title: Text(
                          'Employee Sign up Page TEMP',
                          style: TextStyle(
                            fontFamily: 'SFCM',
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Connected Platform(s): ",
                        style: TextStyle(fontFamily: "SFCM", fontSize: 15),
                      ),
                      Visibility(
                        visible: user.platforms.contains('Amazon'),
                        child: Image(
                          image: AssetImage("assets/images/amazon_small.png"),
                          height: 20,
                        ),
                      ),
                      Visibility(
                        visible: user.platforms.contains('Etsy'),
                        child: Image(
                          image: AssetImage("assets/images/etsy_small.png"),
                          height: 20,
                        ),
                      ),
                      Visibility(
                        visible: user.platforms.contains('Shopify'),
                        child: Image(
                          image: AssetImage("assets/images/shopify_small.png"),
                          height: 20,
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  endIndent: 15,
                  indent: 15,
                  height: 2,
                  color: Colors.grey[700],
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Image(
                    image: AssetImage('assets/images/fulfill_fy.png'),
                    height: 50,
                  ),
                ),
              ],
            ),
    );
  }
}
