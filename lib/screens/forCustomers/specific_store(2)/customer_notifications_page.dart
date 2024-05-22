import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import "package:http/http.dart" as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomerNotificationsPage extends StatefulWidget {
  String customerEmailVal;
  String customerTokenVal;
  String emailVal;
  String tokenVal;
  List<bool> _isSelected;
  CustomerNotificationsPage(this.customerEmailVal, this.customerTokenVal,
      this.emailVal, this.tokenVal, this._isSelected,
      {super.key});

  @override
  State<CustomerNotificationsPage> createState() =>
      _CustomerNotificationsPageState();
}

class _CustomerNotificationsPageState extends State<CustomerNotificationsPage> {
  String customerEmailVal = "";
  String customerTokenVal = "";
  String emailVal = "";
  String tokenVal = "";
  List<dynamic> cartList = [];
  double totalPrice = 0;
  List<bool> _isSelected = [false];

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

      for (int i = 0; i < cartList.length; i++) {
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
  Future<void> initPlatformActivate() async{
    await OneSignal.shared.setAppId("6991924e-f460-444c-824d-bf138d0e8d7b");
    await OneSignal.shared.getDeviceState().then((value) async {
      print("${value?.userId} RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");

      http.Response
      userFuture =
      await http.post(
        Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/add-user-device-id-into-list/${emailVal}"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "deviceId": value?.userId,
          },
        ),
        encoding: Encoding.getByName("utf-8"),
      );

      print(userFuture.body);
    });
    findUserDeviceIdFromList();

  }
  Future<void> initPlatformDeactivate() async{
    await OneSignal.shared.setAppId("6991924e-f460-444c-824d-bf138d0e8d7b");
    await OneSignal.shared.getDeviceState().then((value) async {
      print("${value?.userId} RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");

      http.Response
      userFuture =
      await http.delete(
        Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-user-device-id-from-list/${emailVal}"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "deviceId": value?.userId,
          },
        ),
        encoding: Encoding.getByName("utf-8"),
      );

      print(userFuture.body);

    });
    findUserDeviceIdFromList();

  }

  // bool tempVal = false;
  Future<void> findUserDeviceIdFromList() async{
    await OneSignal.shared.setAppId("6991924e-f460-444c-824d-bf138d0e8d7b");
    await OneSignal.shared.getDeviceState().then((value) async {
      print("${value?.userId} RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");

      http.Response
      userFuture =
      await http.post(
        Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/find-user-device-id-from-list/${emailVal}"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "deviceId":value?.userId
          },
        ),
        encoding:
        Encoding.getByName("utf-8"),

      );
      setState(() {
        _isSelected = [jsonDecode(userFuture.body)];
      });
      print(userFuture.body);

    });

  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerTokenVal = widget.customerTokenVal;
    customerEmailVal = widget.customerEmailVal;
    tokenVal = widget.tokenVal;
    emailVal = widget.emailVal;
    // _isSelected = widget._isSelected;




    getCustomerCartList();
    getListOfAnsweredQuestions();
    findUserDeviceIdFromList();
    //
  }



  void _toggleNotifications(int index) {
    setState(() {
      _isSelected[index] = !_isSelected[index];

    });

    // You can add your notification enabling/disabling logic here
    if (_isSelected[index]) {
      print('Notifications enabled');
      initPlatformActivate();

    } else {
      initPlatformDeactivate();
      print('Notifications disabled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF212128),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 30,
            ),
          ),
          title: Text("${getLang(context, 'notifications')}",
              style: GoogleFonts.lilitaOne(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              )),
          centerTitle: true,
        ),
        body: Container(
          color: Color(0xFFF2F2F2),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${getLang(context, 'notifications')}",
                          style: GoogleFonts.lilitaOne(
                            textStyle: TextStyle(
                              color: Color(0xFF212128),
                              fontSize: 20,
                            ),
                          )),

                      ToggleButtons(
                        isSelected: _isSelected,
                        onPressed: _toggleNotifications,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _isSelected[0] ? 'On' : 'Off',
                              style: _isSelected[0] ? TextStyle(fontSize: 16.0, color: Colors.white) : TextStyle(fontSize: 16.0, color: Colors.black) ,
                            ),
                          ),
                        ],
                        color: Colors.red,  // Text color for the inactive state
                        selectedColor: Colors.green,  // Text color for the active state
                        fillColor: Colors.green.withOpacity(1),  // Background color for the active state
                        borderRadius: BorderRadius.circular(8.0),  // Rounded corners
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Divider(
                    color: Colors.black.withOpacity(.2),
                    height: 1,
                    thickness: 1,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
