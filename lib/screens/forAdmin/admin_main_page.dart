import "../../../stripe_payment/payment_manager.dart";

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminMainPage extends StatelessWidget {
  const AdminMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: TextButton(onPressed: ()=>PaymentManager.makePayment(20,"USD"),
          child: Text("Pay!"),

        ),
      ),
    );
  }
}
