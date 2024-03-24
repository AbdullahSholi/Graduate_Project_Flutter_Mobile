import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
// import 'dart:html';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/models/login_model.dart';
import 'package:graduate_project/models/merchant/cart_content_model.dart';
import 'package:graduate_project/models/merchant/merchant_connect_store_to_social_media.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forGuest/specific_store(2)/display_all_products_to_search.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_store_informations(5.3).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/edit_your_store_design(5.2).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/imageplaceholder.dart';
import "package:http/http.dart" as http;
import "package:flutter/gestures.dart";
import 'package:image_picker/image_picker.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../models/merchant/get_cart_content_model.dart';
import '../../../models/merchant/merchant_specific_store_categories.dart';
import '../../../models/merchant/merchant_store_slider_images.dart';
import '../../../models/singleUser.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class SpecificStoreMainPage extends StatefulWidget {
  final String token;
  final String email;
  final List<String> specificStoreCategories;
  final String storeName;
  final List<dynamic> storeCartsVal;
  final bool sliderVisibility;
  final bool categoryVisibility;
  final bool cartsVisibility;
  final Map<String, dynamic> objectData;
  const SpecificStoreMainPage(
      this.token, this.email, this.specificStoreCategories, this.storeName, this.storeCartsVal, this.sliderVisibility, this.categoryVisibility, this.cartsVisibility, this.objectData,
      {super.key});
  @override
  State<SpecificStoreMainPage> createState() => _SpecificStoreMainPageState();
}

class _SpecificStoreMainPageState extends State<SpecificStoreMainPage> {
  String tokenVal = "";
  String emailVal = "";
  String imageSliderVal = "";
  List<String> specificStoreCategoriesVal = [];
  late Map<String, dynamic> objectDataVal;
  String storeNameVal = "";
  late bool sliderVisibilityVal ;
  late bool categoryVisibilityVal ;
  late bool cartsVisibilityVal ;


  late Future<User> userData;
  late Future<List> sliderImages;
  late Future<List> specificStoreCategories;
  late Future<List> getCartContent;
  // late indexVal="";
  double rateVal = 3;

  // for Images Slider
  List<String> imageUrls = [];
  List<String> cartImageUrls = [];

  double tempSearchBoxHeight = 0;
  late File _image;
  final Dio _dio = Dio();

  bool cartsForSpecificCategory = false;
  List<dynamic> filteredData=[];

  Future<List> getSliderImages() async {
    print("$emailVal tttttttttt");
    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/store-data/${emailVal}"),
    );
    // print(userFuture.body);

    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");
      print(MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .storeSliderImages
          .toList());

      final List<dynamic> data =
      MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .storeSliderImages
          .toList();
      final List<String> urls = data.map((item) => item.toString()).toList();
      print("wwwwwwwwwwwwwwwwww $urls ");
      setState(() {
        imageUrls = urls;

      });

