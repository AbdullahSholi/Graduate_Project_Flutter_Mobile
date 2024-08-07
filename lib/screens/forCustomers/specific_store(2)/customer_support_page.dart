import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:translator/translator.dart';

import '../../../components/applocal.dart';

class CustomerSupportPage extends StatefulWidget {
  String customerEmailVal;
  String customerTokenVal;
  String emailVal;
  String tokenVal;
  CustomerSupportPage(this.customerEmailVal, this.customerTokenVal,
      this.emailVal, this.tokenVal,
      {super.key});

  @override
  State<CustomerSupportPage> createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage>
    with WidgetsBindingObserver {
  String customerEmailVal = "";
  String customerTokenVal = "";
  String emailVal = "";
  String tokenVal = "";
  List<dynamic> cartList = [];
  double totalPrice = 0;

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

    final translator = GoogleTranslator();

    final String localeName = Platform.localeName; // e.g., "en_US"

    // You can extract the language code from the string if needed
    final String langCode = localeName.split('_').first; // e.g., "en"
    if (langCode != "ar") {
      setState(() {
        listOfAnsweredQuestions = [];
        listOfAnsweredQuestions = jsonDecode(userFuture.body);
      });
    }

    if (langCode == "ar") {
      List<dynamic> temp = [];
      temp = jsonDecode(userFuture.body);
      print(temp);
      List<Future<dynamic>> translatedData = temp.map((item) async {
        final translatedQuestion =
            await translator.translate(item["question"], to: langCode);
        final translatedAnswer =
            await translator.translate(item["answer"], to: langCode);
        item["question"] =
            translatedQuestion.text; // Spread syntax for shallow copy
        item["answer"] = translatedAnswer.text;
        return item;
      }).toList();

      List<dynamic> completedData = await Future.wait(translatedData);
      print("IIIIIIIIIIIIIIII");
      // print(getStoreDataVal[0].storeName);
      print(completedData);
      print("IIIIIIIIIIIIIIII");
      setState(() {
        listOfAnsweredQuestions = [];
        listOfAnsweredQuestions = completedData;
        completedData = [];
      });
    }

    // setState(() {
    //   listOfAnsweredQuestions = jsonDecode(userFuture.body);
    // });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    customerTokenVal = widget.customerTokenVal;
    customerEmailVal = widget.customerEmailVal;
    tokenVal = widget.tokenVal;
    emailVal = widget.emailVal;
    getCustomerCartList();
    getListOfAnsweredQuestions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Execute your function here when the app resumes from the background
      // yourFunction();

      getListOfAnsweredQuestions();
    }
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
              color: Colors.white,
              size: 30,
            ),
          ),
          title: Text("${getLang(context, 'help_support')}",
              style: GoogleFonts.roboto(
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
              color: Color(0xFFF2F2F2),
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.question_circle_fill,
                            color: Color(0xFF212128),
                            size: 28,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("${getLang(context, 'faq')}",
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: Color(0xFF212128),
                                  fontSize: 20,
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ListView.separated(
                          itemBuilder: (context, index) => Container(
                                margin: EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF212128),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            listOfAnsweredQuestions[index]
                                                ["question"],
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ))),
                                    Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF7F7F7),
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        listOfAnsweredQuestions[index]
                                            ["answer"],
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            color: Color(0xFF212128),
                                            fontSize: 16,
                                          ),
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          separatorBuilder: (context, index) => SizedBox(
                                height: 15,
                              ),
                          itemCount: listOfAnsweredQuestions.length),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                // width: double.infinity,
                height: MediaQuery.of(context).size.height / 6.5,
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
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: addQuestion,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '${getLang(context, 'va_question')}';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          http.Response userFuture =
                                              await http.post(
                                            Uri.parse(
                                                "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/add-your-question/${emailVal}"),
                                            headers: {
                                              "Content-Type":
                                                  "application/json",
                                            },
                                            body: jsonEncode(
                                              {
                                                "isAnswered": false,
                                                "question": addQuestion.text
                                                // Add card type
                                              },
                                            ),
                                            encoding:
                                                Encoding.getByName("utf-8"),
                                          );
                                          setState(() {
                                            addQuestion.text = "";
                                          });
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.success,
                                            title: "${getLang(context, 'success')}",
                                            text:
                                                '${getLang(context, 'question_successfully')}',
                                          );

                                          print(userFuture.body);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                    hintText:
                                        '${getLang(context, 'type_your_question_here')}',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[300]),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  // Other properties for the TextFormField go here
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
