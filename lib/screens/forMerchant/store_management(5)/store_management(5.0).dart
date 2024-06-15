import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/chat_system.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/connect_to_social_media_accounts.dart';

import 'package:graduate_project/screens/forMerchant/store_management(5)/display_store_informations(5.3).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_your_store(5.1).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/edit_your_store_design(5.2).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/notify_your_customers.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_statistics.dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../models/merchant/all_stores_model.dart';
import '../../../models/merchant/get_cart_content_model.dart';
import '../../../models/merchant/merchant_connect_store_to_social_media.dart';
import '../../../models/merchant/merchant_profile.dart';
import '../../forCustomers/customer_login_register/login_or_register(2).dart';
import '../merchant_home_page(3)/merchant_home_page.dart';
import '../personal_information(4)/personal_information(4).dart';
import 'edit_your_store_informations(5.4).dart';
import 'faq_page.dart';



class StoreManagement extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;
  final String imageUrl;
  final String storeNameVal;
  final String storeCategoryVal;
  final String storeDescriptionVal;
  final List<String> specificStoreCategoriesVal;
  final List<dynamic> storeCartsVal;
  final bool sliderVisibility;
  final bool categoryVisibility;
  final bool cartsVisibility;


  StoreManagement(this.token,this.email,this.imageUrl, this.storeNameVal, this.storeCategoryVal, this.storeDescriptionVal,this.specificStoreCategoriesVal,this.storeCartsVal, this.sliderVisibility, this.categoryVisibility, this.cartsVisibility);

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
  late Map<String, dynamic> objectData ={};

  List<dynamic> storeSliderImagesVal =[];

  String merchantnameVal ="";
  String phoneVal="";
  String countryVal = "";
  String AvatarVal = "";

  List<dynamic> storeProductImagesVal=[];
  List<dynamic> storeSocialMediaAccounts =[];


  List<dynamic> specificStoreCatVal = [];

  List<dynamic> storeCartsVal =[];
  late Future<Merchant> userData;
  late Future<AllStore> storeData;
  late bool sliderVisibilityVal ;
  late bool categoryVisibilityVal;
  late bool cartsVisibilityVal ;

  late bool activateSliderVal;
  late bool activateCategoryVal;
  late bool activateCartsVal;

  late List<dynamic> typeVal;

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
    storeCartsVal = widget.storeCartsVal;
    sliderVisibilityVal = widget.sliderVisibility;
    categoryVisibilityVal = widget.categoryVisibility;
    cartsVisibilityVal = widget.cartsVisibility;
    userData = getUserByName();
    storeData = getAllStoreData();

  }
  Future<http.Response> deleteStore() async {
    final http.Response response = await http.delete(
      Uri.parse('https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-store/$emailVal'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $tokenVal",
      },
    );
    return response;
  }

  Future<AllStore> getAllStoreData() async{
    print("$emailVal tttttttttt");
    http.Response userFuture = await http.get(
      Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}"),
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );
    print(userFuture.statusCode);
    if(userFuture.statusCode == 200){
      // print("${userFuture.body}");
      print(AllStore.fromJson(json.decode(userFuture.body)));

      return AllStore.fromJson(json.decode(userFuture.body));
    }
    else{
      throw Exception("Error");
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
      getSpecificStoreCart();


      return Merchant.fromJson(json.decode(userFuture.body));
    }
    else{
      throw Exception("Error");
    }
  }
  Future<List<dynamic>> getSpecificStoreCart() async {
    print("--------------------------");
    print(emailVal);

    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/test-get-merchant-cart/${emailVal}"),
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );
    print(userFuture.body);
    var temp = GetCartContentModel.fromJson(json.decode(userFuture.body)).type.toList();


    setState(() {
      storeCartsVal = GetCartContentModel
          .fromJson(json.decode(userFuture.body))
          .type.toList();
      print("vvvvvvvvvvvv $storeCartsVal");
    });
    return GetCartContentModel.fromJson(json.decode(userFuture.body)).type.toList();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF212128),
          leading: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MerchantHome(tokenVal, emailVal)));
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
          ),
          title: Text("${getLang(context, 'store_management')}", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),

        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 2,
              color: Colors.white,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF212128),
                ),
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FutureBuilder<AllStore>(
                        future: storeData,
                        builder: (BuildContext context, AsyncSnapshot<AllStore> snapshot) {
                          try {
                            imageUrlVal = snapshot.data!.storeAvatar;
                            storeNameVal = snapshot.data!.storeName;
                            storeCategoryVal = snapshot.data!.storeCategory;
                            storeDescriptionVal = snapshot.data!.storeDescription;
                            sliderVisibilityVal = snapshot.data!.activateSlider;
                            categoryVisibilityVal = snapshot.data!.activateCategory;
                            cartsVisibilityVal = snapshot.data!.activateCarts;

                            specificStoreCatVal = snapshot.data!.specificStoreCategories;
                            List<String> stringList = specificStoreCatVal.map((element) => element.toString()).toList();
                            specificStoreCategoriesVal = stringList;
                            typeVal = snapshot.data!.type;
                            List<String> tempTypeVal = typeVal.map((element) => element.toString()).toList();
                            print("xxxxxxxxxx");
                            print(tempTypeVal);
                            print("xxxxxxxxxx");

                            storeSliderImagesVal = snapshot.data!.storeSliderImages;
                            storeProductImagesVal = snapshot.data!.storeProductImages;
                            storeSocialMediaAccounts = snapshot.data!.socialMediaAccounts;
                            merchantnameVal = snapshot.data!.merchantname;
                            phoneVal = snapshot.data!.phone;
                            countryVal = snapshot.data!.country;
                            AvatarVal = snapshot.data!.Avatar;
                            objectData = {
                              "merchantname":merchantnameVal,
                              "email":emailVal,
                              "phone":phoneVal,
                              "country":countryVal,
                              "Avatar":AvatarVal,
                              "storeName":storeNameVal,
                              "storeAvatar":snapshot.data?.storeAvatar,
                              "storeCategory":storeCategoryVal,
                              "storeSliderImages":storeSliderImagesVal,
                              "storeProductImages":storeProductImagesVal,
                              "storeDescription":storeDescriptionVal,
                              "storeSocialMediaAccounts":storeSocialMediaAccounts,
                              "activateSlider":sliderVisibilityVal,
                              "activateCategory":categoryVisibilityVal,
                              "activateCarts":cartsVisibilityVal ,
                              "specificStoreCategories":specificStoreCategoriesVal,
                              "backgroundColor" : "",
                              "boxesColor" : "",
                              "primaryTextColor" : "",
                              "secondaryTextColor" : "",
                              "clippingColor" : "",
                              "smoothy" : "",
                              "design" : "",
                              // "type":tempTypeVal,


                            };

                            print("%%%%%%%%%%%%%%%%%%%%%");
                            print(objectData);
                            print("%%%%%%%%%%%%%%%%%%%%%");
                            print(storeCartsVal);
                            return Container(


                              child: SingleChildScrollView(
                                child: Column(
                                  children: [

                                    Center(
                                      child: Container(

                                          padding: EdgeInsets.all(15),

                                          child: Text(
                                            storeNameVal,
                                            style: GoogleFonts
                                                .roboto(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          )

                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      border: Border.all(width: 3, color: Colors.white),
                                    ),

                                      child: CircleAvatar(
                                        radius: 100,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            width: double.infinity,
                                            height:  double.infinity,
                                            fit: BoxFit.cover,
                                              imageUrl:snapshot.data!.storeAvatar,
                                            placeholder: (context, url) => SimpleCircularProgressBar(
                                              mergeMode: true,
                                              animationDuration: 1,
                                            ),
                                            errorWidget: (context, url, error) => Icon(Icons.error),


                                          ),


                                        ),
                                      ),
                                    ),
                                    // SizedBox(height: 20,),
                                    // Container(
                                    //   height: 70,
                                    //   margin: EdgeInsets.fromLTRB(30, 20, 30, 5),
                                    //   decoration: BoxDecoration(
                                    //       border: Border.all(color: Colors.white, width: 1),
                                    //       borderRadius: BorderRadius.circular(10),
                                    //       color: Color(0xFF2A212E)),
                                    //   child: Center(
                                    //     child: ListTile(
                                    //       leading: Icon(
                                    //         Icons.view_carousel_outlined,
                                    //         color: Colors.white,
                                    //         size: 35,
                                    //       ),
                                    //       title: Text(
                                    //         "Display your store",
                                    //         style: TextStyle(color: Colors.white),
                                    //       ),
                                    //       onTap: () {
                                    //         Navigator.push(context,
                                    //             MaterialPageRoute(
                                    //                 builder: (context) =>
                                    //                     DisplayYourStore(
                                    //                         tokenVal,emailVal,specificStoreCategoriesVal,storeNameVal, storeCartsVal,sliderVisibilityVal,categoryVisibilityVal,cartsVisibilityVal,objectData )));
                                    //       },
                                    //       trailing: Icon(
                                    //         Icons.arrow_forward_ios,
                                    //         color: Colors.white,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin: EdgeInsets.fromLTRB(
                                    //       30, 0, 30, 0),
                                    //   child: TextButton(
                                    //     style: TextButton.styleFrom(
                                    //         padding: EdgeInsets.all(15),
                                    //         backgroundColor: Colors.white,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius
                                    //                 .circular(15)
                                    //         )
                                    //     ),
                                    //     child: Text("Display your store",
                                    //       style: GoogleFonts.federo(
                                    //         color: Color(0xFF212128),
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 29,
                                    //
                                    //       ),
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //     onPressed: () {
                                    //       Navigator.push(context,
                                    //           MaterialPageRoute(
                                    //               builder: (context) =>
                                    //                   DisplayYourStore(
                                    //                       tokenVal,emailVal,specificStoreCategoriesVal,storeNameVal, storeCartsVal,sliderVisibilityVal,categoryVisibilityVal,cartsVisibilityVal,objectData )));
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(height: 20,),

                                    Container(
                                      height: 70,
                                      margin: EdgeInsets.fromLTRB(30, 0, 30, 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xFF2A212E)),
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          title: Text(
                                            "${getLang(context, 'edit_your_store_design')}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditYourStoreDesign(
                                                            tokenVal,emailVal,specificStoreCategoriesVal,storeNameVal, storeCartsVal,sliderVisibilityVal,categoryVisibilityVal,cartsVisibilityVal, objectData)));
                                          },
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin: EdgeInsets.fromLTRB(
                                    //       30, 0, 30, 0),
                                    //   child: TextButton(
                                    //     style: TextButton.styleFrom(
                                    //         padding: EdgeInsets.all(15),
                                    //         backgroundColor: Colors.white,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius
                                    //                 .circular(15)
                                    //         )
                                    //     ),
                                    //     child: Text(
                                    //       "Edit your store design",
                                    //       style: GoogleFonts.federo(
                                    //         color: Color(0xFF212128),
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 29,
                                    //
                                    //       ),
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //     onPressed: () {
                                    //       Navigator.push(context,
                                    //           MaterialPageRoute(
                                    //               builder: (context) =>
                                    //                   EditYourStoreDesign(
                                    //                       tokenVal,emailVal,specificStoreCategoriesVal,storeNameVal, storeCartsVal,sliderVisibilityVal,categoryVisibilityVal,cartsVisibilityVal, objectData)));
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(height: 20,),

                                    Container(
                                      height: 70,
                                      margin: EdgeInsets.fromLTRB(30, 0, 30, 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xFF2A212E)),
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.view_carousel_outlined,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          title: Text(
                                            "${getLang(context, 'store_informations')}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DisplayStoreInformations(
                                                            tokenVal, emailVal)));
                                          },
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin: EdgeInsets.fromLTRB(
                                    //       30, 0, 30, 0),
                                    //   child: TextButton(
                                    //     style: TextButton.styleFrom(
                                    //         padding: EdgeInsets.all(15),
                                    //         backgroundColor: Colors.white,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius
                                    //                 .circular(15)
                                    //         )
                                    //     ),
                                    //     child: Text(
                                    //       "Display store informations",
                                    //       style: GoogleFonts.federo(
                                    //         color: Color(0xFF212128),
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 24,
                                    //
                                    //       ),
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //     onPressed: () {
                                    //       Navigator.push(context,
                                    //           MaterialPageRoute(
                                    //               builder: (context) =>
                                    //                   DisplayStoreInformations(
                                    //                       tokenVal, emailVal)));
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(height: 20,),

                                    Container(
                                      height: 70,
                                      margin: EdgeInsets.fromLTRB(30, 0, 30, 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xFF2A212E)),
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          title: Text(
                                            "${getLang(context, 'edit_store_informations')}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditYourStoreInformations(
                                                            tokenVal, emailVal,imageUrlVal,storeNameVal,storeCategoryVal,storeDescriptionVal)));
                                          },
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin: EdgeInsets.fromLTRB(
                                    //       30, 0, 30, 0),
                                    //   child: TextButton(
                                    //     style: TextButton.styleFrom(
                                    //         padding: EdgeInsets.all(15),
                                    //         backgroundColor: Colors.white,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius
                                    //                 .circular(15)
                                    //         )
                                    //     ),
                                    //     child: Text(
                                    //       "Edit your store information",
                                    //       style: GoogleFonts.federo(
                                    //         color: Color(0xFF212128),
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 24,
                                    //
                                    //       ),
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //     onPressed: () {
                                    //       Navigator.push(context,
                                    //           MaterialPageRoute(
                                    //               builder: (context) =>
                                    //                   EditYourStoreInformations(
                                    //                       tokenVal, emailVal,imageUrlVal,storeNameVal,storeCategoryVal,storeDescriptionVal)));
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(height: 20,),

                                    Container(
                                      height: 70,
                                      margin: EdgeInsets.fromLTRB(30, 0, 30, 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xFF2A212E)),
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.stacked_line_chart,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          title: Text(
                                            "${getLang(context, 'store_statistics')}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) => StoreStatistics(tokenVal, emailVal)));
                                          },
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin: EdgeInsets.fromLTRB(
                                    //       30, 0, 30, 0),
                                    //   child: TextButton(
                                    //     style: TextButton.styleFrom(
                                    //         padding: EdgeInsets.all(15),
                                    //         backgroundColor: Colors.white,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius
                                    //                 .circular(15)
                                    //         )
                                    //     ),
                                    //     child: Text("Store statistics",
                                    //       style: GoogleFonts.federo(
                                    //         color: Color(0xFF212128),
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 29,
                                    //
                                    //       ),
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //     onPressed: () {
                                    //       Navigator.push(context,
                                    //           MaterialPageRoute(
                                    //               builder: (context) => StoreStatistics(tokenVal, emailVal)));
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(height: 20,),

                                    Container(
                                      height: 70,
                                      margin: EdgeInsets.fromLTRB(30, 0, 30, 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xFF2A212E)),
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.switch_account,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          title: Text(
                                            "${getLang(context, 'connect_to_social_media')}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ConnectToSocialMediaAccounts(tokenVal, emailVal, imageUrlVal, storeNameVal, storeCategoryVal, storeDescriptionVal)));
                                          },
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin: EdgeInsets.fromLTRB(
                                    //       30, 0, 30, 0),
                                    //   child: TextButton(
                                    //     style: TextButton.styleFrom(
                                    //         padding: EdgeInsets.all(15),
                                    //         backgroundColor: Colors.white,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius
                                    //                 .circular(15)
                                    //         )
                                    //     ),
                                    //     child: Text("Connect social media ",
                                    //       style: GoogleFonts.federo(
                                    //         color: Color(0xFF212128),
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 29,
                                    //
                                    //       ),
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //     onPressed: () {
                                    //       Navigator.push(context,
                                    //           MaterialPageRoute(
                                    //               builder: (context) =>
                                    //                   ConnectToSocialMediaAccounts(tokenVal, emailVal, imageUrlVal, storeNameVal, storeCategoryVal, storeDescriptionVal)));
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(height: 20,),

                                    Container(
                                      height: 70,
                                      margin: EdgeInsets.fromLTRB(30, 0, 30, 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xFF2A212E)),
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.chat,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          title: Text(
                                            "${getLang(context, 'chat_system')}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatSystem(tokenVal, emailVal)));
                                          },
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin: EdgeInsets.fromLTRB(
                                    //       30, 0, 30, 0),
                                    //   child: TextButton(
                                    //     style: TextButton.styleFrom(
                                    //         padding: EdgeInsets.all(15),
                                    //         backgroundColor: Colors.white,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius
                                    //                 .circular(15)
                                    //         )
                                    //     ),
                                    //     child: Text("Chat System",
                                    //       style: GoogleFonts.federo(
                                    //         color: Color(0xFF212128),
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 29,
                                    //
                                    //       ),
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //     onPressed: () {
                                    //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatSystem(tokenVal, emailVal)));
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(height: 20,),

                                    Container(
                                      height: 70,
                                      margin: EdgeInsets.fromLTRB(30, 0, 30, 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xFF2A212E)),
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.notifications_active,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          title: Text(
                                            "${getLang(context, 'notify_your_customer')}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NotifyYourCustomers(tokenVal, emailVal)));
                                          },
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin: EdgeInsets.fromLTRB(
                                    //       30, 0, 30, 0),
                                    //   child: TextButton(
                                    //     style: TextButton.styleFrom(
                                    //         padding: EdgeInsets.all(15),
                                    //         backgroundColor: Colors.white,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius
                                    //                 .circular(15)
                                    //         )
                                    //     ),
                                    //     child: Text("Notify Your Customers",
                                    //       style: GoogleFonts.federo(
                                    //         color: Color(0xFF212128),
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 29,
                                    //
                                    //       ),
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //     onPressed: () {
                                    //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NotifyYourCustomers(tokenVal, emailVal)));
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(height: 20,),

                                    Container(
                                      height: 70,
                                      margin: EdgeInsets.fromLTRB(30, 0, 30, 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xFF2A212E)),
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.question_mark_sharp,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          title: Text(
                                            "${getLang(context, 'faq')}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MerchantFaqPage(tokenVal, emailVal)));
                                          },
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin: EdgeInsets.fromLTRB(
                                    //       30, 0, 30, 0),
                                    //   child: TextButton(
                                    //     style: TextButton.styleFrom(
                                    //         padding: EdgeInsets.all(15),
                                    //         backgroundColor: Colors.white,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius
                                    //                 .circular(15)
                                    //         )
                                    //     ),
                                    //     child: Text("FAQ ",
                                    //       style: GoogleFonts.federo(
                                    //         color: Color(0xFF212128),
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 29,
                                    //
                                    //       ),
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //     onPressed: () {
                                    //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MerchantFaqPage(tokenVal, emailVal)));
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(height: 20,),

                                    Container(
                                      height: 70,
                                      margin: EdgeInsets.fromLTRB(30, 0, 30, 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xFF2A212E)),
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.delete_forever,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          title: Text(
                                            "${getLang(context, 'delete_store')}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.confirm,
                                                text: 'Do you want to delete your store?  ( This action will delete your store with all its details!! )',
                                                confirmBtnText: 'Yes',
                                                cancelBtnText: 'No',
                                                confirmBtnColor: Colors.green,
                                                onConfirmBtnTap: (){
                                                  deleteStore();
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LogAllPage()));
                                                },
                                                onCancelBtnTap: (){
                                                  Navigator.pop(context);
                                                }
                                            );
                                          },
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin: EdgeInsets.fromLTRB(
                                    //       30, 0, 30, 0),
                                    //   child: TextButton(
                                    //     style: TextButton.styleFrom(
                                    //         padding: EdgeInsets.all(15),
                                    //         backgroundColor: Colors.white,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius
                                    //                 .circular(15)
                                    //         )
                                    //     ),
                                    //     child: Text("Delete Store ",
                                    //       style: GoogleFonts.federo(
                                    //         color: Color(0xFF212128),
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 29,
                                    //
                                    //       ),
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //     onPressed: () {
                                    //       QuickAlert.show(
                                    //         context: context,
                                    //         type: QuickAlertType.confirm,
                                    //         text: 'Do you want to delete your store?  ( This action will delete your store with all its details!! )',
                                    //         confirmBtnText: 'Yes',
                                    //         cancelBtnText: 'No',
                                    //         confirmBtnColor: Colors.green,
                                    //         onConfirmBtnTap: (){
                                    //           deleteStore();
                                    //           Navigator.push(context, MaterialPageRoute(builder: (context)=>LogAllPage()));
                                    //         },
                                    //         onCancelBtnTap: (){
                                    //           Navigator.pop(context);
                                    //         }
                                    //       );
                                    //       // showDialog(context: context, builder: (context)=>AlertDialog(
                                    //       //   title: Row(
                                    //       //     children: [
                                    //       //       Icon(Icons.warning,color: Colors.red,size: 25,),
                                    //       //       SizedBox(width: 10,),
                                    //       //       Text("Information Message"),
                                    //       //     ],
                                    //       //   ),
                                    //       //   content: Text("This action will delete your store with all it's details!!"),
                                    //       //   actions: [
                                    //       //     TextButton(onPressed: () {
                                    //       //         deleteStore();
                                    //       //         Navigator.push(context, MaterialPageRoute(builder: (context)=>LogAllPage()));
                                    //       //
                                    //       //     }, child: Text("Delete anyway")),
                                    //       //     TextButton(onPressed: (){
                                    //       //       Navigator.pop(context);
                                    //       //     }, child: Text("Cancel")),
                                    //       //
                                    //       //   ],
                                    //       // ),);
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(height: 20,),

                                    Container(
                                      height: 70,
                                      margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xFF2A212E)),
                                      child: Center(
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.logout_outlined,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          title: Text(
                                            "${getLang(context, 'logout')}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {

                                              QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.confirm,
                                                  text: 'Do you want to logout',
                                                  confirmBtnText: 'Yes',
                                                  cancelBtnText: 'No',
                                                  confirmBtnColor: Colors.green,
                                                  onConfirmBtnTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerLoginOrRegister("", "")));
                                                  },
                                                  onCancelBtnTap: (){
                                                    Navigator.pop(context);
                                                  }

                                              );

                                          },
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),


                              ),
                            );
                          }catch(err){
                            return Text("err");
                          }
                        },

                      ),
                      // Container(
                      //   width: double.infinity,
                      //   margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                      //   child: TextButton(
                      //     style: TextButton.styleFrom(
                      //         padding: EdgeInsets.all(15),
                      //         backgroundColor: Colors.white,
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(15)
                      //         )
                      //     ),
                      //     child: Text("Logout", style: GoogleFonts.federo(
                      //       color: Color(0xFF212128),
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 30,
                      //
                      //     ),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //     onPressed: (){
                      //       QuickAlert.show(
                      //           context: context,
                      //           type: QuickAlertType.confirm,
                      //           text: 'Do you want to logout',
                      //           confirmBtnText: 'Yes',
                      //           cancelBtnText: 'No',
                      //           confirmBtnColor: Colors.green,
                      //           onConfirmBtnTap: (){
                      //             Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerLoginOrRegister("", "")));
                      //           },
                      //           onCancelBtnTap: (){
                      //             Navigator.pop(context);
                      //           }
                      //
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ));
  }
}
