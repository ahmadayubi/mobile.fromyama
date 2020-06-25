import 'package:flutter/material.dart';
import 'package:fromyama/controllers/login/loginController.dart';
import 'package:fromyama/screens/dashboard/mainDash.dart';
import 'package:fromyama/utils/requests.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'email'),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          FlatButton(
              onPressed: () async {
                var email = _emailController.text;
                var password = _passwordController.text;
                var token = await validLogin(SERVER_IP, email, password);
                if (token != "") {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return MainDash(token);
                  }));
                } else {
                  displayDialog(context, "An Error Occurred",
                      "No account was found matching that email and password");
                }
              },
              child: Text("Log In")),
/*                       FlatButton(
                          onPressed: () async {
                            var email = _emailController.text;
                            var password = _passwordController.text;

                            if (email.length < 4)
                              displayDialog(context, "Invalid email",
                                  "The email should be at least 4 characters long");
                            else if (password.length < 4)
                              displayDialog(context, "Invalid Password",
                                  "The password should be at least 4 characters long");
                            else {
                              var res = await attemptSignUp(
                                  SERVER_IP, email, password);
                              if (res == 201)
                                displayDialog(context, "Success",
                                    "The user was created. Log in now.");
                              else if (res == 409)
                                displayDialog(
                                    context,
                                    "That email is already registered",
                                    "Please try to sign up using another email or log in if you already have an account.");
                              else {
                                displayDialog(context, "Error",
                                    "An unknown error occurred.");
                              }
                            }
                          },
                          child: Text("Sign Up")) */
        ],
      ),
    );
  }
}
