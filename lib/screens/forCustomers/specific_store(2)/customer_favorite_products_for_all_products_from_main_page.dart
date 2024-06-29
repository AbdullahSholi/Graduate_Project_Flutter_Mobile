import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:http/http.dart' as http;
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../custom_button.dart';
import '../../../discount_icon.dart';
import '../../../models/Stores/display-all-stores.dart';
import '../../../models/merchant/get_cart_content_model.dart';
import '../../../toggle_button.dart';
import 'customer_specific_store_main_page1.dart';

class CustomerFavoriteProductsForAllProductsFromMainPage extends StatefulWidget {
  String customerTokenVal;
  String customerEmailVal;
  CustomerFavoriteProductsForAllProductsFromMainPage( this.customerTokenVal, this.customerEmailVal, {super.key});

  @override
  State<CustomerFavoriteProductsForAllProductsFromMainPage> createState() => _CustomerFavoriteProductsForAllProductsFromMainPageState();
}

class _CustomerFavoriteProductsForAllProductsFromMainPageState extends State<CustomerFavoriteProductsForAllProductsFromMainPage> {
  List<dynamic> filteredProducts = [];
  String customerTokenVal = "";
  String customerEmailVal = "";
  String emailVal = "";
  String tokenVal = "";

  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  double rateVal = 3;
  late List<dynamic> storeCartsVal = [];



