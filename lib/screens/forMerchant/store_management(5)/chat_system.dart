import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/Chating/chat_with_customers.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_store_informations(5.3).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_your_store(5.1).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/edit_your_store_design(5.2).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;

import '../../../models/merchant/merchant_connect_store_to_social_media.dart';
import '../../../models/merchant/merchant_profile.dart';
import '../merchant_home_page(3)/merchant_home_page.dart';
import '../personal_information(4)/personal_information(4).dart';
import 'edit_your_store_informations(5.4).dart';

class ChatSystem extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;

  ChatSystem(
      this.token,
      this.email,
      );

  @override
  State<ChatSystem> createState() => _ChatSystemState();
}

class _ChatSystemState extends State<ChatSystem>
    with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
  late Future<Store> userData;
  final TextEditingController addAnswer = TextEditingController();
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
    userData = getUserByName();

    // Clear Firebase (users) collection
    clearCollection("users");

    getListOfQuestions();
    // get customers list from MongoDB


    // Insert Customers list into firebase


  }
  List<dynamic> customersList1 = [];
  List<dynamic> customersList = [];
  Future<void> getCustomersList() async {

    http.Response userFuture1 =
    await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-all-customers"),
      headers: {
        "Content-Type": "application/json",
      },
    );
    List<dynamic> temp =  jsonDecode(userFuture1.body);
    for (int i = 0; i < temp.length; i++) {
      Map<String, dynamic> userMap = {
        'userId': i,
        'name': temp[i]["username"],
        'email': temp[i]["email"],
        'phone': temp[i]["phone"],
        'Avatar': temp[i]["Avatar"]
      };

      // Convert the map to a JSON string and add to the list
      String jsonString = jsonEncode(userMap);

      setState(() {
        customersList.add(jsonString);
      });
    }



    print("**");
    print(customersList);
    print("**");
    await insertCustomersToFirebaseCollection();

  }
  Future<void> insertCustomersToFirebaseCollection() async {
    print("--");
    print(customersList);
    print("--");

    List<dynamic> temp = jsonDecode(customersList.toString());
    // print(temp[0]["userId"]);


    for (int i = 0; i < temp.length; i++) {
      addUser("${temp[i]["userId"]}" , temp[i]["email"], temp[i]["name"], temp[i]["phone"], temp[i]["Avatar"]);
    }


  }

  Future<void> clearCollection(String collectionPath) async {
    CollectionReference collection = _firestore.collection(collectionPath);
    QuerySnapshot querySnapshot = await collection.get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    await getCustomersList();
  }




  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addUser(String userId, String email, String name, String phone, String Avatar) async {
    await _firestore.collection('users').doc(userId).set({
      'email': email,
      'name': name,
      'phone': phone,
      'Avatar': Avatar,
    });
  }

  List<dynamic> devicesId = [];
  Future<void> getDevicesIdList() async {

    http.Response userFuture1 =
    await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-device-id-list/$emailVal"),
      headers: {
        "Content-Type": "application/json",
      },
    );
    setState(() {
      devicesId = jsonDecode(userFuture1.body);
    });
  }

  Future<void> notifyYourCustomers() async {
    await getDevicesIdList();

    print(devicesId);

    http.Response userFuture =
    await http.post(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/send-custom-notification-to-device"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "messageSubject": subjectTextEditingController.text,
          "messageContent": contentTextEditingController.text,
          "devices": devicesId
        },
      ),
      encoding:
      Encoding.getByName("utf-8"),
    );
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
  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(0xFF0087F4),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFDFF),
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xFFFEA42C),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFDFF),
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Color(0xFF8047F6),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFDFF),
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Color(0xFF00D27C),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFDFF),
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:Color(0xFF0E1011),
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
                  "Chat System",
                  style: GoogleFonts.lilitaOne(
                      color: Color(0xFFF4F4FB),
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                )),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/1.1,
                        height: 60,
                        child: TextButton(

                          style: TextButton.styleFrom(
                            foregroundColor: Color(0xFFF4F4FB), backgroundColor: Color(0xFF0E1011),  // Text color
                            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),  // Border radius
                            ),
                          ),
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatWithCustomers(tokenVal, emailVal)));
                          },
                          child: Text('Chat with Customers',style: GoogleFonts.lilitaOne(
                              color: Color(0xFFF4F4FB),
                              fontWeight: FontWeight.bold,
                              fontSize: 21),),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width/1.1,
                        height: 60,
                        child: TextButton(

                          style: TextButton.styleFrom(
                            foregroundColor: Color(0xFFF4F4FB), backgroundColor: Color(0xFF0E1011),  // Text color
                            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),  // Border radius
                            ),
                          ),
                          onPressed: () async {


                          },
                          child: Text('Chat with Admin',style: GoogleFonts.lilitaOne(
                              color: Color(0xFFF4F4FB),
                              fontWeight: FontWeight.bold,
                              fontSize: 21),),
                        ),
                      ),


                      const SizedBox(
                        width: 28,
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }

}
