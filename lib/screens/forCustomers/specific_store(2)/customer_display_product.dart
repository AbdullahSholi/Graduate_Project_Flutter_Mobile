

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_preview/image_preview.dart';
import 'package:photo_view/photo_view.dart';

import '../../../models/Stores/display-all-stores.dart';
import '../../../toggle_button1.dart';
import "package:http/http.dart" as http;

import 'customer_specific_store_main_page.dart';


class CustomerDisplayProduct extends StatefulWidget {
  Map<String ,dynamic> storeCartsVal;
  String customerTokenVal ;
  String customerEmailVal ;
  String emailVal;
  String tokenVal;
  CustomerDisplayProduct(this.storeCartsVal, this.customerTokenVal, this.customerEmailVal, this.tokenVal, this.emailVal, {super.key});

  @override
  State<CustomerDisplayProduct> createState() => _CustomerDisplayProductState();
}

class _CustomerDisplayProductState extends State<CustomerDisplayProduct> {

  Map<String, dynamic> storeCartsVal = {};
  int counter = 1;
  String customerTokenVal = "";
  String customerEmailVal = "";
  String emailVal = "";
  String tokenVal = "";


  int storeIndexVal = 0;
  late List<dynamic> getStoreDataVal=[];
  late List<dynamic> tempStores1=[];
  Future<void> getMerchantData() async {

    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/get-all-stores/"),
    );
    print(userFuture.body);
    List<dynamic> jsonList = json.decode(userFuture.body);
    for(int i=0; i<jsonList.length; i++){
      tempStores1.add(SpecificStore.fromJson(jsonList[i]));

    }

    // print("jsonList: ${jsonList[1]}");

