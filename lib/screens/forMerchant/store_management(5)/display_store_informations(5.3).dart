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
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
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
      Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}"),
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
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
      Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}"),
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
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
        appBar: AppBar(
          backgroundColor: Color(0xFF212128),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
          ),
          title: Text("Store Informations", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFF212128),
          ),
          width: double.infinity,
          height: double.infinity,

          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
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
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  child: Text(snapshot.data!.storeName,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 3, color: Colors.white),
                                ),
                                child: CircleAvatar(
                                  radius: 100,
                                  child: ClipOval(child: CachedNetworkImage(
                                    imageUrl:snapshot.data!.storeAvatar,
                                    placeholder: (context, url) => SimpleCircularProgressBar(
                                      mergeMode: true,
                                      animationDuration: 1,
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,

                                  ),),
                                ),
                              ),
                              SizedBox(height: 30,),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                child: Text("${snapshot.data!.storeCategory}",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 20,

                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width/1.3,
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),

                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                child: Text("${snapshot.data!.storeDescription}",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 20,

                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width/1.3,
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              FutureBuilder<Store>(
                                future: userSocialAccounts,

                                builder: (BuildContext context, AsyncSnapshot<Store> snapshot) {
                                  return Container(

                                    width: double.infinity,
                                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: ()async{
                                                final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[0]}');
                                                if (_url.toString().startsWith("https://")) {
                                                  if (!await launchUrl(_url)) {
                                                    throw Exception('Could not launch $_url');
                                                  }
                                                } else{
                                                  QuickAlert.show(
                                                    context: context,
                                                    type: QuickAlertType.error,
                                                    title: 'Oops...',
                                                    text: 'Sorry, but link not provided!!',
                                                  );
                                                }

                                              },
                                              child: CircleAvatar(
                                                radius:28,
                                                backgroundColor: Color(0xFF0E1011),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ClipOval(child: FaIcon(FontAwesomeIcons.facebook,size: 40,color: Colors.white,))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: ()async{
                                                final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[3]}');
                                                print(_url);
                                                if (_url.toString().startsWith("https://")) {
                                                  if (!await launchUrl(_url)) {
                                                    throw Exception('Could not launch $_url');
                                                  }
                                                } else{
                                                  QuickAlert.show(
                                                    context: context,
                                                    type: QuickAlertType.error,
                                                    title: 'Oops...',
                                                    text: 'Sorry, but link not provided!!',
                                                  );
                                                }
                                              },
                                              child: CircleAvatar(
                                                radius:28,
                                                backgroundColor: Color(0xFF0E1011),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ClipOval(child: FaIcon(FontAwesomeIcons.whatsapp,size: 40,color: Colors.white,))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: ()async{
                                                final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[1]}');
                                                if (_url.toString().startsWith("https://")) {
                                                  if (!await launchUrl(_url)) {
                                                    throw Exception('Could not launch $_url');
                                                  }
                                                } else{
                                                  QuickAlert.show(
                                                    context: context,
                                                    type: QuickAlertType.error,
                                                    title: 'Oops...',
                                                    text: 'Sorry, but link not provided!!',
                                                  );
                                                }
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Color(0xFF0E1011),
                                                radius:28,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ClipOval(child: FaIcon(FontAwesomeIcons.telegram,size: 40,color: Colors.white,))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: ()async{
                                                final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[4]}');
                                                if (_url.toString().startsWith("https://")) {
                                                  if (!await launchUrl(_url)) {
                                                    throw Exception('Could not launch $_url');
                                                  }
                                                } else{
                                                  QuickAlert.show(
                                                    context: context,
                                                    type: QuickAlertType.error,
                                                    title: 'Oops...',
                                                    text: 'Sorry, but link not provided!!',
                                                  );
                                                }
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Color(0xFF0E1011),
                                                radius:28,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ClipOval(child: FaIcon(FontAwesomeIcons.tiktok,size: 40,color: Colors.white,))
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

                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: ()async{
                                                final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[5]}');
                                                if (_url.toString().startsWith("https://")) {
                                                  if (!await launchUrl(_url)) {
                                                    throw Exception('Could not launch $_url');
                                                  }
                                                } else{
                                                  QuickAlert.show(
                                                    context: context,
                                                    type: QuickAlertType.error,
                                                    title: 'Oops...',
                                                    text: 'Sorry, but link not provided!!',
                                                  );
                                                }
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Color(0xFF0E1011),
                                                radius:28,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ClipOval(child: FaIcon(FontAwesomeIcons.snapchat,size: 40,color: Colors.white,))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: ()async{
                                                final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[2]}');
                                                if (_url.toString().startsWith("https://")) {
                                                  if (!await launchUrl(_url)) {
                                                    throw Exception('Could not launch $_url');
                                                  }
                                                } else{
                                                  QuickAlert.show(
                                                    context: context,
                                                    type: QuickAlertType.error,
                                                    title: 'Oops...',
                                                    text: 'Sorry, but link not provided!!',
                                                  );
                                                }
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Color(0xFF0E1011),
                                                radius:28,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ClipOval(child: FaIcon(FontAwesomeIcons.instagram,size: 40,color: Colors.white,))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: ()async{
                                                final Uri _url = Uri.parse('${snapshot.data!.socialMediaAccounts[6]}');
                                                if (_url.toString().startsWith("https://")) {
                                                  if (!await launchUrl(_url)) {
                                                    throw Exception('Could not launch $_url');
                                                  }
                                                } else{
                                                  QuickAlert.show(
                                                    context: context,
                                                    type: QuickAlertType.error,
                                                    title: 'Oops...',
                                                    text: 'Sorry, but link not provided!!',
                                                  );
                                                }
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Color(0xFF0E1011),
                                                radius:28,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ClipOval(child: FaIcon(FontAwesomeIcons.linkedin,size: 40,color: Colors.white,))
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          width: MediaQuery.of(context).size.width/1.3,
                                          child: Divider(
                                            thickness: 1,
                                            color: Colors.grey,
                                          ),
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
        ));
  }
}
