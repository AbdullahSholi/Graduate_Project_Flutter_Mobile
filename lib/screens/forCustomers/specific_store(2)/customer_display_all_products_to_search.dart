import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import '../../../toggle_button.dart';

class CustomerDisplayAllProducts extends StatefulWidget {
  late List<dynamic> storeCartsVal;
  late String customerTokenVal;
  late String customerEmailVal;
  CustomerDisplayAllProducts(this.storeCartsVal, this.customerTokenVal, this.customerEmailVal, {super.key});

  @override
  State<CustomerDisplayAllProducts> createState() => _CustomerDisplayAllProductsState();
}

class _CustomerDisplayAllProductsState extends State<CustomerDisplayAllProducts> {
  List<dynamic> filteredProducts = [];

  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  double rateVal = 3;
  late List<dynamic> storeCartsVal;
  String customerTokenVal = "";
  String customerEmailVal = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storeCartsVal = widget.storeCartsVal;
    customerEmailVal = widget.customerEmailVal;
    customerTokenVal = widget.customerTokenVal;
  }

  Icon favoriteIcon = Icon(Icons.favorite_border, size: 20, color: Colors.white,);
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
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Center(
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
                        : Text(
                      "Products",
                      style: GoogleFonts.lilitaOne(textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                      ),),
                  ),
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
              ),
            ),
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
                      0.775, // Customize the aspect ratio (width/height) of each tile
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
                                            height: 120,
                                          )
                                              : Image.network(
                                            filteredProducts[index]
                                            ["cartPrimaryImage"]
                                                .toString(),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 120,
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
                                              "DISCOUNT",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          ),
                                        )
                                            : Container(),
                                      ),
                                      Visibility(
                                        visible: storeCartsVal[index]["cartFavourite"],
                                        child: Positioned(
                                            top: 5,
                                            right: 5,
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                              Colors.red,
                                              child: ToggleButton(toggleIcon: favoriteIcon, onIconColor: Colors.white, offIconColor: Colors.black, onChanged: (_isFavorite) async {
                                                if (_isFavorite) {
                                                  try {

                                                    storeCartsVal[index]["isFavorite"] = _isFavorite;
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
                                                          "favouriteList": storeCartsVal[index],
                                                        },
                                                      ),
                                                      encoding: Encoding.getByName("utf-8"),
                                                    );

                                                    print(userFuture.body);
                                                  } catch (error) {}
                                                } else {
                                                  try {

                                                    storeCartsVal[index]["isFavorite"] = !_isFavorite;
                                                    print(storeCartsVal[index]["cartName"]);
                                                    print(storeCartsVal[index]["merchant"]);
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
                                                          "cartName": storeCartsVal[index]["cartName"],
                                                          "merchant": storeCartsVal[index]["merchant"]
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
                                            )),
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
                                                style: GoogleFonts.lilitaOne(textStyle: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                )),),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 8, 10, 3),
                                              child: Text(
                                                "${filteredProducts[index]["cartDescription"].toString()}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: GoogleFonts.lilitaOne(textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                )),),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                              textBaseline:
                                              TextBaseline.alphabetic,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 0, 2, 0),
                                                  child: Text(
                                                    "${filteredProducts[index]["cartPrice"].toString()}",
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: GoogleFonts.lilitaOne(textStyle: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.white,
                                                    )),),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                  child: "${filteredProducts[index]["cartPriceAfterDiscount"].toString()}" ==
                                                      "null"
                                                      ? Text("")
                                                      : Text(
                                                    "${filteredProducts[index]["cartPriceAfterDiscount"].toString()}",
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    maxLines: 1,
                                                    style: GoogleFonts.lilitaOne(textStyle: TextStyle(
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
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
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
                                            height: 120,
                                          )
                                              : Image.network(
                                            storeCartsVal[index]
                                            ["cartPrimaryImage"]
                                                .toString(),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                            height: 120,
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
                                              "DISCOUNT",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          ),
                                        )
                                            : Container(),
                                      ),
                                      Visibility(
                                        visible: storeCartsVal[index]["cartFavourite"],
                                        child: Positioned(
                                            top: 5,
                                            right: 5,
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                              Colors.red,
                                              child: ToggleButton(toggleIcon: favoriteIcon, onIconColor: Colors.white, offIconColor: Colors.black, onChanged: (_isFavorite) async {
                                                if (_isFavorite) {
                                                  try {

                                                    storeCartsVal[index]["isFavorite"] = _isFavorite;
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
                                                          "favouriteList": storeCartsVal[index],
                                                        },
                                                      ),
                                                      encoding: Encoding.getByName("utf-8"),
                                                    );

                                                    print(userFuture.body);
                                                  } catch (error) {}
                                                } else {
                                                  try {

                                                    storeCartsVal[index]["isFavorite"] = !_isFavorite;
                                                    http.Response
                                                    userFuture =
                                                    await http.delete(
                                                      Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/delete-product-from-favorite-list/${customerEmailVal}"),
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

                                                  } catch (error) {}
                                                }
                                                print(
                                                    'Is Favorite $_isFavorite');
                                              }),
                                            )),
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
                                                style: GoogleFonts.lilitaOne(textStyle: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                )),),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 8, 10, 3),
                                              child: Text(
                                                "${storeCartsVal[index]["cartDescription"].toString()}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: GoogleFonts.lilitaOne(textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                )),),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                              textBaseline:
                                              TextBaseline.alphabetic,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 0, 2, 0),
                                                  child: Text(
                                                    "${storeCartsVal[index]["cartPrice"].toString()}",
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: GoogleFonts.lilitaOne(textStyle: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.white,
                                                    )),),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                  child: "${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}" ==
                                                      "null"
                                                      ? Text("")
                                                      : Text(
                                                    "${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}",
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    maxLines: 1,
                                                    style: GoogleFonts.lilitaOne(textStyle: TextStyle(
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
