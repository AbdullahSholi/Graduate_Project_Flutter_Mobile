import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import "package:http/http.dart" as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ForgetAndResetPassword extends StatefulWidget {
  String emailVal;
  String tokenVal;
  ForgetAndResetPassword(this.emailVal, this.tokenVal, {super.key});

  @override
  State<ForgetAndResetPassword> createState() =>
      _ForgetAndResetPasswordState();
}

class _ForgetAndResetPasswordState extends State<ForgetAndResetPassword> {

  String emailVal = "";
  String tokenVal = "";



  final TextEditingController emailTextEditingController = TextEditingController();













  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tokenVal = widget.tokenVal;
    emailVal = widget.emailVal;

    //
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
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 30,
            ),
          ),
          title: Text("${getLang(context, 'forgot_reset_password')}",
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              )),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          width: double.infinity,
          color: Color(0xFFF2F2F2),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text("${getLang(context, 'forgot_password')}",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          color: Color(0xFF212128),
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ), textAlign: TextAlign.start,),
                SizedBox(height: 20,),
                Text("${getLang(context, 'forgot_password_description')}",
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        color: Color(0xFF212128),
                        fontSize: 18,
                        ),
                  ), textAlign: TextAlign.start,),
                SizedBox(height: 40,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    cursorColor: Color(0xFF212128),
                    style: TextStyle(color: Color(0xFF212128)),
                    controller: emailTextEditingController,
                    //Making keyboard just for Email
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Email address is required';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: '${getLang(context, 'email_address')}',
                        labelStyle: TextStyle(color: Color(0xFF212128)),
                        prefixIcon: Icon(
                          Icons.email,color: Color(0xFF212128),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF212128), )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF212128), )
                        )
                    ),
                  ),
                ),
                SizedBox(height: 80,),
                Container(
                  width: MediaQuery.of(context).size.width/1.1,
                  height: 50,
                  child: TextButton(

                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFFF4F4FB), backgroundColor: Color(0xFF0E1011),  // Text color
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),  // Border radius
                      ),
                    ),
                    onPressed: () async {

                      http.Response userFuture =
                      await http.post(
                        Uri.parse(
                            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-forgot-password"),
                        headers: {
                          "Content-Type": "application/json",
                        },
                        body: jsonEncode(
                          {
                            "email": emailTextEditingController.text
                          },
                        ),
                        encoding:
                        Encoding.getByName("utf-8"),
                      );

                      print(userFuture.body);
                      if(userFuture.body == "User with this email does not exist"){
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Oops...',
                          text: 'User with this email does not exist',
                        );
                      }
                      if(userFuture.body == "Password reset link sent to your email account"){
                        setState(() {
                          emailTextEditingController.text = "";
                        });
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: 'Password reset link sent to your email account',
                        );
                      }

                    },
                    child: Text('${getLang(context, 'send')}',style: GoogleFonts.roboto(
                        color: Color(0xFFF4F4FB),
                        fontWeight: FontWeight.bold,
                        fontSize: 21),),
                  ),
                ),

              ],
            ),
          ),
        ));
  }
}
