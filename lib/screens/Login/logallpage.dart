import 'dart:convert';
import 'dart:ffi';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduate_project/screens/forGuest/guest_main_page.dart';
import 'package:graduate_project/screens/home.dart';
import 'package:graduate_project/screens/register.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import '../../models/login_model.dart';
import '../forAdmin/admin_main_page.dart';
import '../forCustomers/customers_main_page.dart';
import '../forMerchant/merchants_main_page(1)/merchants_main_page(1).dart';


class LogAllPage extends StatefulWidget {
  const LogAllPage({super.key});

  @override
  State<LogAllPage> createState() => _LogAllPageState();
}

class _LogAllPageState extends State<LogAllPage> with TickerProviderStateMixin {

  bool defaultObsecure = false;
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(30, 30, 30, 20),
                  height: MediaQuery.of(context).size.height/4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white
                  ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Text("MATJARKOM",style: GoogleFonts.federo(
                      color: Color(0xFF212128),
                      fontSize: 45,
                      fontWeight: FontWeight.bold
                    ),)
                ),
                SizedBox(height: 50,),
                Container(
                  child: Column(
                    children: [
                      InkWell(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> GuestMainPage()));
                      }, child: Text("Continue as Guest",style: GoogleFonts.fredoka(
                        textStyle: TextStyle(color: Colors.white),
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                      ),)),
                      SizedBox(height: 10,),
                      InkWell(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerMainPage()));
                      }, child: Text("Continue as User ",style: GoogleFonts.fredoka(
                          textStyle: TextStyle(color: Colors.white),
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                      ),)),
                      SizedBox(height: 10,),
                      InkWell(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> MerchantMainPage()));
                      }, child: Text("Continue as Merchant",style: GoogleFonts.fredoka(
                          textStyle: TextStyle(color: Colors.white),
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                      ),)),
                      SizedBox(height: 10,),
                      InkWell(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminMainPage()));
                      }, child: Text("Continue as Admin",style: GoogleFonts.fredoka(
                          textStyle: TextStyle(color: Colors.white),
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                      ),))
                    ],
                  ),
                ),

              ],
            ),

          ),
        ),
      ),
    );
  }
}
