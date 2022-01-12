import 'package:http/http.dart' as http;
import 'dart:convert';

const String SERVER_IP = "http://api.fromyama.com";

Map<String, dynamic> formatRes(res) {
  if (res.statusCode != 500) {
    Map<String, dynamic> dataMap;
    if (res.body.isNotEmpty) {
      dynamic decode = json.decode(res.body);
      if (decode is List) {
        dataMap = {"data": decode};
      } else {
        dataMap = decode;
      }
      dataMap['status_code'] = res.statusCode;
      return dataMap;
    }
  }
  return {'status_code': res.statusCode == null ? 500 : res.statusCode};
}

Future<Map<String, dynamic>> getData(String url) async {
  var res = await http.get(Uri.parse(url));
  return formatRes(res);
}

Future<Map<String, dynamic>> postData(String url, Map data) async {
  var res = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
  return formatRes(res);
}

Future<Map<String, dynamic>> getAuthData(String url, String token) async {
  var res = await http.get(Uri.parse(url), headers: {
    "Authorization": 'Bearer $token',
    "Content-Type": "application/json"
  });
  return formatRes(res);
}

Future<Map<String, dynamic>> postAuthData(
    String url, Map data, String token) async {
  var res = await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
    "Authorization": 'Bearer $token',
    "Content-Type": "application/json"
  });

  return formatRes(res);
}

Future<Map<String, dynamic>> putAuthData(
    String url, Map data, String token) async {
  var res = await http.put(Uri.parse(url), body: jsonEncode(data), headers: {
    "Authorization": 'Bearer $token',
    "Content-Type": "application/json"
  });

  return formatRes(res);
}
