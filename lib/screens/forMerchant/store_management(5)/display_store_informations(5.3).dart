import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_your_store(5.1).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/rabish/edit_your_store_design(5.2).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:social_media_flutter/widgets/icons.dart';
import 'package:social_media_flutter/widgets/text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/merchant/merchant_connect_store_to_social_media.dart';
import '../../../models/merchant/merchant_profile.dart';
import '../merchant_home_page(3)/merchant_home_page.dart';
import '../personal_information(4)/personal_information(4).dart';



class DisplayStoreInformations extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;
  DisplayStoreInformations(this.token,this.email);

  @override
  State<DisplayStoreInformations> createState() => _DisplayStoreInformationsState();
}

class _DisplayStoreInformationsState extends State<DisplayStoreInformations> with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
  late Future<Merchant> userData;
  late Future<Store> userSocialAccounts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
    userData = getUserByName();
    userSocialAccounts = getSocialAccountsByEmail();
  }

  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse('https://flutter.dev');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
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

  Future<Store> getSocialAccountsByEmail() async{
    print("$emailVal tttttttttt");
    http.Response userFuture = await http.get(
      Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/merchant-profile/${emailVal}"),
    );

    // print(userFuture.body[1]);

    if(userFuture.statusCode == 200){
      // print("${userFuture.body}");
      print(Store.fromJson(json.decode(userFuture.body)));


      return Store.fromJson(json.decode(userFuture.body));
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF212128),
              ),
              margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
              width: double.infinity,
              height: double.infinity,

              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
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
                                  "Store Informations",
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
                          return Container(
                            height: MediaQuery.of(context).size.height/1.25,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      child: Text(snapshot.data!.storeName,
                                        style: GoogleFonts.permanentMarker(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
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
                                      child: ClipOval(child: CachedNetworkImage(
                                        imageUrl:snapshot.data!.storeAvatar,
                                        placeholder: (context, url) => SimpleCircularProgressBar(
                                          mergeMode: true,
                                          animationDuration: 1,
                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                        fit: BoxFit.cover,

                                      ),),
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
                                              borderRadius: BorderRadius
                                                  .circular(15)
                                          )
                                      ),
                                      child: Text("Category: ${snapshot.data!.storeCategory}",
                                        style: GoogleFonts.federo(
                                          color: Color(0xFF212128),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 29,
                              
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      onPressed: () {

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
                                              borderRadius: BorderRadius
                                                  .circular(15)
                                          )
                                      ),
                                      child: Text("Descripton: ${snapshot.data!.storeDescription}",
                                        style: GoogleFonts.federo(
                                          color: Color(0xFF212128),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 29,
                              
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      onPressed: () {

                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  FutureBuilder<Store>(
                                    future: userSocialAccounts,

                                    builder: (BuildContext context, AsyncSnapshot<Store> snapshot) {
                                      return Container(
                                        
                                        width: double.infinity,
                                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                          padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.white
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("Social Accounts",style: GoogleFonts.federo(
                                              color: Color(0xFF212128),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 29,

                                            ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                SizedBox(width: 5,),
                                                GestureDetector(
                                                  onTap: ()async{
                                                    final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[0]}');
                                                    if (!await launchUrl(_url)) {
                                                      throw Exception('Could not launch $_url');
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    radius:28,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        ClipOval(child: FaIcon(FontAwesomeIcons.facebook,size: 40,color: Colors.blue,))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5,),
                                                GestureDetector(
                                                  onTap: ()async{
                                                    final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[3]}');
                                                    if (!await launchUrl(_url)) {
                                                      throw Exception('Could not launch $_url');
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    radius:28,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        ClipOval(child: FaIcon(FontAwesomeIcons.whatsapp,size: 40,color: Colors.blue,))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5,),
                                                GestureDetector(
                                                  onTap: ()async{
                                                    final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[1]}');
                                                    if (!await launchUrl(_url)) {
                                                      throw Exception('Could not launch $_url');
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    radius:28,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        ClipOval(child: FaIcon(FontAwesomeIcons.telegram,size: 40,color: Colors.blue,))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5,),
                                                GestureDetector(
                                                  onTap: ()async{
                                                    final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[4]}');
                                                    if (!await launchUrl(_url)) {
                                                      throw Exception('Could not launch $_url');
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    radius:28,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        ClipOval(child: FaIcon(FontAwesomeIcons.tiktok,size: 40,color: Colors.blue,))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                SizedBox(width: 5,),
                                                GestureDetector(
                                                  onTap: ()async{
                                                    final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[5]}');
                                                    if (!await launchUrl(_url)) {
                                                      throw Exception('Could not launch $_url');
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    radius:28,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        ClipOval(child: FaIcon(FontAwesomeIcons.snapchat,size: 40,color: Colors.blue,))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5,),
                                                GestureDetector(
                                                  onTap: ()async{
                                                    final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[2]}');
                                                    if (!await launchUrl(_url)) {
                                                      throw Exception('Could not launch $_url');
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    radius:28,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        ClipOval(child: FaIcon(FontAwesomeIcons.instagram,size: 40,color: Colors.blue,))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5,),
                                                GestureDetector(
                                                  onTap: ()async{
                                                    final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[6]}');
                                                    if (!await launchUrl(_url)) {
                                                      throw Exception('Could not launch $_url');
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    radius:28,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        ClipOval(child: FaIcon(FontAwesomeIcons.linkedin,size: 40,color: Colors.blue,))
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),


                                          ],
                                        )
                                      );
                                    },

                                  ),
                              
                              
                                ],
                              ),
                            ),
                          );
                        }
                        catch(e){
                          return Text("err");
                        }
                      },

                    ),

                  ],
                ),
              ),
            )));
  }
}
