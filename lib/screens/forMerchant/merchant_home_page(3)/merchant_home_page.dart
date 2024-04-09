import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forMerchant/customize_store(6)/merchant_payment_information.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;

import '../personal_information(4)/personal_information(4).dart';



class MerchantHome extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;
  MerchantHome(this.token,this.email);

  @override
  State<MerchantHome> createState() => _MerchantHomeState();
}

class _MerchantHomeState extends State<MerchantHome> with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
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

        body: AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                  particleCount: 100,
                  image: Image(image: NetworkImage("https://t3.ftcdn.net/jpg/01/70/28/92/240_F_170289223_KNx1FpHz8r5ody9XZq5kMOfNDxsZphLz.jpg"))
              ),
            ),
            vsync: this,
            child:
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF212128),
                    ),
                    margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              
                              Container(
                                margin: EdgeInsets.all(20),
                                height: 40,
                                width: MediaQuery.of(context).size.width/1.26 ,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Text(
                                      "Main Page",
                                      style: GoogleFonts.federo(
                                          color: Color(0xFF212128),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21
                                      )
                                    )),
                              ),
                              SizedBox(
                                width: 0,
                              ),
                      
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 2,
                            color: Colors.white,
                          ),
                          SizedBox(height: 20,),
                          Container(
                            height: MediaQuery.of(context).size.height/1.5,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Text("Welcome to your Main Page",style: GoogleFonts.permanentMarker(
                                        color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold,
                                      ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40,),
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(15),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                        )
                                      ),
                                      child: Text("Personal Information", style: GoogleFonts.federo(
                                        color: Color(0xFF212128),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 29,
                      
                                      ),
                                      textAlign: TextAlign.center,
                                      ),
                                      onPressed: (){

                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> PersonalInformation(tokenVal,emailVal)));
                      
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.all(15),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)
                                          )
                                      ),
                                      child: Text("Store Management", style: GoogleFonts.federo(
                                        color: Color(0xFF212128),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 29,
                      
                                      ),
                                        textAlign: TextAlign.center,
                                      ),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreManagement(tokenVal, emailVal,"","","","",[],[],false,false,false)));
                      
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.all(15),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)
                                          )
                                      ),
                                      child: Text("Payment Informations", style: GoogleFonts.federo(
                                        color: Color(0xFF212128),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 29,

                                      ),
                                        textAlign: TextAlign.center,
                                      ),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> MerchantPaymentInformation(tokenVal, emailVal)));

                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(15),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                  )
                              ),
                              child: Text("Logout", style: GoogleFonts.federo(
                                color: Color(0xFF212128),
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                      
                              ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> LogAllPage()));
                      
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            )));
  }
}
