import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fromyama/data/user.dart';
import 'package:fromyama/screens/dashboard/approveEmployee.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/login/loginForm.dart';
import 'package:fromyama/screens/platform/addShopify.dart';
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
                                fontFamily: 'SFM',
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              user.name,
                              style: TextStyle(
                                fontFamily: 'SFM',
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
                        leading: Icon(Icons.email),
                        title: Text(
                          user.email,
                          style: TextStyle(
                            fontFamily: 'SFCM',
                            fontSize: 15,
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
                      user.platforms.contains('Shopify')
                          ? ListTile(
                              leading: Icon(
                                Icons.check_circle,
                                color: new Color(0xffD6E198),
                              ),
                              title: Text(
                                "Shopify Store Added",
                                style: TextStyle(
                                  fontFamily: 'SFCM',
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : ListTile(
                              leading: Icon(
                                Icons.add_circle,
                                color: Colors.yellow,
                              ),
                              title: Text(
                                "Add Shopify Store",
                                style: TextStyle(
                                  fontFamily: 'SFCM',
                                  fontSize: 15,
                                ),
                              ),
                              onTap: () => {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddShopify(_token)))
                              },
                            ),
                      user.platforms.contains('Amazon')
                          ? ListTile(
                              leading: Icon(
                                Icons.check_circle,
                                color: new Color(0xffD6E198),
                              ),
                              title: Text(
                                "Amazon Store Added",
                                style: TextStyle(
                                  fontFamily: 'SFCM',
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : ListTile(
                              leading: Icon(
                                Icons.add_circle,
                                color: Colors.yellow,
                              ),
                              title: Text(
                                "Add Amazon Store",
                                style: TextStyle(
                                  fontFamily: 'SFCM',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                      user.platforms.contains('Etsy')
                          ? ListTile(
                              leading: Icon(
                                Icons.check_circle,
                                color: new Color(0xffD6E198),
                              ),
                              title: Text(
                                "Etsy Store Added",
                                style: TextStyle(
                                  fontFamily: 'SFCM',
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : ListTile(
                              leading: Icon(
                                Icons.add_circle,
                                color: Colors.yellow,
                              ),
                              title: Text(
                                "Add Etsy Store",
                                style: TextStyle(
                                  fontFamily: 'SFCM',
                                  fontSize: 15,
                                ),
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
                Divider(
                  endIndent: 15,
                  indent: 15,
                  height: 2,
                  color: Colors.grey[700],
                ),
                Container(
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('assets/images/fromyama.png'),
                        width: 90,
                        height: 90,
                      ),
                      Text(
                        "FromYama 2020",
                        style: TextStyle(
                          fontFamily: "SFCM",
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
