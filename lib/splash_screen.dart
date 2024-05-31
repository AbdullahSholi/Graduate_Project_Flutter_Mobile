import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'onboarding-page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  _goHome() async {
    await Future.delayed(const Duration(milliseconds: 2500), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> OnboardingScreen()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _goHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Container(
        color: Color(0xff053262),
          alignment: Alignment.center,
          child: Image.asset("assets/images/Matjarcom.png", fit: BoxFit.cover,)),
    );
  }
}
