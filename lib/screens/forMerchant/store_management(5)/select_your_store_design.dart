import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_designs/design1.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_designs/design2.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_designs/design3.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../models/merchant/get_cart_content_model.dart';
import '../../../models/merchant/merchant_store_slider_images.dart';
import '../../../models/singleUser.dart';
import "package:http/http.dart" as http;

class SelectYourStoreDesign extends StatefulWidget {
  final String token;
  final String email;
  final List<String> specificStoreCategories;
  final String storeName;
  final List<dynamic> storeCartsVal;
  final bool sliderVisibility;
  final bool categoryVisibility;
  final bool cartsVisibility;
  final Map<String, dynamic> objectData;
  const SelectYourStoreDesign(
      this.token,
      this.email,
      this.specificStoreCategories,
      this.storeName,
      this.storeCartsVal,
      this.sliderVisibility,
      this.categoryVisibility,
      this.cartsVisibility,
      this.objectData,
      {super.key});
  @override
  State<SelectYourStoreDesign> createState() => _SelectYourStoreDesignState();
}

class _SelectYourStoreDesignState extends State<SelectYourStoreDesign> {
  String tokenVal = "";
  String emailVal = "";
  String imageSliderVal = "";
  List<String> specificStoreCategoriesVal = [];
  List<dynamic> storeCartsVal = [];
  String storeNameVal = "";
  late bool sliderVisibilityVal;
  late bool categoryVisibilityVal;
  late bool cartsVisibilityVal;
  late Map<String, dynamic> objectDataVal;

  late Future<User> userData;
  late Future<List> sliderImages;
  late Future<List> specificStoreCategories;
  late Future<List> getCartContent;
  List<String> imageUrls = [];
  List<String> cartImageUrls = [];

  //////////////////////////////////////
  Color textColor = CupertinoColors.white;

  Color topBarBackgroundColor = Color(0xffa599ad);

  Color specificStoreCategoriesColor = Color(0xffa599ad);

  Color specificStoreProductsColor = Color(0xffa599ad);

  Color bottomBarBackgroundColor = Color(0xffa599ad);

  Color backGroundColor = Color(0xff8e13e8);
  Color primaryTextColor = Color(0xff595b48);
  Color secondaryTextColor = Color(0xffd7ed12);
  Color clipPathColor = Color(0xff9241bb);

  final List<Color> _colors = [
    Color(0xFF212128)
  ];

  final List<Color> _backgroundColors = [
    Colors.white
  ];

  final List<Color> _primaryTextColors = [
    CupertinoColors.black
  ];

  final List<Color> _secondaryTextColors = [
    Colors.white
  ];

  final List<Color> _clippingColor = [
    Color(0xff9d31d3)
  ];

  final List<Color> _iconsColor = [
    Colors.white,
  ];

  final List<Color> _iconsBackgroundColor = [
    Colors.red,
  ];

  // Define the options and their corresponding widgets
  final Map<String, Widget> options = {
    'Option 1': OptionOneWidget(),
    'Option 2': OptionTwoWidget(),
    'Option 3': OptionThreeWidget(),
  };

  // The currently selected option
  String? _selectedOption="Option 2";
  List<String> opt = ["Smooth", "Solid"];
  String? _selectedOptions = "Smooth";
  late Color? _selectedColor = Color(0xFF212128);
  late Color? _selectedColor1 = Colors.white;
  late Color? _selectedColor2 = Colors.black;
  late Color? _selectedColor3 = Colors.white;
  late Color? _selectedColor4 = Color(0xff7a3f98);
  late Color? _selectedColor5 = Colors.white;
  late Color? _selectedColor6 = Colors.red;

  bool _isChecked = false;

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor1(Color color) {

    setState(() {
      pickerColor = color;
      _selectedColor1 = pickerColor;
      _backgroundColors[0]=pickerColor;
    });
    print(_selectedColor1);
    print(pickerColor);
  }

  void changeColor(Color color) {

    setState(() {
      pickerColor = color;
      _selectedColor = pickerColor;
      _colors[0]=pickerColor;
    });
    print(_selectedColor);
    print(pickerColor);
  }

  void changeColor2(Color color) {

    setState(() {
      pickerColor = color;
      _selectedColor2 = pickerColor;
      _primaryTextColors[0]=pickerColor;
    });
    print(_selectedColor2);
    print(pickerColor);
  }

