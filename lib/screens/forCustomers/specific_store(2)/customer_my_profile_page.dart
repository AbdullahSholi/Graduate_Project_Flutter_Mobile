import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;

import '../../../components/applocal.dart';
import '../../../models/singleUser.dart';
import '../customer_main_page(1)/customer_main_page.dart';
import 'customer_edit_profile_page.dart';
import 'customer_specific_store_main_page.dart';



class MyProfilePage extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;
  final User tempCustomerProfileData;
  MyProfilePage(this.token,this.email, this.tempCustomerProfileData);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";

  Color primaryColor = Color(0xFF212128);
  Color secondaryColor = Color(0xFFF4F4FB);
  Color accentColor = Color(0xFF0E1011);

  User tempCustomerProfileData = User("", "", "", "", "", "http://res.cloudinary.com/dsuaio9tv/image/upload/v1713135590/j6pvuhvorzgf5wnlqne3.jpg");
  void getUserByName() async{
    print("ppppppppppppppppppp");
    print(emailVal);
    print("ppppppppppppppppppp");

    http.Response userFuture = await http.get(
        Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/profile/${emailVal}"),
        headers: {"Authorization":"Bearer ${tokenVal}"}
    );
    if(userFuture.statusCode == 200){
      print("${userFuture.body}");
      print(User.fromJson(json.decode(userFuture.body)));
      // return User.fromJson(json.decode(userFuture.body));
      setState(() {
        tempCustomerProfileData = User.fromJson(json.decode(userFuture.body));
      });
    }
    else{
      throw Exception("Error");
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
    // tempCustomerProfileData = widget.tempCustomerProfileData;
    getUserByName();


  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: Icon(Icons.arrow_back_ios, color: secondaryColor,)),
          title: Text("${getLang(context, 'my_profile')}", style: GoogleFonts.roboto(textStyle: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 25)),),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(20),
            color: Color(0xFF212128),
          ),
          // margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 2,
                color: secondaryColor,
              ),

              Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          SizedBox(height: 20,),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3 ), // Customize the border color
                              ),
                              child: CircleAvatar(
                                radius: 80,
                                child: ClipOval(child: Image.network("${tempCustomerProfileData.Avatar}",
                                  width: double.infinity,
                                  height:  double.infinity,
                                  fit: BoxFit.cover,
                                )
                                ),

                              ),
                            ),
                          ),
                          SizedBox(height: 40,),
                          Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: secondaryColor
                              ),
                              child:Text("${tempCustomerProfileData.username}",style: GoogleFonts.roboto(textStyle: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),))
                          ),
                          SizedBox(height: 20,),
                          Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: secondaryColor
                              ),
                              child:Text("${tempCustomerProfileData.email}",style: GoogleFonts.roboto(textStyle: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),))



                          ),
                          SizedBox(height: 20,),
                          Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: secondaryColor
                              ),
                              child: Text("${tempCustomerProfileData.phone}",style: GoogleFonts.roboto(textStyle: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),) )



                          ),
                          SizedBox(height: 20,),
                          Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: secondaryColor
                              ),
                              child:Text("${tempCustomerProfileData.country}",style: GoogleFonts.roboto(textStyle: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),) )


                          ),
                          SizedBox(height: 20,),
                          Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: secondaryColor
                              ),
                              child: Text("${tempCustomerProfileData.street}",style: GoogleFonts.roboto(textStyle: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),) )

                          ),
                          SizedBox(height: 20,),


                        ],
                      ),
                    ),
                  ),



            ],
          ),
        ));
  }
}
