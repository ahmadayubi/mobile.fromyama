import 'package:flutter/material.dart';
import 'package:fromyama/controllers/login/loginController.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/screens/signup/signUpForm.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/requests.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool _validEmail = true, _validPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Welcome To",
                style: TextStyle(
                  fontFamily: "SFCR",
                  fontSize: 16,
                ),
              ),
              Image(
                image: AssetImage('assets/images/fulfill_fy.png'),
                height: 70,
              ),
              TextField(
                controller: _emailController,
                onChanged: (value) {
                  setState(() {
                    _validEmail = true;
                  });
                },
                decoration: InputDecoration(
                    errorText: _validEmail ? null : "Invalid Email",
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
                    focusColor: Colors.grey[500],
                    hoverColor: Colors.grey[500],
                    labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                onChanged: (value) {
                  setState(() {
                    _validPassword = true;
                  });
                },
                decoration: InputDecoration(
                    errorText: _validPassword ? null : "Invalid Password",
                    labelStyle:
                        TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
                    focusColor: Colors.grey[500],
                    hoverColor: Colors.grey[500],
                    labelText: 'Password'),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 50,
                      child: RaisedButton(
                        color: blue(),
                        onPressed: () async {
                          var email = _emailController.text;
                          var password = _passwordController.text;
                          var token =
                              await validLogin(SERVER_IP, email, password);
                          if (token != "") {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return MainDash(token);
                            }));
                          } else {
                            setState(() {
                              _validEmail = false;
                              _validPassword = false;
                            });
                          }
                        },
                        child: Text(
                          "Login",
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
                                builder: (context) => SignUpForm()));
                      },
                      child: Text(
                        "Don't Have An Account? Signup",
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
