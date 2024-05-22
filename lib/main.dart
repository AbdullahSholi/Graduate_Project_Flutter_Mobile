import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/forCustomers/specific_store(2)/CustomerRateAndReviewsPage.dart';
import 'package:graduate_project/screens/home.dart';
import 'package:graduate_project/screens/login.dart';
import 'package:graduate_project/stripe_payment/stripe_keys.dart';

import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Stripe.publishableKey="pk_test_51P0BDE1qqwiIHxVLW2VQnKp18Mv56mjqtQTGOw8ZyjkBN8wsDyVo8ohAWlV85JDmvY5lBeql0i1q8dl3IFCjtFw400LCCXSBZ7";
// print("AAAA ${ApiKeys.publishableKey}");
//Remove this method to stop OneSignal Debugging
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        AppLocale.delegate,
      ],
      supportedLocales: [
        Locale("en", ""),
        Locale("ar", ""),
      ], // languages which our app will support .
      localeResolutionCallback: (currentLang, supportLang){
        if(currentLang != null){
          for(Locale locale in supportLang){
            if(locale.languageCode == currentLang.languageCode){ // currentLang --> refer to device language
              return currentLang;
            }

          }
        }
        return supportLang.first; // if error occurs select the en default language of our app
      }, // for handle multi-languages in same app
    );
  }
}

//////////////////////
/////////////////////