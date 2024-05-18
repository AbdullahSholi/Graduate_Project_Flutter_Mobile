import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../models/merchant/register_page_merchant.dart';
import '../merchant_home_page(3)/merchant_home_page.dart';
import '../store_management(5)/display_your_store(5.1).dart';

class MerchantRegister extends StatefulWidget {
  final String token;
  final String email;
  MerchantRegister(this.token, this.email);

  @override
  State<MerchantRegister> createState() => _MerchantRegisterState();
}

class _MerchantRegisterState extends State<MerchantRegister>
    with TickerProviderStateMixin {
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
  TextEditingController storeDescriptionTextEditingController =
      TextEditingController();
  // Define a list of items for the dropdown
  List<String> items = ['Electronic', 'Cars', 'Resturant'];

  // Define a variable to store the selected item
  String selectedItem = 'Electronic';

  String tokenVal = "";
  String emailVal = "";
  bool defaultObsecure = false;
  String emailStatus = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
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
                                Navigator.pop(context);
                              },
                              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 28,
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Center(
                              child: Text(
                            "Register Page",
                            style: TextStyle(
                                color: Color(0xFF212128),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 2,
                      color: Colors.white,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // SizedBox(height:28,),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                controller: merchantnameTextEditingController,
                                //Making keyboard just for Email
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Username is required';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Merchant name',
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    prefixIcon: const Icon(
                                      Icons.person,
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
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                controller: emailTextEditingController,
                                //Making keyboard just for Email
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email Address is required';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    prefixIcon: const Icon(
                                      Icons.email,
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
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: TextFormField(
                                obscureText: !defaultObsecure,
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                controller: passwordTextEditingController,
                                //Making keyboard just for Email
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password is required';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    prefixIcon: const Icon(
                                      Icons.password,
                                      color: Colors.white,
                                    ),
                                    suffixIcon: IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            defaultObsecure = !defaultObsecure;
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
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                controller: phoneTextEditingController,
                                //Making keyboard just for Email
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Phone Number is required';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
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
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 28, 0, 20),
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                controller: countryTextEditingController,
                                //Making keyboard just for Email
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Country is required';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Country',
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
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
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                controller: storeNameTextEditingController,
                                //Making keyboard just for Email
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Store Name is required';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Store Name',
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    prefixIcon: const Icon(
                                      Icons.storefront,
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
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                controller:
                                    storeDescriptionTextEditingController,
                                //Making keyboard just for Email
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Store Description is required';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Store Description',
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    prefixIcon: const Icon(
                                      Icons.description,
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
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: DropdownButton(
                                borderRadius: BorderRadius.circular(20),
                                dropdownColor: Color(0xFF36363C),
                                style: TextStyle(color: Color(0xFF212128)),
                                value: selectedItem,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedItem = newValue!;
                                    print(selectedItem);
                                  });
                                },
                                items: items.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(color: Colors.white),
                                      ));
                                }).toList(),
                              ),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFF18181E),
                              ),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                              child: Center(
                                child: TextButton(
                                    onPressed: () async {
                                      http.Response userFuture1 =
                                          await http.get(
                                        Uri.parse(
                                            "https://api.zerobounce.net/v2/validate?api_key=dbe281151b124ec5b88fd618918e65a9&email=${emailTextEditingController.text}"),
                                        headers: {
                                          "Content-Type": "application/json",
                                        },
                                      );
                                      setState(() {
                                        emailStatus = jsonDecode(
                                            userFuture1.body)["status"];
                                      });

                                      if (emailStatus == "valid") {
                                        try {
                                          var email =
                                              emailTextEditingController.text;
                                          var password =
                                              passwordTextEditingController.text;
                                          var merchantname =
                                              merchantnameTextEditingController
                                                  .text;
                                          var phone =
                                              phoneTextEditingController.text;
                                          var country =
                                              countryTextEditingController.text;
                                          var storeName =
                                              storeNameTextEditingController.text;
                                          var storeCategory = selectedItem;
                                          var storeDescription =
                                              storeDescriptionTextEditingController
                                                  .text;
                                          http.Response userFuture =
                                          await http.post(
                                            Uri.parse(
                                                "http://10.0.2.2:3000/matjarcom/api/v1/merchant-register"),
                                            headers: {
                                              "Content-Type": "application/json"
                                            },
                                            body: jsonEncode(
                                              {
                                                "email": email,
                                                "password": password,
                                                "merchantname": merchantname,
                                                "phone": phone,
                                                "country": country,
                                                "storeName": storeName,
                                                "storeCategory": storeCategory,
                                                "storeDescription":
                                                storeDescription,
                                              },
                                            ),
                                            encoding: Encoding.getByName("utf-8"),
                                          );
                                          print(userFuture.body);
                                          var temp =
                                          RegisterPageMerchant.fromJson(
                                              json.decode(userFuture.body));
                                          print(temp);
                                          print(temp?.token);
                                          // print(temp?.email);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MerchantHome(temp.token,
                                                          temp.email)));
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
                                      }


                                    },
                                    child: Text(
                                      "Register",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
