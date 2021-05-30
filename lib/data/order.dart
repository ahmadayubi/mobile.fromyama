class Order {
  int color;
  String imagePath;
  String order_id;
  String created_at;
  String total;
  String subtotal;
  String tax;
  String currency;
  String name;
  String type;
  bool was_paid;
  List items;
  Map<String, dynamic> shipping_address;
}
