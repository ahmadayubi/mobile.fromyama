import 'package:flutter/material.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';
import 'package:fromyama/utils/cColor.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:stripe_payment/stripe_payment.dart';
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
  int cardResponse = 0;

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

    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51H9FwQBfJqQ07beR9EGPYn1WHyeUzVSJIxHa1pGFPMtCyRhEUpKSOhXWUrVvDRApoacMxUxeTFDJR6pC2DXHC0p700gYbFkUMz"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: Text(
          "Add Payment Method",
          style: TextStyle(color: Colors.grey[800], fontFamily: "SFCR"),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          width: 300,
                          height: 50,
                          child: RaisedButton(
                            color: blue(),
                            child: Text(
                              "Add Payment Method",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "SFCM"),
                            ),
                            onPressed: () {
                              CreditCard card;
                              try {
                                var date = expiryDate.split("/");
                                card = CreditCard(
                                  number: cardNumber,
                                  expMonth: int.parse(date[0]),
                                  expYear: int.parse(date[1]),
                                  cvc: cvvCode,
                                );
                              } catch (err) {
                                print(err);
                              }
                              StripePayment.createTokenWithCard(card)
                                  .then((token) {
                                setState(() {
                                  cardAdded = true;
                                });
                                postAuthData(
                                        '$SERVER_IP/company/payment/add',
                                        {'payment_token': token.tokenId},
                                        widget._token)
                                    .then((response) {
                                  if (response['status_code'] == 200) {
                                    setState(() {
                                      cardResponse = 200;
                                    });
                                  }
                                }).catchError((error) {
                                  setState(() {
                                    cardAdded = false;
                                  });
                                  print(error);
                                });
                              }).catchError((error) {
                                setState(() {
                                  cardAdded = false;
                                });
                                print(error);
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: cardAdded,
              child: Container(
                padding: const EdgeInsets.all(100),
                color: new Color(0x77000000),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 10,
                        right: 10,
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: const Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // To make the card compact
                        children: <Widget>[
                          Visibility(
                            visible: cardResponse == 0,
                            child: SizedBox(height: 80, child: DotLoading()),
                          ),
                          Visibility(
                            visible: cardResponse == 200,
                            child: SizedBox(
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: new Color(0xffbbd984),
                                    size: 60.0,
                                  ),
                                  Text(
                                    "Card Added",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontFamily: "SFCM",
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: cardResponse == 500,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 60.0,
                                ),
                                Text(
                                  "Error",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontFamily: "SFCM",
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 24.0),
                          FlatButton(
                            onPressed:
                                cardResponse == 200 || cardResponse == 500
                                    ? () {
                                        Navigator.of(context).pop();
                                      }
                                    : null,
                            child: Text("Go Back To Main Dash"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
