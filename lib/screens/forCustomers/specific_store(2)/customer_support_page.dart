
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;

import '../../../components/applocal.dart';

class CustomerSupportPage extends StatefulWidget {
  String customerEmailVal;
  String customerTokenVal;
  String emailVal;
  String tokenVal;
  CustomerSupportPage(this.customerEmailVal, this.customerTokenVal, this.emailVal, this.tokenVal, {super.key});

  @override
  State<CustomerSupportPage> createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  String customerEmailVal = "";
  String customerTokenVal = "";
  String emailVal = "";
  String tokenVal = "";
  List<dynamic> cartList = [];
  double totalPrice = 0;



  List<dynamic> cartListPaymentInformations = [];
  List<dynamic> listOfAnsweredQuestions = [];

  final TextEditingController addQuestion = TextEditingController();
  Future<void> getListOfAnsweredQuestions() async {
    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-list-of-answered-questions/${emailVal}"),
      headers: {
        "Content-Type": "application/json",
      },
    );
    setState(() {
      listOfAnsweredQuestions = jsonDecode(userFuture.body);
    });
    // print(listOfQuestions[0]["question"]);
  }

  void getCustomerCartList() async {
    print("ppppppppppppppppppp");
    print(customerEmailVal);
    print("ppppppppppppppppppp");

    http.Response userFuture = await http.get(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-customer-cart-list/${customerEmailVal}"),
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
      getCartListPaymentInformations();
    } else {
      throw Exception("Error");
    }
  }
  void getCartListPaymentInformations() async {
    print("ppppppppppppppppppp");
    print(customerEmailVal);
    print("ppppppppppppppppppp");

    http.Response userFuture = await http.get(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/customer-pay-for-products/${customerEmailVal}"),
        headers: {"Authorization": "Bearer ${customerTokenVal}"});

    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");

      // return GetCartContentModel.fromJson(json.decode(userFuture.body));
      setState(() {
        cartListPaymentInformations = json.decode(userFuture.body);

      });

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
    tokenVal = widget.tokenVal;
    emailVal = widget.emailVal;
    getCustomerCartList();
    getListOfAnsweredQuestions();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF212128),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 30,),),
        title: Text("${getLang(context, 'help_support')}", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            color: Color(0xFFF2F2F2),
            height: double.infinity,

            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(children: [
                      Icon(CupertinoIcons.question_circle_fill, color: Color(0xFF212128), size: 28,),
                      SizedBox(width: 20,),
                      Text("FAQ", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Color(0xFF212128), fontSize: 20, ),)),
                    ],),
                  ),
                  Container(
                    height:  MediaQuery.of(context).size.height/1.5,
                    child: ListView.separated(itemBuilder: (context, index)=> Container(
                      margin: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      
                      child: Column(children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF212128),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerLeft,
                            child: Text(listOfAnsweredQuestions[index]["question"], style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 20, ),))),
              
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          width: MediaQuery.of(context).size.width,
                          child: Text(listOfAnsweredQuestions[index]["answer"], style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Color(0xFF212128), fontSize: 16, ),), maxLines: 3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,),),
              
                      ],),
                    ), separatorBuilder: (context, index)=>SizedBox(height: 15,), itemCount: listOfAnsweredQuestions.length),
                  )
                  ,
              
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(

              // width: double.infinity,
              height: MediaQuery.of(context).size.height/7,
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

                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        children: [
                          Container(

                            child: TextFormField(
                              controller: addQuestion,
                              decoration: InputDecoration(
                                suffixIcon: IconButton ( onPressed: () async {
                                  http.Response userFuture = await http.post(
                                    Uri.parse(
                                        "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/add-your-question/${emailVal}"),
                                    headers: {
                                      "Content-Type": "application/json",
                                    },
                                    body: jsonEncode(
                                      {
                                        "isAnswered": false,
                                        "question": addQuestion.text
                                        // Add card type
                                      },
                                    ),
                                    encoding: Encoding.getByName("utf-8"),
                                  );
                                  setState(() {
                                    addQuestion.text="";

                                  });

                                  print(userFuture.body);
                                } ,icon:Icon(Icons.send_rounded, color: Colors.white,),),
                                hintText: 'Type your question',
                                hintStyle: TextStyle(color: Colors.grey[300]),
                                contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                              ),
                              style: TextStyle(color: Colors.white),
                              // Other properties for the TextFormField go here
                            ),
                          ),

                        ],
                      )
                  ),

                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
