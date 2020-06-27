import 'package:flutter/material.dart';
import 'package:fromyama/screens/login/loginForm.dart';
import 'package:fromyama/utils/requests.dart';

class SignUpCompany extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _name = TextEditingController();

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
            controller: _name,
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
              var response = await postData('$SERVER_IP/company/register', {
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
      ),
    );
  }
}
