import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import "package:http/http.dart" as http;

import '../../../constants/constants.dart';

class CustomerMyCartPage extends StatefulWidget {
  String customerEmailVal;
  String customerTokenVal;
  CustomerMyCartPage(this.customerEmailVal, this.customerTokenVal, {super.key});

  @override
  State<CustomerMyCartPage> createState() => _CustomerMyCartPageState();
}

class _CustomerMyCartPageState extends State<CustomerMyCartPage> {
  String customerEmailVal = "";
  String customerTokenVal = "";
  List<dynamic> cartList = [];
  double totalPrice = 0;

  List<dynamic> cartListPaymentInformations = [];

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryMonthController = TextEditingController();
  final TextEditingController _expiryYearController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _cardTypeController =
      TextEditingController(); // Visa, MasterCard, etc.
  final TextEditingController _phoneNumberController =
      TextEditingController(); // Visa, MasterCard, etc.

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerTokenVal = widget.customerTokenVal;
    customerEmailVal = widget.customerEmailVal;
    getCustomerCartList();
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
        title: Text("${getLang(context, 'shopping_cart')}",
            style: GoogleFonts.lilitaOne(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(
                0,
                0,
                0,
                MediaQuery.of(context).size.height / 5,
              ),
              itemCount: cartList.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF212128),
                  ),
                  child: Row(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                "${cartList[index]["cartPrimaryImage"]}",
                                fit: BoxFit.cover,
                              ))),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.22,
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${cartList[index]["cartName"]}",
                              style: GoogleFonts.lilitaOne(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${cartList[index]["cartCategory"]}",
                              style: GoogleFonts.lilitaOne(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  "\$${cartList[index]["cartPrice"]}",
                                  style: GoogleFonts.lilitaOne(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "\$400",
                                  style: GoogleFonts.lilitaOne(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  "${getLang(context, 'price')}: ",
                                  style: GoogleFonts.lilitaOne(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${cartList[index]["cartPrice"]} * ${cartList[index]["quantities"]} = ${cartList[index]["cartPrice"] * cartList[index]["quantities"]} ",
                                  style: GoogleFonts.lilitaOne(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // width: 60,
                              // height: 60,

                              // color: Colors.red,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: IconButton(
                                  onPressed: () async {
                                    try {
                                      print(cartList[index]["cartName"]);
                                      print(cartList[index]["merchant"]);
                                      http.Response userFuture =
                                          await http.delete(
                                        Uri.parse(
                                            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-product-from-cart-list-from-different-stores/${customerEmailVal}"),
                                        headers: {
                                          "Content-Type": "application/json",
                                          "Authorization":
                                              "Bearer ${customerTokenVal}"
                                        },
                                        body: jsonEncode(
                                          {
                                            "cartName": cartList[index]
                                                ["cartName"],
                                            "merchant": cartList[index]
                                                ["merchant"]
                                          },
                                        ),
                                        encoding: Encoding.getByName("utf-8"),
                                      );

                                      print(userFuture.body);
                                      setState(() {
                                        totalPrice = 0;
                                      });
                                      getCustomerCartList();
                                    } catch (error) {}
                                  },
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.white,
                                    size: 30,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                // if(index == 4){
                //   return Padding( padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height/3,),);
                // }
                // else {
                return SizedBox(height: 0);
                // }
              },
            ),
            // height: MediaQuery.of(context).size.height/1.3,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // width: double.infinity,
              height: MediaQuery.of(context).size.height / 5,
              decoration: BoxDecoration(
                  color: Color(0xFF212128),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )),
              child: Stack(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Column(
                        children: [
                          Text(
                            "${getLang(context, 'total_price')}",
                            style: GoogleFonts.lilitaOne(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${totalPrice}",
                            style: GoogleFonts.lilitaOne(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      )),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: ElevatedButton(
                        onPressed: Constants.submitCardCounter == 0
                            ? () async {
                                String? selectedItem = 'visa';
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                            color: Color(0xFF212128),
                                          ),
                                          child: Form(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SingleChildScrollView(
                                                reverse: true,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      TextFormField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        controller:
                                                            _emailController,
                                                        decoration: InputDecoration(
                                                            labelText: 'Email',
                                                            labelStyle: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please enter your email';
                                                          }
                                                          // return null;
                                                        },
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.5,
                                                            child:
                                                                TextFormField(
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              controller:
                                                                  _cardNumberController,
                                                              decoration: InputDecoration(
                                                                  labelText:
                                                                      'Card Number',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter your card number';
                                                                }
                                                                // return null;
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(0, 20,
                                                                    0, 0),
                                                            // color: Colors.blue,
                                                            child:
                                                                DropdownButton(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              dropdownColor:
                                                                  Color(
                                                                      0xFF36363C),
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF212128)),
                                                              value:
                                                                  selectedItem,
                                                              onChanged: (String?
                                                                  newValue) {
                                                                setState(() {
                                                                  selectedItem =
                                                                      newValue!;
                                                                  print(
                                                                      selectedItem);
                                                                });
                                                                setState(() {
                                                                  selectedItem =
                                                                      newValue!;
                                                                  print(
                                                                      selectedItem);
                                                                });
                                                                setState(() {
                                                                  selectedItem =
                                                                      newValue!;
                                                                  print(
                                                                      selectedItem);
                                                                });
                                                              },
                                                              items: [
                                                                "visa",
                                                                "paypal"
                                                              ].map<
                                                                  DropdownMenuItem<
                                                                      String>>((String
                                                                  value) {
                                                                return DropdownMenuItem(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                      value,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ));
                                                              }).toList(),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.1,
                                                            child:
                                                                TextFormField(
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              controller:
                                                                  _expiryMonthController,
                                                              decoration: InputDecoration(
                                                                  labelText:
                                                                      'Expiry Month',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter your expiry month';
                                                                }
                                                                // return null;
                                                              },
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.1,
                                                            child:
                                                                TextFormField(
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              controller:
                                                                  _expiryYearController,
                                                              decoration: InputDecoration(
                                                                  labelText:
                                                                      'Expiry Year',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter your expiry year';
                                                                }
                                                                // return null;
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      TextFormField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        controller:
                                                            _cvvController,
                                                        decoration: InputDecoration(
                                                            labelText: 'CVV',
                                                            labelStyle: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please enter your cvv';
                                                          }
                                                          // return null;
                                                        },
                                                      ),
                                                      TextFormField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        controller:
                                                            _accountNameController,
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                'Account Name',
                                                            labelStyle: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please enter your account name';
                                                          }
                                                          // return null;
                                                        },
                                                      ),
                                                      TextFormField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        controller:
                                                            _phoneNumberController,
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                'Phone Number',
                                                            labelStyle: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please enter your phone number';
                                                          }
                                                          // return null;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: (_emailController.text.isNotEmpty &&
                                                                _cardNumberController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                _expiryYearController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                _expiryMonthController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                _cvvController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                _accountNameController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                _phoneNumberController
                                                                    .text
                                                                    .isNotEmpty)
                                                            ? () async {
                                                                try {
                                                                  print(_emailController.text.isNotEmpty &&
                                                                      _cardNumberController
                                                                          .text
                                                                          .isNotEmpty &&
                                                                      _expiryYearController
                                                                          .text
                                                                          .isNotEmpty &&
                                                                      _expiryMonthController
                                                                          .text
                                                                          .isNotEmpty &&
                                                                      _cvvController
                                                                          .text
                                                                          .isNotEmpty &&
                                                                      _accountNameController
                                                                          .text
                                                                          .isNotEmpty &&
                                                                      _phoneNumberController
                                                                          .text
                                                                          .isNotEmpty);
                                                                  if (cartList
                                                                      .isEmpty) {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (context) =>
                                                                            AlertDialog(
                                                                              title: Text("No products"),
                                                                              content: Container(
                                                                                height: 190,
                                                                                child: Column(
                                                                                  children: [
                                                                                    CircleAvatar(
                                                                                        radius: 80,
                                                                                        backgroundColor: Colors.red,
                                                                                        child: Icon(
                                                                                          Icons.close,
                                                                                          color: Colors.white,
                                                                                          size: 150,
                                                                                        )),
                                                                                    SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                    Container(
                                                                                      child: Text(
                                                                                        "No any product to buy!!",
                                                                                        textAlign: TextAlign.start,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ));
                                                                  } else {
                                                                    // If the form is valid, proceed with submission
                                                                    // Your submission logic goes here
                                                                    List<dynamic>
                                                                        forPay =
                                                                        [];
                                                                    int price =
                                                                        0;
                                                                    print(
                                                                        cartListPaymentInformations);
                                                                    print(
                                                                        "*************");

                                                                    for (int j =
                                                                            0;
                                                                        j < cartListPaymentInformations.length;
                                                                        j++) {
                                                                      for (int i =
                                                                              0;
                                                                          i < cartList.length;
                                                                          i++) {
                                                                        print(cartList[i]
                                                                            [
                                                                            "merchant"]);
                                                                        print(cartListPaymentInformations[j]
                                                                            [
                                                                            "merchant"]);
                                                                        if (cartList[i]["merchant"] ==
                                                                            cartListPaymentInformations[j]["merchant"]) {
                                                                          price +=
                                                                              (cartList[i]["cartPrice"] as num).toInt();
                                                                          print(
                                                                              price);
                                                                        }
                                                                      }
                                                                      forPay
                                                                          .add({
                                                                        "merchantId":
                                                                            cartListPaymentInformations[j]["merchant"],
                                                                        "price":
                                                                            price,
                                                                        "publishableKey":
                                                                            cartListPaymentInformations[j]["publishableKey"],
                                                                        "secretKey":
                                                                            cartListPaymentInformations[j]["secretKey"],
                                                                      });
                                                                      price = 0;
                                                                    }
                                                                    List<Map<String, dynamic>>
                                                                        uniqueList =
                                                                        forPay.fold(
                                                                            [],
                                                                            (List<Map<String, dynamic>> accumulator,
                                                                                current) {
                                                                      if (!accumulator.any((element) =>
                                                                          element[
                                                                              "merchantId"] ==
                                                                          current[
                                                                              "merchantId"])) {
                                                                        accumulator
                                                                            .add(current);
                                                                      }
                                                                      return accumulator;
                                                                    });
                                                                    // print(price);
                                                                    print(
                                                                        uniqueList);

                                                                    for (int i =
                                                                            0;
                                                                        i < uniqueList.length;
                                                                        i++) {
                                                                      http.Response
                                                                          userFuture =
                                                                          await http
                                                                              .post(
                                                                        Uri.parse(
                                                                            "https://api.lahza.io/transaction/initialize"),
                                                                        headers: {
                                                                          "Content-Type":
                                                                              "application/json",
                                                                          "Authorization":
                                                                              "Bearer ${uniqueList[i]["secretKey"]}"
                                                                        },
                                                                        body:
                                                                            jsonEncode(
                                                                          {
                                                                            "email":
                                                                                customerEmailVal,
                                                                            "card_number":
                                                                                _cardNumberController.text,
                                                                            "exp_month":
                                                                                _expiryMonthController.text,
                                                                            "exp_year":
                                                                                _expiryYearController.text,
                                                                            "account_name":
                                                                                _accountNameController.text,
                                                                            "phone":
                                                                                _phoneNumberController.text,
                                                                            "cvv":
                                                                                _cvvController.text,
                                                                            "amount":
                                                                                uniqueList[i]["price"] * 100,
                                                                            "currency":
                                                                                "USD",
                                                                            "card_type":
                                                                                selectedItem,
                                                                            // Add card type
                                                                          },
                                                                        ),
                                                                        encoding:
                                                                            Encoding.getByName("utf-8"),
                                                                      );

                                                                      print(userFuture
                                                                          .body);
                                                                    }

                                                                    http.Response
                                                                        userFuture1 =
                                                                        await http
                                                                            .delete(
                                                                      Uri.parse(
                                                                          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-all-products-from-cart-list/${customerEmailVal}"),
                                                                      headers: {
                                                                        "Content-Type":
                                                                            "application/json",
                                                                        "Authorization":
                                                                            "Bearer ${customerTokenVal}"
                                                                      },
                                                                      encoding:
                                                                          Encoding.getByName(
                                                                              "utf-8"),
                                                                    );
                                                                    setState(
                                                                        () {
                                                                      getCustomerCartList();
                                                                      totalPrice =
                                                                          0;
                                                                    });
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (context) =>
                                                                            AlertDialog(
                                                                              title: Text("Success"),
                                                                              content: Container(
                                                                                height: 190,
                                                                                child: Column(
                                                                                  children: [
                                                                                    CircleAvatar(
                                                                                        radius: 80,
                                                                                        backgroundColor: Colors.green,
                                                                                        child: Icon(
                                                                                          Icons.check,
                                                                                          color: Colors.white,
                                                                                          size: 150,
                                                                                        )),
                                                                                    SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                    // Container(
                                                                                    //   child: Text("No any product to buy!!", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                                                                                    // ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ));
                                                                    setState(() {
                                                                      Constants.submitCardCounter++;
                                                                    });
                                                                  }
                                                                } catch (error) {}
                                                              }
                                                            : () {},
                                                        child: Text(
                                                          'Submit Payment',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ));
                              }
                            : () async {
                          print(Constants.submitCardCounter);
                                // If the form is valid, proceed with submission
                                // Your submission logic goes here
                                String? selectedItem = 'visa';
                                List<dynamic> forPay = [];
                                int price = 0;
                                print(cartListPaymentInformations);
                                print("*************");

                                for (int j = 0;
                                    j < cartListPaymentInformations.length;
                                    j++) {
                                  for (int i = 0; i < cartList.length; i++) {
                                    print(cartList[i]["merchant"]);
                                    print(cartListPaymentInformations[j]
                                        ["merchant"]);
                                    if (cartList[i]["merchant"] ==
                                        cartListPaymentInformations[j]
                                            ["merchant"]) {
                                      price += (cartList[i]["cartPrice"] as num)
                                          .toInt();
                                      print(price);
                                    }
                                  }
                                  forPay.add({
                                    "merchantId": cartListPaymentInformations[j]
                                        ["merchant"],
                                    "price": price,
                                    "publishableKey":
                                        cartListPaymentInformations[j]
                                            ["publishableKey"],
                                    "secretKey": cartListPaymentInformations[j]
                                        ["secretKey"],
                                  });
                                  price = 0;
                                }
                                List<Map<String, dynamic>> uniqueList = forPay
                                    .fold([],
                                        (List<Map<String, dynamic>> accumulator,
                                            current) {
                                  if (!accumulator.any((element) =>
                                      element["merchantId"] ==
                                      current["merchantId"])) {
                                    accumulator.add(current);
                                  }
                                  return accumulator;
                                });
                                // print(price);
                                print(uniqueList);

                                for (int i = 0; i < uniqueList.length; i++) {
                                  http.Response userFuture = await http.post(
                                    Uri.parse(
                                        "https://api.lahza.io/transaction/initialize"),
                                    headers: {
                                      "Content-Type": "application/json",
                                      "Authorization":
                                          "Bearer ${uniqueList[i]["secretKey"]}"
                                    },
                                    body: jsonEncode(
                                      {
                                        "email": customerEmailVal,
                                        "card_number":
                                            _cardNumberController.text,
                                        "exp_month":
                                            _expiryMonthController.text,
                                        "exp_year": _expiryYearController.text,
                                        "account_name":
                                            _accountNameController.text,
                                        "phone": _phoneNumberController.text,
                                        "cvv": _cvvController.text,
                                        "amount": uniqueList[i]["price"] * 100,
                                        "currency": "USD",
                                        "card_type": selectedItem,
                                        // Add card type
                                      },
                                    ),
                                    encoding: Encoding.getByName("utf-8"),
                                  );

                                  print(userFuture.body);
                                }

                                http.Response userFuture1 = await http.delete(
                                  Uri.parse(
                                      "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-all-products-from-cart-list/${customerEmailVal}"),
                                  headers: {
                                    "Content-Type": "application/json",
                                    "Authorization":
                                        "Bearer ${customerTokenVal}"
                                  },
                                  encoding: Encoding.getByName("utf-8"),
                                );
                                setState(() {
                                  getCustomerCartList();
                                  totalPrice = 0;
                                });

                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Success"),
                                          content: Container(
                                            height: 190,
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                    radius: 80,
                                                    backgroundColor:
                                                        Colors.green,
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 150,
                                                    )),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                // Container(
                                                //   child: Text("No any product to buy!!", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                        child: Text(
                          "${getLang(context, 'purchase')}!",
                          style: GoogleFonts.lilitaOne(
                            textStyle: TextStyle(
                              color: Color(0xFF212128),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ), // Border radius of the button
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
