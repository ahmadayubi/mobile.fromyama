import 'package:flutter/material.dart';
import 'package:fromyama/screens/login/loginForm.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/requests.dart';

class SignUpUser extends StatefulWidget {
  @override
  _SignUpUserState createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _validName, _validPassword, _validCompany, _validEmail;
  String _companyError = "", _emailError = "";

  void initState() {
    _validEmail = true;
    _validPassword = true;
    _validCompany = true;
    _validName = true;
    super.initState();
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _companyController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: new Color(0xfff9efe7),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Container(
                height: 300,
                child: Stack(
                  children: [
                    Positioned(
                      left: 50,
                      child: Image(
                        image: AssetImage('assets/images/amazon_box.png'),
                        height: 200,
                      ),
                    ),
                    Positioned(
                      left: 175,
                      top: 80,
                      child: Image(
                        image: AssetImage('assets/images/shopify_box.png'),
                        height: 150,
                      ),
                    ),
                    Positioned(
                      left: 195,
                      top: 60,
                      child: Image(
                        image: AssetImage('assets/images/etsy_box.png'),
                        height: 100,
                      ),
                    ),
                    Positioned(
                      child: Image(
                        image: AssetImage('assets/images/fromyama.png'),
                        height: 300,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.1,
                      blurRadius: 2,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Start Fulfilling All Your Orders In One Place",
                      style: TextStyle(
                        fontFamily: "SFCM",
                        fontSize: 20,
                      ),
                    ),
                    Divider(),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          errorText:
                              _validName ? null : "Please Enter A Valid Name",
                          labelStyle: TextStyle(
                              color: Colors.grey[800], fontFamily: "SFCR"),
                          focusColor: Colors.grey[500],
                          hoverColor: Colors.grey[500],
                          labelText: 'Full Name'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          errorText: _validEmail ? null : _emailError,
                          labelStyle: TextStyle(
                              color: Colors.grey[800], fontFamily: "SFCR"),
                          focusColor: Colors.grey[500],
                          hoverColor: Colors.grey[500],
                          labelText: 'Email'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          errorText: _validPassword
                              ? null
                              : "Please Enter A Valid Password",
                          labelStyle: TextStyle(
                              color: Colors.grey[800], fontFamily: "SFCR"),
                          focusColor: Colors.grey[500],
                          hoverColor: Colors.grey[500],
                          labelText: 'Password'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: _companyController,
                      decoration: InputDecoration(
                          errorText: _validCompany ? null : _companyError,
                          labelStyle: TextStyle(
                              color: Colors.grey[800], fontFamily: "SFCR"),
                          focusColor: Colors.grey[500],
                          hoverColor: Colors.grey[500],
                          labelText: 'Company ID'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 50,
                      child: RaisedButton(
                        color: orange(),
                        onPressed: () async {
                          var email = _emailController.text;
                          var password = _passwordController.text;
                          var companyID = _companyController.text;
                          var name = _nameController.text;
                          if (name == "") {
                            setState(() {
                              _validName = false;
                            });
                            return;
                          } else {
                            setState(() {
                              _validName = true;
                            });
                          }
                          if (email == "") {
                            setState(() {
                              _validEmail = false;
                              _emailError = "Invalid Email";
                            });
                            return;
                          } else {
                            setState(() {
                              _validEmail = true;
                            });
                          }
                          if (password == "") {
                            setState(() {
                              _validPassword = false;
                            });
                            return;
                          } else {
                            setState(() {
                              _validPassword = true;
                            });
                          }
                          if (companyID == "") {
                            setState(() {
                              _validCompany = false;
                              _companyError = "Company ID Cannot Be Empty";
                            });
                            return;
                          } else {
                            setState(() {
                              _validCompany = true;
                            });
                          }

                          var response = await postData(
                              '$SERVER_IP/user/signup', {
                            'name': name,
                            'email': email,
                            'password': password,
                            'company_id': companyID
                          });
                          switch (response['status_code']) {
                            case 201:
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginForm()));
                              break;
                            case 422:
                              setState(() {
                                _validEmail = false;
                                _emailError = "Email Already In Use";
                              });
                              break;
                            case 401:
                              setState(() {
                                _validCompany = false;
                                _companyError = "Invalid Company ID";
                              });
                              break;
                            default:
                              break;
                          }
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "SFCM"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginForm()));
                      },
                      child: Text(
                        "Already Signed Up? Login",
                        style: TextStyle(fontFamily: "SFCM"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
