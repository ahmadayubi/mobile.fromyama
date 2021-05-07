import 'package:fromyama/utils/requests.dart';

Future<Map<String, dynamic>> getCanadaPostRates(String pc, String l, String w,
    String h, String weight, String token) async {
  return await postAuthData(
      '$SERVER_IP/postage/rates/canadapost',
      {
        'postal_code': pc,
        'weight': weight,
        'length': l,
        'width': w,
        'height': h,
      },
      token);
}
