import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/register_model.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController streetTextEditingController = TextEditingController();

  bool defaultObsecure = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        // appBar: AppBar(
        //   leading: Builder(
        //     builder: (BuildContext context) {
        //       return IconButton(
        //         icon: const Icon(Icons.arrow_back,color: Colors.white,), // Replace with your desired icon
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        //       );
        //     },
        //   ),
        //   title: Text("Register",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        //   centerTitle: true,
        //   backgroundColor: Color(0xFF212128),
        // ),
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
    child:
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF212128),
      ),
      margin: EdgeInsets.fromLTRB(20,40,20,20),
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
              height: MediaQuery.of(context).size.height/1.2,

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
                        controller: usernameTextEditingController,
                        //Making keyboard just for Email
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Username is required';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: const TextStyle(color: Colors.white),
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
                            labelStyle: const TextStyle(color: Colors.white),
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
                            return 'Password is required';
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
                            labelStyle: const TextStyle(color: Colors.white),
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
                      margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
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
                            labelStyle: const TextStyle(color: Colors.white),
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
                      margin: EdgeInsets.fromLTRB(0, 28, 0, 20),
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: streetTextEditingController,
                        //Making keyboard just for Email
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Street',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.location_on,
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
                    Container(
                      width: MediaQuery.of(context).size.width/2.5,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF18181E),
                      ),
                      child: Center(child: TextButton(onPressed: ()async{
                        try {
                          var email = emailTextEditingController.text;
                          var password = passwordTextEditingController.text;
                          var username = usernameTextEditingController.text;
                          var phone = phoneTextEditingController.text;
                          var country = countryTextEditingController.text;
                          var street = streetTextEditingController.text;
                          http.Response userFuture = await http.post(
                            Uri.parse(
                                "http://10.0.2.2:3000/electrohub/api/v1/register"),
                            headers: { "Content-Type": "application/json"},
                            body: jsonEncode(
                                {"email": email, "password": password,
                                  "username":username, "phone":phone, "country": country,
                                  "street":street
                                },
                
                            ),
                            encoding: Encoding.getByName("utf-8"),
                          );
                          print(userFuture.body);
                          var temp = RegisterPage.fromJson(
                              json.decode(userFuture.body));
                          print(temp);
                          print(temp?.token );
                          print(temp?.email);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(temp.token,temp.email)));
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
                      }, child: Text("Register",style: TextStyle(color: Colors.white),)),),
                    ),
                    SizedBox(height: 5,),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: const TextStyle(color: Colors.white),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Login ',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                },
                              style: const TextStyle(color: Colors.blue),
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
      ),
    )
        )
    );
  }
}
