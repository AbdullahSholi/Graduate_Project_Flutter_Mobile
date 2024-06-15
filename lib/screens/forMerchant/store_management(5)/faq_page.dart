import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_store_informations(5.3).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_your_store(5.1).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/edit_your_store_design(5.2).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

import '../../../models/merchant/merchant_connect_store_to_social_media.dart';
import '../../../models/merchant/merchant_profile.dart';
import '../merchant_home_page(3)/merchant_home_page.dart';
import '../personal_information(4)/personal_information(4).dart';
import 'edit_your_store_informations(5.4).dart';

class MerchantFaqPage extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;

  MerchantFaqPage(
    this.token,
    this.email,
  );

  @override
  State<MerchantFaqPage> createState() => _MerchantFaqPageState();
}

class _MerchantFaqPageState extends State<MerchantFaqPage>
    with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
  late Future<Store> userData;
  final TextEditingController addAnswer = TextEditingController();
  List<dynamic> listOfQuestions = [];
  List<dynamic> listOfAnsweredQuestions = [];
  bool isAnswered = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
    userData = getUserByName();
    getListOfQuestions();
  }

  Future<void> getListOfQuestions() async {
    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-list-of-questions/${emailVal}"),
      headers: {
        "Content-Type": "application/json",
      },
    );
    setState(() {
      listOfQuestions = jsonDecode(userFuture.body);
    });
    // print(listOfQuestions[0]["question"]);
  }

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

  Future<Store> getUserByName() async {
    print("$emailVal tttttttttt");
    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}"),
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );

    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");
      print(Store.fromJson(json.decode(userFuture.body)));

      return Store.fromJson(json.decode(userFuture.body));
    } else {
      print("error");
      throw Exception("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF212128),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
          ),
          title: Text("${getLang(context, 'faq')}", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 2,
            color: Color(0xFFF4F4FB),
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF212128),
                  ),

                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                      // physics: NeverScrollableScrollPhysics(),
                      child: Column(
                    children: [

                      SizedBox(height: 20,),

                      Container(
                        height: MediaQuery.of(context).size.height/1.4,
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: ListView.separated(
                            itemCount: listOfQuestions.length,
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text(
                                                "Type your answer...",
                                                style: GoogleFonts.lilitaOne(
                                                    textStyle: TextStyle(
                                                        color: Color(
                                                            0xFF212128))),
                                              ),
                                              content: Container(
                                                color: Color(0xFFF4F4FB),
                                                child: TextFormField(
                                                  controller: addAnswer,
                                                  decoration:
                                                      InputDecoration(
                                                    suffixIcon: IconButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          listOfQuestions[index]["isAnswered"] = true;
                                                        });

                                                        http.Response userFuture = await http.post(
                                                          Uri.parse(
                                                              "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/add-your-answer/${emailVal}"),
                                                          headers: {
                                                            "Content-Type": "application/json",
                                                          },
                                                          body: jsonEncode(
                                                            {
                                                              "index": index,
                                                              "answer": addAnswer.text,
                                                              "isAnswered": listOfQuestions[index]["isAnswered"],
                                                              // Add card type
                                                            },
                                                          ),
                                                          encoding: Encoding.getByName("utf-8"),
                                                        );
                                                        setState(() {
                                                          addAnswer.text = "";

                                                        });


                                                        print(userFuture.body);
                                                      },
                                                      icon: Icon(
                                                        Icons.send_rounded,
                                                        color: Color(
                                                            0xFF212128),
                                                      ),
                                                    ),
                                                    hintText: '',
                                                    hintStyle: TextStyle(
                                                        color: Colors
                                                            .grey[300]),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 20.0,
                                                            horizontal:
                                                                10.0),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.0)),
                                                  ),
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xFF212128)),
                                                  // Other properties for the TextFormField go here
                                                ),
                                              ),
                                            ));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        color: Color(0xFFF4F4FB),
                                      ),
                                      child: ListTile(
                                        leading: Icon(
                                          CupertinoIcons
                                              .question_square_fill,
                                          color: listOfQuestions[index]["isAnswered"] ? Colors.green : Color(0xFF212128),
                                        ),
                                        title: Text(
                                          listOfQuestions[index]["question"],
                                          style: GoogleFonts.lilitaOne(
                                              textStyle: TextStyle(
                                                  color:
                                                      Color(0xFF212128))),
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xFF212128),
                                        ),
                                      )),
                                ), separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 20,); },),
                      )
                    ],
                  ))))
        ]));
  }
}
