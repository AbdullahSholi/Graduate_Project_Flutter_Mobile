import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:fl_chart/fl_chart.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';

class ChattingPage extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;
  final String name;
  final String Avatar;
  final String receiverEmail;

  ChattingPage(
      this.token,
      this.email, this.name, this.Avatar, this.receiverEmail
      );

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage>
    with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
  String nameVal = "";
  String AvatarVal = "";
  String receiverEmail = "";
  List<dynamic> listOfQuestions = [];
  List<dynamic> listOfAnsweredQuestions = [];
  bool isAnswered = false;
  int touchedIndex = -1;

  final List<Color> gradientColors = [
    const Color(0xFF18FF8B),
    const Color(0xFFA618F3),
    const Color(0xFF10B8F9),
  ];

  TextEditingController subjectTextEditingController = TextEditingController();
  TextEditingController contentTextEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
    nameVal = widget.name;
    AvatarVal = widget.Avatar;
    receiverEmail = widget.receiverEmail;
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();
    print(querySnapshot);
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
  // final String chatId;
  final _controller = TextEditingController();

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('chats')
        .doc("chatId")
        .collection('messages')
        .add({
      'sender': '$emailVal', // Change as needed
      'text': _controller.text,
      'timestamp': FieldValue.serverTimestamp(),
      'receiver': '$receiverEmail'
    });

    setState(() {
      _controller.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0E1011),
          titleSpacing: 0,
          leading: Container(
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFFF4F4FB),
              ), // Replace with your desired icon
              onPressed: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>StoreManagement(tokenVal, emailVal,imageUrlVal,storeNameVal,storeCategoryVal, storeDescriptionVal,[],[], false, false, false)));
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white,
                      width: 3), // Customize the border color
                ),
                child: CircleAvatar(
                    radius: 18,
                    child: ClipOval(
                        child: Image.network(
                          "${AvatarVal}",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ))),
              ),
              SizedBox(width: 13,),
              Container(
                height: 40,
                // width: MediaQuery.of(context).size.width / 1.56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: Color(0xFFF4F4FB),
                ),
                child: Center(
                    child: Text(
                      "${nameVal}",
                      style: GoogleFonts.lilitaOne(
                          color: Color(0xFFF4F4FB),
                          fontWeight: FontWeight.bold,
                          fontSize: 21),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    )
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.white,
            ),
            Expanded(
              child: Container(
                  color: Color(0xFF212128),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric( vertical: 15 ,horizontal: 20),
                  // height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        // color: Colors.blue,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chats')
                              .doc("chatId")
                              .collection('messages')
                              .orderBy('timestamp')
                              .snapshots(),
                          builder: (context, snapshot) {

                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            List<Widget> temp =[];
                            var messages = snapshot.data!.docs;
                            for(int i = 0; i<messages.length; i++) {
                              if ((messages[i]["sender"] == emailVal &&
                                  messages[i]["receiver"] == receiverEmail) || (messages[i]["sender"] == receiverEmail &&
                                  messages[i]["receiver"] == emailVal)) {

                                if (messages[i]["sender"] == emailVal) {
                                  temp.add(Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)
                                        ),
                                        color: Color(0xFF3C9542),

                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 10
                                      ),
                                      child: Text("${messages[i]['text']}",
                                        style: GoogleFonts.lilitaOne(
                                            color: Color(0xFFF4F4FB),
                                            fontSize: 16),),
                                    ),
                                  ));
                                }
                                else if (messages[i]["sender"] == receiverEmail) {
                                  temp.add(Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)
                                        ),
                                        color: Color(0xFF3A3A3A),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 10
                                      ),
                                      child: Text("${messages[i]['text']}",
                                        style: GoogleFonts.lilitaOne(
                                            color: Color(0xFFF4F4FB),
                                            fontSize: 16),),
                                    ),
                                  ));
                                }
                                temp.add(SizedBox(height: 10,));
                              }
                            }

                            return ListView(children: temp, physics: BouncingScrollPhysics(),);
                          },
                        ),
                      ),
                    ),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.only(
                  //         bottomRight: Radius.circular(10),
                  //         topLeft: Radius.circular(10),
                  //         topRight: Radius.circular(10)
                  //       ),
                  //       color: Color(0xFF3A3A3A),
                  //     ),
                  //     padding: EdgeInsets.symmetric(
                  //       vertical: 5,
                  //       horizontal: 10
                  //     ),
                  //     child: Text("Hello World", style: GoogleFonts.lilitaOne(
                  //         color: Color(0xFFF4F4FB),
                  //         fontSize: 16),),
                  //   ),
                  // ),
                  //   Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.only(
                  //             bottomLeft: Radius.circular(10),
                  //             topLeft: Radius.circular(10),
                  //             topRight: Radius.circular(10)
                  //         ),
                  //         color: Color(0xFF3C9542),
                  //       ),
                  //       padding: EdgeInsets.symmetric(
                  //           vertical: 5,
                  //           horizontal: 10
                  //       ),
                  //       child: Text("Hello World", style: GoogleFonts.lilitaOne(
                  //           color: Color(0xFFF4F4FB),
                  //           fontSize: 16),  ),
                  //     ),
                  //   ),
                  //   Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!.withOpacity(.2),
                          width: 1
                        ),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "${getLang(context, 'type_in_chat')}",
                              hintStyle: GoogleFonts.lilitaOne(
                                color: Color(0xFFF4F4FB),
                              fontSize: 16),
                            ),
                            style: TextStyle(color: Color(0xFFF4F4FB)),
                          ),
                        )),
                        Container(
                          height: 50,
                            color: Colors.blue,
                          child: IconButton(onPressed: _sendMessage, icon: Icon(
                            Icons.send_rounded, size: 20, color: Colors.white,
                          )),
                        )
                      ],),
                    )

                ],),
                  ),
            ),
          ],
        ));
  }
}

class Message {
  final String sender;
  final String receiver;
  final String text;
  final Timestamp timestamp;



  Message({required this.sender, required this.text, required this.timestamp, required this.receiver});

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      sender: doc['sender'],
      receiver: doc['receiver'],
      text: doc['text'],
      timestamp: doc['timestamp'],
    );
  }
}