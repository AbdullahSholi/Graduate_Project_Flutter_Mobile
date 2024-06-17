import 'dart:convert';
import 'dart:math';

import 'package:animated_background/animated_background.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
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
  int touchedIndex1 = -1;


  late List<String> xAxisList;
  late List<double> yAxisList;
  late String xAxisName;
  late String yAxisName;
  late double interval;

  final List<Color> gradientColors = [
    const Color(0xFF18FF8B),
    const Color(0xFFA618F3),
    const Color(0xFF10B8F9),
  ];

  List<dynamic> barChartForCategory = [];
  List<dynamic> barChartForProducts = [];

  Future<void> fetchDataForProducts() async {

      String url = 'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/test-get-merchant-cart/${emailVal}';

      // Make GET request
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $tokenVal',  // Replace with your actual authorization token
        'Content-Type': 'application/json',
      });

        // Decode JSON response
        var data = jsonDecode(response.body)["type"];
        print("-----------------------------XXX");
        print(data);

        setState(() {
          barChartForProducts = data;
        });

        print(barChartForProducts[0]["forMostViewed"]);

  }
  Future<void> fetchData() async {
    try {
      String url = 'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}';

      // Make GET request
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $tokenVal',  // Replace with your actual authorization token
        'Content-Type': 'application/json',
      });


      // Check if the request was successful
      if (response.statusCode == 200) {
        // Decode JSON response
        var data = jsonDecode(response.body);
        print("-----------------------------");
        print(data["forMostCategory"]);

        setState(() {
          barChartForCategory = data["forMostCategory"];
        });
      } else {
        // Handle errors
        // setState(() {
        //   responseMessage = 'Error fetching data: ${response.statusCode}';
        // });
      }
    } catch (e) {
      // Handle exceptions
      // setState(() {
      //   responseMessage = 'Error: $e';
      // });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
    fetchData();
    fetchDataForProducts();
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

  double calculateTotal(List<dynamic> data) {
    return data.fold(0, (sum, item) => sum + item['forMostViewed']);
  }

  List<PieChartSectionData> showingSections(List<dynamic> data, double radius, double fontSize, List<Shadow> shadows) {
    List<Color> colors = [Color(0xFF0087F4), Color(0xFFFEA42C), Color(0xFF8047F6), Color(0xFF00D27C), Color(0xFF00E676)];
    final total = calculateTotal(data);
    return List.generate(data.length, (i) {
      final productData = data[i];
      final isTouched = i == touchedIndex;
      final double radiusSize = isTouched ? radius + 10 : radius;
      final percentage = (productData['forMostViewed'] / total) * 100;
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: productData['forMostViewed'].toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radiusSize,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFDFF),
          shadows: shadows,
        ),
      );
    });
  }
  List<PieChartSectionData> showingSections1(List<dynamic> data, double radius, double fontSize, List<Shadow> shadows) {
    List<Color> colors = [Color(0xFF0087F4), Color(0xFFFEA42C), Color(0xFF8047F6), Color(0xFF00D27C), Color(0xFF00E676)];
    final total = calculateTotal(data);
    return List.generate(data.length, (i) {
      final categoryData = data[i];
      final isTouched = i == touchedIndex1;
      final double radiusSize = isTouched ? radius + 10 : radius;
      final percentage = (categoryData['forMostViewed'] / total) * 100;
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: categoryData['forMostViewed'].toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radiusSize,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFDFF),
          shadows: shadows,
        ),
      );
    });
  }

  int get maxForMostViewed {
    // Calculate the maximum forMostViewed value in barChartForCategory
    int max = 0;
    for (var category in barChartForCategory) {
      int forMostViewed = category['forMostViewed'];
      if (forMostViewed > max) {
        max = forMostViewed;
      }
    }
    return max;
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
            child: Column(
              children: [
                Divider(
                  thickness: 1,
                  color: Colors.white,

                ),
                Expanded(
                  child: SingleChildScrollView(
                  
                      // physics: NeverScrollableScrollPhysics(),
                      child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        width: double.infinity,
                        child:
                        Text("Total Revenue", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, ),),),
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
                      Divider(
                        thickness: 1,
                        color: Colors.white,

                      ),
                      SizedBox(height: 20,),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        width: double.infinity,
                        child:
                        Text("Products Statistics", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, ),),),
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
                                            touchedIndex1 = -1;
                                            return;
                                          }
                                          touchedIndex1 = pieTouchResponse
                                              .touchedSection!.touchedSectionIndex;
                                        });
                                      },
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                    ),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 50,
                                    sections: showingSections1( barChartForProducts ,50.0,16.0,
                                        [
                                          Shadow(
                                            blurRadius: 2,
                                            color: Color(0xFF000000),
                                          ),
                                        ]),
                                  )
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(barChartForProducts.length, (i) {
                                    List<Color> colors = [Color(0xFF0087F4), Color(0xFFFEA42C), Color(0xFF8047F6), Color(0xFF00D27C), Color(0xFF00E676)];
                  
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                                      child: Row(
                                        children: [
                                          Container(width: 15, height: 15, color: colors[i % colors.length]),
                                          SizedBox(width: 5),
                                          Text(barChartForProducts[i]['cartName'].toString(), style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),)
                          ],
                        ),
                      ),
                      Container(
                        height: 400,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: BarChart(BarChartData(
                              borderData: FlBorderData(
                                  border: const Border(
                                    top: BorderSide.none,
                                    right: BorderSide.none,
                                    left: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1),
                                  )),
                              groupsSpace: 10,
                              barGroups: _buildBarGroups1(),
                              titlesData: FlTitlesData(


                                leftTitles: AxisTitles(

                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 22,
                                        getTitlesWidget: barWidgetColors1
                                      // margin: 8,
                                    )),

                                bottomTitles: AxisTitles(

                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 22,
                                        getTitlesWidget: barWidgetColorsBottom1
                                      // margin: 8,
                                    )),
                                rightTitles: AxisTitles(

                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 0,
                                        getTitlesWidget: barWidgetColors
                                      // margin: 8,
                                    )),
                              )


                          )),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.white,

                      ),
                      SizedBox(height: 20,),

                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        width: double.infinity,
                        child:
                        Text("Categories Statistics", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, ),),),


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
                                  sections: showingSections( barChartForCategory ,50.0,16.0,
                                  [
                                  Shadow(
                                  blurRadius: 2,
                                    color: Color(0xFF000000),
                                  ),
                                    ]),
                                )
                              ),
                            ),
                            Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(barChartForCategory.length, (i) {
                        List<Color> colors = [Color(0xFF0087F4), Color(0xFFFEA42C), Color(0xFF8047F6), Color(0xFF00D27C), Color(0xFF00E676)];
                  
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              Container(width: 15, height: 15, color: colors[i % colors.length]),
                              SizedBox(width: 5),
                              Text(barChartForCategory[i]['cartCategory'], style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),)
                          ],
                        ),
                      ),
                  
                      const SizedBox(
                        height: 20,
                      ),
                  
                      Container(
                        height: 400,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: BarChart(BarChartData(
                              borderData: FlBorderData(
                                  border: const Border(
                                    top: BorderSide.none,
                                    right: BorderSide.none,
                                    left: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1),
                                  )),
                              groupsSpace: 10,
                              barGroups: _buildBarGroups(),
                              titlesData: FlTitlesData(
                  
                  
                                leftTitles: AxisTitles(
                  
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 22,
                                        getTitlesWidget: barWidgetColors
                                      // margin: 8,
                                    )),
                  
                                bottomTitles: AxisTitles(
                  
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 22,
                                        getTitlesWidget: barWidgetColorsBottom
                                      // margin: 8,
                                    )),
                                rightTitles: AxisTitles(
                  
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 0,
                                        getTitlesWidget: barWidgetColors
                                      // margin: 8,
                                    )),
                              )
                  
                  
                          )),
                        ),
                      ),
                  
                  
                  
                  
                    ],
                      ),
                  
                  
                  ),
                ),
              ],
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

  Widget barWidgetColors(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Color(0xFFF4F4FB)
    );
    String text;
    // Ensure the index is within the range of categories list
    int maxValue = barChartForCategory.length; // You need to define this function

    // Generate a list of titles from 0 to 'maxValue'
    if (value % (maxValue / 1) == 0) { // Adjust the division factor as needed
      return Text(value.toString(), style: style, textAlign: TextAlign.center);
    } else {
      return Container(); // Return empty container for other values
    }

    // return Text(text, style: style, textAlign: TextAlign.center);
  }

  Widget barWidgetColors1(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Color(0xFFF4F4FB)
    );
    String text;
    // Ensure the index is within the range of categories list
    int maxValue = barChartForProducts.length; // You need to define this function

    // Generate a list of titles from 0 to 'maxValue'
    if (value % (maxValue / 1) == 0) { // Adjust the division factor as needed
      return Text(value.toString(), style: style, textAlign: TextAlign.center);
    } else {
      return Container(); // Return empty container for other values
    }

    // return Text(text, style: style, textAlign: TextAlign.center);
  }

  Widget barWidgetColorsBottom(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Color(0xFFF4F4FB)
    );
    String text = ''; // Initialize text variable

    // Ensure the index is within the range of categories list
    if (value >= 0 && value < barChartForCategory.length) {
      String categoryName = barChartForCategory[value.toInt()]['cartCategory'];

      // Generate text based on category name
      text = categoryName; // Display only cartCategory
    } else {
      return Container(); // Return empty container if index is out of range
    }


    return Text(text, style: style, textAlign: TextAlign.center);
  }

  Widget barWidgetColorsBottom1(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Color(0xFFF4F4FB)
    );
    String text = ''; // Initialize text variable

    // Ensure the index is within the range of categories list
    if (value >= 0 && value < barChartForProducts.length) {
      String cartName = barChartForProducts[value.toInt()]['cartName'];

      // Generate text based on category name
      text = cartName; // Display only cartCategory
    } else {
      return Container(); // Return empty container if index is out of range
    }


    return Text(text, style: style, textAlign: TextAlign.center);
  }

  List<BarChartGroupData> _buildBarGroups() {
    List<BarChartGroupData> barGroups = [];

    // Loop through barChartForCategory and create BarChartGroupData for each item
    for (int i = 0; i < barChartForCategory.length; i++) {
      dynamic categoryData = barChartForCategory[i];
      double value = categoryData['forMostViewed'].toDouble(); // Convert to double

      // Create BarChartRodData for this category
      List<BarChartRodData> rods = [
        BarChartRodData(
          toY: value,
          color: Colors.amber, // Set your desired color here
          width: 15,
        ),
      ];

      // Add BarChartGroupData to barGroups list
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: rods,
        ),
      );
    }

    return barGroups;
  }

  List<BarChartGroupData> _buildBarGroups1() {
    List<BarChartGroupData> barGroups = [];

    // Loop through barChartForCategory and create BarChartGroupData for each item
    for (int i = 0; i < barChartForProducts.length; i++) {
      dynamic categoryData = barChartForProducts[i];
      double value = categoryData['forMostViewed'].toDouble(); // Convert to double

      // Create BarChartRodData for this category
      List<BarChartRodData> rods = [
        BarChartRodData(
          toY: value,
          color: Colors.amber, // Set your desired color here
          width: 15,
        ),
      ];

      // Add BarChartGroupData to barGroups list
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: rods,
        ),
      );
    }

    return barGroups;
  }

}



