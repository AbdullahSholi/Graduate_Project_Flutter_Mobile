import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graduate_project/stripe_payment/stripe_keys.dart';

abstract class PaymentManager{
  static Future<void> makePayment(int amount, String currency)async{
    try{
      String clientSecret=await _getClientSecret((amount*100).toString(), currency);
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
    }catch(error){
      throw Exception(error.toString());
    }

  }

  static Future<void> _initializePaymentSheet(String clientSecret) async{

    await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: clientSecret,
      merchantDisplayName: "Product",
      appearance: PaymentSheetAppearance(
        colors: PaymentSheetAppearanceColors(
          background: Color(0xFF212128).withOpacity(1),
          primary: Color(0xFF212128),
          componentBorder: Colors.red,
          componentText: Colors.black,
          primaryText: Colors.white,
          secondaryText: Colors.white

        ),
        shapes: PaymentSheetShape(
          borderWidth: 4,
          shadow: PaymentSheetShadowParams(color: Colors.red),
        ),
        primaryButton: PaymentSheetPrimaryButtonAppearance(
          shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
          colors: PaymentSheetPrimaryButtonTheme(
            light: PaymentSheetPrimaryButtonThemeColors(
              background: Color.fromARGB(255, 231, 235, 30),
              text: Color.fromARGB(255, 235, 92, 30),
              border: Color.fromARGB(255, 235, 92, 30),
            ),
          ),
        ),
      ),
    ));
  }

  static Future<String> _getClientSecret(String amount, String currency) async{
    print(ApiKeys.secretKey);
    print(ApiKeys.publishableKey);
    Dio dio = Dio();
    var response= await dio.post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      ),
      data: {
        'amount': amount,
        'currency': currency,
      },
    );
    return response.data["client_secret"];
  }
}