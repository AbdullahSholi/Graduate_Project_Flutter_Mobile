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

import '../../../models/merchant/merchant_connect_store_to_social_media.dart';
import '../../../models/merchant/merchant_profile.dart';
import '../merchant_home_page(3)/merchant_home_page.dart';
import '../personal_information(4)/personal_information(4).dart';
import 'edit_your_store_informations(5.4).dart';

class StoreStatistics extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;

  StoreStatistics(
    this.token,
    this.email,
  );

  @override
  State<StoreStatistics> createState() => _StoreStatisticsState();
}

class _StoreStatisticsState extends State<StoreStatistics>
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
        title: Text(
          "${getLang(context, 'store_statistics')}",
          style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,

      ),
        body: Container(

            color: Color(0xFF212128),
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Column(
              children: [

                Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width / 1,
                  child: LineChart(
                    LineChartData(
                        minX: 0,
                        maxX: 11,
                        minY: 0,
                        maxY: 11,
                        titlesData: FlTitlesData(
                            rightTitles: AxisTitles(

                                sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 22,
                                    getTitlesWidget: rightTitleWidgets
                                  // margin: 8,
                                )),
                            topTitles: AxisTitles(

                                sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 22,
                                    getTitlesWidget: topTitleWidgets
                                  // margin: 8,
                                )),
                            bottomTitles: AxisTitles(

                                sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 22,
                                    getTitlesWidget: bottomTitleWidgets
                                  // margin: 8,
                                )),
                            show: true,
                            leftTitles: AxisTitles(

                                sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 22,
                                    getTitlesWidget: leftTitleWidgets
                                  // margin: 8,
                                ))),

                        gridData: FlGridData(
                          show: true,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                                color: Color(0xff37434d),
                                strokeWidth: 1);
                          },
                          drawHorizontalLine: true,
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                                color: Color(0xff37434d),
                                strokeWidth: 1);
                          },
                          drawVerticalLine: true,
                        ),
                        borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                                color: Color(0xFF37434d), width: 1)),
                        lineBarsData: [
                          LineChartBarData(
                              spots: [
                                FlSpot(1, 3),
                                FlSpot(2.6, 7),
                                FlSpot(4.9, 5),
                                FlSpot(6.8, 1),
                                FlSpot(8, 8),
                                FlSpot(9.5, 1.7),
                                FlSpot(11, 3),
                              ],
                              isCurved: true,
                              color: gradientColors[0],
                              // dotData: FlDotData(show: false),
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                  show: true,
                                  color: gradientColors[1]
                                      .withOpacity(.2))),

                          LineChartBarData(
                              spots: [
                                FlSpot(1, 1),
                                FlSpot(3, 2),
                                FlSpot(6, 2.5),
                                FlSpot(7, 4),
                                FlSpot(8, 5),
                                FlSpot(9.5, 10),
                                FlSpot(11, 5),
                              ],
                              isCurved: true,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                  show: true,
                                  color: gradientColors[1]
                                      .withOpacity(.2))),
                        ]),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width / 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(

                        // color: Colors.blue,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(
                              show: true,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 50,
                            sections: showingSections(),
                          )
                        ),
                      ),
                      Expanded(

                        child: Container(
                          // color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(width: 15, height: 15,color: Color(0xFF0087F4),),
                                  SizedBox(width: 5,),
                                  Text('First', style: TextStyle(color: Colors.white),),

                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),

                              Row(
                                children: [
                                  Container(width: 15, height: 15,color: Color(0xFFFEA42C),),
                                  SizedBox(width: 5,),
                                  Text('Second', style: TextStyle(color: Colors.white),),

                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),

                              Row(
                                children: [
                                  Container(width: 15, height: 15,color: Color(0xFF8047F6),),
                                  SizedBox(width: 5,),
                                  Text('Third', style: TextStyle(color: Colors.white),),

                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),

                              Row(
                                children: [
                                  Container(width: 15, height: 15,color: Color(0xFF00D27C),),
                                  SizedBox(width: 5,),
                                  Text('Fourth', style: TextStyle(color: Colors.white),),

                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),


                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 28,
                ),
              ],
                ),


            )));
  }
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 10,
        color: Color(0xFFF4F4FB)
    );
    String text;
    print(value.toInt());
    switch (value.toInt()) {
      case 1:
        text = '100';
        break;
      case 2:
        text = '200';
        break;
      case 3:
        text = '300';
        break;
      case 4:
        text = '400';
        break;
      case 5:
        text = '500';
        break;
      case 6:
        text = '600';
        break;
      case 7:
        text = '700';
        break;
      case 8:
        text = '800';
        break;
      case 9:
        text = '900';
        break;
      case 10:
        text = '1000';
        break;
      default:
        text = '10k';
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }
  Widget rightTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Color(0xFFF4F4FB)
    );
    String text;
    switch (value.toInt()) {
      default:
        return Container();
    }

    // return Text(text, style: style, textAlign: TextAlign.center);
  }
  Widget topTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Color(0xFF23b6e6)
    );
    String text;
    switch (value.toInt()) {

      default:
        return Container();
    }

    // return Text(text, style: style, textAlign: TextAlign.center);
  }
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Color(0xFFF4F4FB)
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'JAN';
        break;
      case 1:
        text = 'FEB';
        break;
      case 2:
        text = 'MAR';
        break;
      case 3:
        text = 'APR';
        break;
      case 4:
        text = 'MAY';
        break;
      case 5:
        text = 'JUN';
        break;
      case 6:
        text = 'JUL';
        break;
      case 7:
        text = 'AUG';
        break;
      case 8:
        text = 'SEP';
        break;
      case 9:
        text = 'OCT';
        break;
      case 10:
        text = 'NOV';
        break;
      case 11:
        text = 'DEC';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }
}
