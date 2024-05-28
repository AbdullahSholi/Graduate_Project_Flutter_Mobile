import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/screens/forCustomers/customer_main_page(1)/customer_main_page.dart';
import 'package:http/http.dart' as http;

import '../../../models/customer/customer_register_model.dart';
import '../../../models/merchant/register_page_merchant.dart';

class CustomerRegister extends StatefulWidget {
  final String token;
  final String email;
  CustomerRegister(this.token, this.email);

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister>
    with TickerProviderStateMixin {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController customernameTextEditingController =
      TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController streetTextEditingController = TextEditingController();
  TextEditingController storeCategoryTextEditingController =
      TextEditingController();
  TextEditingController storeDescriptionTextEditingController =
      TextEditingController();
  // Define a list of items for the dropdown
  List<String> items = ['Electronic', 'Cars', 'Resturant'];

  String emailStatus = "";

  // Define a variable to store the selected item
  String selectedItem = 'Electronic';

  String tokenVal = "";
  String emailVal = "";
  bool defaultObsecure = false;

  Color primaryColor = Color(0xFF212128);
  Color secondaryColor = Color(0xFFF4F4FB);
  Color accentColor = Color(0xFF0E1011);
  final _formKey = GlobalKey<FormState>();

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
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios, color: secondaryColor,)),
        title: Text("${getLang(context, 'register_page')}", style: GoogleFonts.roboto(textStyle: TextStyle(color: secondaryColor, fontSize: 30, fontWeight: FontWeight.bold) ,),),
        centerTitle: true,
      ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFF212128),
          ),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Divider(
                thickness: 2,
                color: secondaryColor,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: 2,
                      //   color: Colors.white,
                      // ),
                      Form(
                        key: _formKey,
                        // height: MediaQuery.of(context).size.height / 1.2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // SizedBox(height:28,),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                                width: MediaQuery.of(context).size.width / 1.15,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  controller: customernameTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Username is required';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: "${getLang(context, 'customer_name')}",
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
                                width: MediaQuery.of(context).size.width / 1.15,
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
                                      labelText: "${getLang(context, 'email_address')}",
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
                                width: MediaQuery.of(context).size.width / 1.15,
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
                                      labelText: "${getLang(context, 'password')}",
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
                                width: MediaQuery.of(context).size.width / 1.15,
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
                                      labelText: "${getLang(context, 'phone_number')}",
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
                                width: MediaQuery.of(context).size.width / 1.15,
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
                                      labelText: "${getLang(context, 'country')}",
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
                                width: MediaQuery.of(context).size.width / 1.15,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  controller: streetTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'street is required';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: "${getLang(context, 'street')}",
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
                              SizedBox(height: 20,),
                
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                // height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: accentColor,
                                ),
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Center(
                                  child: TextButton(
                                      onPressed: () async {
                                        if(_formKey.currentState!.validate()){
                                          http.Response userFuture1 =
                                          await http.get(
                                            Uri.parse(
                                                "https://api.zerobounce.net/v2/validate?api_key=dbe281151b124ec5b88fd618918e65a9&email=${emailTextEditingController.text}"),
                                            headers: {
                                              "Content-Type": "application/json",
                                            },
                                          );
                                          setState(() {
                                            emailStatus = jsonDecode(userFuture1.body)["status"];
                                          });
                
                                          if (emailStatus == "valid") {
                                            try {
                                              var email =
                                                  emailTextEditingController.text;
                                              var password =
                                                  passwordTextEditingController
                                                      .text;
                                              var customername =
                                                  customernameTextEditingController
                                                      .text;
                                              var phone =
                                                  phoneTextEditingController.text;
                                              var country =
                                                  countryTextEditingController.text;
                                              var street =
                                                  streetTextEditingController.text;
                
                                              http.Response userFuture =
                                              await http.post(
                                                Uri.parse(
                                                    "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/register"),
                                                headers: {
                                                  "Content-Type": "application/json"
                                                },
                                                body: jsonEncode(
                                                  {
                                                    "email": email,
                                                    "password": password,
                                                    "username": customername,
                                                    "phone": phone,
                                                    "country": country,
                                                    "street": street,
                                                  },
                                                ),
                                                encoding:
                                                Encoding.getByName("utf-8"),
                                              );
                                              print(userFuture.body);
                                              var temp =
                                              CustomerRegisterPage.fromJson(
                                                  json.decode(userFuture.body));
                                              print(temp);
                                              print(temp?.token);
                                              print(temp?.email);
                
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CustomerMainPage(
                                                              temp.token,
                                                              temp.email)));
                                            } catch (error) {}
                                          }
                                        }
                
                                      },
                                      child: Text(
                                        "${getLang(context, 'register')}",
                                        style: GoogleFonts.roboto(textStyle: TextStyle(color: secondaryColor, fontSize: 20, fontWeight: FontWeight.bold)) ,
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
              ),
            ],
          ),
        ));
  }
}
