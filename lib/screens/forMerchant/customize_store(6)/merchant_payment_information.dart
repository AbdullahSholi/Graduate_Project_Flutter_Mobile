import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;

import '../../../stripe_payment/stripe_keys.dart';
import '../merchant_home_page(3)/merchant_home_page.dart';

class MerchantPaymentInformation extends StatefulWidget {
  String tokenVal;
  String emailVal;
  MerchantPaymentInformation(this.tokenVal, this.emailVal, {super.key});

  @override
  State<MerchantPaymentInformation> createState() => _MerchantPaymentInformationState();
}

class _MerchantPaymentInformationState extends State<MerchantPaymentInformation> with TickerProviderStateMixin{

  String tokenVal="";
  String emailVal="";

  TextEditingController publishableKeyTextEditingController = TextEditingController();
  TextEditingController secretKeyTextEditingController = TextEditingController();

  Future<void> postData() async {
    print(tokenVal);
    print(emailVal);
    final String apiUrl = 'http://10.0.2.2:3000/merchant/api/v1/add-payment-informations/${emailVal}';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $tokenVal"
      },
      body: jsonEncode(<String, String>{
        'publishableKey': publishableKeyTextEditingController.text,
        'secretKey': secretKeyTextEditingController.text,
      }),
    );

    if (response.statusCode == 201) {
      // If the server returns a 201 CREATED response,
      // then parse the JSON.
      print(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to post data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.tokenVal;
    emailVal = widget.emailVal;

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                  particleCount: 100,
                  image: Image(
                      image: NetworkImage(
                          "https://t3.ftcdn.net/jpg/01/70/28/92/240_F_170289223_KNx1FpHz8r5ody9XZq5kMOfNDxsZphLz.jpg"))),
            ),
            vsync: this,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF212128),
                  ),
                  margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF212128),
                                ), // Replace with your desired icon
                                onPressed: () {

                                  Navigator.push(context, (MaterialPageRoute(builder: (context)=> MerchantHome(tokenVal, emailVal))));
                                },
                                // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 0,
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Center(
                                child: Text(
                                  "Update your personal information",
                                  style: GoogleFonts.federo(
                                      color: Color(0xFF212128),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                          ),
                          SizedBox(
                            width: 0,
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 2,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),

                              Container(
                                width:
                                MediaQuery.of(context).size.width / 1.3,
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  controller:
                                  publishableKeyTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Your Publish Key is required';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Publishable Key',
                                      labelStyle:
                                      TextStyle(color: Colors.white),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ))),
                                ),
                              ),

                              SizedBox(
                                height: 30.0,
                              ),
                              Container(
                                width:
                                MediaQuery.of(context).size.width / 1.3,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  controller: secretKeyTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType:
                                  TextInputType.visiblePassword,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Secret Key is required';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Secret Key',
                                      labelStyle: const TextStyle(
                                          color: Colors.white),
                                      prefixIcon: const Icon(
                                        Icons.password,
                                        color: Colors.white,
                                      ),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ))),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: TextButton(
                            onPressed: () async {
                              final String apiUrl = 'http://10.0.2.2:3000/matjarcom/api/v1/add-payment-informations/${emailVal}';

                              final response = await http.post(
                                Uri.parse(apiUrl),
                                headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  "Authorization": "Bearer $tokenVal"
                                },
                                body: jsonEncode(<String, String>{
                                  'publishableKey': publishableKeyTextEditingController.text,
                                  'secretKey': secretKeyTextEditingController.text,
                                }),
                              );

                              ///////////////////////




                            },
                            child: Text(
                              "Add",
                              style: GoogleFonts.federo(
                                color: Color(0xFF212128),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.white,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
