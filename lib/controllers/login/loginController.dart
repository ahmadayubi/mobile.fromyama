import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fromyama/utils/requests.dart';

final storage = FlutterSecureStorage();

Future<String> validLogin(String server, String email, String password) async {
  var res = await postData(
      '$server/user/login', {"email": email, "password": password});
  if (res['token'] != null) {
    storage.write(key: 'token', value: res['token']);
    storage.write(key: 'email', value: email);
    storage.write(key: 'password', value: password);
    return res['token'];
  }
  return "";
}
