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
            spreadRadius: 0.1,
            blurRadius: 2,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Shipping To",
                style: TextStyle(
                  fontFamily: "SFCM",
                  fontSize: 20,
                  color: Colors.grey[800],
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
                fontFamily: "SFCR",
                fontSize: 17,
                color: Colors.grey[800],
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
