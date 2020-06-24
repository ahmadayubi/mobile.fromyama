import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fromyama/controllers/login/loginController.dart';

final storage = FlutterSecureStorage();

Future<String> alreadyLoggedIn(String server) async {
  String email = await storage.read(key: 'email');
  String password = await storage.read(key: 'password');

  if (email == null || password == null) return "";
  var valid = await validLogin(server, email, password);
  String token = await storage.read(key: 'token');
  return valid != "" ? token : "";
}
