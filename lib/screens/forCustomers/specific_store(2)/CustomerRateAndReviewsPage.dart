

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_text/flutter_expandable_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerRateAndReviewsPage extends StatefulWidget {
  CustomerRateAndReviewsPage({super.key});

  @override
  State<CustomerRateAndReviewsPage> createState() => _CustomerRateAndReviewsPageState();
}

class _CustomerRateAndReviewsPageState extends State<CustomerRateAndReviewsPage> {

  double bottomNavigationHeight = 50;
  double otherHeight = 0;
  bool bottomNavigationIsVisible = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF212128),
        title: Text("Rating & Reviews", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 35)),),
        centerTitle: true,
        elevation: .1,
      ),
      backgroundColor: Color(0xFF22222A),
      body: Stack(
        children: [
          Divider(
            color: Colors.white,
          ),
          Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
// color: Colors.red,
            child: SingleChildScrollView(
              child: Column(
                children: [

                  Container(
                    padding: EdgeInsets.all(0),
                    height: MediaQuery.of(context).size.height/4,
// color: Colors.blue,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.star, color: Colors.yellow, size: 45,),
                            SizedBox(width: 10,),
                            Text("Rating", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 35)),)
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height/5.4,
                              width: MediaQuery.of(context).size.width/4,
// color: Colors.yellow,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("4.3", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 70),)),
                                  Text("23 ratings", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                height: MediaQuery.of(context).size.height/5.4,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/3.2,

                                          child: RatingBar.builder(
                                            textDirection: TextDirection.rtl,
                                            ignoreGestures: true,
                                            initialRating: 5,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 15,
                                            unratedColor: Colors.white,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            onRatingUpdate: (rating) {
                                              setState(() {
// rateVal = rating;
                                              });

                                              print(rating);
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 70,
                                          child: LinearProgressIndicator(
                                            value: 0.5, // Set a value between 0.0 and 1.0 for determinate progress
                                            backgroundColor: Color(0xFF212128), // Customize the track color
                                            color: Colors.white // Customize the progress color
                                          ),
                                        ),
                                        Text("22", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/3.2,

                                          child: RatingBar.builder(
                                            textDirection: TextDirection.rtl,
                                            ignoreGestures: true,
                                            initialRating: 5,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 4,
                                            itemSize: 15,
                                            unratedColor: Colors.white,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),

                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            onRatingUpdate: (rating) {
                                              setState(() {
// rateVal = rating;
                                              });

                                              print(rating);
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 70,
                                          child: LinearProgressIndicator(
                                              value: 0.5, // Set a value between 0.0 and 1.0 for determinate progress
                                              backgroundColor: Color(0xFF212128), // Customize the track color
                                              color: Colors.white // Customize the progress color
                                          ),
                                        ),
                                        Text("22", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/3.2,

                                          child: RatingBar.builder(
                                            textDirection: TextDirection.rtl,
                                            ignoreGestures: true,
                                            initialRating: 5,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 3,
                                            itemSize: 15,
                                            unratedColor: Colors.white,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            onRatingUpdate: (rating) {
                                              setState(() {
// rateVal = rating;
                                              });

                                              print(rating);
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 70,
                                          child: LinearProgressIndicator(
                                              value: 0.5, // Set a value between 0.0 and 1.0 for determinate progress
                                              backgroundColor: Color(0xFF212128), // Customize the track color
                                              color: Colors.white // Customize the progress color
                                          ),
                                        ),
                                        Text("22", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/3.2,

                                          child: RatingBar.builder(
                                            textDirection: TextDirection.rtl,
                                            ignoreGestures: true,
                                            initialRating: 5,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 2,
                                            itemSize: 15,
                                            unratedColor: Colors.white,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            onRatingUpdate: (rating) {
                                              setState(() {
// rateVal = rating;
                                              });

                                              print(rating);
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 70,
                                          child: LinearProgressIndicator(
                                              value: 0.5, // Set a value between 0.0 and 1.0 for determinate progress
                                              backgroundColor: Color(0xFF212128), // Customize the track color
                                              color: Colors.white // Customize the progress color
                                          ),
                                        ),
                                        Text("22", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/3.2,

                                          child: RatingBar.builder(
                                            textDirection: TextDirection.rtl,
                                            ignoreGestures: true,
                                            initialRating: 1,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 1,
                                            itemSize: 15,
                                            unratedColor: Colors.white,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ), onRatingUpdate: (double value) {  },

                                          ),
                                        ),
                                        Container(
                                          width: 70,
                                          child: LinearProgressIndicator(
                                              value: 0.5, // Set a value between 0.0 and 1.0 for determinate progress
                                              backgroundColor: Color(0xFF212128), // Customize the track color
                                              color: Colors.white // Customize the progress color
                                          ),
                                        ),
                                        Text("22", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                                      ],
                                    ),
                                  ],
                                ),

                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.message, color: Colors.yellow, size: 45,),
                      SizedBox(width: 12,),
                      Text("Reviews", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 35)),)
                    ],
                  ),
                  Container(
// color: Colors.blue,
                    child: Column(
                      children: [

                        SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 2, 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  width: 2,
                                  color: Colors.white
                              )
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(70),
                                    child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWxeP0FYO40fLbYn1hS08ZASqlpf6K4boW4w&s",width: 70, height: 70,),
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Abdullah Sholi", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 25),)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.date_range, color: Colors.white70,),
                                          SizedBox(width: 10,),
                                          Text("27/4/2024", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),)),
                                          SizedBox(width: 15,),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 25,
                                            width: 55,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Row(
                                              children: [
                                                RatingBar.builder(
                                                  textDirection: TextDirection.rtl,
                                                  ignoreGestures: true,
                                                  initialRating: 1,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 1,
                                                  itemSize: 15,
                                                  unratedColor: Colors.white,
                                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                  ), onRatingUpdate: (double value) {  },

                                                ),
                                                Text("4.5", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),

                                ],
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: ExpandableText(
                                  'RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR',
                                  trimType: TrimType.lines,
                                  trim: 3, // trims if text exceeds 20 characters
                                  style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white),), textAlign: TextAlign.start,
                                  readLessText: 'show less',
                                  readMoreText: 'show more',
                                ),
                              ),

                            ],
                          ),
                        ),
