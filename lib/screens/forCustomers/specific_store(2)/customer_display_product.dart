

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_expandable_text/flutter_expandable_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/screens/forCustomers/specific_store(2)/CustomerRateAndReviewsPage.dart';
import 'package:graduate_project/screens/forCustomers/specific_store(2)/customer_chat_system.dart';
import 'package:graduate_project/screens/forCustomers/specific_store(2)/customer_my_cart_page.dart';
import 'package:image_preview/image_preview.dart';
import 'package:photo_view/photo_view.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:translator/translator.dart';

import '../../../models/Stores/display-all-stores.dart';
import '../../../toggle_button1.dart';
import "package:http/http.dart" as http;

import 'customer_specific_store_main_page1.dart';
import 'customer_specific_store_main_page2.dart';
import 'customer_specific_store_main_page3.dart';
// import 'package:flutter_expandable_text/expandable_text.dart';


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

class _CustomerDisplayProductState extends State<CustomerDisplayProduct> with WidgetsBindingObserver {

  Map<String, dynamic> storeCartsVal = {};
  int counter = 0;
  String customerTokenVal = "";
  String customerEmailVal = "";
  String emailVal = "";
  String tokenVal = "";

  Color primaryTextColor = Color(0xFF212128);
  Color secondaryTextColor = Color(0xFF212128);
  Color boxesColor = Color(0xFF212128);
  Color backgroundColor = Color(0xFF212128);
  String smoothy = "";


  late double smoothDesignBorderRadius = 15;
  late double solidDesignBorderRadius = 2;
  double spaceAboveComponent = 20;
  double spaceBelowComponent = 10;


