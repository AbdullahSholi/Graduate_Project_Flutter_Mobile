import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

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
  List<String> items = ['All Stores'];
  String selectedItem = 'All Stores';

  Future<void> getAdminData() async {

    http.Response userFuture5 = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/admins-list"),
    );
    print("qqqqqqqqqqqqqqqqqqq");
    print(jsonDecode(userFuture5.body)["email"]);
    print("qqqqqqqqqqqqqqqqqqq");

    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/admin-data/${jsonDecode(userFuture5.body)["email"]}"),
    );

    print("uuuuuuuuuuuuXX");
    print(jsonDecode(userFuture.body)["allCategories"].runtimeType);
    print("uuuuuuuuuuuuXX");
    setState(() {
      List<dynamic> dynamicList = jsonDecode(userFuture.body)["allCategories"];
      List<String> stringList = dynamicList.map((element) => element.toString()).toList();

      items.addAll(stringList);
      print(items);
      print("uuuuuuuuuuuuXXXXXXXXXXXXXXXX");
    });

  }

  String tokenVal = "";
  String emailVal = "";
  bool defaultObsecure = false;
  String emailStatus = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
    getAdminData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF212128),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          title: Text(
            "${getLang(context, 'register_page')}",
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFF212128),
          ),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: Colors.white,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.1,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // SizedBox(height:28,),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: merchantnameTextEditingController,
                              //Making keyboard just for Email
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Merchant Name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText:
                                      '${getLang(context, 'merchantname')}',
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
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: emailTextEditingController,
                              //Making keyboard just for Email
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  labelText:
                                      '${getLang(context, 'email_address')}',
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
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: TextFormField(
                              obscureText: !defaultObsecure,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: passwordTextEditingController,
                              //Making keyboard just for Email
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                // Check if the value is null or empty
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }

                                // Define a regular expression to match the password criteria
                                final RegExp passwordRegExp = RegExp(
                                    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

                                // Check if the password matches the criteria
                                if (!passwordRegExp.hasMatch(value)) {
                                  return 'Password must be at least 8 characters long, '
                                      'include at least one uppercase letter, one lowercase letter, '
                                      'one number, and one special character';
                                }

                                // If all checks pass, return null
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: '${getLang(context, 'password')}',
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
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: phoneTextEditingController,
                              //Making keyboard just for Email
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                // Check if the value is null or empty
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }

                                // Define a regular expression to match the phone number criteria
                                final RegExp phoneRegExp = RegExp(r'^05\d{8}$');

                                // Check if the phone number matches the criteria
                                if (!phoneRegExp.hasMatch(value)) {
                                  return 'Phone number must start with "05" and be exactly 10 digits long';
                                }

                                // If all checks pass, return null
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText:
                                      '${getLang(context, 'phone_number')}',
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
                            width: MediaQuery.of(context).size.width / 1.1,
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
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: '${getLang(context, 'country')}',
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
                            width: MediaQuery.of(context).size.width / 1.1,
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
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText:
                                      '${getLang(context, 'store_name')}',
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
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: storeDescriptionTextEditingController,
                              //Making keyboard just for Email
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Store Description is required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText:
                                      '${getLang(context, 'store_description')}',
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
                            width: MediaQuery.of(context).size.width / 1.1,
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
                                    if (_formKey.currentState!.validate()) {
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
                                              passwordTextEditingController
                                                  .text;
                                          var merchantname =
                                              merchantnameTextEditingController
                                                  .text;
                                          var phone =
                                              phoneTextEditingController.text;
                                          var country =
                                              countryTextEditingController.text;
                                          var storeName =
                                              storeNameTextEditingController
                                                  .text;
                                          var storeCategory = selectedItem;
                                          var storeDescription =
                                              storeDescriptionTextEditingController
                                                  .text;
                                          http.Response userFuture =
                                              await http.post(
                                            Uri.parse(
                                                "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-register"),
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
                                            encoding:
                                                Encoding.getByName("utf-8"),
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
                                      } else{
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.error,
                                          title: 'Oops...',
                                          text: 'Sorry, but this Invalid Email.',
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    "${getLang(context, 'register')}",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
