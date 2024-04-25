

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../toggle_button1.dart';


class CustomerDisplayProduct extends StatefulWidget {
  const CustomerDisplayProduct({super.key});

  @override
  State<CustomerDisplayProduct> createState() => _CustomerDisplayProductState();
}

class _CustomerDisplayProductState extends State<CustomerDisplayProduct> {
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
                        Navigator.pop(context);
                      }, icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,size: 25,),))),
            ),
          ],
        )
        ,centerTitle: true,
        title: Text("Product", style: GoogleFonts.lilitaOne(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)),
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
                    child: Image.network(
                      "https://t4.ftcdn.net/jpg/03/71/92/67/240_F_371926762_MdmDMtJbXt7DoaDrxFP0dp9Nq1tSFCnR.jpg",
                      fit: BoxFit.cover,
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
                            initialValue: false, onChanged: (_isFavorite) async {
                              if (_isFavorite) {
                                try {

                                } catch (error) {}
                              } else {
                                try {

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
                                child: IconButton(onPressed: (){}, icon: Icon(Icons.remove, color: Color(0xFF212128), size: 30,))),
                            SizedBox(width: 10,),
                            Text("01", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 35),)),
                            SizedBox(width: 10,),
                            Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0), // Set border radius here
                                ),
                                child: IconButton(onPressed: (){}, icon: Icon(Icons.add, color: Color(0xFF212128), size: 30,))),
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
