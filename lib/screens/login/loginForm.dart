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
    return Scaffold(
      body: Padding(
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
              child: Text("Log In"),
            ),
          ],
        ),
      ),
    );
  }
}
