import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> getData(String url) async {
  var res = await http.get(url);

  if (res.statusCode == 200) {
    Map<String, dynamic> dataMap = json.decode(res.body);
    return dataMap;
  }
  return {};
}

Future<Map<String, dynamic>> postData(String url, Map data) async {
  var res = await http.post(url, body: data);

  if (res.statusCode == 200) {
    Map<String, dynamic> dataMap = json.decode(res.body);
    return dataMap;
  }
  return {};
}

Future<Map<String, dynamic>> getAuthData(String url, String token) async {
  var res = await http.get(url, headers: {"Authorization": 'Bearer $token'});
  if (res.statusCode == 200) {
    Map<String, dynamic> dataMap = json.decode(res.body);
    return dataMap;
  }
  return {};
}

Future<Map<String, dynamic>> postAuthData(
    String url, Map data, String token) async {
  var res = await http
      .post(url, body: data, headers: {"Authorization": 'Bearer $token'});

  if (res.statusCode == 200) {
    Map<String, dynamic> dataMap = json.decode(res.body);
    return dataMap;
  }
  return {};
}
