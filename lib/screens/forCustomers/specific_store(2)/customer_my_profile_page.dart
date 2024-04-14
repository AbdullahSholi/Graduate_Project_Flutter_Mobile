import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;

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
  User tempCustomerProfileData = User("", "", "", "", "", "http://res.cloudinary.com/dsuaio9tv/image/upload/v1713135590/j6pvuhvorzgf5wnlqne3.jpg");
  void getUserByName() async{
    print("ppppppppppppppppppp");
    print(emailVal);
    print("ppppppppppppppppppp");

    http.Response userFuture = await http.get(
        Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/profile/${emailVal}"),
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

        body: AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                // spawnMaxRadius: 40,
                // spawnMinRadius: 1.0,
                  particleCount: 100,
                  // spawnMaxSpeed: 150.0,
                  // // minOpacity: .3,
                  // // spawnOpacity: .4,
                  // // baseColor: Colors.black26,
                  image: Image(image: NetworkImage("https://t3.ftcdn.net/jpg/01/70/28/92/240_F_170289223_KNx1FpHz8r5ody9XZq5kMOfNDxsZphLz.jpg"))
              ),
            ),
            vsync: this,
            child:
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF212128),
                    ),
                    margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          children: [

                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 1.34,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Center(
                                  child: Text(
                                    "My Profile",
                                    style: TextStyle(
                                        color: Color(0xFF212128),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )),
                            ),

                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                height: 60,

                              ),
                            ),
                          ],
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 2,
                          color: Colors.white,
                        ),
                        SizedBox(height: 20,),

                        Container(
                              height: MediaQuery.of(context).size.height/1.5,
                              child: SingleChildScrollView(
                                child: Column(

                                  children: [
                                    SizedBox(height: 20,),
                                    Center(
                                      child: InkWell(
                                        onTap: (){
                                          print(tempCustomerProfileData.Avatar);
                                        },
                                        child: CircleAvatar(
                                          radius: 80,
                                          child: ClipOval(child: Image.network("${tempCustomerProfileData.Avatar}", width: double.infinity, height:  double.infinity,)),

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
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white
                                        ),
                                        child:Text("Username: ${tempCustomerProfileData.username}",style: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),)
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
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white
                                        ),
                                        child:Text("Email: ${tempCustomerProfileData.email}",style: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),)



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
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white
                                        ),
                                        child: Text("Phone: ${tempCustomerProfileData.phone}",style: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),)



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
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white
                                        ),
                                        child:Text("Country: ${tempCustomerProfileData.country}",style: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),)


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
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white
                                        ),
                                        child: Text("Street: ${tempCustomerProfileData.street}",style: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),)

                                    ),
                                    SizedBox(height: 20,),








                                  ],
                                ),
                              ),
                            ),






                      ],
                    ),
                  ),
                ),

              ],
            )));
  }
}
