class ShopifyOrder {
  final String orderID;
  final String customerName;
  final int total;

  ShopifyOrder(this.orderID, this.customerName, this.total);

  ShopifyOrder.fromJson(Map<String, dynamic> json)
      : orderID = json['_id'],
        customerName = json['product'],
        total = json['quantity'];

  Map<String, dynamic> toJson() => {
        'order_id': orderID,
        'customer_name': customerName,
      };
}
