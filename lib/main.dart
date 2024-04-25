import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/home.dart';
import 'package:graduate_project/screens/login.dart';
import 'package:graduate_project/stripe_payment/stripe_keys.dart';


void main() {
  // Stripe.publishableKey="pk_test_51P0BDE1qqwiIHxVLW2VQnKp18Mv56mjqtQTGOw8ZyjkBN8wsDyVo8ohAWlV85JDmvY5lBeql0i1q8dl3IFCjtFw400LCCXSBZ7";
  // print("AAAA ${ApiKeys.publishableKey}");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: LogAllPage(),
    );
  }
}