  int storeIndexVal = 0;
  late List<dynamic> getStoreDataVal=[];
  late List<dynamic> tempStores1=[];
  Future<void> getMerchantData() async {

    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-all-stores/"),
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
        boxesColor = Color(int.parse(getStoreDataVal[storeIndexVal].boxesColor.replaceAll("Color(", "").replaceAll(")", "")));
        backgroundColor = Color(int.parse(getStoreDataVal[storeIndexVal].backgroundColor.replaceAll("Color(", "").replaceAll(")", "")));
        primaryTextColor = Color(int.parse(getStoreDataVal[storeIndexVal].primaryTextColor.replaceAll("Color(", "").replaceAll(")", "")));
        secondaryTextColor = Color(int.parse(getStoreDataVal[storeIndexVal].secondaryTextColor.replaceAll("Color(", "").replaceAll(")", "")));
        smoothy = getStoreDataVal[storeIndexVal].smoothy;
      });

    } else {
      print("error");
      throw Exception("Error");
    }
  }
  Future<void> getStoreIndex() async {

    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-store-index/"),
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

  Map<String, dynamic> merchantData = {};
  Future<void> getMerchantProfile() async {
    print("%%%%%%%%%%%%%%%%%%%%%%%");
    print("%%%%%%%%%%%%%%%%%%%%%%%");
    print("$emailVal tttttttttXX");
    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile-second/${emailVal}"),
      headers: {
        "Content-Type": "application/json",
      },
    );
    print(userFuture.body);

    setState(() {
      merchantData = jsonDecode(userFuture.body);
    });

    print(merchantData["merchantname"]);


    print("%%%%%%%%%%%%%%%%%%%%%%%");
    print("%%%%%%%%%%%%%%%%%%%%%%%");

  }


  int index = 0;
  Future<void> getProductNameViaIndex() async {

    http.Response userFuture = await http.post(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-product-name-via-index/${emailVal}"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "productName":storeCartsVal["cartName"]
        },
      ),
      encoding: Encoding.getByName("utf-8"),
    );

    setState(() {
      index = jsonDecode(userFuture.body)["index"];
    });
    print(index);
  }

  double productAverageRate = 0;
  int numberOfRates = 0;
  Future<void> getAverageProductRate() async {

    await getProductNameViaIndex();

    http.Response userFuture = await http.post(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-average-product-rate/${emailVal}"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "index": index
        },
      ),
      encoding: Encoding.getByName("utf-8"),
    );

    print(userFuture.body);

    var temp = json.decode(userFuture.body);

    if (userFuture.statusCode == 200) {
      print("${userFuture.statusCode}");
      setState(() {
        productAverageRate = double.parse(temp["Rate"].toDouble().toStringAsFixed(1));
        numberOfRates = temp["numberOfRates"];
      });

      print("IIIIIIIIIIIIIIIIIIIIIII");
      print(productAverageRate);
      print("IIIIIIIIIIIIIIIIIIIIIII");

    } else {
      print("error");
      throw Exception("Error");
    }
  }

  Future<void> translateProductDescription() async {

    Map<String, dynamic> temp = storeCartsVal;

    // print("jsonList: ${jsonList[1]}");

      final translator = GoogleTranslator();

      final String localeName = Platform.localeName; // e.g., "en_US"

      // You can extract the language code from the string if needed
      final String langCode = localeName.split('_').first; // e.g., "en"

      if(langCode != "ar") {
        final translatedDescription = await translator.translate(temp["cartDescription"], to: langCode);

        temp["cartDescription"] = translatedDescription.text;
        print("IIIIIIIIIIIIIIII");
        // print(getStoreDataVal[0].storeName);
        print("IIIIIIIIIIIIIIII");
        setState(() {
          storeCartsVal={};
          storeCartsVal = temp;
          temp={};
        });
      }


      if(langCode == "ar") {

        final translatedDescription = await translator.translate(temp["cartDescription"], to: langCode);

        temp["cartDescription"] = translatedDescription.text;
        print("IIIIIIIIIIIIIIII");
        // print(getStoreDataVal[0].storeName);
        print("IIIIIIIIIIIIIIII");
        setState(() {
          storeCartsVal={};
          storeCartsVal = temp;
          temp={};
        });
      }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    storeCartsVal = widget.storeCartsVal;
    customerEmailVal = widget.customerEmailVal;
    customerTokenVal = widget.customerTokenVal;
    emailVal = widget.emailVal;
    tokenVal = widget.tokenVal;

    print("*********************");
    print(customerTokenVal);
    print("*********************");

    getMerchantData();
    getStoreIndex();
    getAverageProductRate();
    getMerchantProfile();
    translateProductDescription();



  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Execute your function here when the app resumes from the background
      // yourFunction();

      // getSpecificStoreCategories();
      translateProductDescription();
    }

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
                      color: boxesColor
                    ),
                      child: IconButton(onPressed: (){
                        if(getStoreDataVal[storeIndexVal].design == "Option 1"){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerSpecificStoreMainPage1(tokenVal,emailVal,[] ,getStoreDataVal[storeIndexVal].storeName,
                            [],getStoreDataVal[storeIndexVal].activateSlider,getStoreDataVal[storeIndexVal].activateCategory,getStoreDataVal[storeIndexVal].activateCarts,
                            {}, customerTokenVal, customerEmailVal,
                            getStoreDataVal[storeIndexVal].backgroundColor,
                            getStoreDataVal[storeIndexVal].boxesColor,
                            getStoreDataVal[storeIndexVal].primaryTextColor,
                            getStoreDataVal[storeIndexVal].secondaryTextColor,
                            getStoreDataVal[storeIndexVal].clippingColor,
                            getStoreDataVal[storeIndexVal].smoothy,
                            getStoreDataVal[storeIndexVal].design,
                          )));
                          print(storeIndexVal);
                        }

                        if(getStoreDataVal[storeIndexVal].design == "Option 2"){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerSpecificStoreMainPage2(tokenVal,emailVal,[] ,getStoreDataVal[storeIndexVal].storeName,
                            [],getStoreDataVal[storeIndexVal].activateSlider,getStoreDataVal[storeIndexVal].activateCategory,getStoreDataVal[storeIndexVal].activateCarts,
                            {}, customerTokenVal, customerEmailVal,
                            getStoreDataVal[storeIndexVal].backgroundColor,
                            getStoreDataVal[storeIndexVal].boxesColor,
                            getStoreDataVal[storeIndexVal].primaryTextColor,
                            getStoreDataVal[storeIndexVal].secondaryTextColor,
                            getStoreDataVal[storeIndexVal].clippingColor,
                            getStoreDataVal[storeIndexVal].smoothy,
                            getStoreDataVal[storeIndexVal].design,
                          )));
                          print(storeIndexVal);
                        }

                        if(getStoreDataVal[storeIndexVal].design == "Option 3"){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerSpecificStoreMainPage3(tokenVal,emailVal,[] ,getStoreDataVal[storeIndexVal].storeName,
                            [],getStoreDataVal[storeIndexVal].activateSlider,getStoreDataVal[storeIndexVal].activateCategory,getStoreDataVal[storeIndexVal].activateCarts,
                            {}, customerTokenVal, customerEmailVal,
                            getStoreDataVal[storeIndexVal].backgroundColor,
                            getStoreDataVal[storeIndexVal].boxesColor,
                            getStoreDataVal[storeIndexVal].primaryTextColor,
                            getStoreDataVal[storeIndexVal].secondaryTextColor,
                            getStoreDataVal[storeIndexVal].clippingColor,
                            getStoreDataVal[storeIndexVal].smoothy,
                            getStoreDataVal[storeIndexVal].design,
                          )));
                          print(storeIndexVal);
                        }



                        // return Future.value(true);
                      }, icon: Icon(Icons.arrow_back_ios_outlined, color: secondaryTextColor,size: 25,),))),
            ),
          ],
        )
        ,centerTitle: true,
        title: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width/2,
          height: 45,
          decoration: BoxDecoration(
            color: boxesColor,
            borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
          ),
            child: Text("${getLang(context, 'product')}", style: GoogleFonts.roboto(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color: secondaryTextColor),))),
        actions: [
          Center(
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: boxesColor
                  ),
                  child: IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerMyCartPage(customerEmailVal, customerTokenVal)));
                  }, icon: Icon(Icons.shopping_cart_outlined, color: secondaryTextColor,size: 25,),))),
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
                      child: InkWell(
                        onTap: (){
                          // showDialog(context: context, builder: (context)=>AlertDialog(
                          //   elevation: .5,
                          //   contentPadding: EdgeInsets.all(0),
                          //   backgroundColor: Color(0xFF212128),
                          //   title: Text("Rating & Reviews", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white)),),
                          //   content: Stack(
                          //     children: [
                          //       Divider(),
                          //       Container(
                          //         padding: EdgeInsets.all(15),
                          //         width: MediaQuery.of(context).size.width,
                          //         height: MediaQuery.of(context).size.height,
                          //         // color: Colors.red,
                          //         child: SingleChildScrollView(
                          //           child: Column(
                          //             children: [
                          //
                          //               Container(
                          //                 padding: EdgeInsets.all(0),
                          //                 height: MediaQuery.of(context).size.height/4,
                          //                 // color: Colors.blue,
                          //                 child: Column(
                          //                   children: [
                          //                     Row(
                          //                       mainAxisAlignment: MainAxisAlignment.start,
                          //                       children: [
                          //                         Icon(Icons.star, color: Colors.yellow, size: 45,),
                          //                         SizedBox(width: 10,),
                          //                         Text("Rating", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 35)),)
                          //                       ],
                          //                     ),
                          //                     Row(
                          //                       children: [
                          //                         Container(
                          //                           height: MediaQuery.of(context).size.height/5.4,
                          //                           width: MediaQuery.of(context).size.width/5,
                          //                           // color: Colors.yellow,
                          //                           child: Column(
                          //                             mainAxisAlignment: MainAxisAlignment.center,
                          //                             crossAxisAlignment: CrossAxisAlignment.center,
                          //                             children: [
                          //                               Text("4.3", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 50),)),
                          //                               Text("23 ratings", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15),)),
                          //                             ],
                          //                           ),
                          //                         ),
                          //                         Expanded(
                          //                           child: Container(
                          //                             padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          //                             height: MediaQuery.of(context).size.height/5.4,
                          //                             child: Column(
                          //                               children: [
                          //                                 Row(
                          //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                   children: [
                          //                                     Container(
                          //                                       width: MediaQuery.of(context).size.width/3.2,
                          //
                          //                                       child: RatingBar.builder(
                          //                                         textDirection: TextDirection.rtl,
                          //                                         ignoreGestures: true,
                          //                                         initialRating: 5,
                          //                                         minRating: 1,
                          //                                         direction: Axis.horizontal,
                          //                                         allowHalfRating: true,
                          //                                         itemCount: 5,
                          //                                         itemSize: 15,
                          //                                         unratedColor: Colors.white,
                          //                                         itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          //                                         itemBuilder: (context, _) => Icon(
                          //                                           Icons.star,
                          //                                           color: Colors.yellow,
                          //                                         ),
                          //                                         onRatingUpdate: (rating) {
                          //                                           setState(() {
                          //                                             // rateVal = rating;
                          //                                           });
                          //
                          //                                           print(rating);
                          //                                         },
                          //                                       ),
                          //                                     ),
                          //                                     Text("22", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                          //                                   ],
                          //                                 ),
                          //                                 Row(
                          //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                   children: [
                          //                                     Container(
                          //                                       width: MediaQuery.of(context).size.width/3.2,
                          //
                          //                                       child: RatingBar.builder(
                          //                                         textDirection: TextDirection.rtl,
                          //                                         ignoreGestures: true,
                          //                                         initialRating: 5,
                          //                                         minRating: 1,
                          //                                         direction: Axis.horizontal,
                          //                                         allowHalfRating: true,
                          //                                         itemCount: 4,
                          //                                         itemSize: 15,
                          //                                         unratedColor: Colors.white,
                          //                                         itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          //
                          //                                         itemBuilder: (context, _) => Icon(
                          //                                           Icons.star,
                          //                                           color: Colors.yellow,
                          //                                         ),
                          //                                         onRatingUpdate: (rating) {
                          //                                           setState(() {
                          //                                             // rateVal = rating;
                          //                                           });
                          //
                          //                                           print(rating);
                          //                                         },
                          //                                       ),
                          //                                     ),
                          //                                     Text("22", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                          //                                   ],
                          //                                 ),
                          //                                 Row(
                          //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                   children: [
                          //                                     Container(
                          //                                       width: MediaQuery.of(context).size.width/3.2,
                          //
                          //                                       child: RatingBar.builder(
                          //                                         textDirection: TextDirection.rtl,
                          //                                         ignoreGestures: true,
                          //                                         initialRating: 5,
                          //                                         minRating: 1,
                          //                                         direction: Axis.horizontal,
                          //                                         allowHalfRating: true,
                          //                                         itemCount: 3,
                          //                                         itemSize: 15,
                          //                                         unratedColor: Colors.white,
                          //                                         itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          //                                         itemBuilder: (context, _) => Icon(
                          //                                           Icons.star,
                          //                                           color: Colors.yellow,
                          //                                         ),
                          //                                         onRatingUpdate: (rating) {
                          //                                           setState(() {
                          //                                             // rateVal = rating;
                          //                                           });
                          //
                          //                                           print(rating);
                          //                                         },
                          //                                       ),
                          //                                     ),
                          //                                     Text("22", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                          //                                   ],
                          //                                 ),
                          //                                 Row(
                          //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                   children: [
                          //                                     Container(
                          //                                       width: MediaQuery.of(context).size.width/3.2,
                          //
                          //                                       child: RatingBar.builder(
                          //                                         textDirection: TextDirection.rtl,
                          //                                         ignoreGestures: true,
                          //                                         initialRating: 5,
                          //                                         minRating: 1,
                          //                                         direction: Axis.horizontal,
                          //                                         allowHalfRating: true,
                          //                                         itemCount: 2,
                          //                                         itemSize: 15,
                          //                                         unratedColor: Colors.white,
                          //                                         itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          //                                         itemBuilder: (context, _) => Icon(
                          //                                           Icons.star,
                          //                                           color: Colors.yellow,
                          //                                         ),
                          //                                         onRatingUpdate: (rating) {
                          //                                           setState(() {
                          //                                             // rateVal = rating;
                          //                                           });
                          //
                          //                                           print(rating);
                          //                                         },
                          //                                       ),
                          //                                     ),
                          //                                     Text("22", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                          //                                   ],
                          //                                 ),
                          //                                 Row(
                          //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                   children: [
                          //                                     Container(
                          //                                       width: MediaQuery.of(context).size.width/3.2,
                          //
                          //                                       child: RatingBar.builder(
                          //                                         textDirection: TextDirection.rtl,
                          //                                         ignoreGestures: true,
                          //                                         initialRating: 1,
                          //                                         minRating: 1,
                          //                                         direction: Axis.horizontal,
                          //                                         allowHalfRating: true,
                          //                                         itemCount: 1,
                          //                                         itemSize: 15,
                          //                                         unratedColor: Colors.white,
                          //                                         itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          //                                         itemBuilder: (context, _) => Icon(
                          //                                           Icons.star,
                          //                                           color: Colors.yellow,
                          //                                         ), onRatingUpdate: (double value) {  },
                          //
                          //                                       ),
                          //                                     ),
                          //                                     Text("22", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                          //                                   ],
                          //                                 ),
                          //                               ],
                          //                             ),
                          //
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //               Container(
                          //                 height: 1,
                          //                 width: double.infinity,
                          //                 color: Colors.white,
                          //               ),
                          //               SizedBox(height: 20,),
                          //               Row(
                          //                 mainAxisAlignment: MainAxisAlignment.start,
                          //                 children: [
                          //                   Icon(Icons.message, color: Colors.yellow, size: 45,),
                          //                   SizedBox(width: 12,),
                          //                   Text("Reviews", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 35)),)
                          //                 ],
                          //               ),
                          //               Container(
                          //                 // color: Colors.blue,
                          //                 child: Column(
                          //                   children: [
                          //
                          //                     SizedBox(height: 20,),
                          //                     Container(
                          //                       padding: EdgeInsets.fromLTRB(5, 5, 2, 10),
                          //                       decoration: BoxDecoration(
                          //                         borderRadius: BorderRadius.circular(20),
                          //                         border: Border.all(
                          //                           width: 2,
                          //                           color: Colors.white
                          //                         )
                          //                       ),
                          //                       child: Column(
                          //                         children: [
                          //                           Row(
                          //                             children: [
                          //                               ClipRRect(
                          //                                 borderRadius: BorderRadius.circular(70),
                          //                                   child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWxeP0FYO40fLbYn1hS08ZASqlpf6K4boW4w&s",width: 70, height: 70,),
                          //                               ),
                          //                               SizedBox(width: 10,),
                          //                               Column(
                          //                                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                                 children: [
                          //                                   Text("Abdullah Sholi", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 25),)),
                          //                                   Row(
                          //                                     mainAxisAlignment: MainAxisAlignment.start,
                          //                                     children: [
                          //                                       Icon(Icons.date_range, color: Colors.white70,),
                          //                                       SizedBox(width: 10,),
                          //                                       Text("27/4/2024", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15),)),
                          //                                       SizedBox(width: 15,),
                          //                                       Container(
                          //                                         alignment: Alignment.center,
                          //                                         height: 25,
                          //                                         width: 55,
                          //                                         decoration: BoxDecoration(
                          //                                             color: Colors.blue,
                          //                                           borderRadius: BorderRadius.circular(10)
                          //                                         ),
                          //                                         child: Row(
                          //                                           children: [
                          //                                             RatingBar.builder(
                          //                                               textDirection: TextDirection.rtl,
                          //                                               ignoreGestures: true,
                          //                                               initialRating: 1,
                          //                                               minRating: 1,
                          //                                               direction: Axis.horizontal,
                          //                                               allowHalfRating: true,
                          //                                               itemCount: 1,
                          //                                               itemSize: 15,
                          //                                               unratedColor: Colors.white,
                          //                                               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          //                                               itemBuilder: (context, _) => Icon(
                          //                                                 Icons.star,
                          //                                                 color: Colors.yellow,
                          //                                               ), onRatingUpdate: (double value) {  },
                          //
                          //                                             ),
                          //                                             Text("4.5", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                          //                                           ],
                          //                                         ),
                          //                                       )
                          //                                     ],
                          //                                   )
                          //                                 ],
                          //                               ),
                          //
                          //                             ],
                          //                           ),
                          //                           SizedBox(height: 10,),
                          //                           Padding(
                          //                             padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          //                             child: ExpandableText(
                          //                               '${storeCartsVal["cartDescription"]}',
                          //                               trimType: TrimType.lines,
                          //                               trim: 3, // trims if text exceeds 20 characters
                          //                               style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white),), textAlign: TextAlign.start,
                          //                               readLessText: 'show less',
                          //                               readMoreText: 'show more',
                          //                             ),
                          //                           ),
                          //
                          //                         ],
                          //                       ),
                          //                     ),
                          //                     // SizedBox(height: 20,),
                          //
                          //                   ],
                          //
                          //                 ),
                          //               ),
                          //               SizedBox(height: 20,),
                          //
                          //               Container(
                          //                 // color: Colors.blue,
                          //                 child: Column(
                          //                   children: [
                          //
                          //                     SizedBox(height: 20,),
                          //                     Container(
                          //                       padding: EdgeInsets.fromLTRB(5, 5, 2, 10),
                          //                       decoration: BoxDecoration(
                          //                           borderRadius: BorderRadius.circular(20),
                          //                           border: Border.all(
                          //                               width: 2,
                          //                               color: Colors.white
                          //                           )
                          //                       ),
                          //                       child: Column(
                          //                         children: [
                          //                           Row(
                          //                             children: [
                          //                               ClipRRect(
                          //                                 borderRadius: BorderRadius.circular(70),
                          //                                 child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWxeP0FYO40fLbYn1hS08ZASqlpf6K4boW4w&s",width: 70, height: 70,),
                          //                               ),
                          //                               SizedBox(width: 10,),
                          //                               Column(
                          //                                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                                 children: [
                          //                                   Text("Abdullah Sholi", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 25),)),
                          //                                   Row(
                          //                                     mainAxisAlignment: MainAxisAlignment.start,
                          //                                     children: [
                          //                                       Icon(Icons.date_range, color: Colors.white70,),
                          //                                       SizedBox(width: 10,),
                          //                                       Text("27/4/2024", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15),)),
                          //                                       SizedBox(width: 15,),
                          //                                       Container(
                          //                                         alignment: Alignment.center,
                          //                                         height: 25,
                          //                                         width: 55,
                          //                                         decoration: BoxDecoration(
                          //                                             color: Colors.blue,
                          //                                             borderRadius: BorderRadius.circular(10)
                          //                                         ),
                          //                                         child: Row(
                          //                                           children: [
                          //                                             RatingBar.builder(
                          //                                               textDirection: TextDirection.rtl,
                          //                                               ignoreGestures: true,
                          //                                               initialRating: 1,
                          //                                               minRating: 1,
                          //                                               direction: Axis.horizontal,
                          //                                               allowHalfRating: true,
                          //                                               itemCount: 1,
                          //                                               itemSize: 15,
                          //                                               unratedColor: Colors.white,
                          //                                               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          //                                               itemBuilder: (context, _) => Icon(
                          //                                                 Icons.star,
                          //                                                 color: Colors.yellow,
                          //                                               ), onRatingUpdate: (double value) {  },
                          //
                          //                                             ),
                          //                                             Text("4.5", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                          //                                           ],
                          //                                         ),
                          //                                       )
                          //                                     ],
                          //                                   )
                          //                                 ],
                          //                               ),
                          //
                          //                             ],
                          //                           ),
                          //                           SizedBox(height: 10,),
                          //                           Padding(
                          //                             padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          //                             child: ExpandableText(
                          //                               '${storeCartsVal["cartDescription"]}',
                          //                               trimType: TrimType.lines,
                          //                               trim: 3, // trims if text exceeds 20 characters
                          //                               style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white),), textAlign: TextAlign.start,
                          //                               readLessText: 'show less',
                          //                               readMoreText: 'show more',
                          //                             ),
                          //                           ),
                          //
                          //                         ],
                          //                       ),
                          //                     ),
                          //                     // SizedBox(height: 20,),
                          //
                          //                   ],
                          //
                          //                 ),
                          //               ),
                          //               SizedBox(height: 20,),
                          //
                          //               SizedBox(height: 180,),
                          //               // Container(
                          //               //   height: MediaQuery.of(context).size.height/3,
                          //               //   // color: Colors.blue,
                          //               // ),
                          //             ],
                          //           ),
                          //         ),
                          //
                          //       ),
                          //       Positioned(
                          //         bottom: 0,
                          //         left: 0,
                          //         right: 0,
                          //         child: Container(
                          //
                          //           height: 200,
                          //           width: 500,
                          //           decoration: BoxDecoration(
                          //               color: Colors.white,
                          //             borderRadius: BorderRadius.circular(20)
                          //           ),
                          //           child: Column(
                          //             children: [
                          //               Container(
                          //                 height: 50,
                          //                 width: double.infinity,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius: BorderRadius.only(
                          //                     topRight: Radius.circular(20),
                          //                     topLeft: Radius.circular(20),
                          //                   ),
                          //                   boxShadow: [
                          //                     BoxShadow(
                          //                       color: Colors.black.withOpacity(.2),
                          //                       spreadRadius: 10,
                          //                       blurRadius: 5,
                          //                       offset: Offset(0, 0), // changes x,y position of shadow
                          //                     ),
                          //                   ],
                          //                   color: Colors.red,
                          //                 ),
                          //                 child: Text("Rate & Write a review", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 30),),textAlign: TextAlign.center,),
                          //               ),
                          //
                          //               Container(
                          //                 alignment: Alignment.center,
                          //                 padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          //                 color: Color(0xFF212128),
                          //                 width: double.infinity,
                          //                 height: 50,
                          //                 child: RatingBar.builder(
                          //                   initialRating: 3,
                          //                   minRating: 1,
                          //                   direction: Axis.horizontal,
                          //                   allowHalfRating: true,
                          //                   itemCount: 5,
                          //                   itemSize: 35,
                          //                   unratedColor: Colors.white,
                          //                   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          //                   itemBuilder: (context, _) => Icon(
                          //                     Icons.star,
                          //                     color: Colors.yellow,
                          //                   ),
                          //                   onRatingUpdate: (rating) {
                          //                     setState(() {
                          //                       // rateVal = rating;
                          //                     });
                          //
                          //                     print(rating);
                          //                   },
                          //                 ),
                          //               ),
                          //               Container(
                          //                 height: 100,
                          //                 child: Row(
                          //                   children: [
                          //                     Container(
                          //                       width: 264.68,
                          //                       child: TextField(
                          //                       ),
                          //                     ),
                          //                     Container(
                          //                         height: 100,
                          //                       decoration: BoxDecoration(
                          //                         borderRadius: BorderRadius.only(
                          //                           bottomRight: Radius.circular(20),
                          //
                          //                         ),
                          //                         color: Color(0xFF212128),
                          //                       ),
                          //
                          //                         child: IconButton(onPressed: (){}, icon: Icon(Icons.send_rounded, color: Colors.white, )))
                          //                   ],
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ));
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerRateAndReviewsPage(  storeCartsVal,index,emailVal, tokenVal, customerEmailVal, customerTokenVal ,productAverageRate, numberOfRates)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                            color: boxesColor
                          ),
                          width: 80,
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(width: 10,),
                              Text("${productAverageRate}", style: TextStyle(color: secondaryTextColor, fontSize: 20),),
                              SizedBox(width: 8,),
                              Icon(Icons.star, color: Colors.yellow,)

                            ],
                          ),
                        ),
                      )
                    ),
                  ),
                  Positioned(
                    bottom: 220,
                    right: 30,
                    child: Visibility(
                      visible: true,
                      child: Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          color: boxesColor,
                          borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius)
                        ),
                        
                        child: IconButton(onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerChatSystem(customerTokenVal, customerEmailVal, merchantData["merchantname"], merchantData["Avatar"], emailVal, )));
                        }, icon: Icon(Icons.chat, color: secondaryTextColor, size: 30,)),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 20,
                    child: Visibility(
                      visible: true,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: boxesColor,
                        child: ToggleButton1(onIcon: Icon(Icons.favorite, color: secondaryTextColor, size: 40,),
                            offIcon: Icon(Icons.favorite_outline, color: secondaryTextColor, size: 40,),
                            initialValue: storeCartsVal["isFavorite"], onChanged: (_isFavorite) async {
                              if (_isFavorite) {
                                try {
                                  storeCartsVal["isFavorite"] = _isFavorite;
                                  http.Response
                                  userFuture =
                                  await http.post(
                                    Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/customer-add-to-favorite-list/${customerEmailVal}"),
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
                                    Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-product-from-favorite-list-from-different-stores/${customerEmailVal}"),
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
                    color: boxesColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                    topRight: Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                  )
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${storeCartsVal["cartName"]}", style: GoogleFonts.roboto(textStyle: TextStyle(color: secondaryTextColor, fontSize: 30),)),
                          Text("${storeCartsVal["cartPrice"]}\$", style: GoogleFonts.roboto(textStyle: TextStyle(color: secondaryTextColor, fontSize: 50, fontWeight: FontWeight.bold),)),
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
                              color: secondaryTextColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius), // Set border radius here
                              ),
                                child: IconButton(onPressed: (){
                                  if(counter > 1 ) {
                                    setState(() {
                                      counter--;
                                    });
                                  }

                                }, icon: Icon(Icons.remove, color: boxesColor, size: 30,))),
                            SizedBox(width: 10,),
                            Text("$counter", style: GoogleFonts.roboto(textStyle: TextStyle(color: secondaryTextColor, fontSize: 35),)),
                            SizedBox(width: 10,),
                            Material(
                                color: secondaryTextColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius), // Set border radius here
                                ),
                                child: IconButton(onPressed: (){
                                  if(counter < storeCartsVal["cartQuantities"]){
                                    setState(() {
                                      counter++;
                                    });
                                  }

                                }, icon: Icon(Icons.add, color: boxesColor, size: 30,))),
                          ],),


                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // ExpandableTextWidget(),
                             Text("${getLang(context, 'description')}", style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: secondaryTextColor),))
                            ],),

                        ],
                      ),
                    ),


                    Container(
                      height: MediaQuery.of(context).size.height/7,
                        // color: Colors.blue,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              ExpandableText(
                                '${storeCartsVal["cartDescription"]}',
                                trimType: TrimType.lines,
                                trim: 6, // trims if text exceeds 20 characters
                                style: GoogleFonts.roboto(textStyle: TextStyle(color: secondaryTextColor),), textAlign: TextAlign.start,
                                readLessText: 'show less',
                                readMoreText: 'show more',
                              ),
                            ],
                          ),
                        ),

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
                      color: secondaryTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topRight: Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                          topLeft: Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                        ) // Set border radius here
                      ),
                      child: TextButton(
                        onPressed: () async {

                          try {
                            if(counter > 0){
                              http.Response
                              userFuture =
                              await http.post(
                                Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/customer-add-to-cart-list/${customerEmailVal}"),
                                headers: {
                                  "Content-Type": "application/json",
                                  "Authorization": "Bearer ${customerTokenVal}"
                                },
                                body: jsonEncode(
                                  {
                                    "cartList": storeCartsVal,
                                    "quantities": counter
                                  },
                                ),
                                encoding: Encoding.getByName("utf-8"),
                              );

                              print(userFuture.body);
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'Product Added Successfully!',
                              );
                              print("0000000000000000000000000");
                              print(storeCartsVal);
                            } else{
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Oops...',
                                text: 'Sorry, stock is empty!!',
                              );
                            }




                          } catch (error) {}
                        }, child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.add, color: Color(0xFF212128), ),
                          Text("${getLang(context, 'add_to_cart')}", style: GoogleFonts.roboto(textStyle: TextStyle(color: boxesColor, fontSize: 24, fontWeight: FontWeight.bold),))
                        ],
                      ),style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(secondaryTextColor),
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
