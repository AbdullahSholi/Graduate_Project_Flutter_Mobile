import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_your_store(5.1).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:graduate_project/screens/register.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../components/applocal.dart';
import '../../../models/merchant/login_page_merchant.dart';
import '../merchant_home_page(3)/merchant_home_page.dart';
import 'merchant-forget-reset-password.dart';
import 'merchant_register.dart';



class LoginOrRegister extends StatefulWidget {

  final String token;
  final String email;
  LoginOrRegister(this.token,this.email);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> with TickerProviderStateMixin {


  String tokenVal = "";
  String emailVal = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
  }

  bool defaultObsecure = false;
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  Color primaryColor = Color(0xFF212128);
  Color secondaryColor = Color(0xFFF4F4FB);
  Color accentColor = Color(0xFF0E1011);
  final _formKey = GlobalKey<FormState>();


  int secondsLeft = 60;

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (secondsLeft == 0) {
        timer.cancel();
        print("Countdown complete!");
        setState(() {
          secondsLeft=60;
        });
      } else {
        print('$secondsLeft seconds left');
        setState(() {
          secondsLeft--;
        });

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF212128),
          ),
          child: Form(
            key: _formKey,
            child: Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipPath(
                      clipper: WaveClipper(),
                      child: Image.asset(
                        'assets/images/login.jpg',
                        // width: 110.0,
                        // height: 110.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 12,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                      child: TextFormField(
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        controller: emailTextEditingController,
                        //Making keyboard just for Email
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: '${getLang(context, 'email_address')}',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.email,color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, )
                            )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
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
                            labelStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(
                              Icons.password,color: Colors.white,
                            ),
                            suffixIcon: IconButton( color: Colors.white, onPressed: () {
                              setState(() {
                                defaultObsecure= !defaultObsecure;
                              });
                            }, icon: Icon(defaultObsecure ? Icons.visibility : Icons.visibility_off)
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, )
                            )
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/2.5,
                          decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child: TextButton(onPressed:
                              ()async{
                            if(_formKey.currentState!.validate()){
                              try {
                                var email = emailTextEditingController.text;
                                var password = passwordTextEditingController.text;
                                http.Response userFuture = await http.post(
                                  Uri.parse(
                                      "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-login"),
                                  headers: { "Content-Type": "application/json"},
                                  body: jsonEncode(
                                    {"email": email, "password": password,},

                                  ),
                                  encoding: Encoding.getByName("utf-8"),
                                );
                                print(userFuture.body);
                                print(emailVal);
                                if(userFuture.body.toString().trim()=="Too many login attempts, please try again after 60 seconds"){

                                    startTimer();
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: 'Oops...',
                                    text: 'Too many login attempts, please try again after ${secondsLeft} seconds',
                                  );

                                }
                                else if(jsonDecode(userFuture.body)["message"].toString().trim() == "Invalid email or password"){
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: 'Oops...',
                                    text: 'Incorrect email or password. Please try again.',
                                  );
                                }
                                var temp = LoginPageMerchant.fromJson(
                                    json.decode(userFuture.body));

                                print(temp?.token );
                                print(temp?.email);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> MerchantHome(temp.token,temp.email)));
                              }
                              catch(error) {

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

                          }, child: Text("${getLang(context, 'login')}",style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)))),
                        ),
                        SizedBox(width: 20,),
                        Container(
                          width: MediaQuery.of(context).size.width/2.5,
                          decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child: TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> MerchantRegister("","")));
                          }, child: Text("${getLang(context, 'register')}",style:GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),)),
                        ),
                      ],),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${getLang(context, 'forgot_password')}?  ",
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15))),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetAndResetPassword(
                                        emailVal, tokenVal)));
                          },
                          child: Text("${getLang(context, 'click')} !",
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue,
                                      decorationThickness: 2,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))),
                        ),
                        // SizedBox(width: 30,)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

        ),
      ),
    );
  }
}


class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
    Offset(size.width * 3 / 4, size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}