import 'package:fromyama/data/order.dart';

class EtsyOrder implements Order {
  String order_id;
  String created_at;
  String total;
  String subtotal;
  String tax;
  String currency;
  String name;
  bool was_paid;
  List items;
  Map<String, dynamic> shipping_address;

  EtsyOrder(
      this.order_id,
      this.total,
      this.created_at,
      this.currency,
      this.was_paid,
      this.items,
      this.name,
      this.shipping_address,
      this.subtotal,
      this.tax);

  EtsyOrder.fromJson(Map<String, dynamic> json)
      : order_id = json['order_id'].toString(),
        created_at = json['created_at'],
        total = json['total'],
        subtotal = json['subtotal'],
        tax = json['tax'],
        currency = json['currency'],
        name = json['name'],
        was_paid = json['was_paid'],
        items = json['items'],
        shipping_address = json['shipping_address'];

  Map<String, dynamic> toJson() => {
        'order_id': order_id,
        'created_at': created_at,
      };
}
