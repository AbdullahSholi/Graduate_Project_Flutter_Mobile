import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/screens/forCustomers/customer_login_register/customer-forget-reset-password.dart';
import 'package:graduate_project/screens/forCustomers/customer_main_page(1)/customer_main_page.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_your_store(5.1).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:graduate_project/screens/register.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

// import '../../../models/merchant/login_page_merchant.dart';

import '../../../models/customer/customer_login_model.dart';
import '../../../models/customer/customer_register_model.dart';
import '../../forMerchant/login_or_register(2)/login_or_register(2).dart';
import 'customer_register.dart';

class CustomerLoginOrRegister extends StatefulWidget {
  final String token;
  final String email;
  CustomerLoginOrRegister(this.token, this.email);

  @override
  State<CustomerLoginOrRegister> createState() =>
      _CustomerLoginOrRegisterState();
}

class _CustomerLoginOrRegisterState extends State<CustomerLoginOrRegister>
    with TickerProviderStateMixin {
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
      backgroundColor: primaryColor,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // color: Colors.blue,
        ),
        child: Container(
          height: double.infinity,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                  // SizedBox(height: MediaQuery.of(context).size.height/10,),
                  // Text("${getLang(context, 'login_as_customer')}",style: TextStyle(color: secondaryColor, fontSize: 25),),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                    // width: MediaQuery.of(context).size.width/1.3,
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(color: secondaryColor)),
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
                          labelText: "${getLang(context, 'email_address')}",
                          labelStyle: GoogleFonts.roboto(
                              textStyle: TextStyle(color: secondaryColor)),
                          prefixIcon: Icon(
                            Icons.email,
                            color: secondaryColor,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: secondaryColor,
                          )),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: secondaryColor,
                          ))),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                    child: TextFormField(
                      obscureText: !defaultObsecure,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(color: secondaryColor)),
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
                          labelText: "${getLang(context, 'password')}",
                          labelStyle: GoogleFonts.roboto(
                              textStyle: TextStyle(color: secondaryColor)),
                          prefixIcon: Icon(
                            Icons.password,
                            color: secondaryColor,
                          ),
                          suffixIcon: IconButton(
                              color: secondaryColor,
                              onPressed: () {
                                setState(() {
                                  defaultObsecure = !defaultObsecure;
                                });
                              },
                              icon: Icon(defaultObsecure
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: secondaryColor,
                          )),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: secondaryColor,
                          ))),
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
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: TextButton(
                            onPressed: () async {
                              // _formKey.currentState!.validate();
                              if (_formKey.currentState!.validate()) {
                                try {
                                  var email = emailTextEditingController.text;
                                  var password =
                                      passwordTextEditingController.text;
                                  http.Response userFuture = await http.post(
                                    Uri.parse(
                                        "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/login"),
                                    headers: {
                                      "Content-Type": "application/json"
                                    },
                                    body: jsonEncode(
                                      {
                                        "email": email,
                                        "password": password,
                                      },
                                    ),
                                    encoding: Encoding.getByName("utf-8"),
                                  );
                                  print(userFuture.body);
                                  print(emailVal);
                                  if (userFuture.body.toString().trim() ==
                                      "Too many login attempts, please try again after 60 seconds") {
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (context) => AlertDialog(
                                    //     title: Row(
                                    //       children: [
                                    //         Icon(
                                    //           Icons.error_outline,
                                    //           color: Colors.red,
                                    //           weight: 30,
                                    //         ),
                                    //         SizedBox(
                                    //           width: 10,
                                    //         ),
                                    //         Text(
                                    //           "Error Occurs!",
                                    //           style: TextStyle(
                                    //               color: Colors.white),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     backgroundColor: Color(0xFF101720),
                                    //     content: Container(
                                    //       height: MediaQuery.of(context)
                                    //               .size
                                    //               .height /
                                    //           20,
                                    //       child: Text(
                                    //         "${userFuture.body}",
                                    //         style:
                                    //             TextStyle(color: Colors.white),
                                    //       ),
                                    //     ),
                                    //     actions: [
                                    //       TextButton(
                                    //           onPressed: () {
                                    //             Navigator.pop(context);
                                    //           },
                                    //           child: Text(
                                    //             "OK",
                                    //             style: TextStyle(
                                    //                 color: Colors.white),
                                    //           ))
                                    //     ],
                                    //   ),
                                    // );
                                    startTimer();
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      title: 'Oops...',
                                      text: 'Too many login attempts, please try again after ${secondsLeft} seconds',
                                    );
                                  }

                                  var temp = CustomerLoginPage.fromJson(
                                      json.decode(userFuture.body));

                                  print(temp?.token);
                                  print(temp?.email);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerMainPage(
                                                  temp.token, temp.email)));
                                } catch (error) {}
                              }
                            },
                            child: Text("${getLang(context, 'login')}",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)))),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerRegister("", "")));
                            },
                            child: Text("${getLang(context, 'register')}",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)))),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                  SizedBox(height: 60),
                  Container(
                    width: MediaQuery.of(context).size.width /1.15,
                    decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(4)),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginOrRegister("", "")));
                        },
                        child: Text("${getLang(context, 'continue_as_merchant')}",
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////
////////////////////
////////////////////
////////////////////
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