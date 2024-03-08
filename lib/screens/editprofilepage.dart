import 'dart:convert';
// import 'dart:html';
import 'dart:io';
import 'package:animated_background/animated_background.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduate_project/models/UserProfileImage.dart';
import 'package:graduate_project/screens/home.dart';
import 'package:graduate_project/screens/myprofilepage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../models/singleUser.dart';
import '../models/update_model.dart';
import 'package:image_picker/image_picker.dart';

import 'favouritespage.dart';
class EditProfilePage extends StatefulWidget {
  final String token;
  final String email;
  EditProfilePage(this.token,this.email);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with TickerProviderStateMixin {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController streetTextEditingController = TextEditingController();

  //////////
  late File _image;
  final Dio _dio = Dio();
  late String imageUrl = "http://res.cloudinary.com/dsuaio9tv/image/upload/v1708201847/pmha0zckptyp1pyeyobp.png";
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
      final url = 'http://10.0.2.2:3000/electrohub/api/v1/avatar';

      // Extract the file name from the path
      String fileName = _image.path.split('/').last;

      try {
        FormData formData = FormData.fromMap({
          'avatar': await MultipartFile.fromFile(
              _image.path, filename: fileName),
          "email": emailVal,
        });
        Options options = Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            // Add any other headers if needed
          },

        );

        // Make the POST request using dio
        Response response = await _dio.post(
            url, data: formData, options: options);
        // print(response.data['data']['url']);
        // var imageUrl = response.data['data'];
        print(response.data["data"]);
        setState(() {
          imageUrl=response.data["data"];
        });

        // Check the response status
        if (response.statusCode == 200) {
          print('Image uploaded successfully');


        } else {
          print('Failed to upload image. Status code: ${response.statusCode}');
        }
      }catch(error){
        print('Error uploading image: $error');
      }

    }
  }


  ///////////
  bool defaultObsecure = false;

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
      print("${userFuture}-------");
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
                child: SingleChildScrollView(
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> MyProfilePage(tokenVal, emailVal)));
                                },
                                // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 28,
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
                                  "Edit Profile",
                                  style: TextStyle(
                                      color: Color(0xFF212128),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                          ),
                          SizedBox(
                            width: 0,
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
                        height: MediaQuery.of(context).size.height/1.45,
                        child: SingleChildScrollView(
                          child: Column(

                            children: [
                              SizedBox(height: 20,),
                              Center(
                                child: CircleAvatar(
                                  radius: 80,
                                  child: Stack(
                                    children:[
                                          ClipOval(
                                            child: Image.network(
                                              imageUrl,
                                              width: double.infinity,
                                              height: double.infinity,

                                            ),
                                          ),




                                      Positioned(
                                          bottom: 6,
                                          right: 6,
                                          child: CircleAvatar(
                                            radius: 22,
                                            backgroundColor: Color(0xFF212128),
                                            child: Center(

                                                child: IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.white,))),
                                          )
                                      ),
                                      Positioned(
                                        bottom: 8,
                                          right: 8,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            child: Center(
                                                child: IconButton(
                                                    onPressed: _pickAndUploadImage
                                                , icon: Icon(Icons.edit,color: Colors.white,))),
                                          )
                                      )
                                  ]
                                  )
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  controller: usernameTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      labelText: 'New Username ',
                                      labelStyle: const TextStyle(color: Colors.white),
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  controller: emailTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      labelText: 'New Email Address ',
                                      labelStyle: const TextStyle(color: Colors.white),
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                                width: MediaQuery.of(context).size.width/1.3,
                                child: TextFormField(
                                  obscureText: !defaultObsecure,
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  controller: passwordTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                      labelText: 'New Password ',
                                      labelStyle: const TextStyle(color: Colors.white),
                                      prefixIcon: const Icon(
                                        Icons.password,color: Colors.white,
                                      ),
                                      suffixIcon: IconButton( color: Colors.white, onPressed: () {
                                        setState(() {
                                          defaultObsecure= !defaultObsecure;
                                        });
                                      }, icon: Icon(defaultObsecure ? Icons.visibility : Icons.visibility_off)
                                      ),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, )
                                      )
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  controller: phoneTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      labelText: 'New Phone Number ',
                                      labelStyle: const TextStyle(color: Colors.white),
                                      prefixIcon: const Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  controller: countryTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: 'New Country value ',
                                      labelStyle: const TextStyle(color: Colors.white),
                                      prefixIcon: const Icon(
                                        Icons.location_city,
                                        color: Colors.white,
                                      ),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 28, 0, 20),
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  controller: streetTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      labelText: 'New Street value ',
                                      labelStyle: TextStyle(color: Colors.white),
                                      prefixIcon: Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ))),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width/2.5,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFF18181E),
                                ),
                                child: Center(child: TextButton(onPressed: ()async{
                                  try {
                                    var email = emailTextEditingController.text;
                                    var password = passwordTextEditingController.text;
                                    var username = usernameTextEditingController.text;
                                    var phone = phoneTextEditingController.text;
                                    var country = countryTextEditingController.text;
                                    var street = streetTextEditingController.text;
                                    print(emailVal);
                                    http.Response userFuture = await http.patch(
                                      Uri.parse(
                                          "http://10.0.2.2:3000/electrohub/api/v1/update-user-profile/${emailVal}"),
                                      headers: { "Content-Type": "application/json", "Authorization":"Bearer ${tokenVal}"},
                                      body: jsonEncode(
                                        {"email": email, "password": password,
                                          "username":username, "phone":phone, "country": country,
                                          "street":street
                                        },

                                      ),
                                      encoding: Encoding.getByName("utf-8"),
                                    );
                                    // print("${userFuture.body}");
                                    var temp = UpdatePage.fromJson(
                                        json.decode(userFuture.body));
                                    print(temp.Message);
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false, // User must tap button to close
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: Row(
                                              children: [
                                                Icon(Icons.done_all,color: Colors.green,weight: 30,),
                                                SizedBox(width: 10,),
                                                Text("Information Message"),
                                              ],
                                            ),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text("${temp.Message}",style: TextStyle(color: Colors.black),),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("OK"),
                                                onPressed: () {
                                                  print("${tokenVal} --- ${emailVal}");
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(tokenVal, emailVal))); // Close the dialog
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );




                                  }
                                  catch(error) {
                                    //   showDialog<void>(
                                    //     context: context,
                                    //     barrierDismissible: false, // User must tap button to close
                                    //     builder: (BuildContext context) {
                                    //       return AlertDialog(
                                    //         backgroundColor: Colors.white,
                                    //         title: Row(
                                    //           children: [
                                    //             Icon(Icons.error_outline,color: Colors.red,weight: 30,),
                                    //             SizedBox(width: 10,),
                                    //             Text("Error Occurs!"),
                                    //           ],
                                    //         ),
                                    //         content: const SingleChildScrollView(
                                    //           child: ListBody(
                                    //             children: <Widget>[
                                    //               Text("Wrong Email or Password!!",style: TextStyle(color: Colors.black),),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //         actions: <Widget>[
                                    //           TextButton(
                                    //             child: const Text("OK"),
                                    //             onPressed: () {
                                    //               Navigator.of(context).pop(); // Close the dialog
                                    //             },
                                    //           ),
                                    //         ],
                                    //       );
                                    //     },
                                    //   );
                                    //
                                    //
                                    // }


                                  }
                                }, child: Text("Update",style: TextStyle(color: Colors.white),)),),
                              ),


                            ],
                          ),
                        ),
                      ),




                    ],
                  ),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(tokenVal,emailVal)));
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
