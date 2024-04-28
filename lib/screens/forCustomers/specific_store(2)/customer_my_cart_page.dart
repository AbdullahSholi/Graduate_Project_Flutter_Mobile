
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;

class CustomerMyCartPage extends StatefulWidget {
  String customerEmailVal;
  String customerTokenVal;
  CustomerMyCartPage(this.customerEmailVal, this.customerTokenVal, {super.key});

  @override
  State<CustomerMyCartPage> createState() => _CustomerMyCartPageState();
}

class _CustomerMyCartPageState extends State<CustomerMyCartPage> {
  String customerEmailVal = "";
  String customerTokenVal = "";
  List<dynamic> cartList = [];
  double totalPrice = 0;
  void getCustomerCartList() async {
    print("ppppppppppppppppppp");
    print(customerEmailVal);
    print("ppppppppppppppppppp");

    http.Response userFuture = await http.get(
        Uri.parse(
            "http://10.0.2.2:3000/matjarcom/api/v1/get-customer-cart-list/${customerEmailVal}"),
        headers: {"Authorization": "Bearer ${customerTokenVal}"});

    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");

      // return GetCartContentModel.fromJson(json.decode(userFuture.body));
      setState(() {
        cartList = json.decode(userFuture.body);

      });

      for(int i = 0; i < cartList.length; i++){
        setState(() {
          totalPrice += cartList[i]["cartPrice"] * cartList[i]["quantities"];
        });

      }
    } else {
      throw Exception("Error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerTokenVal = widget.customerTokenVal;
    customerEmailVal = widget.customerEmailVal;
    getCustomerCartList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF212128),
        leading: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 30,),
        title: Text("Shopping Cart", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height/5,),
                itemCount: cartList.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/5,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF212128),
                    ),
                    child: Row(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height/5,
                            width: MediaQuery.of(context).size.width/3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                                child: Image.network("${cartList[index]["cartPrimaryImage"]}", fit: BoxFit.cover,))
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width/2.22,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text("${cartList[index]["cartName"]}", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            Text("${cartList[index]["cartCategory"]}",  style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                              SizedBox(height: 5,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text("\$${cartList[index]["cartPrice"]}", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  SizedBox(width: 20,),
                                  Text("\$400", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text("Price: ", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  SizedBox(width: 10,),
                                  Text("${cartList[index]["cartPrice"]} * ${cartList[index]["quantities"]} = ${ cartList[index]["cartPrice"] * cartList[index]["quantities"]} ", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15,  ),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ],
                              ),



                            ],),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // width: 60,
                                // height: 60,

                                // color: Colors.red,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: IconButton( onPressed: () async {
                                    try {
                                      print(cartList[index]["cartName"]);
                                      print(cartList[index]["merchant"]);
                                      http.Response
                                      userFuture =
                                          await http.delete(
                                        Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/delete-product-from-cart-list-from-different-stores/${customerEmailVal}"),
                                        headers: {
                                          "Content-Type": "application/json",
                                          "Authorization": "Bearer ${customerTokenVal}"
                                        },

                                        body: jsonEncode(
                                          {
                                            "cartName": cartList[index]["cartName"],
                                            "merchant": cartList[index]["merchant"]
                                          },
                                        ),
                                        encoding: Encoding.getByName("utf-8"),
                                      );

                                      print(userFuture.body);
                                      setState(() {
                                        totalPrice = 0;
                                      });
                                      getCustomerCartList();



                                    } catch (error) {}
                                  } ,icon: Icon(Icons.remove_circle_outline, color: Colors.white, size: 30,)),)

                            ],
                          ),
                        ),

                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  // if(index == 4){
                  //   return Padding( padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height/3,),);
                  // }
                  // else {
                    return SizedBox(height:  0);
                  // }
                },
              ),
            // height: MediaQuery.of(context).size.height/1.3,

          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(

              // width: double.infinity,
              height: MediaQuery.of(context).size.height/5,
              decoration: BoxDecoration(
                color: Color(0xFF212128),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )
              ),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Column(
                      children: [
                        Text("Total Price ", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                        Text("${totalPrice}", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,),), maxLines: 1, overflow: TextOverflow.ellipsis,)
                      ],
                    )
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      child: ElevatedButton(onPressed: (){

                      }, child: Text("Purchase!", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Color(0xFF212128), fontSize: 25, fontWeight: FontWeight.bold,),), maxLines: 1, overflow: TextOverflow.ellipsis, ), style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ), // Border radius of the button
                          ),
                        ),
                      ),),
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