// SizedBox(height: 20,),

                      ],

                    ),
                  ),
                  SizedBox(height: 20,),

                  Container(
// color: Colors.blue,
                    child: Column(
                      children: [

                        SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 2, 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  width: 2,
                                  color: Colors.white
                              )
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(70),
                                    child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWxeP0FYO40fLbYn1hS08ZASqlpf6K4boW4w&s",width: 70, height: 70,),
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Abdullah Sholi", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 25),)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.date_range, color: Colors.white70,),
                                          SizedBox(width: 10,),
                                          Text("27/4/2024", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),)),
                                          SizedBox(width: 15,),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 25,
                                            width: 55,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Row(
                                              children: [
                                                RatingBar.builder(
                                                  textDirection: TextDirection.rtl,
                                                  ignoreGestures: true,
                                                  initialRating: 1,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 1,
                                                  itemSize: 15,
                                                  unratedColor: Colors.white,
                                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                  ), onRatingUpdate: (double value) {  },

                                                ),
                                                Text("4.5", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),

                                ],
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: ExpandableText(
                                  'Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A ',
                                  trimType: TrimType.lines,
                                  trim: 3, // trims if text exceeds 20 characters
                                  style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white),), textAlign: TextAlign.start,
                                  readLessText: 'show less',
                                  readMoreText: 'show more',
                                ),
                              ),

                            ],
                          ),
                        ),
// SizedBox(height: 20,),

                      ],

                    ),
                  ),
                  SizedBox(height: 20,),

                  SizedBox(height: bottomNavigationIsVisible ? 200 : 100,),
// Container(
//   height: MediaQuery.of(context).size.height/3,
//   // color: Colors.blue,
// ),
                ],
              ),
            ),

          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: bottomNavigationHeight,
              width: 500,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: (){

                        if(bottomNavigationIsVisible == false){
                          print(bottomNavigationHeight);
                          setState(() {
                            bottomNavigationHeight = 200;
                            bottomNavigationIsVisible = true;
                          });

                        } else if( bottomNavigationIsVisible == true ) {
                          print(bottomNavigationHeight);
                          setState(() {
                            bottomNavigationHeight = 50;
                            bottomNavigationIsVisible = false;
                          });

                          // bottomNavigationIsVisible = true;
                          // otherHeight = 0;
                        }


                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            spreadRadius: 10,
                            blurRadius: 5,
                            offset: Offset(0, 0), // changes x,y position of shadow
                          ),
                        ],
                        color: Colors.red,
                      ),
                      child: Text("Rate & Write a review", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 30),),textAlign: TextAlign.center,),
                    ),
                  ),

                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    color: Color(0xFF212128),
                    width: double.infinity,
                    height: bottomNavigationIsVisible ? 50 : otherHeight,
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 35,
                      unratedColor: Colors.white,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
            // rateVal = rating;
                        });

                        print(rating);
                      },
                    ),
                  ),
                  Container(
                    height: bottomNavigationIsVisible ? 100 : otherHeight,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/1.14,
                          child: TextField(
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                          
                                ),
                                color: Color(0xFF212128),
                              ),
                          
                              child: IconButton(onPressed: (){}, icon: Icon(Icons.send_rounded, color: Colors.white, ))),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),

    );
  }
}