      return MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .storeSliderImages
          .toList();
    } else {
      print("error");
      throw Exception("Error");
    }
  }

  Future<List> getSpecificStoreCategories() async {
    print("$emailVal ppppp");
    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/store-data/${emailVal}"),
    );
    // print(userFuture.body);

    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");
      print(MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .specificStoreCategories
          .toList());

      final List<dynamic> data =
      MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .specificStoreCategories
          .toList();
      final List<String> urls = data.map((item) => item.toString()).toList();
      print("ooooooooooooooo $urls ");
      setState(() {
        specificStoreCategoriesVal = urls;
      });
      getSpecificStoreCart(emailVal);

      return MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .specificStoreCategories
          .toList();
    } else {
      print("error");
      throw Exception("Error");
    }
  }

  //////////////////////////
  List<dynamic> storeCartsVal=[];
  List<dynamic> CartsForOneCategoryVal=[];
  Future<void> getSpecificStoreCart(emailVal) async {
    storeCartsVal=[];
    print("--------------------------");
    print(emailVal);

    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/test-get-store-cart/${emailVal}"),

    );
    print(userFuture.body);
    var temp = GetCartContentModel.fromJson(json.decode(userFuture.body)).type.toList();


    setState(() {
      storeCartsVal = GetCartContentModel
          .fromJson(json.decode(userFuture.body))
          .type.toList();
      print("vvvvvvvvvvvv $storeCartsVal");
    });

  }
  Future<void> getCartsForOneCategory(emailVal, cartCategory) async {
    CartsForOneCategoryVal=[];
    print("--------------------------");
    print(emailVal);

    http.Response userFuture = await http.get(
      Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/get-all-carts-for-one-category?email=$emailVal&cartCategory=$cartCategory"),
    );
    print(userFuture.body);

///////////////////////////////////////////////////

    List<dynamic> jsonList = json.decode(userFuture.body);
    print("CCCCCCCCCCCCCCCCC");
    print(jsonList[0]["cartName"]);

    setState(() {
    CartsForOneCategoryVal = jsonList;

      print("vvvvvvvvvvvv $CartsForOneCategoryVal");
    });

  }


  Future<List<dynamic>> getSpecificStoreCartSliderImages() async {
    print("--------------------------");
    print(emailVal);

    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/test-get-store-cart/${emailVal}"),
    );
    print(userFuture.body);
    var temp = GetCartContentModel.fromJson(json.decode(userFuture.body)).type.toList();


    setState(() {
      storeCartsVal = GetCartContentModel
          .fromJson(json.decode(userFuture.body))
          .type.toList();
      print("vvvvvvvvvvvv $storeCartsVal");
    });

    return storeCartsVal;

  }



  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  ////////

  /////
  // Visibility
  // bool sliderVisibility = true;
  bool customizeVisibility = false;
  // bool categoryVisibility = true;
  // bool cartsVisibility = true;

  ////

  /////////
  // related to merchant customize button widgets
  List<Widget> containers = [
    Container(),
  ];
  List<Widget> containersCarts = [];

  /////////

  ////////
  // Specific Category
  TextEditingController specificStoreCategoriesTextEditingController =
  TextEditingController();

  // Specific Cart

  TextEditingController cartNameTextEditingController = TextEditingController();
  TextEditingController cartPriceTextEditingController =
  TextEditingController();
  bool cartDiscountBool = false;
  bool cartLikedBool = false;
  bool cartFavouriteBool = false;
  TextEditingController cartPriceAfterDiscountTextEditingController =
  TextEditingController();
  TextEditingController cartDescriptionTextEditingController =
  TextEditingController();
  TextEditingController cartCategoryTextEditing = TextEditingController();
  TextEditingController cartQuantitiesTextEditingController = TextEditingController();

  late String dropdownValue= 'All Products' ;


  ////////

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tokenVal = widget.token;
    emailVal = widget.email;
    specificStoreCategoriesVal = widget.specificStoreCategories;
    storeNameVal = widget.storeName;
    objectDataVal = widget.objectData;
    print(emailVal);
    // userData = getUserByName();
    sliderImages = getSliderImages();
    specificStoreCategories = getSpecificStoreCategories();

    sliderVisibilityVal = widget.sliderVisibility;
    categoryVisibilityVal = widget.categoryVisibility;
    cartsVisibilityVal = widget.cartsVisibility;



  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(

              margin: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height / 20, 20, 0),
              decoration: BoxDecoration(
                  color: Color(0xFF212128),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Center(
                      child: Text(
                        storeNameVal,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,),
                        textAlign: TextAlign.center,
                      )),

                ],
              ),
            ),

            FutureBuilder<List>(
                future: sliderImages,
                builder:
                    (BuildContext context, AsyncSnapshot<List> snapshot) {
                  return Container(
                    // color: Colors.blue,
                    height: MediaQuery.of(context).size.height /1.15 ,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      // color: Colors.cyan
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Visibility(
                            visible: sliderVisibilityVal,
                            child: Column(children: [
                              SizedBox(
                                height: 5,
                              ),

                              FutureBuilder<List>(
                                future: sliderImages,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List> snapshot) {
                                  return Container(
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                        // clipBehavior: ,
                                        autoPlay: true,
                                        height: 200.0,
                                        aspectRatio: 5,
                                        enlargeCenterPage: true,
                                      ),
                                      items: imageUrls.map((url) {
                                        return Builder(
                                          builder:
                                              (BuildContext context) {
                                            return Container(
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                                child: CachedNetworkImage(
                                                  imageUrl: url,
                                                  placeholder: (context,
                                                      url) =>
                                                      SimpleCircularProgressBar(
                                                        mergeMode: true,
                                                        animationDuration: 1,
                                                      ),
                                                  errorWidget: (context,
                                                      url, error) =>
                                                      Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible: categoryVisibilityVal,
                            child: Column(children: [

                              SizedBox(
                                height: 15,
                              ),
                              FutureBuilder<List>(
                                future: specificStoreCategories,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List> snapshot) {
                                  print(storeCartsVal);
                                  return Container(

                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        1.13,
                                    height: 50,

                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                      specificStoreCategoriesVal
                                          .length,
                                      itemBuilder: (context, index) =>
                                          Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                                color: Color(0xFF212128),
                                              ),
                                              width: 120,
                                              child: TextButton(
                                                  onPressed: () async {
                                                    if (specificStoreCategoriesVal[index] == "All Products") {
                                                      setState(() {
                                                        cartsForSpecificCategory=false;
                                                      });

                                                    } else {
                                                      await getCartsForOneCategory(
                                                          emailVal,
                                                          specificStoreCategoriesVal[index]);
                                                      setState(() {

                                                        cartsForSpecificCategory =
                                                        true;

                                                      });

                                                      print(
                                                          cartsForSpecificCategory);
                                                    }
                                                  },
                                                  child: Text(
                                                    specificStoreCategoriesVal[
                                                    index],
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white,
                                                        fontSize: 15),
                                                  ))),
                                      separatorBuilder:
                                          (context, index) => SizedBox(
                                        width: 5,
                                      ),
                                    ),
                                  );
                                },
                              )
                            ]),
                          ),
                          Column(
                            children: [
                              Visibility(
                                visible: cartsVisibilityVal,
                                child: Column(
                                  children: [
                                    Container(

                                      padding: EdgeInsets.fromLTRB(13, 20, 20, 0),
                                      child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:
                                        [
                                          Text("Products",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: Color(0xFF212128)),),
                                      InkWell(child: Text("View All",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: Color(0xFF212128)),),
                                        onTap: (){

                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DisplayAllProducts(storeCartsVal)));
                                        },
                                      )
                                    ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: !cartsForSpecificCategory,
                                      child: Container(

                                            width: MediaQuery.of(context)
                                                .size
                                                .width,

                                            child: GridView.builder(
                                              padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                                              scrollDirection: Axis.vertical,
                                              physics:
                                              NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                2, // Set the number of columns
                                                childAspectRatio:
                                                0.77, // Customize the aspect ratio (width/height) of each tile
                                                mainAxisSpacing:
                                                4.0, // Spacing between rows
                                                crossAxisSpacing:
                                                2.0, // Spacing between columns
                                              ),
                                              // storeCartsVal[index]
                                              itemBuilder: (context, index) => InkWell(
                                                onTap: () async{

                                                },
                                                child: Container(

                                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                                  child: Stack(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.all(1),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                topRight: Radius.circular(20),
                                                                topLeft: Radius.circular(20),
                                                              ),
                                                              color: Color(0xF2222128),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                topRight: Radius.circular(20),
                                                                topLeft: Radius.circular(20),
                                                              ),
                                                              child: (storeCartsVal[index]["cartPrimaryImage"].toString() == "null" || storeCartsVal[index]["cartPrimaryImage"].toString() == "") ? Image.network(
                                                                "https://th.bing.com/th/id/R.2cdd64d3370db75b36e9b02259d1832a?rik=w2QxlPJgMEIzXQ&pid=ImgRaw&r=0" ,
                                                                fit: BoxFit.cover,
                                                                width: double.infinity,
                                                                height: 120,
                                                              ): Image.network(
                                                                storeCartsVal[index]["cartPrimaryImage"].toString(),
                                                                fit: BoxFit.cover,
                                                                width: double.infinity,
                                                                height: 120,
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 0,
                                                            left: 0,
                                                            child: storeCartsVal[index]["cartDiscount"].toString() == "true" ? Container(
                                                              margin: EdgeInsets.fromLTRB(4, 0, 0, 10),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(3),
                                                                color: Colors.red,
                                                              ),

                                                              width: 60,
                                                              height: 20,
                                                              child: Container(

                                                                padding: const EdgeInsets.all(2.0),
                                                                child: Text("DISCOUNT",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),
                                                              ),
                                                            ) : Container(),
                                                          ),
                                                          Visibility(
                                                            visible: storeCartsVal[index]["cartFavourite"],
                                                            child: Positioned(
                                                                top: 5,
                                                                right: 5,
                                                                child: FavoriteButton(
                                                                    iconDisabledColor: Color(0xFF212128),
                                                                    iconSize: 40,
                                                                    iconColor: Colors.white,
                                                                    valueChanged: (_isFavorite){
                                                                      print('Is Favorite $_isFavorite');
                                                                    })),
                                                          )
                                                        ],
                                                      ),
                                                      Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          right: 0,
                                                          child: Container(
                                                            height: 120,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                bottomRight: Radius.circular(20),
                                                                bottomLeft: Radius.circular(20),
                                                              ),
                                                              color: Color(0xF2222128),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                                                                  child: Text("${storeCartsVal[index]["cartName"].toString()}",
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 1,
                                                                      style: TextStyle(
                                                                        fontSize: 22,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.white,
                                                                      )),
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets.fromLTRB(10, 8, 10, 3),
                                                                  child: Text("${storeCartsVal[index]["cartDescription"].toString()}",
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 2,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.white,
                                                                      )),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                  textBaseline: TextBaseline.alphabetic,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.fromLTRB(10, 0, 2, 0),
                                                                      child: Text("${storeCartsVal[index]["cartPrice"].toString()}",
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.white,
                                                                          )),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Container(
                                                                      // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                      child: "${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}"=="null" ? Text("") : Text("${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}",
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.bold,
                                                                            decoration: TextDecoration.lineThrough,
                                                                            decorationThickness: 3,
                                                                            color: Colors.white,
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Visibility(
                                                                  visible: storeCartsVal[index]["cartLiked"],
                                                                  child: Container(
                                                                    padding: EdgeInsets.fromLTRB(7, 2, 0, 0),
                                                                    child: RatingBar.builder(
                                                                      initialRating: 3,
                                                                      minRating: 1,
                                                                      direction: Axis.horizontal,
                                                                      allowHalfRating: true,
                                                                      itemCount: 5,
                                                                      itemSize: 20,
                                                                      unratedColor: Colors.white,
                                                                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                                      itemBuilder: (context, _) => Icon(
                                                                        Icons.favorite,
                                                                        color: Colors.yellow,
                                                                      ),
                                                                      onRatingUpdate: (rating) {
                                                                        setState(() {
                                                                          rateVal = rating;
                                                                        });

                                                                        print(rating);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              ,
                                              itemCount: storeCartsVal.length,
                                            ),
                                          ),
                                    ),
                                    Visibility(
                                      visible: cartsForSpecificCategory,
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,

                                        child: GridView.builder(
                                          padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                                          scrollDirection: Axis.vertical,
                                          physics:
                                          NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                            2, // Set the number of columns
                                            childAspectRatio:
                                            0.77, // Customize the aspect ratio (width/height) of each tile
                                            mainAxisSpacing:
                                            4.0, // Spacing between rows
                                            crossAxisSpacing:
                                            2.0, // Spacing between columns
                                          ),
                                          // storeCartsVal[index]
                                          itemBuilder: (context, index) => InkWell(
                                            onTap: () async{

                                            },
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                              child: Stack(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(1),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(20),
                                                            topLeft: Radius.circular(20),
                                                          ),
                                                          color: Color(0xF2222128),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(20),
                                                            topLeft: Radius.circular(20),
                                                          ),
                                                          child: (CartsForOneCategoryVal[index]["cartPrimaryImage"].toString() == "null" || CartsForOneCategoryVal[index]["cartPrimaryImage"].toString() == "") ? Image.network(
                                                            "https://th.bing.com/th/id/R.2cdd64d3370db75b36e9b02259d1832a?rik=w2QxlPJgMEIzXQ&pid=ImgRaw&r=0" ,
                                                            fit: BoxFit.cover,
                                                            width: double.infinity,
                                                            height: 120,
                                                          ): Image.network(
                                                            CartsForOneCategoryVal[index]["cartPrimaryImage"].toString(),
                                                            fit: BoxFit.cover,
                                                            width: double.infinity,
                                                            height: 120,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        left: 0,
                                                        child: CartsForOneCategoryVal[index]["cartDiscount"].toString() == "true" ? Container(
                                                          margin: EdgeInsets.fromLTRB(4, 0, 0, 10),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(3),
                                                            color: Colors.red,
                                                          ),

                                                          width: 60,
                                                          height: 20,
                                                          child: Container(

                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Text("DISCOUNT",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),
                                                          ),
                                                        ) : Container(),
                                                      ),
                                                    ],
                                                  ),
                                                  Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: Container(
                                                        height: 120,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            bottomRight: Radius.circular(20),
                                                            bottomLeft: Radius.circular(20),
                                                          ),
                                                          color: Color(0xF2222128),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                                                              child: Text("${CartsForOneCategoryVal[index]["cartName"].toString()}",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                    fontSize: 22,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                  )),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(10, 8, 10, 3),
                                                              child: Text("${CartsForOneCategoryVal[index]["cartDescription"].toString()}",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                  )),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.baseline,
                                                              textBaseline: TextBaseline.alphabetic,
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets.fromLTRB(10, 0, 2, 0),
                                                                  child: Text("${CartsForOneCategoryVal[index]["cartPrice"].toString()}",
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 1,
                                                                      style: TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.white,
                                                                      )),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Container(
                                                                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                  child: "${CartsForOneCategoryVal[index]["cartPriceAfterDiscount"].toString()}"=="null" ? Text("") : Text("${CartsForOneCategoryVal[index]["cartPriceAfterDiscount"].toString()}",
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 1,
                                                                      style: TextStyle(
                                                                        fontSize: 11,
                                                                        fontWeight: FontWeight.bold,
                                                                        decoration: TextDecoration.lineThrough,
                                                                        decorationThickness: 3,
                                                                        color: Colors.white,
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          )
                                          ,
                                          itemCount: CartsForOneCategoryVal.length,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),

    );
  }



  void defaultCategoryContainer() {

  }

  void defaultCartContainer() {

  }

  void addDataToFilteredData(){

  }
}
