import 'package:flutter/material.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';
import 'package:fromyama/screens/loading/processLoading.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/fyButton.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class AddPayment extends StatefulWidget {
  final String _token;

  AddPayment(this._token);

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool cardAdded = false;
  int cardResponse = -1;
  String _responseMessage = "";

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  initState() {
    super.initState();
    //
    // StripePayment.setOptions(StripeOptions(
    //     publishableKey:
    //         "pk_test_51H9FwQBfJqQ07beR9EGPYn1WHyeUzVSJIxHa1pGFPMtCyRhEUpKSOhXWUrVvDRApoacMxUxeTFDJR6pC2DXHC0p700gYbFkUMz"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        toolbarHeight: 45,
        title: Text(
          "Add Payment Method",
          style: TextStyle(
            color: Colors.grey[800],
            fontFamily: "SFCR",
            fontSize: 17,
          ),
        ),
      ),
      backgroundColor: beige(),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 10,
                    right: 10,
                  ),
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
                  child: Column(
                    children: [
                      CreditCardForm(
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: FYButton(
                      //     text: "Add Payment Method",
                      //     onPressed: () {
                      //       CreditCard card;
                      //       try {
                      //         var date = expiryDate.split("/");
                      //         card = CreditCard(
                      //           number: cardNumber,
                      //           expMonth: int.parse(date[0]),
                      //           expYear: int.parse(date[1]),
                      //           cvc: cvvCode,
                      //         );
                      //       } catch (err) {
                      //         print(err);
                      //       }
                      //       StripePayment.createTokenWithCard(card).then((token) {
                      //         setState(() {
                      //           cardResponse = 0;
                      //           _responseMessage = "Adding payment method.";
                      //           cardAdded = true;
                      //         });
                      //         postAuthData(
                      //                 '$SERVER_IP/company/add/payment/method',
                      //                 {'payment_token': token.tokenId},
                      //                 widget._token)
                      //             .then((response) {
                      //           if (response['status_code'] == 200) {
                      //             setState(() {
                      //               cardResponse = 200;
                      //               _responseMessage = "Payment method added.";
                      //             });
                      //           }
                      //         }).catchError((error) {
                      //           setState(() {
                      //             cardResponse = 500;
                      //             _responseMessage = "Error adding payment method.";
                      //           });
                      //           print(error);
                      //         });
                      //       }).catchError((error) {
                      //         setState(() {
                      //           cardResponse = 500;
                      //           _responseMessage = "Error adding payment method.";
                      //         });
                      //         print(error);
                      //       });
                      //     },
                      //   ),
                      // )
                    ],
                  ),
                ),
/*                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(left: 50, right: 50, top: 5),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text("Payments are processed using Stripe, we don't store anything."),
                  ),
                ),*/
              ],
            ),
            ProcessLoading(responseStatus: cardResponse, message: _responseMessage),
          ],
        ),
      ),
    );
  }
}