  void getCustomerFavoriteList() async {
    print("ppppppppppppppppppp");
    print(customerEmailVal);
    print("ppppppppppppppppppp");

    http.Response userFuture = await http.get(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-customer-favorite-list/${customerEmailVal}"),
        headers: {"Authorization": "Bearer ${customerTokenVal}"});
    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");

      // return GetCartContentModel.fromJson(json.decode(userFuture.body));
      setState(() {
        storeCartsVal = json.decode(userFuture.body);

      });
    } else {
      throw Exception("Error");
    }


  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerEmailVal = widget.customerEmailVal;
    customerTokenVal = widget.customerTokenVal;
    // storeCartsVal = widget.storeCartsVal;
    getCustomerFavoriteList();
    getMerchantData();
    getStoreIndex();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF212128),
        leading: IconButton(
          onPressed: () {

          },
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF212128),
            size: 30,
          ),
        ),
        title: Container(
          child: Center(
            child: _isSearching
                ? Container(
              width: 200, // Example width
              height: 50, // Example height
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (value) {
                  filterProducts(value);
                  print(filteredProducts);
                },
              ),
            )
                : Container(
              width: MediaQuery.of(context).size.width/2,
              child: Text(
                "${getLang(context, 'favorite_products')}",
                style: GoogleFonts.roboto(textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    // filterProducts('');
                  }
                });
              },
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ),
          )
        ],

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Visibility(
              visible: true,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/1.15,
                child: AnimationLimiter(
                  child: GridView.builder(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    scrollDirection: Axis.vertical,

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Set the number of columns
                      childAspectRatio:
                      0.78, // Customize the aspect ratio (width/height) of each tile
                      mainAxisSpacing: 4.0, // Spacing between rows
                      crossAxisSpacing: 2.0, // Spacing between columns
                    ),
                    // storeCartsVal[index]
                    itemBuilder: (context, index) => filteredProducts.isNotEmpty
                        ? AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 1200),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: InkWell(
                            onTap: () async {},
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                              child: Column(
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
                                          child: (filteredProducts[index]
                                          ["cartPrimaryImage"]
                                              .toString() ==
                                              "null" ||
                                              filteredProducts[index]
                                              ["cartPrimaryImage"]
                                                  .toString() ==
                                                  "")
                                              ? Image.network(
                                            "https://th.bing.com/th/id/R.2cdd64d3370db75b36e9b02259d1832a?rik=w2QxlPJgMEIzXQ&pid=ImgRaw&r=0",
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 180,
                                          )
                                              : Image.network(
                                            filteredProducts[index]
                                            ["cartPrimaryImage"]
                                                .toString(),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 180,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: filteredProducts[index]
                                        ["cartDiscount"]
                                            .toString() ==
                                            "true"
                                            ? Container(
                                          margin: EdgeInsets.fromLTRB(
                                              4, 0, 0, 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(3),
                                            color: Colors.red,
                                          ),
                                          width: 60,
                                          height: 20,
                                          child: Container(
                                            padding:
                                            const EdgeInsets.all(2.0),
                                            child: Text(
                                              "${getLang(context, 'discount')}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight:
                                                  FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                            : Container(),
                                      ),
                                      Visibility(
                                        visible: storeCartsVal[index]["cartFavourite"],
                                        child: Positioned(
                                            top: 0,
                                            right: 0,
                                            child: CustomButton(CustomIcon: Icon(Icons.remove_circle, size: 40, color: Colors.red,),onClick: (_isFavorite) async {
                                                if(!_isFavorite){
                                                  try {

                                                    storeCartsVal[index]["isFavorite"] = !_isFavorite;
                                                    http.Response
                                                    userFuture =
                                                        await http.delete(
                                                      Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-product-from-favorite-list/${customerEmailVal}"),
                                                      headers: {
                                                        "Content-Type": "application/json",
                                                        "Authorization": "Bearer ${customerTokenVal}"
                                                      },
                                                          body: jsonEncode(
                                                            {
                                                              "index": index,
                                                            },
                                                          ),
                                                      encoding: Encoding.getByName("utf-8"),
                                                    );

                                                    print(userFuture.body);
                                                    getCustomerFavoriteList();
                                                  } catch (error) {}
                                                }
                                                  print('Is Favorite $_isFavorite');
                                                })),
                                      ),
                                      filteredProducts[index]["cartDiscount"] ? Positioned(
                                        left: 5,
                                        top: 5,
                                        child: CustomPaint(
                                          size: Size(45, 45),
                                          painter: DiscountPainter(filteredProducts[index]["discountValue"] * 1.0), // Change this value to set the discount percentage
                                        ),) : Container()
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 77,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        color: Color(0xF2222128),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 8, 10, 0),
                                            child: Text(
                                              "${filteredProducts[index]["cartName"].toString()}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.roboto(textStyle: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),),
                                          ),
                                    
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                              textBaseline:
                                              TextBaseline.alphabetic,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Text(
                                                    "${filteredProducts[index]["cartPrice"].toString()}",
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: GoogleFonts.roboto(textStyle: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.white,
                                                    )),),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Visibility(
                                                  visible: filteredProducts[index]["cartDiscount"],
                                                  child: Container(
                                                    // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    child: "${filteredProducts[index]["cartPriceAfterDiscount"].toString()}" ==
                                                        "null"
                                                        ? Text("")
                                                        : Text(
                                                      "${filteredProducts[index]["cartPrice"]/ (1-(filteredProducts[index]["discountValue"]/100))}",
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      maxLines: 1,
                                                      style: GoogleFonts.roboto(textStyle: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        decoration:
                                                        TextDecoration
                                                            .lineThrough,
                                                        decorationThickness:
                                                        3,
                                                        color: Colors.white,
                                                      )),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        : AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 1200),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: InkWell(
                            onTap: () async {},
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                              child: Column(
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
                                          child: (storeCartsVal[index]
                                          ["cartPrimaryImage"]
                                              .toString() ==
                                              "null" ||
                                              storeCartsVal[index]
                                              ["cartPrimaryImage"]
                                                  .toString() ==
                                                  "")
                                              ? Image.network(
                                            "https://th.bing.com/th/id/R.2cdd64d3370db75b36e9b02259d1832a?rik=w2QxlPJgMEIzXQ&pid=ImgRaw&r=0",
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 180,
                                          )
                                              : Image.network(
                                            storeCartsVal[index]
                                            ["cartPrimaryImage"]
                                                .toString(),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                            height: 180,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: storeCartsVal[index]
                                        ["cartDiscount"]
                                            .toString() ==
                                            "true"
                                            ? Container(
                                          margin: EdgeInsets.fromLTRB(
                                              4, 0, 0, 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(3),
                                            color: Colors.red,
                                          ),
                                          width: 60,
                                          height: 20,
                                          child: Container(
                                            padding:
                                            const EdgeInsets.all(2.0),
                                            child: Text(
                                              "${getLang(context, 'discount')}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight:
                                                  FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                            : Container(),
                                      ),
                                      Visibility(
                                        visible: storeCartsVal[index]["cartFavourite"],
                                        child: Positioned(
                                            top: 0,
                                            right: 0,
                                            child: CustomButton(CustomIcon: Icon(Icons.remove_circle, size: 40, color: Colors.red,),onClick: (_isFavorite) async {
                                                  if(!_isFavorite){
                                                    try {

                                                      storeCartsVal[index]["isFavorite"] = !_isFavorite;
                                                      http.Response
                                                      userFuture =
                                                      await http.delete(
                                                        Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-product-from-favorite-list/${customerEmailVal}"),
                                                        headers: {
                                                          "Content-Type": "application/json",
                                                          "Authorization": "Bearer ${customerTokenVal}"
                                                        },
                                                        body: jsonEncode(
                                                          {
                                                            "index": index,
                                                          },
                                                        ),
                                                        encoding: Encoding.getByName("utf-8"),
                                                      );

                                                      print(userFuture.body);
                                                      getCustomerFavoriteList();
                                                    } catch (error) {}
                                                  }
                                                  print('Is Favorite $_isFavorite');
                                                })),
                                      ),
                                      storeCartsVal[index]["cartDiscount"] ? Positioned(
                                        left: 5,
                                        top: 5,
                                        child: CustomPaint(
                                          size: Size(45, 45),
                                          painter: DiscountPainter(storeCartsVal[index]["discountValue"] * 1.0), // Change this value to set the discount percentage
                                        ),) : Container()
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 71,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        color: Color(0xF2222128),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 8, 10, 0),
                                            child: Text(
                                              "${storeCartsVal[index]["cartName"].toString()}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.roboto(textStyle: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),),
                                          ),
                                    
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                              textBaseline:
                                              TextBaseline.alphabetic,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Text(
                                                    "${storeCartsVal[index]["cartPrice"].toString()}",
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: GoogleFonts.roboto(textStyle: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.white,
                                                    )),),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Visibility(
                                                  visible: storeCartsVal[index]["cartDiscount"],
                                                  child: Container(
                                                    // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    child: "${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}" ==
                                                        "null"
                                                        ? Text("")
                                                        : Text(
                                                      "${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}",
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      maxLines: 1,
                                                      style: GoogleFonts.roboto(textStyle: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        decoration:
                                                        TextDecoration
                                                            .lineThrough,
                                                        decorationThickness:
                                                        3,
                                                        color: Colors.white,
                                                      )),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: false,
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    itemCount: filteredProducts.isNotEmpty ? filteredProducts.length : storeCartsVal.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterProducts(input) {
    setState(() {
      filteredProducts = storeCartsVal
          .where(
              (product) => product["cartName"].toString().toLowerCase().startsWith(input))
          .toList();

    });

  }
}