  void changeColor3(Color color) {

    setState(() {
      pickerColor = color;
      _selectedColor3 = pickerColor;
      _secondaryTextColors[0]=pickerColor;
    });
    print(_selectedColor3);
    print(pickerColor);
  }

  void changeColor4(Color color) {

    setState(() {
      pickerColor = color;
      _selectedColor4 = pickerColor;
      _clippingColor[0]=pickerColor;
    });
    print(_selectedColor4);
    print(pickerColor);
  }

  void changeColor5(Color color) {

    setState(() {
      pickerColor = color;
      _selectedColor5 = pickerColor;
      _iconsColor[0]=pickerColor;
    });
    print(_selectedColor5);
    print(pickerColor);
  }

  void changeColor6(Color color) {

    setState(() {
      pickerColor = color;
      _selectedColor6 = pickerColor;
      _iconsBackgroundColor[0]=pickerColor;
    });
    print(_selectedColor6);
    print(pickerColor);
  }


  ////////////////////////////////////
  Future<List> getSliderImages() async {
    print("$emailVal tttttttttt");
    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}"),
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );
    // print(userFuture.body);

    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");
      print(MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .storeSliderImages
          .toList());

      final List<dynamic> data =
          MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
              .storeSliderImages
              .toList();
      final List<String> urls = data.map((item) => item.toString()).toList();
      print("wwwwwwwwwwwwwwwwww $urls ");
      setState(() {
        imageUrls = urls;
      });

      return MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .storeSliderImages
          .toList();
    } else {
      print("error");
      throw Exception("Error");
    }
  }

  Future<List> getSpecificStoreCategories() async {
    print("$emailVal ppppp");
    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}"),
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );
    // print(userFuture.body);

    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");
      print(MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .specificStoreCategories
          .toList());

      final List<dynamic> data =
          MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
              .specificStoreCategories
              .toList();
      final List<String> urls = data.map((item) => item.toString()).toList();
      print("ooooooooooooooo $urls ");
      setState(() {
        specificStoreCategoriesVal = urls;
      });

      return MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .specificStoreCategories
          .toList();
    } else {
      print("error");
      throw Exception("Error");
    }
  }

  Future<List<dynamic>> getSpecificStoreCart() async {
    print("--------------------------");
    print(emailVal);

    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/test-get-merchant-cart/${emailVal}"),
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );
    print(userFuture.body);
    var temp = GetCartContentModel.fromJson(json.decode(userFuture.body))
        .type
        .toList();

    setState(() {
      storeCartsVal = GetCartContentModel.fromJson(json.decode(userFuture.body))
          .type
          .toList();
      print("vvvvvvvvvvvv $storeCartsVal");
    });
    return GetCartContentModel.fromJson(json.decode(userFuture.body))
        .type
        .toList();
  }

  Map<String, dynamic> merchant ={};

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
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/send-notification-to-device"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "storeName": storeNameVal,
          "devices": devicesId
        },
      ),
      encoding:
      Encoding.getByName("utf-8"),
    );
  }

  Future<void> addStoreToDatabase() async {
    print("XPPPPPPPPPPPPX");
    print(sliderVisibilityVal);
    print(categoryVisibilityVal);
    print(cartsVisibilityVal);
    print(_selectedColor1);
    print(_selectedColor);
    print(_selectedColor2);
    print(_selectedColor3);
    print(_selectedColor4);
    print(_selectedOptions);
    print(_selectedOption);
    print("PPPPPPPPPPPP");

    String colorToString(Color color) {
      return 'Color(0x${color.value.toRadixString(16).padLeft(8, '0')})';
    }

    String x_selectedColor1 = colorToString(_selectedColor1!);
    String x_selectedColor = colorToString(_selectedColor!);
    String x_selectedColor2 = colorToString(_selectedColor2!);
    String x_selectedColor3 = colorToString(_selectedColor3!);
    String x_selectedColor4 = colorToString(_selectedColor4!);

    setState(() {
      objectDataVal["activateSlider"] = sliderVisibilityVal;
      objectDataVal["activateCategory"] = categoryVisibilityVal;
      objectDataVal["activateCarts"] = cartsVisibilityVal;
      objectDataVal["specificStoreCategories"] = specificStoreCategoriesVal;
      objectDataVal["backgroundColor"] = x_selectedColor1;
      objectDataVal["boxesColor"] = x_selectedColor;
      objectDataVal["primaryTextColor"] = x_selectedColor2;
      objectDataVal["secondaryTextColor"] = x_selectedColor3;
      objectDataVal["clippingColor"] = x_selectedColor4;
      objectDataVal["smoothy"] = _selectedOptions.toString();
      objectDataVal["design"] = _selectedOption.toString();
      // objectDataVal["type"] = storeCartsVal;

    });
    print(objectDataVal);
    print("PPPPPPPPPPPP");
    print("PPPPPPPPPPPP");


    var storeDataToAddVal = objectDataVal;

    http.Response userFuture1 = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}"),

      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );
    setState(() {
      merchant = jsonDecode(userFuture1.body);
    });

    print(merchant["secretKey"]);
    if (merchant["secretKey"] == null || merchant["publishableKey"] == null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,

        title: '${getLang(context, "oops")}',
        text: '${getLang(context, "must_add_information")}',
        confirmBtnText: "${getLang(context, "al_ok")}"
      );
    } else {

      http.Response userFuture =
      await http.post(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-add-store-to-database/$emailVal"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $tokenVal",
        },
        body: jsonEncode(
          {
            "stores": storeDataToAddVal
          },
        ),
        encoding:
        Encoding.getByName("utf-8"),
      );
      print(userFuture.body);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: "${getLang(context, 'success')}",
        text: "${getLang(context, 'store_published_successfully')}",
        confirmBtnText: "${getLang(context, 'al_ok')}"
      );
      await notifyYourCustomers();
    }
  }



  Future<void> getColors() async {
    print("--------------------------");
    print(emailVal);

    try {
      http.Response userFuture = await http.get(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-specific-store/${emailVal}"),
        headers: {
          "Authorization": "Bearer $tokenVal", // Add the token to the headers
        },
      );

      print("EEEEEEEEEEEEEEEE");
      var responseBody = jsonDecode(userFuture.body);

      // Print out all the colors for debugging
      print(responseBody["backgroundColor"]);
      print(responseBody["boxesColor"]);
      print(responseBody["primaryTextColor"]);
      print(responseBody["secondaryTextColor"]);
      print(responseBody["clippingColor"]);
      print("EEEEEEEEEEEEEEEE");

      setState(() {
        // Convert each color string to a Color? type
        _selectedColor1 = parseColorString(responseBody["backgroundColor"]);
        _selectedColor = parseColorString(responseBody["boxesColor"]);
        _selectedColor2 = parseColorString(responseBody["primaryTextColor"]);
        _selectedColor3 = parseColorString(responseBody["secondaryTextColor"]);
        _selectedColor4 = parseColorString(responseBody["clippingColor"]);
      });

    } catch (e) {
      print("Error occurred while fetching colors: $e");
    }
  }

