

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_text/flutter_expandable_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/screens/forCustomers/specific_store(2)/customer_display_product.dart';
import "package:http/http.dart" as http;

class CustomerRateAndReviewsPage extends StatefulWidget {
  double productAverageRate;
  int numberOfRates;
  String emailVal;
  String tokenVal;
  String customerEmailVal;
  String customerTokenVal;
  int index1;
  Map<String, dynamic> storeCartsVal;
  CustomerRateAndReviewsPage(  this.storeCartsVal,this.index1 ,this.emailVal, this.tokenVal, this.customerEmailVal, this.customerTokenVal ,this.productAverageRate, this.numberOfRates,  {super.key});

  @override
  State<CustomerRateAndReviewsPage> createState() => _CustomerRateAndReviewsPageState();
}

class _CustomerRateAndReviewsPageState extends State<CustomerRateAndReviewsPage> {

  Map<String, dynamic> storeCartsVal = {};
  String emailVal = "";
  String tokenVal = "";
  String customerEmailVal = "";
  String customerTokenVal = "";
  int index1 = 0;

  double bottomNavigationHeight = 50;
  double otherHeight = 0;
  bool bottomNavigationIsVisible = false;

  double productAverageRate=0;
  int numberOfRates=0;
  double rateVal = 3;
  TextEditingController addComment = TextEditingController();

  String customerName = "";

  int number5Stars = 0;
  int number4Stars = 0;
  int number3Stars = 0;
  int number2Stars = 0;
  int number1Stars = 0;

  double number5StarsRatio = 0;
  double number4StarsRatio = 0;
  double number3StarsRatio = 0;
  double number2StarsRatio = 0;
  double number1StarsRatio = 0;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailVal= widget.emailVal;
    customerEmailVal = widget.customerEmailVal;
    tokenVal = widget.tokenVal;
    customerTokenVal = widget.customerTokenVal;
    productAverageRate = widget.productAverageRate;
    numberOfRates = widget.numberOfRates;
    index1 = widget.index1;
    storeCartsVal = widget.storeCartsVal;