    if (userFuture.statusCode == 200) {
      print("${userFuture.statusCode}");
      setState(() {
        getStoreDataVal=tempStores1;
      });

    } else {
      print("error");
      throw Exception("Error");
    }
  }
  Future<void> getStoreIndex() async {

    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/get-store-index/"),
    );
    print(userFuture.body);
    var temp = json.decode(userFuture.body);
    print(temp["value"]);
    if (userFuture.statusCode == 200) {
      print("${userFuture.statusCode}");
      setState(() {
        storeIndexVal=temp["value"];
      });

    } else {
      print("error");
      throw Exception("Error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storeCartsVal = widget.storeCartsVal;
    customerEmailVal = widget.customerEmailVal;
    customerTokenVal = widget.customerTokenVal;
    emailVal = widget.emailVal;
    tokenVal = widget.tokenVal;

    getMerchantData();
    getStoreIndex();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,

      appBar: AppBar(
        forceMaterialTransparency: true,

        elevation: 0,
        leading: Row(
          children: [
            SizedBox(width: 8,),
            Expanded(
              child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF212128)
                    ),
                      child: IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerSpecificStoreMainPage(tokenVal,emailVal,[] ,getStoreDataVal[storeIndexVal].storeName,
                            [],getStoreDataVal[storeIndexVal].activateSlider,getStoreDataVal[storeIndexVal].activateCategory,getStoreDataVal[storeIndexVal].activateCarts,
                            {}, customerTokenVal, customerEmailVal)));
                        print(storeIndexVal);
                        // return Future.value(true);
                      }, icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,size: 25,),))),
            ),
          ],
        )
        ,centerTitle: true,
        title: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width/2,
          height: 45,
          decoration: BoxDecoration(
            color: Color(0xFF212128),
            borderRadius: BorderRadius.circular(20),
          ),
            child: Text("Product", style: GoogleFonts.lilitaOne(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color: Colors.white),))),
        actions: [
          Center(
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF212128)
                  ),
                  child: IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart_outlined, color: Colors.white,size: 25,),))),
          SizedBox(width: 10,)
        ],

      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            // Place the image as the background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/1.9,
                    child: InkWell(
                      onTap: (){
                        List<String> imagesURL = [];
                        List<String> temp = [];
                        temp = List<String>.from(storeCartsVal["cartSecondaryImagesSlider"] as List);
                        // imagesURL.add(storeCartsVal["cartPrimaryImage"]);
                        imagesURL = [storeCartsVal["cartPrimaryImage"], ...temp];
                        print(storeCartsVal["cartPrimaryImage"]);
                        // print(imagesURL);

                        openImagesPage(Navigator.of(context),
                          imgUrls: imagesURL,
                        );
                      },
                      child: Image.network(
                        storeCartsVal["cartPrimaryImage"],
                        fit: BoxFit.cover,
                      ),
                    ),

                  ),
                  Positioned(
                    bottom: 170,
                    right: 20,
                    child: Visibility(
                      visible: true,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: Color(0xFF212128)
                        ),
                        width: 80,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // SizedBox(width: 10,),
                            Text("4.8", style: TextStyle(color: Colors.white, fontSize: 20),),
                            SizedBox(width: 8,),
                            Icon(Icons.star, color: Colors.yellow,)

                          ],
                        ),
                      )
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 20,
                    child: Visibility(
                      visible: true,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFF212128),
                        child: ToggleButton1(onIcon: Icon(Icons.favorite, color: Colors.white, size: 40,),
                            offIcon: Icon(Icons.favorite_outline, color: Colors.white, size: 40,),
                            initialValue: storeCartsVal["isFavorite"], onChanged: (_isFavorite) async {
                              if (_isFavorite) {
                                try {
                                  storeCartsVal["isFavorite"] = _isFavorite;
                                  http.Response
                                  userFuture =
                                  await http.post(
                                    Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/customer-add-to-favorite-list/${customerEmailVal}"),
                                    headers: {
                                      "Content-Type": "application/json",
                                      "Authorization": "Bearer ${customerTokenVal}"
                                    },
                                    body: jsonEncode(
                                      {
                                        "favouriteList": storeCartsVal,
                                      },
                                    ),
                                    encoding: Encoding.getByName("utf-8"),
                                  );

                                  print(userFuture.body);
                                } catch (error) {}
                              } else {
                                try {
                                  storeCartsVal["isFavorite"] = !_isFavorite;
                                  print(storeCartsVal["cartName"]);
                                  print(storeCartsVal["merchant"]);
                                  http.Response
                                  userFuture =
                                  await http.delete(
                                    Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/delete-product-from-favorite-list-from-different-stores/${customerEmailVal}"),
                                    headers: {
                                      "Content-Type": "application/json",
                                      "Authorization": "Bearer ${customerTokenVal}"
                                    },

                                    body: jsonEncode(
                                      {
                                        "cartName": storeCartsVal["cartName"],
                                        "merchant": storeCartsVal["merchant"]
                                      },
                                    ),
                                    encoding: Encoding.getByName("utf-8"),
                                  );

                                  print(userFuture.body);
                                } catch (error) {}
                              }
                              print(
                                  'Is Favorite $_isFavorite');
                            }),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(

                width: double.infinity,
                height: MediaQuery.of(context).size.height/1.8,
                decoration: BoxDecoration(
                    color: Color(0xFF212128),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Furnutare", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 30),)),
                          Text("400\$", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                            Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0), // Set border radius here
                              ),
                                child: IconButton(onPressed: (){
                                  if(counter > 1 ) {
                                    setState(() {
                                      counter--;
                                    });
                                  }

                                }, icon: Icon(Icons.remove, color: Color(0xFF212128), size: 30,))),
                            SizedBox(width: 10,),
                            Text("$counter", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 35),)),
                            SizedBox(width: 10,),
                            Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0), // Set border radius here
                                ),
                                child: IconButton(onPressed: (){
                                  if(counter < storeCartsVal["cartQuantities"]){
                                    setState(() {
                                      counter++;
                                    });
                                  }

                                }, icon: Icon(Icons.add, color: Color(0xFF212128), size: 30,))),
                          ],),


                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                             Text("Description", style: GoogleFonts.lilitaOne(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),))
                            ],),

                        ],
                      ),
                    ),

                    Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text("datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata",
                            style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white),))
                    ),



                    // Container(
                    //   margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    //   child: Row(
                    //     children: [
                    //       Visibility(
                    //         visible: true,
                    //         child: InkWell(
                    //           onTap: (){
                    //             showDialog(context: context, builder: (context)=> AlertDialog());
                    //           },
                    //           child: Container(
                    //             // padding: EdgeInsets.fromLTRB(7, 2, 0, 0),
                    //             child: RatingBar.builder(
                    //               ignoreGestures: true,
                    //               initialRating: 3,
                    //               minRating: 1,
                    //               direction: Axis.horizontal,
                    //               allowHalfRating: true,
                    //               itemCount: 5,
                    //               itemSize: 30,
                    //               unratedColor: Colors.white,
                    //               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    //               itemBuilder: (context, _) => Icon(
                    //                 Icons.star,
                    //                 color: Colors.yellow,
                    //               ),
                    //               onRatingUpdate: (rating) {
                    //                 // setState(() {
                    //                 //   // rateVal = rating;
                    //                 // });
                    //                 showDialog(context: context, builder: (context)=> AlertDialog());
                    //
                    //                 print(rating);
                    //               },
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),

              ),
            ),
            // Add any other widgets you want to display over the image
            // For example, additional content or buttons
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/12,
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ) // Set border radius here
                      ),
                      child: TextButton(
                        onPressed: (){}, child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.add, color: Color(0xFF212128), ),
                          Text("Add to Cart", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Color(0xFF212128), fontSize: 24, fontWeight: FontWeight.bold),))
                        ],
                      ),style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),

    );
  }
}
