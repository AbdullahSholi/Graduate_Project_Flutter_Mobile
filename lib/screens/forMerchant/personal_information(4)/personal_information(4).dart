import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forMerchant/merchant_home_page(3)/merchant_home_page.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
  final _formKey = GlobalKey<FormState>();

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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF212128),
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, (MaterialPageRoute(builder: (context)=> MerchantHome(tokenVal, emailVal))));
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
        ),
        title: Text("${getLang(context, 'update_your_informations')}", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
      ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 2,
              color: Colors.white,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF212128),
                ),
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                  
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 1.15,
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
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: '${getLang(context, 'merchantname')}',
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
                                    MediaQuery.of(context).size.width / 1.15,
                                child: TextFormField(
                                  obscureText: !defaultObsecure,
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  controller: passwordTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType:
                                      TextInputType.visiblePassword,
                                  validator: (value) {
                                    // Check if the value is null or empty
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }

                                    // Define a regular expression to match the password criteria
                                    final RegExp passwordRegExp = RegExp(
                                        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'
                                    );

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
                                    MediaQuery.of(context).size.width / 1.15,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  controller: phoneTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType:
                                      TextInputType.visiblePassword,
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
                                      labelText: '${getLang(context, 'phone_number')}',
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
                                    MediaQuery.of(context).size.width / 1.15,
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
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: '${getLang(context, 'country')}',
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
                              SizedBox(
                                height: 50.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Color(0xFF0E1011),
                                ),
                                child: TextButton(
                                    onPressed: () async {
                                      if(_formKey.currentState!.validate()){
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
                                                "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-update/${emailVal}"),
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
                  
                                          merchantnameTextEditingController.text="";
                                          passwordTextEditingController.text="";
                                          phoneTextEditingController.text="";
                                          countryTextEditingController.text="";
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.success,
                                            text: "Your Information's Updated Successfully!",
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
                                      }
                  
                                    },
                                    child: Text(
                                      "${getLang(context, 'update')}",
                                      style: GoogleFonts.federo(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                  
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
