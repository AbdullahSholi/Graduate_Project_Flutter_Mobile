
import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../models/merchant/get_cart_content_model.dart';
import '../../../models/merchant/merchant_connect_store_to_social_media.dart';
import '../../../models/merchant/merchant_profile.dart';
import '../../models/Stores/display-all-stores.dart';




class GuestMainPage extends StatefulWidget {

  // late List<AllStore> storeDataVal;
  GuestMainPage();

  @override
  State<GuestMainPage> createState() => _GuestMainPageState();
}

class _GuestMainPageState extends State<GuestMainPage> with TickerProviderStateMixin {


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


  List<String> items = ['Electronic', 'Cars', 'Resturant'];

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
            FutureBuilder<List<dynamic>>(
              future: getStoreData,
              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {

                return Column(
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
                                    width: MediaQuery.of(context).size.width / 1.58,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                        child: Text(
                                            "Stores",
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

                              Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 1.2,

                                child: SingleChildScrollView(
                                  child:   Column(
                                    children: [
                                      
                                      Container(
                                        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                        width: MediaQuery.of(context)
                                            .size
                                            .width /
                                            1.13,
                                        height: 50,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                          items.length,
                                          itemBuilder: (context, index) =>
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                    color: Colors.white,
                                                  ),
                                                  width: 120,
                                                alignment: Alignment.center,
                                                child: Text(items[index],style: TextStyle(color: Color(0xFF212128),fontSize: 20, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                                                   ),
                                          separatorBuilder:
                                              (context, index) => SizedBox(
                                            width: 10,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        height: MediaQuery.of(context)
                                            .size
                                            .height /
                                            1,
                                        child: GridView.builder(
                                          scrollDirection:
                                          Axis.vertical,
                                          physics:
                                          NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                            1, // Set the number of columns
                                            childAspectRatio:
                                            1.9, // Customize the aspect ratio (width/height) of each tile

                                            crossAxisSpacing:
                                            2.0, // Spacing between columns
                                          ),
                                          // storeCartsVal[index]
                                          itemBuilder:
                                              (context, index) =>Container(
                                                margin: EdgeInsets.fromLTRB(20,0,20,15),
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width ,
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height / 4,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    border: Border.all(width: 1)
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      width: MediaQuery.of(context).size.width/2.6,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Colors.white
                                                      ),
                                                      child: Image.network(snapshot.data![index].storeAvatar),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(height: 15,),
                                                        Container(
                                                          width: MediaQuery.of(context).size.width/4,
                                                            // color: Colors.blue,
                                                            child: Text("${snapshot.data![index].storeName}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                                        SizedBox(height: 5,),
                                                        Container(
                                                            width: MediaQuery.of(context).size.width/4,
                                                            // color: Colors.blue,
                                                            child: Text("${snapshot.data![index].storeCategory}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                                        SizedBox(height: 5,),
                                                        Container(
                                                            width: MediaQuery.of(context).size.width/4,
                                                            // color: Colors.blue,
                                                            child: Text("Owned by: ${snapshot.data![index].merchantname}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                                        SizedBox(height: 5,),
                                                        Container(
                                                            width: MediaQuery.of(context).size.width/4,
                                                            // color: Colors.blue,
                                                            child: Text("email: ${snapshot.data![index].email}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                                        SizedBox(height: 5,),
                                                        Container(
                                                            width: MediaQuery.of(context).size.width/4,
                                                            // color: Colors.blue,
                                                            child: Text("Phone: ${snapshot.data![index].phone}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),

                                          itemCount:
                                          snapshot.data!.length,
                                        ),
                                      ),

                                      // Container(
                                      //   margin: EdgeInsets.fromLTRB(20,20,20,10),
                                      //   width: MediaQuery
                                      //       .of(context)
                                      //       .size
                                      //       .width ,
                                      //   height: MediaQuery
                                      //       .of(context)
                                      //       .size
                                      //       .height / 4,
                                      //   decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.circular(20),
                                      //       border: Border.all(width: 1)
                                      //   ),
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.start,
                                      //     children: [
                                      //       Container(
                                      //         width: MediaQuery.of(context).size.width/2.2,
                                      //         decoration: BoxDecoration(
                                      //             borderRadius: BorderRadius.circular(20),
                                      //             color: Colors.white
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),








                                    ],
                                  ),



                                ),
                              ),
                              // Container(
                              //   width: double.infinity,
                              //   margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                              //
                              //     child: Text("", style: GoogleFonts.federo(
                              //       color: Color(0xFF212128),
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 30,
                              //
                              //     ),
                              //       textAlign: TextAlign.center,
                              //     ),
                              //
                              //
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                );
              },

            )));
  }
}

