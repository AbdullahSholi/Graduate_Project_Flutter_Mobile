import 'dart:convert';
// import 'dart:html';
import 'dart:io';
import 'package:animated_background/animated_background.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graduate_project/models/UserProfileImage.dart';
import 'package:graduate_project/models/singleUser.dart';
import 'package:graduate_project/screens/home.dart';
import 'package:graduate_project/screens/forCustomers/specific_store(2)/customer_my_profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../components/applocal.dart';
import '../../../models/update_model.dart';

class CustomerEditProfilePage extends StatefulWidget {
  final String token;
  final String email;
  final User  tempCustomerProfileData;
  CustomerEditProfilePage(this.token,this.email, this.tempCustomerProfileData);

  @override
  State<CustomerEditProfilePage> createState() => _CustomerEditProfilePageState();
}

class _CustomerEditProfilePageState extends State<CustomerEditProfilePage> with TickerProviderStateMixin {
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
      final url = 'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/avatar';

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
        print("---------------");
        print(url);
        print(formData);
        print(options);
        // Make the POST request using dio
        Response response = await _dio.post(
            url, data: formData, options: options);
        // print(response.data['data']['url']);
        // var imageUrl = response.data['data'];
        print("---------------");
        print(response.data["data"]);
        print("---------------");
        setState(() {
          imageUrl=response.data["data"];
          getUserByName();

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
  late User tempCustomerProfileData = User("", "", "", "", "", "http://res.cloudinary.com/dsuaio9tv/image/upload/v1713135590/j6pvuhvorzgf5wnlqne3.jpg") ;

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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [

                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                margin: EdgeInsets.all(20),
                                padding: EdgeInsets.all(5),
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1.42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Text(
                                      "${getLang(context, 'edit_profile')}",
                                      style: TextStyle(
                                          color: Color(0xFF212128),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )),
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: 28,
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
                            height: MediaQuery.of(context).size.height/1.45,
                            child: SingleChildScrollView(
                              child: Column(

                                children: [
                                  SizedBox(height: 20,),
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 3 ), // Customize the border color
                                      ),
                                      child: CircleAvatar(
                                          radius: 80,
                                          child: Stack(
                                              children:[
                                                ClipOval(
                                                  child: Image.network(
                                                    tempCustomerProfileData.Avatar,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,

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
                                                              , icon: Icon(Icons.edit,color: Colors.white, ),
                                                          )),
                                                    )
                                                )
                                              ]
                                          )
                                      ),
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
                                          labelText: "${getLang(context, 'username')}",
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
                                  // Container(
                                  //   margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                                  //   width: MediaQuery.of(context).size.width / 1.3,
                                  //   child: TextFormField(
                                  //     style: TextStyle(color: Colors.white),
                                  //     cursorColor: Colors.white,
                                  //     controller: emailTextEditingController,
                                  //     //Making keyboard just for Email
                                  //     keyboardType: TextInputType.emailAddress,
                                  //     decoration: InputDecoration(
                                  //         labelText: "${getLang(context, 'email_address')}",
                                  //         labelStyle: const TextStyle(color: Colors.white),
                                  //         prefixIcon: const Icon(
                                  //           Icons.email,
                                  //           color: Colors.white,
                                  //         ),
                                  //         border: const OutlineInputBorder(
                                  //             borderSide: BorderSide(
                                  //               color: Colors.white,
                                  //             )),
                                  //         focusedBorder: OutlineInputBorder(
                                  //             borderSide: BorderSide(
                                  //               color: Colors.white,
                                  //             ))),
                                  //   ),
                                  // ),
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
                                          labelText: "${getLang(context, 'password')}",
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
                                          labelText: "${getLang(context, 'phone_number')}",
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
                                          labelText: "${getLang(context, 'country')}",
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
                                      decoration: InputDecoration(
                                          labelText: "${getLang(context, 'street')}",
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
                                              "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/update-user-profile/${emailVal}"),
                                          headers: { "Content-Type": "application/json", "Authorization":"Bearer ${tokenVal}"},
                                          body: jsonEncode(
                                            { "password": password,
                                              "username":username,
                                              "phone":phone,
                                              "country": country,
                                              "street":street
                                            },

                                          ),
                                          encoding: Encoding.getByName("utf-8"),
                                        );
                                        print("${userFuture.body}");
                                        var temp = UpdatePage.fromJson(
                                            json.decode(userFuture.body));
                                        print(temp.Message);
                                        usernameTextEditingController.text="";
                                        passwordTextEditingController.text="";
                                        phoneTextEditingController.text="";
                                        countryTextEditingController.text="";
                                        streetTextEditingController.text="";


                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          text: "Your Information's Updated Successfully!",
                                        );

                                        // showDialog<void>(
                                        //   context: context,
                                        //   barrierDismissible: false, // User must tap button to close
                                        //   builder: (BuildContext context) {
                                        //     return AlertDialog(
                                        //       backgroundColor: Colors.white,
                                        //       title: Row(
                                        //         children: [
                                        //           Icon(Icons.done_all,color: Colors.green,weight: 30,),
                                        //           SizedBox(width: 10,),
                                        //           Text("Information Message"),
                                        //         ],
                                        //       ),
                                        //       content: SingleChildScrollView(
                                        //         child: ListBody(
                                        //           children: <Widget>[
                                        //             Text("${temp.Message}",style: TextStyle(color: Colors.black),),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //       actions: <Widget>[
                                        //         TextButton(
                                        //           child: const Text("OK"),
                                        //           onPressed: () {
                                        //             print("${tokenVal} --- ${emailVal}");
                                        //             // Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(tokenVal, emailVal))); // Close the dialog
                                        //           },
                                        //         ),
                                        //       ],
                                        //     );
                                        //   },
                                        // );




                                      }
                                      catch(error) {



                                      }
                                    }, child: Text("${getLang(context, 'update')}",style: TextStyle(color: Colors.white),)),),
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

              ],
            )));
  }
}
