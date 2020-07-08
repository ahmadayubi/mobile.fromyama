class Order {
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
}
