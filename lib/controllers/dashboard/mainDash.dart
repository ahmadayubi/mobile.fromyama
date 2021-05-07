import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/data/user.dart';
import 'package:fromyama/data/shopifyOrder.dart';
import 'package:fromyama/data/amazonOrder.dart';
import 'package:fromyama/data/etsyOrder.dart';

Future<User> getUserDetails(String token) async {
  return User.fromJson(await getAuthData('$SERVER_IP/user/details', token));
}

Future<Map<String, dynamic>> getPlatforms(String token) async {
  return await getAuthData('$SERVER_IP/company/platforms', token);
}

Future<List<dynamic>> getUnfulfilledOrders(String token, Map<String, dynamic> platforms) async {
  var amazonList = [], shopifyList = [], etsyList = [];
  if (platforms["shopify_connected"]) {
    var shopifyOrders =
    await getAuthData('$SERVER_IP/shopify/orders/all', token);
    if (shopifyOrders['status_code'] == 200 &&
        shopifyOrders["orders"] != null) {
      shopifyList = shopifyOrders['orders'].map((order) {
        return ShopifyOrder.fromJson(order);
      }).toList();
    }
  }
  if (platforms["amazon_connected"]) {
    var amazonOrders =
    await getAuthData('$SERVER_IP/amazon/orders/all', token);
    if (amazonOrders['status_code'] == 200 &&
        amazonOrders["orders"] != null) {
      amazonList = amazonOrders['orders'].map((order) {
        return AmazonOrder.fromJson(order);
      }).toList();
    }
  }
  if (platforms["etsy_connected"]) {
    var etsyOrders =
    await getAuthData('$SERVER_IP/etsy/orders/all', token);
    if (etsyOrders['status_code'] == 200 && etsyOrders["orders"] != null) {
      etsyList = etsyOrders['orders'].map((order) {
        return EtsyOrder.fromJson(order);
      }).toList();
    }
  }
  List<dynamic> sortedList = shopifyList + amazonList + etsyList;
  return sortedList;
}