import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/connect_to_social_media_accounts.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_store_informations(5.3).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_your_store(5.1).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/edit_your_store_design(5.2).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;

import '../../../models/merchant/merchant_connect_store_to_social_media.dart';
import '../../../models/merchant/merchant_profile.dart';
import '../merchant_home_page(3)/merchant_home_page.dart';
import '../personal_information(4)/personal_information(4).dart';
import 'edit_your_store_informations(5.4).dart';



class StoreManagement extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;
  final String imageUrl;
  final String storeNameVal;
  final String storeCategoryVal;
  final String storeDescriptionVal;
  final List<String> specificStoreCategoriesVal;

  StoreManagement(this.token,this.email,this.imageUrl, this.storeNameVal, this.storeCategoryVal, this.storeDescriptionVal,this.specificStoreCategoriesVal);

  @override
  State<StoreManagement> createState() => _StoreManagementState();
}

class _StoreManagementState extends State<StoreManagement> with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
  String imageUrlVal="";
  String storeNameVal = "";
  String storeCategoryVal = "";
  String storeDescriptionVal = "";
  List<String> specificStoreCategoriesVal = [];
  late Future<Merchant> userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
    imageUrlVal = widget.imageUrl;
    storeNameVal = widget.storeNameVal;
    storeCategoryVal = widget.storeCategoryVal;
    storeDescriptionVal = widget.storeDescriptionVal;
    specificStoreCategoriesVal = widget.specificStoreCategoriesVal;
    userData = getUserByName();

  }

  Future<Merchant> getUserByName() async{
  print("$emailVal tttttttttt");
    http.Response userFuture = await http.get(
        Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/merchant-profile/${emailVal}"),
    );

    // print(userFuture.body[1]);

    if(userFuture.statusCode == 200){
      // print("${userFuture.body}");
      print(Merchant.fromJson(json.decode(userFuture.body)));


      return Merchant.fromJson(json.decode(userFuture.body));
    }
    else{
      throw Exception("Error");
    }
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MerchantHome(tokenVal, emailVal)));
                                    },
                                    // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 0,
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Text(
                                        "Store Management",
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

                          FutureBuilder<Merchant>(
                            future: userData,
                            builder: (BuildContext context, AsyncSnapshot<Merchant> snapshot) {
                              try {
                                imageUrlVal = snapshot.data!.storeAvatar;
                                storeNameVal = snapshot.data!.storeName;
                                storeCategoryVal = snapshot.data!.storeCategory;
                                storeDescriptionVal = snapshot.data!.storeDescription;
                                return Container(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height / 1.5,

                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [

                                        Center(
                                          child: Container(

                                              padding: EdgeInsets.all(15),

                                              child: Text(
                                                storeNameVal,
                                                style: GoogleFonts
                                                    .permanentMarker(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              )

                                          ),
                                        ),
                                        Container(

                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 2,
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height / 4,
                                          child: CircleAvatar(
                                            radius: 20,
                                            child: ClipOval(
                                              child: Image.network(
                                                  snapshot.data!.storeAvatar,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),

                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.fromLTRB(
                                              30, 0, 30, 0),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(15),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(15)
                                                )
                                            ),
                                            child: Text("Display your store",
                                              style: GoogleFonts.federo(
                                                color: Color(0xFF212128),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 29,

                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DisplayYourStore(
                                                              "", "")));
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.fromLTRB(
                                              30, 0, 30, 0),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(15),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(15)
                                                )
                                            ),
                                            child: Text(
                                              "Edit your store design",
                                              style: GoogleFonts.federo(
                                                color: Color(0xFF212128),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 29,

                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditYourStoreDesign(
                                                              tokenVal,emailVal,specificStoreCategoriesVal,storeNameVal)));
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.fromLTRB(
                                              30, 0, 30, 0),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(15),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(15)
                                                )
                                            ),
                                            child: Text(
                                              "Display store informations",
                                              style: GoogleFonts.federo(
                                                color: Color(0xFF212128),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,

                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DisplayStoreInformations(
                                                              tokenVal, emailVal)));
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.fromLTRB(
                                              30, 0, 30, 0),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(15),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(15)
                                                )
                                            ),
                                            child: Text(
                                              "Edit your store information",
                                              style: GoogleFonts.federo(
                                                color: Color(0xFF212128),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,

                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditYourStoreInformations(
                                                              tokenVal, emailVal,imageUrlVal,storeNameVal,storeCategoryVal,storeDescriptionVal)));
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.fromLTRB(
                                              30, 0, 30, 0),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(15),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(15)
                                                )
                                            ),
                                            child: Text("Store statistics",
                                              style: GoogleFonts.federo(
                                                color: Color(0xFF212128),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 29,

                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditYourStoreDesign(
                                                              "", "",specificStoreCategoriesVal,storeNameVal)));
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.fromLTRB(
                                              30, 0, 30, 0),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.all(15),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(15)
                                                )
                                            ),
                                            child: Text("Connect social media ",
                                              style: GoogleFonts.federo(
                                                color: Color(0xFF212128),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 29,

                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ConnectToSocialMediaAccounts(tokenVal, emailVal, imageUrlVal, storeNameVal, storeCategoryVal, storeDescriptionVal)));
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                      ],
                                    ),


                                  ),
                                );
                              }catch(err){
                                return Text("err");
                              }
                            },

                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
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
