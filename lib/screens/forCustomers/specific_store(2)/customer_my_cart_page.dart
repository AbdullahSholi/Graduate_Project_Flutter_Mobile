import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import "package:http/http.dart" as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
  List<dynamic> forProfitList = [];
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

  Color primaryColor = Color(0xFF212128);
  Color secondaryColor = Color(0xFFF4F4FB);
  Color accentColor = Color(0xFF0E1011);

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
      // The Key of solution here ...
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

  final _formKey = GlobalKey<FormState>();
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
            color: secondaryColor,
            size: 30,
          ),
        ),
        title: Text("${getLang(context, 'shopping_cart')}",
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: secondaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            color: secondaryColor,
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
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${cartList[index]["cartCategory"]}",
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    color: secondaryColor,
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
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: secondaryColor,
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
                                  "\$${cartList[index]["cartPrice"]/ (1-(cartList[index]["discountValue"]/100))}",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: secondaryColor,
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
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: secondaryColor,
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
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: secondaryColor,
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
                                    color: secondaryColor,
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
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: secondaryColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${totalPrice}",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: secondaryColor,
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
                                            key: _formKey,
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
                                                                secondaryColor),
                                                        controller:
                                                            _emailController,
                                                        decoration: InputDecoration(
                                                            labelText: 'Email',
                                                            labelStyle: TextStyle(
                                                                color:
                                                                    secondaryColor)),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return '${getLang(context, 'va_email')}';
                                                          }
                                                          if (!RegExp(
                                                                  r'^[^@]+@[^@]+\.[^@]+')
                                                              .hasMatch(
                                                                  value)) {
                                                            return '${getLang(context, 'va_email')}';
                                                          } else {
                                                            return null;
                                                          }
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
                                                                  color:
                                                                      secondaryColor),
                                                              controller:
                                                                  _cardNumberController,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return '${getLang(context, 'va_card')}';
                                                                }
                                                                value = value
                                                                    .replaceAll(
                                                                        ' ',
                                                                        ''); // Remove spaces

                                                                // Check if all characters are digits and length is correct
                                                                if (value.length < 13 ||
                                                                    value.length >
                                                                        19 ||
                                                                    !RegExp(r'^[0-9]+$')
                                                                        .hasMatch(
                                                                            value)) {
                                                                  return '${getLang(context, 'va_card1')}';
                                                                }

                                                                // Luhn algorithm
                                                                int sum = 0;
                                                                for (int i = 0;
                                                                    i <
                                                                        value
                                                                            .length;
                                                                    i++) {
                                                                  int digit = int
                                                                      .parse(value[
                                                                          value.length -
                                                                              i -
                                                                              1]);
                                                                  if (i % 2 ==
                                                                      1) {
                                                                    digit *= 2;
                                                                    if (digit >
                                                                        9)
                                                                      digit -=
                                                                          9;
                                                                  }
                                                                  sum += digit;
                                                                }

                                                                if (sum % 10 !=
                                                                    0) {
                                                                  return '${getLang(context, 'va_card1')}';
                                                                }

                                                                return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                  labelText:
                                                                      'Card Number',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              secondaryColor)),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
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
                                                                              secondaryColor),
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
                                                                  color:
                                                                      secondaryColor),
                                                              controller:
                                                                  _expiryMonthController,
                                                              decoration: InputDecoration(
                                                                  labelText:
                                                                      'Expiry Month',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              secondaryColor)),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return '${getLang(context, 'va_exp_month')}';
                                                                }

                                                                if (!RegExp(
                                                                        r'^(0[1-9]|1[0-2])$')
                                                                    .hasMatch(
                                                                        value)) {
                                                                  return '${getLang(context, 'va_exp_month1')}';
                                                                }

                                                                return null;
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
                                                                  color:
                                                                      secondaryColor),
                                                              controller:
                                                                  _expiryYearController,
                                                              decoration: InputDecoration(
                                                                  labelText:
                                                                      'Expiry Year',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              secondaryColor)),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return '${getLang(context, 'va_exp_year')}';
                                                                }

                                                                if (!RegExp(
                                                                        r'^[0-9]{2}$')
                                                                    .hasMatch(
                                                                        value)) {
                                                                  return '${getLang(context, 'va_exp_year1')}';
                                                                }

                                                                final int
                                                                    currentYear =
                                                                    DateTime.now()
                                                                            .year %
                                                                        100; // Last two digits of the current year
                                                                final int
                                                                    enteredYear =
                                                                    int.parse(
                                                                        value);

                                                                if (enteredYear <
                                                                    currentYear) {
                                                                  return '${getLang(context, 'va_exp_year1')}';
                                                                }

                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      TextFormField(
                                                        style: TextStyle(
                                                            color:
                                                                secondaryColor),
                                                        controller:
                                                            _cvvController,
                                                        decoration: InputDecoration(
                                                            labelText: 'CVC',
                                                            labelStyle: TextStyle(
                                                                color:
                                                                    secondaryColor)),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return '${getLang(context, 'va_cvc')}';
                                                          }

                                                          // Check if all characters are digits and length is correct
                                                          if (!RegExp(
                                                                  r'^[0-9]{3}$')
                                                              .hasMatch(
                                                                  value)) {
                                                            return '${getLang(context, 'va_cvc1')}';
                                                          }

                                                          return null;
                                                        },
                                                      ),
                                                      TextFormField(
                                                        style: TextStyle(
                                                            color:
                                                                secondaryColor),
                                                        controller:
                                                            _accountNameController,
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                'Account Name',
                                                            labelStyle: TextStyle(
                                                                color:
                                                                    secondaryColor)),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return '${getLang(context, "va_account_name")}';
                                                          }
                                                          // return null;
                                                        },
                                                      ),
                                                      TextFormField(
                                                        keyboardType: TextInputType.phone,
                                                        style: TextStyle(
                                                            color:
                                                                secondaryColor),
                                                        controller:
                                                            _phoneNumberController,
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                'Phone Number',
                                                            labelStyle: TextStyle(
                                                                color:
                                                                    secondaryColor)),
                                                        validator: (value) {
                                                          // Check if the value is null or empty
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return '${getLang(context, 'va_phone')}';
                                                          }

                                                          // Define a regular expression to match the phone number criteria
                                                          final RegExp
                                                              phoneRegExp =
                                                              RegExp(
                                                                  r'^05\d{8}$');

                                                          // Check if the phone number matches the criteria
                                                          if (!phoneRegExp
                                                              .hasMatch(
                                                                  value)) {
                                                            return '${getLang(context, 'va_phone1')}';
                                                          }

                                                          // If all checks pass, return null
                                                          return null;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: (true)
                                                            ? () async {
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
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
                                                                      QuickAlert
                                                                          .show(
                                                                        context:
                                                                            context,
                                                                        type: QuickAlertType
                                                                            .error,
                                                                        title:
                                                                            '${getLang(context, 'oops')}',
                                                                        text:
                                                                            '${getLang(context, 'no_product')}',
                                                                      );
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

                                                                      setState(() {
                                                                        forProfitList = cartList;
                                                                      });

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
                                                                            print(price);
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
                                                                        price =
                                                                            0;
                                                                      }
                                                                      List<Map<String, dynamic>>
                                                                          uniqueList =
                                                                          forPay.fold(
                                                                              [],
                                                                              (List<Map<String, dynamic>> accumulator, current) {
                                                                        if (!accumulator.any((element) =>
                                                                            element["merchantId"] ==
                                                                            current["merchantId"])) {
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
                                                                            await http.post(
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
                                                                              "email": customerEmailVal,
                                                                              "card_number": _cardNumberController.text,
                                                                              "exp_month": _expiryMonthController.text,
                                                                              "exp_year": _expiryYearController.text,
                                                                              "account_name": _accountNameController.text,
                                                                              "phone": _phoneNumberController.text,
                                                                              "cvv": _cvvController.text,
                                                                              "amount": uniqueList[i]["price"] * 100,
                                                                              "currency": "USD",
                                                                              "card_type": selectedItem,
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
                                                                          userFuture2 =
                                                                          await http
                                                                              .get(
                                                                        Uri.parse(
                                                                            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/decrease-quantity-part-one/${customerEmailVal}"),
                                                                        headers: {
                                                                          "Content-Type":
                                                                              "application/json",
                                                                          "Authorization":
                                                                              "Bearer ${customerTokenVal}"
                                                                        },
                                                                      );

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
                                                                            Encoding.getByName("utf-8"),
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        getCustomerCartList();
                                                                        totalPrice =
                                                                            0;
                                                                      });

                                                                      http.Response
                                                                          userFuture3 =
                                                                          await http
                                                                              .post(
                                                                        Uri.parse(
                                                                            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/decrease-quantity-part-two/${customerEmailVal}"),
                                                                        headers: {
                                                                          "Content-Type":
                                                                              "application/json",
                                                                          "Authorization":
                                                                              "Bearer ${customerTokenVal}"
                                                                        },
                                                                        encoding:
                                                                            Encoding.getByName("utf-8"),
                                                                        body:
                                                                            jsonEncode(
                                                                          {
                                                                            "data":
                                                                                jsonDecode(userFuture2.body)
                                                                          },
                                                                        ),
                                                                      );

                                                                      setState(
                                                                          () {
                                                                        getCustomerCartList();
                                                                        totalPrice =
                                                                            0;
                                                                      });
                                                                      _emailController
                                                                          .text = "";
                                                                      _cardNumberController
                                                                          .text = "";
                                                                      _expiryMonthController
                                                                          .text = "";
                                                                      _expiryYearController
                                                                          .text = "";
                                                                      _cvvController
                                                                          .text = "";
                                                                      _accountNameController
                                                                          .text = "";
                                                                      _phoneNumberController
                                                                          .text = "";

                                                                      QuickAlert
                                                                          .show(
                                                                        context:
                                                                            context,
                                                                        type: QuickAlertType
                                                                            .success,
                                                                        title: "${getLang(context, 'success')}",
                                                                        text:
                                                                            '${getLang(context, 'transaction_successfully')}',
                                                                      );

                                                                      DateTime now = DateTime.now();
                                                                      int currentMonth = now.month;

                                                                      print(currentMonth);
                                                                      print(forProfitList);
                                                                      for(int k =0; k<forProfitList.length; k++){
                                                                        http.Response userFuture6 = await http.post(
                                                                          Uri.parse(
                                                                              "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/statistics-add-to-revenue/${forProfitList[k]["merchant"]}"),
                                                                          headers: {
                                                                            "Content-Type": "application/json",

                                                                          },
                                                                          encoding: Encoding.getByName("utf-8"),
                                                                          body: jsonEncode(
                                                                            {
                                                                              "month": currentMonth,
                                                                              "revenue": forProfitList[k]["cartPrice"] * forProfitList[k]["quantities"]
                                                                            },
                                                                          ),
                                                                        );
                                                                      }





                                                                      setState(
                                                                          () {
                                                                        Constants
                                                                            .submitCardCounter++;
                                                                      });
                                                                    }
                                                                  } catch (error) {}
                                                                }
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
                                if (cartList.length != 0) {
                                  print(Constants.submitCardCounter);
                                  // If the form is valid, proceed with submission
                                  // Your submission logic goes here
                                  String? selectedItem = 'visa';
                                  List<dynamic> forPay = [];
                                  int price = 0;
                                  print(cartListPaymentInformations);
                                  print("*************");

                                  setState(() {
                                    forProfitList = cartList;
                                  });

                                  for (int j = 0;
                                      j < cartListPaymentInformations.length;
                                      j++) {
                                    for (int i = 0; i < cartList.length; i++) {
                                      print(cartList);
                                      print(cartListPaymentInformations);

                                      if (cartList[i]["merchant"] ==
                                          cartListPaymentInformations[j]
                                              ["merchant"]) {
                                        price +=
                                            (cartList[i]["cartPrice"] as num)
                                                .toInt();
                                        print(price);
                                      }


                                    }
                                    forPay.add({
                                      "merchantId":
                                          cartListPaymentInformations[j]
                                              ["merchant"],
                                      "price": price,
                                      "publishableKey":
                                          cartListPaymentInformations[j]
                                              ["publishableKey"],
                                      "secretKey":
                                          cartListPaymentInformations[j]
                                              ["secretKey"],
                                    });
                                    price = 0;
                                  }
                                  List<Map<String, dynamic>> uniqueList = forPay
                                      .fold([], (List<Map<String, dynamic>>
                                              accumulator,
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
                                          "exp_year":
                                              _expiryYearController.text,
                                          "account_name":
                                              _accountNameController.text,
                                          "phone": _phoneNumberController.text,
                                          "cvv": _cvvController.text,
                                          "amount":
                                              uniqueList[i]["price"] * 100,
                                          "currency": "USD",
                                          "card_type": selectedItem,
                                          // Add card type
                                        },
                                      ),
                                      encoding: Encoding.getByName("utf-8"),
                                    );

                                    print(userFuture.body);
                                  }

                                  http.Response userFuture2 = await http.get(
                                    Uri.parse(
                                        "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/decrease-quantity-part-one/${customerEmailVal}"),
                                    headers: {
                                      "Content-Type": "application/json",
                                      "Authorization":
                                          "Bearer ${customerTokenVal}"
                                    },
                                  );

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

                                  http.Response userFuture3 = await http.post(
                                    Uri.parse(
                                        "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/decrease-quantity-part-two/${customerEmailVal}"),
                                    headers: {
                                      "Content-Type": "application/json",
                                      "Authorization":
                                          "Bearer ${customerTokenVal}"
                                    },
                                    encoding: Encoding.getByName("utf-8"),
                                    body: jsonEncode(
                                      {"data": jsonDecode(userFuture2.body)},
                                    ),
                                  );

                                  print("555555555");
                                  print(userFuture2.body);
                                  print("555555555");

                                  DateTime now = DateTime.now();
                                  int currentMonth = now.month;

                                  print(currentMonth);
                                  print(forProfitList);
                                  for(int k =0; k<forProfitList.length; k++){
                                    http.Response userFuture4 = await http.post(
                                      Uri.parse(
                                          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/statistics-add-to-revenue/${forProfitList[k]["merchant"]}"),
                                      headers: {
                                        "Content-Type": "application/json",

                                      },
                                      encoding: Encoding.getByName("utf-8"),
                                      body: jsonEncode(
                                        {
                                          "month": currentMonth,
                                          "revenue": forProfitList[k]["cartPrice"] * forProfitList[k]["quantities"]
                                        },
                                      ),
                                    );
                                  }


                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    title: getLang(context, 'success'),
                                    text: '${getLang(context, 'transaction_successfully')}',
                                  );
                                } else {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: "${getLang(context, 'oops')}",
                                    text: '${getLang(context, 'no_product')}',
                                  );
                                }
                              },
                        child: Text(
                          "${getLang(context, 'purchase')}!",
                          style: GoogleFonts.roboto(
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
                              MaterialStateProperty.all<Color>(secondaryColor),
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
