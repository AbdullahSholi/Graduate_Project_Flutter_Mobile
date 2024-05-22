import 'dart:convert';
// import 'dart:ffi';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_your_store(5.1).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:graduate_project/screens/register.dart';
import 'package:http/http.dart' as http;

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            // spawnMaxRadius: 40,
            // spawnMinRadius: 1.0,
              particleCount: 100,
              // spawnMaxSpeed: 150.0,
              // // minOpacity: .3,
              // // spawnOpacity: .4,
              // // baseColor: Colors.black26,
              image: Image(image: NetworkImage("https://t3.ftcdn.net/jpg/01/70/28/92/240_F_170289223_KNx1FpHz8r5ody9XZq5kMOfNDxsZphLz.jpg"))
          ),
        ),
        vsync: this,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 60, 10, 60),
          // color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFF212128),
            ),
            child: Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height/10,),
                    Text("Login as Merchant",style: TextStyle(color: Colors.white, fontSize: 25),),
                    SizedBox(height: 20,),
                    Container(
                      width: MediaQuery.of(context).size.width/1.3,
                      child: TextFormField(
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        controller: emailTextEditingController,
                        //Making keyboard just for Email
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Email address is required';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Email Address',
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
                      width: MediaQuery.of(context).size.width/1.3,
                      child: TextFormField(
                        obscureText: !defaultObsecure,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: passwordTextEditingController,
                        //Making keyboard just for Email
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Email address is required';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Password',
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
                      height: 50.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextButton(onPressed:
                              ()async{
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
                                showDialog(context: context, builder: (context)=>AlertDialog(
                                    title: Row(
                                                children: [
                                                  Icon(Icons.error_outline,color: Colors.red,weight: 30,),
                                                  SizedBox(width: 10,),
                                                  Text("Error Occurs!",style: TextStyle(color: Colors.white),),
                                                ],
                                              ),
                                  backgroundColor: Color(0xFF101720),
                                  content: Container(
                                    height: MediaQuery.of(context).size.height/20,
                                    child: Text("${userFuture.body}",style: TextStyle(color: Colors.white),),
                                  ),
                                actions: [
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: Text("OK",style: TextStyle(color: Colors.white),))
                                ],
                                ),
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
                          }, child: Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                        ),
                        SizedBox(width: 20,),
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> MerchantRegister("","")));
                          }, child: Text("Register",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                        ),
                      ],),
                    SizedBox(height: 10,),
                    Center(
                      child: InkWell( onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgetAndResetPassword(emailVal, tokenVal)));
                      }, child: Text("Forgot Password?",style: TextStyle(color: Colors.white),),),
                    )
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



