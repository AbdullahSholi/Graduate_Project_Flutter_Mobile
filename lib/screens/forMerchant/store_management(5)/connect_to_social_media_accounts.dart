import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
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



class ConnectToSocialMediaAccounts extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;
  final String imageUrl;
  final String storeNameVal;
  final String storeCategoryVal;
  final String storeDescriptionVal;
  ConnectToSocialMediaAccounts(this.token,this.email,this.imageUrl, this.storeNameVal, this.storeCategoryVal, this.storeDescriptionVal);

  @override
  State<ConnectToSocialMediaAccounts> createState() => _ConnectToSocialMediaAccountsState();
}

class _ConnectToSocialMediaAccountsState extends State<ConnectToSocialMediaAccounts> with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
  String imageUrlVal="";
  String storeNameVal = "";
  String storeCategoryVal = "";
  String storeDescriptionVal = "";
  late Future<Store> userData;

  TextEditingController facebookPageLinkTextEditingController = TextEditingController();
  TextEditingController telegramPageLinkTextEditingController = TextEditingController();
  TextEditingController instagramTextEditingController = TextEditingController();
  TextEditingController snapshatTextEditingController = TextEditingController();
  TextEditingController tiktokTextEditingController = TextEditingController();
  TextEditingController linkedinTextEditingController = TextEditingController();
  TextEditingController whatsappTextEditingController = TextEditingController();

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
    userData = getUserByName();
  }

  Future<Store> getUserByName() async{
    print("$emailVal tttttttttt");
    http.Response userFuture = await http.get(
      Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/merchant-profile/${emailVal}"),
    );



    if(userFuture.statusCode == 200){
      // print("${userFuture.body}");
      print(Store.fromJson(json.decode(userFuture.body)));


      return Store.fromJson(json.decode(userFuture.body));
    }
    else{
      print("error");
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
                      // physics: NeverScrollableScrollPhysics(),
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>StoreManagement(tokenVal, emailVal,imageUrlVal,storeNameVal,storeCategoryVal, storeDescriptionVal,[])));
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
                                        "Connect To Social Media Accounts",
                                        style: GoogleFonts.federo(
                                            color: Color(0xFF212128),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21
                                        ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
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
                          FutureBuilder<Store>(
                            future: userData,

                            builder: (BuildContext context, AsyncSnapshot<Store> snapshot) {
                              print(snapshot.data?.socialMediaAccounts);
                              if(snapshot.hasData) {
                                return Container(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height / 1.2,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 38, 0, 0),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 1.3,

                                          child: TextFormField(

                                            style: TextStyle(
                                                color: Colors.white),
                                            cursorColor: Colors.white,
                                            controller: facebookPageLinkTextEditingController,
                                            //Making keyboard just for Email
                                            keyboardType: TextInputType.name,

                                            decoration: InputDecoration(
                                              hintText: snapshot.data!.socialMediaAccounts[0],
                                              hintStyle: TextStyle(color: Colors.white),
                                              prefixIcon: Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(20, 10, 20, 10),
                                                child: const FaIcon(
                                                  FontAwesomeIcons.facebook,
                                                  color: Colors.white,),
                                              ),
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  )),
                                            ),

                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 28, 0, 0),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 1.3,

                                          child: TextFormField(
                                            style: TextStyle(
                                                color: Colors.white),
                                            cursorColor: Colors.white,
                                            controller: telegramPageLinkTextEditingController,
                                            //Making keyboard just for Email
                                            keyboardType: TextInputType.name,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Telegram page link is required';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText: snapshot.data?.socialMediaAccounts[1],
                                                labelStyle: const TextStyle(
                                                    color: Colors.white),
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(20, 10, 20, 10),
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.telegram,
                                                    color: Colors.white,),
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
                                          margin: EdgeInsets.fromLTRB(
                                              0, 28, 0, 0),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 1.3,

                                          child: TextFormField(
                                            style: TextStyle(
                                                color: Colors.white),
                                            cursorColor: Colors.white,
                                            controller: instagramTextEditingController,
                                            //Making keyboard just for Email
                                            keyboardType: TextInputType.name,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Instagram page link is required';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText: snapshot.data?.socialMediaAccounts[2],
                                                labelStyle: const TextStyle(
                                                    color: Colors.white),
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(20, 10, 20, 10),
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.instagram,
                                                    color: Colors.white,),
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
                                          margin: EdgeInsets.fromLTRB(
                                              0, 28, 0, 0),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 1.3,

                                          child: TextFormField(
                                            style: TextStyle(
                                                color: Colors.white),
                                            cursorColor: Colors.white,
                                            controller: whatsappTextEditingController,
                                            //Making keyboard just for Email
                                            keyboardType: TextInputType.name,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Whatsapp page link is required';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText: snapshot.data?.socialMediaAccounts[3],
                                                labelStyle: const TextStyle(
                                                    color: Colors.white),
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(20, 10, 20, 10),
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.whatsapp,
                                                    color: Colors.white,),
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
                                          margin: EdgeInsets.fromLTRB(
                                              0, 28, 0, 0),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 1.3,

                                          child: TextFormField(
                                            style: TextStyle(
                                                color: Colors.white),
                                            cursorColor: Colors.white,
                                            controller: tiktokTextEditingController,
                                            //Making keyboard just for Email
                                            keyboardType: TextInputType.name,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Tiktok page link is required';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText: snapshot.data?.socialMediaAccounts[4],
                                                labelStyle: const TextStyle(
                                                    color: Colors.white),
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(20, 10, 20, 10),
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.tiktok,
                                                    color: Colors.white,),
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
                                          margin: EdgeInsets.fromLTRB(
                                              0, 28, 0, 0),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 1.3,

                                          child: TextFormField(
                                            style: TextStyle(
                                                color: Colors.white),
                                            cursorColor: Colors.white,
                                            controller: snapshatTextEditingController,
                                            //Making keyboard just for Email
                                            keyboardType: TextInputType.name,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Snapshat page link is required';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText: snapshot.data?.socialMediaAccounts[5],
                                                labelStyle: const TextStyle(
                                                    color: Colors.white),
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(20, 10, 20, 10),
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.snapchat,
                                                    color: Colors.white,),
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
                                          margin: EdgeInsets.fromLTRB(
                                              0, 28, 0, 0),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 1.3,

                                          child: TextFormField(
                                            style: TextStyle(
                                                color: Colors.white),
                                            cursorColor: Colors.white,
                                            controller: linkedinTextEditingController,
                                            //Making keyboard just for Email
                                            keyboardType: TextInputType.name,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Linkedin page link is required';
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText: snapshot.data?.socialMediaAccounts[6],
                                                labelStyle: const TextStyle(
                                                    color: Colors.white),
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(20, 10, 20, 10),
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.linkedinIn,
                                                    color: Colors.white,),
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
                                        SizedBox(height: 20,),
                                        Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 2.5,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                20),
                                            color: Color(0xFF18181E),
                                          ),
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, 0, 40),
                                          child: Center(child: TextButton(
                                              onPressed: () async {
                                                try {

                                                  var updatedData = {
                                                    "storeSocialMediaAccounts" :[
                                                      facebookPageLinkTextEditingController.text.isNotEmpty
                                                          ? facebookPageLinkTextEditingController.text
                                                          : snapshot.data!.socialMediaAccounts[0],
                                                      telegramPageLinkTextEditingController.text.isNotEmpty
                                                          ? telegramPageLinkTextEditingController.text
                                                          : snapshot.data!.socialMediaAccounts[1],
                                                      instagramTextEditingController.text.isNotEmpty
                                                          ? instagramTextEditingController.text
                                                          : snapshot.data!.socialMediaAccounts[2],
                                                      whatsappTextEditingController.text.isNotEmpty
                                                          ? whatsappTextEditingController.text
                                                          : snapshot.data!.socialMediaAccounts[3],
                                                      tiktokTextEditingController.text.isNotEmpty
                                                          ? tiktokTextEditingController.text
                                                          : snapshot.data!.socialMediaAccounts[4],
                                                      snapshatTextEditingController.text.isNotEmpty
                                                          ? snapshatTextEditingController.text
                                                          : snapshot.data!.socialMediaAccounts[5],
                                                      linkedinTextEditingController.text.isNotEmpty
                                                          ? linkedinTextEditingController.text
                                                          : snapshot.data!.socialMediaAccounts[6],
                                                    ]
                                                  };
                                                  http
                                                      .Response userFuture = await http
                                                      .patch(
                                                    Uri.parse(
                                                        "http://10.0.2.2:3000/matjarcom/api/v1/connect-social-media-accounts/${emailVal}"),
                                                    headers: {
                                                      "Content-Type": "application/json"
                                                    },
                                                    body: jsonEncode( updatedData
                                                    ),
                                                    encoding: Encoding
                                                        .getByName("utf-8"),
                                                  );
                                                  print(userFuture.body);


                                                }
                                                catch (error) {

                                                }
                                              },
                                              child: Text("Connect",
                                                style: TextStyle(
                                                    color: Colors.white),)),),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else{
                                return Text("Null");
                              }
                            },
                          )


                        ],
                      ),
                    ),
                  ),
                ),

              ],
            )));
  }
}
