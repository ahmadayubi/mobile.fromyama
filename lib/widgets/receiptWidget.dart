import 'package:flutter/material.dart';
import 'package:fromyama/data/shopifyOrder.dart';

class ReceiptWidget extends StatefulWidget {
  final ShopifyOrder _order;

  ReceiptWidget(this._order);

  @override
  _ReceiptWidgetState createState() => _ReceiptWidgetState();
}

class _ReceiptWidgetState extends State<ReceiptWidget> {
  List<bool> _checked;

  void initState() {
    super.initState();
    _checked = new List<bool>.filled(widget._order.items.length, false,
        growable: false);
    print(_checked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(9),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Order Summary",
                style: TextStyle(
                  fontFamily: "SFM",
                  fontSize: 25,
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            height: 6,
            thickness: 1,
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget._order.items.map<Widget>(
              (item) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => setState(
                              () {
                                _checked[widget._order.items.indexOf(item)] =
                                    !_checked[
                                        widget._order.items.indexOf(item)];
                              },
                            ),
                            child: _checked[widget._order.items.indexOf(item)]
                                ? Icon(
                                    Icons.check_circle_outline,
                                    size: 40.0,
                                    color: Colors.black,
                                  )
                                : Icon(
                                    Icons.adjust,
                                    size: 40.0,
                                    color: Colors.black,
                                  ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item['title']}',
                                style: TextStyle(
                                  fontFamily: "SFM",
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'SKU:${item['sku']}',
                                style: TextStyle(
                                  fontFamily: "SFM",
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        'x ${item['quantity']}',
                        style: TextStyle(
                          fontFamily: "SFM",
                          fontSize: 35,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.grey,
            height: 6,
            thickness: 1,
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SubTotal:",
                    style: TextStyle(
                      fontFamily: "SF",
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget._order.subtotal,
                    style: TextStyle(
                      fontFamily: "SF",
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tax:",
                    style: TextStyle(
                      fontFamily: "SFM",
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget._order.tax,
                    style: TextStyle(
                      fontFamily: "SFM",
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Total:",
                    style: TextStyle(
                      fontFamily: "SFM",
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '${widget._order.total} ${widget._order.currency}',
                    style: TextStyle(
                      fontFamily: "SFM",
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
