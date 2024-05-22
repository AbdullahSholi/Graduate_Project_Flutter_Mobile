import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
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

class NotifyYourCustomers extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;

  NotifyYourCustomers(
      this.token,
      this.email,
      );

  @override
  State<NotifyYourCustomers> createState() => _NotifyYourCustomersState();
}

class _NotifyYourCustomersState extends State<NotifyYourCustomers>
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
    getListOfQuestions();
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
    print(listOfQuestions[0]["question"]);
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
          backgroundColor:Color(0xFF212128),
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
                  "Notify Your Customers",
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
                        child: TextFormField(
                          cursorColor: Colors.white,
                          style: GoogleFonts.lilitaOne(
                              color: Color(0xFFF4F4FB),
                              fontSize: 16),
                          controller: subjectTextEditingController,
                          //Making keyboard just for Email
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Notification subject is required';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Subject',
                              labelStyle: GoogleFonts.lilitaOne(
                                  color: Color(0xFFF4F4FB),
                                  fontSize: 16),
                              prefixIcon: Icon(
                                Icons.subject,color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, )
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width/1.1,
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          maxLines: 7,
                          cursorColor: Colors.white,
                          style: GoogleFonts.lilitaOne(
                              color: Color(0xFFF4F4FB),
                              fontSize: 16),
                          controller: contentTextEditingController,
                          //Making keyboard just for Email
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Notification subject is required';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Content',
                              labelStyle: GoogleFonts.lilitaOne(
                                  color: Color(0xFFF4F4FB),
                                  fontSize: 16),

                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, )
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 80,),
                      Container(
                  width: MediaQuery.of(context).size.width/1.1,
                  height: 50,
                  child: TextButton(

                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFFF4F4FB), backgroundColor: Color(0xFF0E1011),  // Text color
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),  // Border radius
                      ),
                    ),
                    onPressed: () async {
                      await notifyYourCustomers();
                      setState(() {
                        subjectTextEditingController.text = "";
                        contentTextEditingController.text = "";
                      });

                    },
                    child: Text('Notify',style: GoogleFonts.lilitaOne(
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
