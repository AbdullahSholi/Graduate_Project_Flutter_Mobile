import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import "package:http/http.dart" as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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

  final _formKey = GlobalKey<FormState>();

  TextEditingController publishableKeyTextEditingController = TextEditingController();
  TextEditingController secretKeyTextEditingController = TextEditingController();

  Future<void> postData() async {
    print(tokenVal);
    print(emailVal);
    final String apiUrl = 'https://graduate-project-backend-1.onrender.com/merchant/api/v1/add-payment-informations/${emailVal}';

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
        appBar: AppBar(
          backgroundColor: Color(0xFF212128),
          leading: IconButton(
            onPressed: (){
              Navigator.push(context, (MaterialPageRoute(builder: (context)=> MerchantHome(tokenVal, emailVal))));
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
          ),
          title: Text("${getLang(context, 'payment_informations')}", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),

                            Container(
                              width:
                              MediaQuery.of(context).size.width / 1.15,
                              child: TextFormField(
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                controller:
                                publishableKeyTextEditingController,
                                //Making keyboard just for Email
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '${getLang(context, 'va_publish_key')}';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: '${getLang(context, 'publishable_key')}',
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
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                controller: secretKeyTextEditingController,
                                //Making keyboard just for Email
                                keyboardType:
                                TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '${getLang(context, 'va_secret_key')}';
                                  }
                                  return null;

                                },
                                decoration: InputDecoration(
                                    labelText: '${getLang(context, 'secret_key')}',
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
                      SizedBox(
                        height: 40.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFF0E1011)
                        ),
                        child: TextButton(
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
                                final String apiUrl = 'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/add-payment-informations/${emailVal}';

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
                                // publishableKeyTextEditingController.text="";
                                // secretKeyTextEditingController.text="";
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  title: "${getLang(context, 'success')}",
                                  text: "${getLang(context, 'al_payment_information_successfully')}",
                                  confirmBtnText: "${getLang(context, 'al_ok')}"
                                );

                                ///////////////////////
                              }





                            },
                            child: Text(
                              "${getLang(context, 'add')}",
                              style: GoogleFonts.roboto(
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
            ),
          ],
        ));
  }
}
