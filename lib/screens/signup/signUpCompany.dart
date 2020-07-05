import 'package:flutter/material.dart';
import 'package:fromyama/screens/login/loginForm.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/requests.dart';

class SignUpCompany extends StatefulWidget {
  @override
  _SignUpCompanyState createState() => _SignUpCompanyState();
}

class _SignUpCompanyState extends State<SignUpCompany> {
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
                    TextField(
                      controller: _companyController,
                      decoration: InputDecoration(
                          errorText: _validCompany ? null : _companyError,
                          labelStyle: TextStyle(
                              color: Colors.grey[800], fontFamily: "SFCR"),
                          focusColor: Colors.grey[500],
                          hoverColor: Colors.grey[500],
                          labelText: 'Company Name'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          errorText:
                              _validName ? null : "Please Enter A Valid Name",
                          labelStyle: TextStyle(
                              color: Colors.grey[800], fontFamily: "SFCR"),
                          focusColor: Colors.grey[500],
                          hoverColor: Colors.grey[500],
                          labelText: 'User Full Name'),
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

                          if (companyID == "") {
                            setState(() {
                              _validCompany = false;
                              _companyError = "Company Name Cannot Be Empty";
                            });
                            return;
                          } else {
                            setState(() {
                              _validCompany = true;
                            });
                          }
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
                            case 403:
                              setState(() {
                                _validCompany = false;
                                _companyError =
                                    "Email Already Associated With Head Of Company";
                              });
                              break;
                            default:
                              break;
                          }
                        },
                        child: Text(
                          "Register",
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

    /* Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Full Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          TextField(
            controller: _companyController,
            decoration: InputDecoration(labelText: 'Company Name'),
          ),
          FlatButton(
            onPressed: () async {
              var email = _emailController.text;
              var password = _passwordController.text;
              var companyName = _companyController.text;
              var name = _nameController.text;
              var response = await postData('$SERVER_IP/company/register', {
                'name': name,
                'email': email,
                'password': password,
                'company_name': companyName
              });
              switch (response['status_code']) {
                case 200:
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginForm()));
                  break;
                case 403:
                  displayDialog(
                      context, "Already the head of a company.", "Error 403");
                  break;
                default:
                  displayDialog(context, "An Error Occurred", "Error 500");
                  break;
              }
            },
            child: Text("Sign Up"),
          ),
        ],
      ), */
  }
}