    getCustomerName();
    getProductRateList();



  }

  int index = 0;
  Future<void> getProductNameViaIndex() async {

    http.Response userFuture = await http.post(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/get-product-name-via-index/${emailVal}"),
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
  Future<void> getAverageProductRate() async {

    await getProductNameViaIndex();

    http.Response userFuture = await http.post(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/get-average-product-rate/${emailVal}"),
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


  List<dynamic> productRateList =[];

  Future<void> getProductRateList() async {
    http.Response userFuture = await http.post(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/get-product-rate-list/${emailVal}"
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "index": index1,
          "customerEmail": customerEmailVal,
        },
      ),
      encoding: Encoding.getByName("utf-8"),
    );
    setState(() {
      productRateList = jsonDecode(userFuture.body)["productRate"];
    });

    print(productRateList);
    await getNumberOfRatesViaNumberOfStarsFor1();
    await getNumberOfRatesViaNumberOfStarsFor2();
    await getNumberOfRatesViaNumberOfStarsFor3();
    await getNumberOfRatesViaNumberOfStarsFor4();
    await getNumberOfRatesViaNumberOfStarsFor5();

  }


  Future<void> addYourRate() async {
    DateTime now = DateTime.now();

    // Extract the date components
    int year = now.year;
    int month = now.month;
    int day = now.day;
    http.Response userFuture = await http.post(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/add-your-rate/${emailVal}"
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
            "index": index1,
            "productRateValue": rateVal,
            "date": "$day/$month/$year",
            "customerName": customerName,
            "customerEmail": customerEmailVal,
            "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEQnE44KMbJDrlWFeHZ_Cud7yp12vSTlr-4A&usqp=CAU",
            "comment": addComment.text
        },
      ),
      encoding: Encoding.getByName("utf-8"),
    );

    addComment.text="";


  }

  Future<void> getCustomerName() async {
    print(customerTokenVal);
    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/profile/${customerEmailVal}"
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${customerTokenVal}"
      },

    );
    var temp = jsonDecode(userFuture.body)["username"];


    setState(() {
      customerName = temp;
    });
    print(customerName);
  }

  Future<void> getNumberOfRatesViaNumberOfStarsFor1() async {
    http.Response userFuture = await http.post(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/get-number-of-rates-via-number-of-stars/${emailVal}"
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "index": index1,
          "customerEmail": customerEmailVal,
          "numberOfStars":1
        },
      ),
      encoding: Encoding.getByName("utf-8"),
    );

    print("PPPPPPPPPPPPPPPPPPPPPPPP");
    print(jsonDecode(userFuture.body)["result"]);
    print("PPPPPPPPPPPPPPPPPPPPPPPP");

    setState(() {
      number1Stars = jsonDecode(userFuture.body)["result"];
    });
  }
  Future<void> getNumberOfRatesViaNumberOfStarsFor2() async {
    http.Response userFuture = await http.post(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/get-number-of-rates-via-number-of-stars/${emailVal}"
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "index": index1,
          "customerEmail": customerEmailVal,
          "numberOfStars":2
        },
      ),
      encoding: Encoding.getByName("utf-8"),
    );
    setState(() {
      number2Stars = jsonDecode(userFuture.body)["result"];
    });
  }
  Future<void> getNumberOfRatesViaNumberOfStarsFor3() async {
    http.Response userFuture = await http.post(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/get-number-of-rates-via-number-of-stars/${emailVal}"
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "index": index1,
          "customerEmail": customerEmailVal,
          "numberOfStars":3
        },
      ),
      encoding: Encoding.getByName("utf-8"),
    );
    setState(() {
      number3Stars = jsonDecode(userFuture.body)["result"];
    });
  }
  Future<void> getNumberOfRatesViaNumberOfStarsFor4() async {
    http.Response userFuture = await http.post(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/get-number-of-rates-via-number-of-stars/${emailVal}"
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "index": index1,
          "customerEmail": customerEmailVal,
          "numberOfStars":4
        },
      ),
      encoding: Encoding.getByName("utf-8"),
    );
    setState(() {
      number4Stars = jsonDecode(userFuture.body)["result"];
    });
  }
  Future<void> getNumberOfRatesViaNumberOfStarsFor5() async {
    http.Response userFuture = await http.post(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/get-number-of-rates-via-number-of-stars/${emailVal}"
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "index": index1,
          "customerEmail": customerEmailVal,
          "numberOfStars":5
        },
      ),
      encoding: Encoding.getByName("utf-8"),
    );
    setState(() {
      number5Stars = jsonDecode(userFuture.body)["result"];
      number1StarsRatio = number1Stars/numberOfRates;
      number2StarsRatio = number2Stars/numberOfRates;
      number3StarsRatio = number3Stars/numberOfRates;
      number4StarsRatio = number4Stars/numberOfRates;
      number5StarsRatio = number5Stars/numberOfRates;

    });

    print(number1StarsRatio);
    print(number2StarsRatio);
    print(number3StarsRatio);
    print(number4StarsRatio);
    print(number5StarsRatio);


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(

      onWillPop: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerDisplayProduct(storeCartsVal, customerTokenVal, customerEmailVal, tokenVal, emailVal)));
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerDisplayProduct(storeCartsVal, customerTokenVal, customerEmailVal, tokenVal, emailVal)));
          }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
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
                                width: MediaQuery.of(context).size.width/3.8,
      // color: Colors.yellow,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${productAverageRate}", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 70),)),
                                    Text("${numberOfRates} Ratings", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),)),
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
                                              value: number5StarsRatio, // Set a value between 0.0 and 1.0 for determinate progress
                                              backgroundColor: Color(0xFF212128), // Customize the track color
                                              color: Colors.white // Customize the progress color
                                            ),
                                          ),
                                          SizedBox(width: 3,),
                                          Text("${number5Stars}", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
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
                                                value: number4StarsRatio, // Set a value between 0.0 and 1.0 for determinate progress
                                                backgroundColor: Color(0xFF212128), // Customize the track color
                                                color: Colors.white // Customize the progress color
                                            ),
                                          ),
                                          SizedBox(width: 3,),
                                          Text("${number4Stars}", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
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
                                                value: number3StarsRatio, // Set a value between 0.0 and 1.0 for determinate progress
                                                backgroundColor: Color(0xFF212128), // Customize the track color
                                                color: Colors.white // Customize the progress color
                                            ),
                                          ),
                                          SizedBox(width: 3,),
                                          Text("${number3Stars}", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
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
                                                value: number2StarsRatio, // Set a value between 0.0 and 1.0 for determinate progress
                                                backgroundColor: Color(0xFF212128), // Customize the track color
                                                color: Colors.white // Customize the progress color
                                            ),
                                          ),
                                          SizedBox(width: 3,),
                                          Text("${number2Stars}", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
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
                                                value: number1StarsRatio, // Set a value between 0.0 and 1.0 for determinate progress
                                                backgroundColor: Color(0xFF212128), // Customize the track color
                                                color: Colors.white // Customize the progress color
                                            ),
                                          ),
                                          SizedBox(width: 3,),
                                          Text("${number1Stars}", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
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
                      height: MediaQuery.of(context).size.height/2.2,
                      child: ListView.separated(itemBuilder: (context, index)=>Container(
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
                                          Text(productRateList[index]["customerName"], style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 25),)),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(Icons.date_range, color: Colors.white70,),
                                              SizedBox(width: 10,),
                                              Text(productRateList[index]["date"], style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),)),
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
                                                    Text('${double.parse(productRateList[index]["productRateValue"].toStringAsFixed(1))}', style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
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
                                  Container(

                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                      child: ExpandableText(

                                        '${productRateList[index]["comment"]}',
                                        trimType: TrimType.lines,
                                        trim: 3, // trims if text exceeds 20 characters
                                        style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white,), ), textAlign: TextAlign.start,
                                        readLessText: 'show less',
                                        readMoreText: 'show more',

                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                      // SizedBox(height: 20,),

                          ],

                        ),
                      ), separatorBuilder: (context, index)=> SizedBox(height: 20,), itemCount: productRateList.length),
                    ),



      //                   Container(
      // // color: Colors.blue,
      //                     child: Column(
      //                       children: [
      //
      //                         SizedBox(height: 20,),
      //                         Container(
      //                           padding: EdgeInsets.fromLTRB(5, 5, 2, 10),
      //                           decoration: BoxDecoration(
      //                               borderRadius: BorderRadius.circular(20),
      //                               border: Border.all(
      //                                   width: 2,
      //                                   color: Colors.white
      //                               )
      //                           ),
      //                           child: Column(
      //                             children: [
      //                               Row(
      //                                 children: [
      //                                   ClipRRect(
      //                                     borderRadius: BorderRadius.circular(70),
      //                                     child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWxeP0FYO40fLbYn1hS08ZASqlpf6K4boW4w&s",width: 70, height: 70,),
      //                                   ),
      //                                   SizedBox(width: 10,),
      //                                   Column(
      //                                     crossAxisAlignment: CrossAxisAlignment.start,
      //                                     children: [
      //                                       Text("Abdullah Sholi", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 25),)),
      //                                       Row(
      //                                         mainAxisAlignment: MainAxisAlignment.start,
      //                                         children: [
      //                                           Icon(Icons.date_range, color: Colors.white70,),
      //                                           SizedBox(width: 10,),
      //                                           Text("27/4/2024", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),)),
      //                                           SizedBox(width: 15,),
      //                                           Container(
      //                                             alignment: Alignment.center,
      //                                             height: 25,
      //                                             width: 55,
      //                                             decoration: BoxDecoration(
      //                                                 color: Colors.blue,
      //                                                 borderRadius: BorderRadius.circular(10)
      //                                             ),
      //                                             child: Row(
      //                                               children: [
      //                                                 RatingBar.builder(
      //                                                   textDirection: TextDirection.rtl,
      //                                                   ignoreGestures: true,
      //                                                   initialRating: 1,
      //                                                   minRating: 1,
      //                                                   direction: Axis.horizontal,
      //                                                   allowHalfRating: true,
      //                                                   itemCount: 1,
      //                                                   itemSize: 15,
      //                                                   unratedColor: Colors.white,
      //                                                   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      //                                                   itemBuilder: (context, _) => Icon(
      //                                                     Icons.star,
      //                                                     color: Colors.yellow,
      //                                                   ), onRatingUpdate: (double value) {  },
      //
      //                                                 ),
      //                                                 Text("4.5", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15),))
      //                                               ],
      //                                             ),
      //                                           )
      //                                         ],
      //                                       )
      //                                     ],
      //                                   ),
      //
      //                                 ],
      //                               ),
      //                               SizedBox(height: 10,),
      //                               Padding(
      //                                 padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      //                                 child: ExpandableText(
      //                                   'Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A Addidas-A ',
      //                                   trimType: TrimType.lines,
      //                                   trim: 3, // trims if text exceeds 20 characters
      //                                   style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white),), textAlign: TextAlign.start,
      //                                   readLessText: 'show less',
      //                                   readMoreText: 'show more',
      //                                 ),
      //                               ),
      //
      //                             ],
      //                           ),
      //                         ),
      // // SizedBox(height: 20,),
      //
      //                       ],
      //
      //                     ),
      //                   ),
      //                   SizedBox(height: 20,),

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
                            rateVal = rating;
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
                              controller: addComment,
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

                                child: IconButton(onPressed: () async {
                                      await addYourRate();
                                      setState(() {
                                        bottomNavigationHeight = 50;
                                        bottomNavigationIsVisible = false;
                                      });
                                      await getProductRateList();
                                      await getAverageProductRate();


                                }, icon: Icon(Icons.send_rounded, color: Colors.white, ))),
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

      ),
    );
  }
}
