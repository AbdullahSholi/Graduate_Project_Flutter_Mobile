import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forMerchant/customize_store(6)/merchant_payment_information.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../forCustomers/customer_login_register/login_or_register(2).dart';
import '../personal_information(4)/personal_information(4).dart';



class MerchantHome extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;
  MerchantHome(this.token,this.email);

  @override
  State<MerchantHome> createState() => _MerchantHomeState();
}

class _MerchantHomeState extends State<MerchantHome> with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF212128),
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
          centerTitle: true,
          title: Text("${getLang(context, 'main_page')}", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFF212128),
          ),
          width: double.infinity,

          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 2,
                color: Colors.white,
              ),
              SizedBox(height: 20,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 70,
                      margin: EdgeInsets.fromLTRB(30, 20, 30, 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF2A212E)),
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 35,
                          ),
                          title: Text(
                            "${getLang(context, 'personal_informations')}",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            print("My Profile");
                            print(tokenVal);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> PersonalInformation(tokenVal,emailVal)));
                          },
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    //   child: TextButton(
                    //     style: TextButton.styleFrom(
                    //       padding: EdgeInsets.all(15),
                    //       backgroundColor: Colors.white,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(15)
                    //       )
                    //     ),
                    //     child: Text("Personal Information", style: GoogleFonts.roboto(
                    //       color: Color(0xFF212128),
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 29,
                    //
                    //     ),
                    //     textAlign: TextAlign.center,
                    //     ),
                    //     onPressed: (){
                    //       print(tokenVal);
                    //       Navigator.push(context, MaterialPageRoute(builder: (context)=> PersonalInformation(tokenVal,emailVal)));
                    //
                    //     },
                    //   ),
                    // ),
                    Container(
                      height: 70,
                      margin: EdgeInsets.fromLTRB(30, 20, 30, 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF2A212E)),
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.settings_sharp,
                            color: Colors.white,
                            size: 35,
                          ),
                          title: Text(
                            "${getLang(context, 'store_management')}",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            print("My Profile");
                            print(tokenVal);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreManagement(tokenVal, emailVal,"","","","",[],[],false,false,false)));
                          },
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    //   child: TextButton(
                    //     style: TextButton.styleFrom(
                    //         padding: EdgeInsets.all(15),
                    //         backgroundColor: Colors.white,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(15)
                    //         )
                    //     ),
                    //     child: Text("Store Management", style: GoogleFonts.roboto(
                    //       color: Color(0xFF212128),
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 29,
                    //
                    //     ),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //     onPressed: (){
                    //       Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreManagement(tokenVal, emailVal,"","","","",[],[],false,false,false)));
                    //
                    //     },
                    //   ),
                    // ),
                    // SizedBox(height: 20,),
                    Container(
                      height: 70,
                      margin: EdgeInsets.fromLTRB(30, 20, 30, 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF2A212E)),
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.payments_outlined,
                            color: Colors.white,
                            size: 35,
                          ),
                          title: Text(
                            "${getLang(context, 'payment_informations')}",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            print("My Profile");
                            print(tokenVal);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> MerchantPaymentInformation(tokenVal, emailVal)));
                          },
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    //   child: TextButton(
                    //     style: TextButton.styleFrom(
                    //         padding: EdgeInsets.all(15),
                    //         backgroundColor: Colors.white,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(15)
                    //         )
                    //     ),
                    //     child: Text("Payment Informations", style: GoogleFonts.roboto(
                    //       color: Color(0xFF212128),
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 29,
                    //
                    //     ),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //     onPressed: (){
                    //       Navigator.push(context, MaterialPageRoute(builder: (context)=> MerchantPaymentInformation(tokenVal, emailVal)));
                    //
                    //     },
                    //   ),
                    // ),

                    Container(
                      height: 70,
                      margin: EdgeInsets.fromLTRB(30, 20, 30, 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF2A212E)),
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.logout_outlined,
                            color: Colors.white,
                            size: 35,
                          ),
                          title: Text(
                            "${getLang(context, 'logout')}",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                // title: "",
                                title: '${getLang(context, 'al_logout')}',
                                confirmBtnText: '${getLang(context, 'al_yes')}',
                                cancelBtnText: '${getLang(context, 'al_no')}',
                                confirmBtnColor: Colors.green,
                                onConfirmBtnTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerLoginOrRegister("", "")));
                                },
                                onCancelBtnTap: (){
                                  Navigator.pop(context);
                                }

                            );
                          },
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   margin: EdgeInsets.fromLTRB(30, 70, 30, 20),
                    //   child: TextButton(
                    //     style: TextButton.styleFrom(
                    //         padding: EdgeInsets.all(15),
                    //         backgroundColor: Colors.white,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(15)
                    //         )
                    //     ),
                    //     child: Text("Logout", style: GoogleFonts.roboto(
                    //       color: Color(0xFF212128),
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 30,
                    //
                    //     ),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //     onPressed: (){
                    //       QuickAlert.show(
                    //           context: context,
                    //           type: QuickAlertType.confirm,
                    //           text: 'Do you want to logout',
                    //           confirmBtnText: 'Yes',
                    //           cancelBtnText: 'No',
                    //           confirmBtnColor: Colors.green,
                    //           onConfirmBtnTap: (){
                    //             Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerLoginOrRegister("", "")));
                    //           },
                    //           onCancelBtnTap: (){
                    //             Navigator.pop(context);
                    //           }
                    //
                    //       );
                    //
                    //
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),


            ],
          ),
        ));
  }
}
