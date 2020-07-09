import 'package:fromyama/data/order.dart';

class AmazonOrder implements Order {
  String order_id;
  String created_at;
  String total;
  String subtotal;
  String tax;
  String currency;
  String name;
  bool was_paid;
  List items;
  Map<String, dynamic> shipping_info;
  bool is_prime;
  String item_count;

  AmazonOrder(
      this.order_id,
      this.total,
      this.created_at,
      this.currency,
      this.was_paid,
      this.items,
      this.name,
      this.shipping_info,
      this.subtotal,
      this.tax,
      this.is_prime,
      this.item_count);

  AmazonOrder.fromJson(Map<String, dynamic> json)
      : order_id = json['order_id'].toString(),
        created_at = json['created_at'],
        total = json['total'],
        subtotal = json['subtotal'],
        tax = json['tax'],
        currency = json['currency'],
        name = json['name'],
        was_paid = json['was_paid'],
        items = json['items'],
        shipping_info = json['shipping_info'],
        is_prime = json['is_prime'],
        item_count = json['item_count'];

  Map<String, dynamic> toJson() => {
        'order_id': order_id,
        'created_at': created_at,
      };
}