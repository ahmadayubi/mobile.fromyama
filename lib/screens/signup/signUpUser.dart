import 'package:flutter/material.dart';
import 'package:fromyama/screens/login/loginForm.dart';
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
    return Scaffold(
      backgroundColor: new Color(0xfff9efe7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Container(
                child: Text("PLACEHOLDER FOR ART"),
                height: 400,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    errorText: _validName ? null : "Please Enter A Valid Name",
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    border: OutlineInputBorder(),
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
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    border: OutlineInputBorder(),
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
                    errorText:
                        _validPassword ? null : "Please Enter A Valid Password",
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    border: OutlineInputBorder(),
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
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    border: OutlineInputBorder(),
                    focusColor: Colors.grey[500],
                    hoverColor: Colors.grey[500],
                    labelText: 'Company ID'),
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
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.orangeAccent,
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
                        "Already Registered? Login",
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
