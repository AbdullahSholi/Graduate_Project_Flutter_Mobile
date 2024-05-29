import 'dart:convert';
// import 'dart:ffi';

import 'package:animated_background/animated_background.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/screens/forGuest/guest_main_page(1)/guest_main_page.dart';
import 'package:graduate_project/screens/home.dart';
import 'package:graduate_project/screens/register.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import '../../models/Stores/display-all-stores.dart';
import '../../models/login_model.dart';
import '../../models/merchant/merchant_connect_store_to_social_media.dart';
import '../../stripe_payment/stripe_keys.dart';
import '../forAdmin/admin_main_page.dart';
import '../forCustomers/customer_login_register/login_or_register(2).dart';
import '../forCustomers/customer_main_page(1)/customer_main_page.dart';
import '../forMerchant/merchants_main_page(1)/merchants_main_page(1).dart';

class LogAllPage extends StatefulWidget {
  const LogAllPage({super.key});

  @override
  State<LogAllPage> createState() => _LogAllPageState();
}

class _LogAllPageState extends State<LogAllPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  bool defaultObsecure = false;

  TextEditingController emailTextEditingController = TextEditingController();

  TextEditingController passwordTextEditingController = TextEditingController();
////////////////////////////////////////////////////
  ///////////////////////////////////////////////

  late Future<List<dynamic>> getStoreData;
  late List<dynamic> tempStores = [];
  Future<List<dynamic>> getMerchantData() async {
    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-all-stores/"),
    );
    print(userFuture.body);
    List<dynamic> jsonList = json.decode(userFuture.body);
    for (int i = 0; i < jsonList.length; i++) {
      tempStores.add(SpecificStore.fromJson(jsonList[i]));
    }

    // print("jsonList: ${jsonList[1]}");

    if (userFuture.statusCode == 200) {
      print("${userFuture.statusCode}");

      return tempStores;
    } else {
      print("error");
      throw Exception("Error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStoreData = getMerchantData();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.green,
      end: Colors.lightGreenAccent,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF212128),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return Container(
                      margin: EdgeInsets.all(20), 
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_colorAnimation.value!, Colors.green.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ColorizeAnimatedText(
                              'MATJARCOM',
                              textStyle: TextStyle(
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold,
                              ),
                              colors: [
                                Colors.purple,
                                Colors.blue,
                                Colors.yellow,
                                Colors.red,
                              ],
                              speed: Duration(milliseconds: 300),
                            ),
                            TypewriterAnimatedText(
                              'MATJARCOM',
                              textStyle: TextStyle(
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              speed: Duration(milliseconds: 200),
                            ),
                          ],
                          totalRepeatCount: 100,
                          pause: Duration(milliseconds: 1000),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: Column(
                    children: [
                      FutureBuilder<List<dynamic>>(
                        future: getStoreData,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          print("RRRR ${snapshot.data}");
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GuestMainPage()));
                              },
                              child: Text(
                                '${getLang(context, "continue_as_guest")}',
                                style: GoogleFonts.lilitaOne(
                                    textStyle: TextStyle(color: Colors.white),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerLoginOrRegister("", "")));
                          },
                          child: Text(
                            '${getLang(context, "continue_as_customer")}',
                            style: GoogleFonts.lilitaOne(
                                textStyle: TextStyle(color: Colors.white),
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MerchantMainPage()));
                          },
                          child: Text(
                            '${getLang(context, "continue_as_merchant")}',
                            style: GoogleFonts.lilitaOne(
                                textStyle: TextStyle(color: Colors.white),
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminMainPage()));
                          },
                          child: Text(
                            '${getLang(context, "continue_as_admin")}',
                            style: GoogleFonts.lilitaOne(
                                textStyle: TextStyle(color: Colors.white),
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
