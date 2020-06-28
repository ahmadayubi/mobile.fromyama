import 'package:flutter/material.dart';
import 'package:fromyama/screens/login/loginForm.dart';
import 'package:fromyama/utils/requests.dart';

class SignUpUser extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            decoration: InputDecoration(labelText: 'Company ID'),
          ),
          FlatButton(
            onPressed: () async {
              var email = _emailController.text;
              var password = _passwordController.text;
              var companyID = _companyController.text;
              var name = _nameController.text;
              var response = await postData('$SERVER_IP/user/signup', {
                'name': name,
                'email': email,
                'password': password,
                'company_id': companyID
              });
              switch (response['status_code']) {
                case 201:
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginForm()));
                  break;
                case 422:
                  displayDialog(
                      context, "An Error Occurred", "User Already Exists");
                  break;
                case 401:
                  displayDialog(context, "An Error Occurred",
                      "No Company With That ID Exists");
                  break;
                default:
                  displayDialog(context, "An Error Occurred", "Error 500");
                  break;
              }
            },
            child: Text("Sign Up"),
          ),
        ],
      ),
    );
  }
}
