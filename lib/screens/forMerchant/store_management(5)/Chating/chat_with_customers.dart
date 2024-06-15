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
import 'package:graduate_project/screens/forMerchant/store_management(5)/Chating/chatting_page.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_store_informations(5.3).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_your_store(5.1).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/edit_your_store_design(5.2).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatWithCustomers extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;

  ChatWithCustomers(
    this.token,
    this.email,
  );

  @override
  State<ChatWithCustomers> createState() => _ChatWithCustomersState();
}

class _ChatWithCustomersState extends State<ChatWithCustomers>
    with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
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
    fetchUsers();


  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();
    print(querySnapshot);
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0E1011),
          leading: IconButton(
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
          title: Container(
            height: 40,
            width: MediaQuery.of(context).size.width / 1.56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // color: Color(0xFFF4F4FB),
            ),
            child: Center(
                child: Text(
              "${getLang(context, 'chats')}",
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
                  // height: double.infinity,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchUsers(),
                    builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No Data Found'));
                      }
                      List<Map<String, dynamic>> users = snapshot.data!;
                      return ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) => InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ChattingPage(tokenVal, emailVal, users[index]["name"], users[index]["Avatar"], users[index]["email"])));
                            },
                            child: Container(
                              width: double.infinity,
                              height: 80,
                              // color: Colors.blue,
                              margin: EdgeInsets.all(20),
                              child: Row(
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
                                        radius: 25,
                                        child: ClipOval(
                                            child: Image.network(
                                              "${users[index]["Avatar"]}",
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ))),
                                  ),
                                  SizedBox(width: 15,),
                                  Text("${users[index]["name"]}",style: GoogleFonts.lilitaOne(
                                      color: Color(0xFFF4F4FB),
                                      fontWeight: FontWeight.w200,
                                      fontSize: 18),)
                                ],
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) => Divider(
                            thickness: 1,
                            color: Colors.white.withOpacity(.2),
                          ),
                          itemCount: users.length);
                    },

                  )),
            ),
          ],
        ));
  }
}
