import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forMerchant/merchant_home_page(3)/merchant_home_page.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;

import '../../../models/merchant/update_page_merchant.dart';
import '../personal_information(4)/personal_information(4).dart';

class PersonalInformation extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;
  PersonalInformation(this.token, this.email);

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation>
    with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
  bool defaultObsecure = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
  }

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController merchantnameTextEditingController =
      TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController storeNameTextEditingController =
      TextEditingController();
  TextEditingController storeCategoryTextEditingController =
      TextEditingController();

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
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF212128),
                    ),
                    margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
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
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        "Warning: Your Information will updated!!",
                                        style: GoogleFonts.permanentMarker(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    child: TextFormField(
                                      cursorColor: Colors.white,
                                      style: TextStyle(color: Colors.white),
                                      controller:
                                          merchantnameTextEditingController,
                                      //Making keyboard just for Email
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Your name is required';
                                        }
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Merchant name',
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
                                      obscureText: !defaultObsecure,
                                      style: TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      controller: passwordTextEditingController,
                                      //Making keyboard just for Email
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Password is required';
                                        }
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
                                          prefixIcon: const Icon(
                                            Icons.password,
                                            color: Colors.white,
                                          ),
                                          suffixIcon: IconButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                setState(() {
                                                  defaultObsecure =
                                                      !defaultObsecure;
                                                });
                                              },
                                              icon: Icon(defaultObsecure
                                                  ? Icons.visibility
                                                  : Icons.visibility_off)),
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
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      controller: phoneTextEditingController,
                                      //Making keyboard just for Email
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Phone number is required';
                                        }
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Phone number',
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
                                          prefixIcon: const Icon(
                                            Icons.phone,
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
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      controller: countryTextEditingController,
                                      //Making keyboard just for Email
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Country is required';
                                        }
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Country',
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
                                          prefixIcon: const Icon(
                                            Icons.location_city,
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
                            height: 25.0,
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
                                  try {
                                    var email = emailTextEditingController.text;
                                    var password =
                                        passwordTextEditingController.text;
                                    var merchantname =
                                        merchantnameTextEditingController.text;
                                    var phone = phoneTextEditingController.text;
                                    var country =
                                        countryTextEditingController.text;
                                    var storeName =
                                        storeNameTextEditingController.text;
                                    print("$email yyyyyyyyyy");
                                    http.Response userFuture = await http.patch(
                                      Uri.parse(
                                          "http://10.0.2.2:3000/matjarcom/api/v1/merchant-update/${emailVal}"),
                                      headers: {
                                        "Content-Type": "application/json",
                                        "Authorization": "Bearer $tokenVal",
                                      },
                                      body: jsonEncode(
                                        {
                                          "email": email,
                                          "password": password,
                                          "merchantname": merchantname,
                                          "phone": phone,
                                          "country": country,
                                        },
                                      ),
                                      encoding: Encoding.getByName("utf-8"),
                                    );
                                    print(userFuture.body);
                                    var temp = UpdatePageMerchant.fromJson(
                                        json.decode(userFuture.body));
                                    print(temp);

                                    AlertDialog(
                                      title: Text(
                                          "Information Message"),
                                      content: Text(temp.Message),
                                    );
                                  } catch (error) {
                                    //   showDialog<void>(
                                    //     context: context,
                                    //     barrierDismissible: false, // User must tap button to close
                                    //     builder: (BuildContext context) {
                                    //       return AlertDialog(
                                    //         backgroundColor: Colors.white,
                                    //         title: Row(
                                    //           children: [
                                    //             Icon(Icons.error_outline,color: Colors.red,weight: 30,),
                                    //             SizedBox(width: 10,),
                                    //             Text("Error Occurs!"),
                                    //           ],
                                    //         ),
                                    //         content: const SingleChildScrollView(
                                    //           child: ListBody(
                                    //             children: <Widget>[
                                    //               Text("Wrong Email or Password!!",style: TextStyle(color: Colors.black),),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //         actions: <Widget>[
                                    //           TextButton(
                                    //             child: const Text("OK"),
                                    //             onPressed: () {
                                    //               Navigator.of(context).pop(); // Close the dialog
                                    //             },
                                    //           ),
                                    //         ],
                                    //       );
                                    //     },
                                    //   );
                                    //
                                    //
                                    // }
                                  }
                                },
                                child: Text(
                                  "Update",
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
                  ),
                ),
              ],
            )));
  }
}
