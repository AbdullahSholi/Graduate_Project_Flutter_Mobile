import 'dart:convert';
import 'dart:ffi';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graduate_project/screens/forGuest/guest_main_page(1)/guest_main_page.dart';
import 'package:graduate_project/screens/home.dart';
import 'package:graduate_project/screens/register.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import '../../models/Stores/display-all-stores.dart';
import '../../models/login_model.dart';
import '../../models/merchant/merchant_connect_store_to_social_media.dart';
import '../../stripe_payment/stripe_keys.dart';
import '../forAdmin/admin_main_page.dart';
import '../forCustomers/customer_main_page(1)/customer_main_page.dart';
import '../forMerchant/merchants_main_page(1)/merchants_main_page(1).dart';


class LogAllPage extends StatefulWidget {
  const LogAllPage({super.key});

  @override
  State<LogAllPage> createState() => _LogAllPageState();
}

class _LogAllPageState extends State<LogAllPage> with TickerProviderStateMixin{
  bool defaultObsecure = false;

  TextEditingController emailTextEditingController = TextEditingController();

  TextEditingController passwordTextEditingController = TextEditingController();
////////////////////////////////////////////////////
  ///////////////////////////////////////////////

  late Future<List<dynamic>> getStoreData;
  late List<dynamic> tempStores=[];
  Future<List<dynamic>> getMerchantData() async {

    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/get-all-stores/"),
    );
    print(userFuture.body);
    List<dynamic> jsonList = json.decode(userFuture.body);
    for(int i=0; i<jsonList.length; i++){
      tempStores.add(SpecificStore.fromJson(jsonList[i]));

    }

    // print("jsonList: ${jsonList[1]}");

    if (userFuture.statusCode == 200) {
      print("${userFuture.statusCode}");

      return tempStores;
    } else {
      print("error");
      throw Exception("Error");
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStoreData = getMerchantData();


  }

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
                        child: Text("MATJARKOM",style: GoogleFonts.lilitaOne(
                            color: Color(0xFF212128),
                            fontSize: 45,
                            fontWeight: FontWeight.bold
                        ),)
                    ),
                    SizedBox(height: 50,),
                    Container(
                      child: Column(
                        children: [

                          FutureBuilder<List<dynamic>>(
                            future: getStoreData,
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              print("RRRR ${snapshot.data}");
                              return InkWell(onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> GuestMainPage()));
                              }, child: Text("Continue as Guest",style: GoogleFonts.lilitaOne(
                                  textStyle: TextStyle(color: Colors.white),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                              ),));
                            },

                          ),

                          SizedBox(height: 10,),
                          InkWell(onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerMainPage()));
                          }, child: Text("Continue as User ",style: GoogleFonts.lilitaOne(
                              textStyle: TextStyle(color: Colors.white),
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                          ),)),
                          SizedBox(height: 10,),
                          InkWell(onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> MerchantMainPage()));
                          }, child: Text("Continue as Merchant",style: GoogleFonts.lilitaOne(
                              textStyle: TextStyle(color: Colors.white),
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                          ),)),
                          SizedBox(height: 10,),
                          InkWell(onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminMainPage()));
                          }, child: Text("Continue as Admin",style: GoogleFonts.lilitaOne(
                              textStyle: TextStyle(color: Colors.white),
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                          ),))
                        ],
                      ),
                    ),

                  ],

            )


          ),
        ),
      ),
    );
  }
}
