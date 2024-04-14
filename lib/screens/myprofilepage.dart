import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;

import '../models/singleUser.dart';
import 'favouritespage.dart';

class MyProfilePage extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;
  MyProfilePage(this.token,this.email);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
  late Future<User> userData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
    userData = getUserByName();
  }

  Future<User> getUserByName() async{
    http.Response userFuture = await http.get(
        Uri.parse("http://10.0.2.2:3000/electrohub/api/v1/profile/${emailVal}"),
        headers: {"Authorization":"Bearer ${tokenVal}"}
    );
    if(userFuture.statusCode == 200){
      print("${userFuture.body}");
      return User.fromJson(json.decode(userFuture.body));
    }
    else{
      throw Exception("Error");
    }
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
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color(0xFF212128),
                              ), // Replace with your desired icon
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(tokenVal, emailVal)));
                              },
                              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 0,
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2.0,
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
                        SizedBox(
                          width: 0,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF212128),
                                ), // Replace with your desired icon
                                onPressed: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>  EditProfilePage(tokenVal,emailVal)));
                                },
                                // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                              ),
                            ),
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
                              child: CircleAvatar(
                                radius: 80,
                                child: FutureBuilder<User>(
                                    future: userData,
                                    builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                                      print(snapshot.data?.street);
                                      if(snapshot.hasData){
                                        return ClipOval(
                                          child: Image.network(
                                            snapshot
                                                .data!.Avatar,
                                            width: double.infinity,
                                            height: double.infinity,
              
                                          ),
                                        );
              
                                      }
                                      else if(snapshot.hasError){
                                        return Text("Error Occured!");
                                      }
                                      else{
                                        return CircularProgressIndicator();
                                      }
              
                                    }
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
                              child: FutureBuilder<User>(
                                  future: userData,
                                  builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                                    print(snapshot.data?.street);
                                    if(snapshot.hasData){
                                      return Text("Username: ${snapshot.data!.username}",style: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),);
              
                                    }
                                    else if(snapshot.hasError){
                                      return Text("Error Occured!");
                                    }
                                    else{
                                      return CircularProgressIndicator();
                                    }
              
                                  }
                              ),
              
              
              
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
                              child: FutureBuilder<User>(
                                  future: userData,
                                  builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                                    print(snapshot.data?.street);
                                    if(snapshot.hasData){
                                      return Text("Email: ${snapshot.data!.email}",style: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),);
              
                                    }
                                    else if(snapshot.hasError){
                                      return Text("Error Occured!");
                                    }
                                    else{
                                      return CircularProgressIndicator();
                                    }
              
                                  }
                              ),
              
              
              
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
                              child: FutureBuilder<User>(
                                  future: userData,
                                  builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                                    print(snapshot.data?.street);
                                    if(snapshot.hasData){
                                      return Text("Phone: ${snapshot.data!.phone}",style: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),);
              
                                    }
                                    else if(snapshot.hasError){
                                      return Text("Error Occured!");
                                    }
                                    else{
                                      return CircularProgressIndicator();
                                    }
              
                                  }
                              ),
              
              
              
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
                              child: FutureBuilder<User>(
                                  future: userData,
                                  builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                                    print(snapshot.data?.street);
                                    if(snapshot.hasData){
                                      return Text("Country: ${snapshot.data!.country}",style: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),);
              
                                    }
                                    else if(snapshot.hasError){
                                      return Text("Error Occured!");
                                    }
                                    else{
                                      return CircularProgressIndicator();
                                    }
              
                                  }
                              ),
              
              
              
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
                              child: FutureBuilder<User>(
                                  future: userData,
                                  builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                                    print(snapshot.data?.street);
                                    if(snapshot.hasData){
                                      return Text("Street: ${snapshot.data!.street}",style: TextStyle(color: Color(0xFF212128),fontWeight: FontWeight.bold,height: 4,fontSize: 16,),);
              
                                    }
                                    else if(snapshot.hasError){
                                      return Text("Error Occured!");
                                    }
                                    else{
                                      return CircularProgressIndicator();
                                    }
              
                                  }
                              ),
              
              
              
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
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BottomNavigationBar(
                  backgroundColor: Color(0xFF212128),
                  onTap: (index){
                    if(index == 0){
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(tokenVal,emailVal)));
                    }
                    else if(index == 1){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> FavouritesPage(tokenVal,emailVal)));
                    }
                    else if(index == 2){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyProfilePage(tokenVal, emailVal)));
                    }
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      label: 'Favourites',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      label: 'Profile',
                    ),
                  ],
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Color(0xFF717389),
                ),
              ),
            ),
          ],
        )));
  }
}
