import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fromyama/data/user.dart';
import 'package:fromyama/screens/dashboard/approveEmployee.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/login/loginForm.dart';
import 'package:fromyama/screens/platform/addAmazon.dart';
import 'package:fromyama/screens/platform/addEtsy.dart';
import 'package:fromyama/screens/platform/addShopify.dart';
import 'package:fromyama/screens/postage/addParcel.dart';
import 'package:fromyama/screens/postage/addPayment.dart';
import 'package:fromyama/screens/postage/checkRate.dart';
import 'package:fromyama/screens/setting/settings.dart';
import 'package:fromyama/screens/signup/signUpCompany.dart';
import 'package:fromyama/screens/signup/signUpForm.dart';
import 'package:fromyama/screens/signup/signUpUser.dart';
import 'package:fromyama/utils/cColor.dart';

final storage = FlutterSecureStorage();

class MainDrawer extends StatelessWidget {
  final User user;
  final String _token;
  final Map<String, dynamic> _platforms;

  MainDrawer(this.user, this._token, this._platforms);

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
                        child: Row(children: [
                          Icon(
                            Icons.supervised_user_circle,
                            size: 50,
                            color: Colors.grey[800],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: TextStyle(
                                  fontFamily: 'SFCM',
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                user.email,
                                style: TextStyle(
                                  fontFamily: 'SFCR',
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                            ],
                          ),
                        ]),
                      ),
                      Tooltip(
                        message: "Company ID copied to clipboard.",
                        child: ListTile(
                          onTap: (){
                            Clipboard.setData(ClipboardData(text: user.company_id));
                          },
                          leading: Icon(Icons.store),
                          title: Text(
                            '${user.company}',
                            style: TextStyle(
                              fontFamily: 'SFCM',
                              fontSize: 15,
                            ),
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
                          color: green(),
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
                        visible: !_platforms["shopify_connected"],
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
                        visible: !_platforms["amazon_connected"],
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
                        visible: !_platforms["etsy_connected"],
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
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddParcel(_token)));
                        },
                        leading: Icon(
                          Icons.add_circle,
                          color: new Color(0xffD6E198),
                        ),
                        title: Text(
                          'Add Parcel TEMP',
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
                                  builder: (context) => AddPayment(_token)));
                        },
                        leading: Icon(
                          Icons.add_circle,
                          color: new Color(0xffD6E198),
                        ),
                        title: Text(
                          'Add Payment TEMP',
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
                        visible: _platforms["amazon_connected"],
                        child: Image(
                          image: AssetImage("assets/images/amazon_small.png"),
                          height: 20,
                        ),
                      ),
                      Visibility(
                        visible: _platforms["etsy_connected"],
                        child: Image(
                          image: AssetImage("assets/images/etsy_small.png"),
                          height: 20,
                        ),
                      ),
                      Visibility(
                        visible: _platforms["shopify_connected"],
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
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image(
                      image: AssetImage('assets/images/fulfill_fy.png'),
                      height: 30,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
