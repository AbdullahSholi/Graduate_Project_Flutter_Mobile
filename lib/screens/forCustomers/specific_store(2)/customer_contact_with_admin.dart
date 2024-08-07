
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import "package:http/http.dart" as http;

class CustomerContactWithAdmin extends StatefulWidget {
  String customerEmailVal;
  String customerTokenVal;
  CustomerContactWithAdmin(this.customerEmailVal, this.customerTokenVal, {super.key});

  @override
  State<CustomerContactWithAdmin> createState() => _CustomerContactWithAdminState();
}

class _CustomerContactWithAdminState extends State<CustomerContactWithAdmin> {
  String customerEmailVal = "";
  String customerTokenVal = "";
  List<dynamic> cartList = [];
  double totalPrice = 0;

  TextEditingController subjectEditingController = TextEditingController();
  TextEditingController contentEditingController = TextEditingController();

  List<dynamic> cartListPaymentInformations = [];


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

      for(int i = 0; i < cartList.length; i++){
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
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 30,),),
          title: Text("${getLang(context, 'help_support')}", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: subjectEditingController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '${getLang(context, 'va_subject')}';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: '${getLang(context, 'subject')}',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: contentEditingController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '${getLang(context, 'va_content')}';
                      }
                    },
                    maxLines: null, // Allows for multiline input
                    decoration: InputDecoration(
                      labelText: '${getLang(context, 'content')}',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF212128),
                      borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                    ),
                    child: TextButton(
                      onPressed: () async {
    if(_formKey.currentState!.validate()) {
      http.Response userFuture5 = await http.get(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/admins-list"),
      );

      http.Response userFuture = await http.post(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/send-email-to-admin/${jsonDecode(userFuture5.body)["email"]}"),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "email": customerEmailVal,
            "subject": subjectEditingController.text,
            "content": contentEditingController.text
          },
        ),
        encoding: Encoding.getByName("utf-8"),
      );

      setState(() {
        subjectEditingController.text = "";
        contentEditingController.text = "";
      });
    }
                      },
                      child: Text(
                        '${getLang(context, 'send')}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
