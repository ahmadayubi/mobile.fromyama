import 'package:flutter/material.dart';

class AddressWidget extends StatelessWidget {
  final Map<String, dynamic> address;

  AddressWidget(this.address);

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
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Shipping To",
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
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: "SFM",
                fontSize: 20,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(text: '${address['name']}'),
                TextSpan(text: '\n${address['address1']}'),
                TextSpan(
                    text:
                        '\n${address['city']}, ${address['province_code']} ${address['zip']}'),
                TextSpan(text: '\n${address['country']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
