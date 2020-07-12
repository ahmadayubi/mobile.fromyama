import 'package:http/http.dart' as http;
import 'dart:convert';

const String SERVER_IP = "https://18617aa5b440.ngrok.io";

Map<String, dynamic> formatRes(res) {
  if (res.statusCode != 500) {
    Map<String, dynamic> dataMap;
    if (res.body.isNotEmpty) {
      dataMap = json.decode(res.body);
      dataMap['status_code'] = res.statusCode;
      return dataMap;
    }
  }
  return {'status_code': res.statusCode == null ? 500 : res.statusCode};
}

Future<Map<String, dynamic>> getData(String url) async {
  var res = await http.get(url);
  return formatRes(res);
}

Future<Map<String, dynamic>> postData(String url, Map data) async {
  var res = await http.post(url, body: data);
  return formatRes(res);
}

Future<Map<String, dynamic>> getAuthData(String url, String token) async {
  var res = await http.get(url, headers: {"Authorization": 'Bearer $token'});
  return formatRes(res);
}

Future<Map<String, dynamic>> postAuthData(
    String url, Map data, String token) async {
  var res = await http
      .post(url, body: data, headers: {"Authorization": 'Bearer $token'});

  return formatRes(res);
}
