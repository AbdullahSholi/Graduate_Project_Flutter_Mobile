import 'dart:convert';
import 'dart:ffi';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduate_project/screens/home.dart';
import 'package:graduate_project/screens/register.dart';
import 'package:http/http.dart' as http;


import '../models/login_model.dart' ;

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height/10,),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Image.asset("assets/images/logo.png")
                    ),
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
                                    "http://10.0.2.2:3000/electrohub/api/v1/login"),
                                headers: { "Content-Type": "application/json"},
                                body: jsonEncode(
                                    {"email": email, "password": password}),
                                encoding: Encoding.getByName("utf-8"),
                              );
                              var temp = LoginPage.fromJson(
                                  json.decode(userFuture.body));
                              print(temp?.token );
                              print(temp?.email);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(temp.token,temp.email)));
                            }
                            catch(error){
                              print("Email or Password was wrong!!");
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false, // User must tap button to close
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Row(
                                      children: [
                                        Icon(Icons.error_outline,color: Colors.red,weight: 30,),
                                        SizedBox(width: 10,),
                                        Text("Error Occurs!"),
                                      ],
                                    ),
                                    content: const SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text("Wrong Email or Password!!",style: TextStyle(color: Colors.black),),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
        
        
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
                          }, child: Text("Register",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                        ),
                    ],),
                    SizedBox(height: 10,),
                    Center(
                      child: TextButton( onPressed: () {  }, child: Text("Forgot Password?",style: TextStyle(color: Colors.white),),),
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



