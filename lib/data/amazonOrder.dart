class AmazonOrder {
  final String order_id;
  final String created_at;
  final String total;
  final String subtotal;
  final String tax;
  final String currency;
  final String name;
  final bool was_paid;
  final List items;
  final Map<String, dynamic> shipping_info;

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
      this.tax);

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
        shipping_info = json['shipping_info'];

  Map<String, dynamic> toJson() => {
        'order_id': order_id,
        'created_at': created_at,
      };
}
