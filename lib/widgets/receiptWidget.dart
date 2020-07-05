import 'package:flutter/material.dart';
import 'package:fromyama/data/shopifyOrder.dart';

class ReceiptWidget extends StatefulWidget {
  final ShopifyOrder _order;
  final Function _allChecked;

  ReceiptWidget(this._order, this._allChecked);

  @override
  _ReceiptWidgetState createState() => _ReceiptWidgetState();
}

class _ReceiptWidgetState extends State<ReceiptWidget> {
  List<bool> _checked;

  void initState() {
    super.initState();
    _checked = new List<bool>.filled(widget._order.items.length, false,
        growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.1,
            blurRadius: 2,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Order Summary",
                style: TextStyle(
                  fontFamily: "SFCM",
                  fontSize: 19,
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
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: InkWell(
                    onTap: () => setState(
                      () {
                        _checked[widget._order.items.indexOf(item)] =
                            !_checked[widget._order.items.indexOf(item)];
                        for (int i = 0; i < _checked.length; i++) {
                          if (!(_checked[i])) {
                            widget._allChecked(false);
                            return;
                          }
                        }
                        widget._allChecked(true);
                      },
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _checked[widget._order.items.indexOf(item)]
                                ? Icon(
                                    Icons.check_circle_outline,
                                    size: 40.0,
                                    color: Colors.grey[800],
                                  )
                                : Icon(
                                    Icons.adjust,
                                    size: 40.0,
                                    color: Colors.grey[800],
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item['title']}',
                                  style: TextStyle(
                                    fontFamily: "SFCR",
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'SKU:${item['sku']}',
                                  style: TextStyle(
                                    fontFamily: "SFCR",
                                    fontSize: 15,
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
                            fontFamily: "SFCM",
                            fontSize: 20,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
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
                    "Subtotal:",
                    style: TextStyle(
                      fontFamily: "SFCR",
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget._order.subtotal,
                    style: TextStyle(
                      fontFamily: "SFCR",
                      fontSize: 15,
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
                      fontFamily: "SFCR",
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget._order.tax,
                    style: TextStyle(
                      fontFamily: "SFCR",
                      fontSize: 15,
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
                      fontFamily: "SFCM",
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    '${widget._order.total} ${widget._order.currency}',
                    style: TextStyle(
                      fontFamily: "SFCM",
                      fontSize: 17,
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