// Helper function to parse a color string like "Color(0xffffffff)" to a Color object
  Color? parseColorString(String colorString) {
    try {
      // Extract the hexadecimal part of the string using regex
      RegExp colorRegExp = RegExp(r'0x([0-9a-fA-F]+)');
      Match? match = colorRegExp.firstMatch(colorString);

      if (match != null) {
        // Get the hexadecimal part from the first group of the match
        String hexColor = match.group(0)!.replaceAll("0x", ""); // Remove the '0x' prefix
        // Convert the hex part to an integer
        int colorValue = int.parse(hexColor, radix: 16);
        // Return the Color object
        return Color(colorValue);
      }
    } catch (e) {
      print("Error parsing color string '$colorString': $e");
    }
    // If the string does not match the expected pattern or any error occurs, return null
    return null;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
    specificStoreCategoriesVal = widget.specificStoreCategories;
    storeNameVal = widget.storeName;
    storeCartsVal = widget.storeCartsVal.toList();
    print(emailVal);
    // userData = getUserByName();
    sliderImages = getSliderImages();
    specificStoreCategories = getSpecificStoreCategories();
    getCartContent = getSpecificStoreCart();
    sliderVisibilityVal = widget.sliderVisibility;
    categoryVisibilityVal = widget.categoryVisibility;
    cartsVisibilityVal = widget.cartsVisibility;
    objectDataVal = widget.objectData;
    getColors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF212128),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30,)),
        title: Text('${getLang(context, 'select_design')}', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold ),),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_selectedOption == "Option 1") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Design1(
                              tokenVal,
                              emailVal,
                              specificStoreCategoriesVal,
                              storeNameVal,
                              storeCartsVal,
                              sliderVisibilityVal,
                              categoryVisibilityVal,
                              cartsVisibilityVal,
                              objectDataVal,
                              textColor,
                              topBarBackgroundColor,
                              specificStoreCategoriesColor,
                              specificStoreProductsColor,
                              bottomBarBackgroundColor,
                              _selectedOptions,
                              _selectedColor,
                              backGroundColor,
                              primaryTextColor,
                              secondaryTextColor,
                              _selectedColor1,
                              _selectedColor2,
                              _selectedColor3,
                              clipPathColor
                            )));
              }
              if (_selectedOption == "Option 2") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Design2(
                              tokenVal,
                              emailVal,
                              specificStoreCategoriesVal,
                              storeNameVal,
                              storeCartsVal,
                              sliderVisibilityVal,
                              categoryVisibilityVal,
                              cartsVisibilityVal,
                              objectDataVal,
                              textColor,
                              topBarBackgroundColor,
                              specificStoreCategoriesColor,
                              specificStoreProductsColor,
                              bottomBarBackgroundColor,
                              _selectedOptions,
                              _selectedColor,
                              backGroundColor,
                              primaryTextColor,
                              secondaryTextColor,
                              _selectedColor1,
                              _selectedColor2,
                              _selectedColor3,
                                clipPathColor
                            )));
              }
              if (_selectedOption == "Option 3") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Design3(
                          tokenVal,
                          emailVal,
                          specificStoreCategoriesVal,
                          storeNameVal,
                          storeCartsVal,
                          sliderVisibilityVal,
                          categoryVisibilityVal,
                          cartsVisibilityVal,
                          objectDataVal,
                          textColor,
                          topBarBackgroundColor,
                          specificStoreCategoriesColor,
                          specificStoreProductsColor,
                          bottomBarBackgroundColor,
                          _selectedOptions,
                          _selectedColor,
                          backGroundColor,
                          primaryTextColor,
                          secondaryTextColor,
                          _selectedColor1,
                          _selectedColor2,
                          _selectedColor3,
                          _selectedColor4,
                            clipPathColor

                        )));
              }

            },
            child: Text(
              "${getLang(context, 'preview')}",
              style: TextStyle(color: CupertinoColors.white),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green)),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Text("${getLang(context, 'store_color')}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.green,
                        child: IconButton(onPressed: (){
                            addStoreToDatabase();
                        }, icon: Icon(Icons.check, color: Colors.white, size: 30,))),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                            width: 150,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text("${getLang(context, 'background_color')}")),
                  
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _backgroundColors.map((color) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(context: context, builder: (context){
                                  return AlertDialog(
                                    content: Container(
                                      height: MediaQuery.of(context).size.height/1.68,
                                      child: ColorPicker(
                                        pickerColor: pickerColor,
                                        onColorChanged: changeColor1,
                                      ),
                                    ),
                                  );
                  
                                });
                  
                                print(_selectedColor1);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildColorCircle1(color),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                            width: 150,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text("${getLang(context, 'boxes_color')}")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _colors.map((color) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(context: context, builder: (context){
                                  return AlertDialog(
                                    content: Container(
                                      height: MediaQuery.of(context).size.height/1.68,
                                      child: ColorPicker(
                                        pickerColor: pickerColor,
                                        onColorChanged: changeColor,
                                      ),
                                    ),
                                  );
                  
                                });
                  
                                print(_selectedColor);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildColorCircle(color),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                            width: 150,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text("${getLang(context, 'primary_text_color')}")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _primaryTextColors.map((color) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(context: context, builder: (context){
                                  return AlertDialog(
                                    content: Container(
                                      height: MediaQuery.of(context).size.height/1.68,
                                      child: ColorPicker(
                                        pickerColor: pickerColor,
                                        onColorChanged: changeColor2,
                                      ),
                                    ),
                                  );
                  
                                });
                  
                                print(_selectedColor2);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildColorCircle2(color),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                            width: 150,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text("${getLang(context, 'secondary_text_color')}")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _secondaryTextColors.map((color) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(context: context, builder: (context){
                                  return AlertDialog(
                                    content: Container(
                                      height: MediaQuery.of(context).size.height/1.68,
                                      child: ColorPicker(
                                        pickerColor: pickerColor,
                                        onColorChanged: changeColor3,
                                      ),
                                    ),
                                  );
                  
                                });
                  
                                print(_selectedColor3);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildColorCircle3(color),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                            width: 150,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text("${getLang(context, 'clipping_color')}")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _clippingColor.map((color) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(context: context, builder: (context){
                                  return AlertDialog(
                                    content: Container(
                                      height: MediaQuery.of(context).size.height/1.68,
                                      child: ColorPicker(
                                        pickerColor: pickerColor,
                                        onColorChanged: changeColor4,
                                      ),
                                    ),
                                  );

                                });

                                print(_selectedColor4);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildColorCircle3(color),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Container(
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //           width: 150,
                  //           margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  //           child: Text("Icons Color ")),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: _iconsColor.map((color) {
                  //           return GestureDetector(
                  //             onTap: () {
                  //               showDialog(context: context, builder: (context){
                  //                 return AlertDialog(
                  //                   content: Container(
                  //                     height: MediaQuery.of(context).size.height/1.68,
                  //                     child: ColorPicker(
                  //                       pickerColor: pickerColor,
                  //                       onColorChanged: changeColor5,
                  //                     ),
                  //                   ),
                  //                 );
                  //
                  //               });
                  //
                  //               print(_selectedColor5);
                  //             },
                  //             child: Container(
                  //               margin: EdgeInsets.symmetric(vertical: 10),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   _buildColorCircle3(color),
                  //                   SizedBox(width: 10),
                  //                 ],
                  //               ),
                  //             ),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //           width: 150,
                  //           margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  //           child: Text("Icon Color ")),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: _iconsBackgroundColor.map((color) {
                  //           return GestureDetector(
                  //             onTap: () {
                  //               showDialog(context: context, builder: (context){
                  //                 return AlertDialog(
                  //                   content: Container(
                  //                     height: MediaQuery.of(context).size.height/1.68,
                  //                     child: ColorPicker(
                  //                       pickerColor: pickerColor,
                  //                       onColorChanged: changeColor6,
                  //                     ),
                  //                   ),
                  //                 );
                  //
                  //               });
                  //
                  //               print(_selectedColor6);
                  //             },
                  //             child: Container(
                  //               margin: EdgeInsets.symmetric(vertical: 10),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   _buildColorCircle3(color),
                  //                   SizedBox(width: 10),
                  //                 ],
                  //               ),
                  //             ),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Text("${getLang(context, 'store_components')}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),

                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 60,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RadioListTile<String?>(
                      title: Text('${getLang(context, 'smooth')}'),
                      value: 'Smooth',
                      groupValue: _selectedOptions,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOptions = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String?>(
                      title: Text('${getLang(context, 'solid')}'),
                      value: 'Solid',
                      groupValue: _selectedOptions,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOptions = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Text("${getLang(context, 'store_designs')}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),

                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: MediaQuery.of(context).size.height / .6,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: options.keys.map((String key) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: RadioListTile<String>(
                              title: Text(key),
                              value: key,
                              groupValue: _selectedOption,
                              onChanged: (String? value) {
                                print(value);
                                setState(() {
                                  _selectedOption = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          options[key]!,
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    bool isSelected = _selectedColor == color;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
      ),
    );
  }

  Widget _buildColorCircle1(Color color) {
    bool isSelected = _selectedColor1 == color;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
      ),
    );
  }

  Widget _buildColorCircle2(Color color) {
    bool isSelected = _selectedColor2 == color;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
      ),
    );
  }

  Widget _buildColorCircle3(Color color) {
    bool isSelected = _selectedColor3 == color;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
      ),
    );
  }
}

// Define the widgets for each option
class OptionOneWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.blue,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(
            "assets/images/Option 1.png",
            fit: BoxFit.cover,
            height: 380,
            width: 200,
          ),
        ),
      ),
    );
  }
}

class OptionTwoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.blue,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(
            "assets/images/Option 2.png",
            fit: BoxFit.cover,
            height: 380,
            width: 200,
          ),
        ),
      ),
    );
  }
}

class OptionThreeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            "assets/images/Option 3.png",
            fit: BoxFit.cover,
            height: 380,
            width: 200,
          ),
        ),
      ),
    );
  }
}

