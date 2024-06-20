import 'dart:convert';
// import 'dart:html';
import 'dart:io';
import 'package:animated_background/animated_background.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final User tempCustomerProfileData;
  CustomerEditProfilePage(this.token, this.email, this.tempCustomerProfileData);

  @override
  State<CustomerEditProfilePage> createState() =>
      _CustomerEditProfilePageState();
}

class _CustomerEditProfilePageState extends State<CustomerEditProfilePage>
    with TickerProviderStateMixin {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController streetTextEditingController = TextEditingController();

  Color primaryColor = Color(0xFF212128);
  Color secondaryColor = Color(0xFFF4F4FB);
  Color accentColor = Color(0xFF0E1011);

  //////////
  late File _image;
  final Dio _dio = Dio();
  late String imageUrl =
      "http://res.cloudinary.com/dsuaio9tv/image/upload/v1708201847/pmha0zckptyp1pyeyobp.png";
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      final url =
          'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/avatar';

      // Extract the file name from the path
      String fileName = _image.path.split('/').last;

      try {
        FormData formData = FormData.fromMap({
          'avatar':
              await MultipartFile.fromFile(_image.path, filename: fileName),
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
        Response response =
            await _dio.post(url, data: formData, options: options);
        // print(response.data['data']['url']);
        // var imageUrl = response.data['data'];
        print("---------------");
        print(response.data["data"]);
        print("---------------");
        setState(() {
          imageUrl = response.data["data"];
          getUserByName();
        });

        // Check the response status
        if (response.statusCode == 200) {
          print('Image uploaded successfully');
        } else {
          print('Failed to upload image. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error uploading image: $error');
      }
    }
  }

  ///////////
  bool defaultObsecure = false;

  String tokenVal = "";
  String emailVal = "";

  void getUserByName() async {
    print("ppppppppppppppppppp");
    print(emailVal);
    print("ppppppppppppppppppp");

    http.Response userFuture = await http.get(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/profile/${emailVal}"),
        headers: {"Authorization": "Bearer ${tokenVal}"});
    if (userFuture.statusCode == 200) {
      print("${userFuture.body}");
      print(User.fromJson(json.decode(userFuture.body)));
      // return User.fromJson(json.decode(userFuture.body));
      setState(() {
        tempCustomerProfileData = User.fromJson(json.decode(userFuture.body));
      });
    } else {
      throw Exception("Error");
    }
  }

  void getUserData() async {
    print("ppppppppppppppppppp");
    print(emailVal);
    print("ppppppppppppppppppp");

    http.Response userFuture = await http.get(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/profile/${emailVal}"),
        headers: {"Authorization": "Bearer ${tokenVal}"});
    if (userFuture.statusCode == 200) {
      setState(() {
        usernameTextEditingController.text = jsonDecode(userFuture.body)["username"];
        phoneTextEditingController.text = jsonDecode(userFuture.body)["phone"];
        countryTextEditingController.text = jsonDecode(userFuture.body)["country"];
        streetTextEditingController.text = jsonDecode(userFuture.body)["street"];
      });
    } else {
      throw Exception("Error");
    }
  }

  late User tempCustomerProfileData = User("", "", "", "", "",
      "http://res.cloudinary.com/dsuaio9tv/image/upload/v1713135590/j6pvuhvorzgf5wnlqne3.jpg");
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;

    emailVal = widget.email;
    // tempCustomerProfileData = widget.tempCustomerProfileData;
    getUserByName();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: secondaryColor,
              )),
          title: Text(
            "Edit Profile",
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    color: secondaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFF212128),
          ),
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
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white,
                                  width: 3), // Customize the border color
                            ),
                            child: CircleAvatar(
                                radius: 80,
                                child: Stack(children: [
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
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ))),
                                      )),
                                  Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: Center(
                                            child: IconButton(
                                          onPressed: _pickAndUploadImage,
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        )),
                                      ))
                                ])),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 28, 0, 0),
                          width: MediaQuery.of(context).size.width / 1.15,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            controller: usernameTextEditingController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Username is required';
                              }
                            },
                            //Making keyboard just for Email
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                labelText: "${getLang(context, 'username')}",
                                labelStyle:
                                    const TextStyle(color: Colors.white),
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
                          width: MediaQuery.of(context).size.width / 1.15,
                          child: TextFormField(
                            obscureText: !defaultObsecure,
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            controller: passwordTextEditingController,

                            //Making keyboard just for Email
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                labelText: "${getLang(context, 'password')}",
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                prefixIcon: const Icon(
                                  Icons.password,
                                  color: Colors.white,
                                ),
                                suffixIcon: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        defaultObsecure = !defaultObsecure;
                                      });
                                    },
                                    icon: Icon(defaultObsecure
                                        ? Icons.visibility
                                        : Icons.visibility_off)),
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
                          width: MediaQuery.of(context).size.width / 1.15,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            controller: phoneTextEditingController,
                            validator: (value) {
                              // Check if the value is null or empty
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }

                              // Define a regular expression to match the phone number criteria
                              final RegExp phoneRegExp = RegExp(r'^05\d{8}$');

                              // Check if the phone number matches the criteria
                              if (!phoneRegExp.hasMatch(value)) {
                                return 'Phone number must start with "05" and be exactly 10 digits long';
                              }

                              // If all checks pass, return null
                              return null;
                            },
                            //Making keyboard just for Email
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                labelText:
                                    "${getLang(context, 'phone_number')}",
                                labelStyle:
                                    const TextStyle(color: Colors.white),
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
                          width: MediaQuery.of(context).size.width / 1.15,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            controller: countryTextEditingController,
                            //Making keyboard just for Email
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Country is required';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "${getLang(context, 'country')}",
                                labelStyle:
                                    const TextStyle(color: Colors.white),
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
                          width: MediaQuery.of(context).size.width / 1.15,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            controller: streetTextEditingController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Street is required';
                              }
                            },
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
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: accentColor,
                          ),
                          child: Center(
                            child: TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      var email =
                                          emailTextEditingController.text;
                                      var password =
                                          passwordTextEditingController.text;
                                      var username =
                                          usernameTextEditingController.text;
                                      var phone =
                                          phoneTextEditingController.text;
                                      var country =
                                          countryTextEditingController.text;
                                      var street =
                                          streetTextEditingController.text;
                                      print(emailVal);
                                      http.Response userFuture =
                                          await http.patch(
                                        Uri.parse(
                                            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/update-user-profile/${emailVal}"),
                                        headers: {
                                          "Content-Type": "application/json",
                                          "Authorization": "Bearer ${tokenVal}"
                                        },
                                        body: jsonEncode(
                                          {
                                            "password": password,
                                            "username": username,
                                            "phone": phone,
                                            "country": country,
                                            "street": street
                                          },
                                        ),
                                        encoding: Encoding.getByName("utf-8"),
                                      );
                                      print("${userFuture.body}");
                                      var temp = UpdatePage.fromJson(
                                          json.decode(userFuture.body));
                                      print(temp.Message);
                                      // usernameTextEditingController.text = "";
                                      // passwordTextEditingController.text = "";
                                      // phoneTextEditingController.text = "";
                                      // countryTextEditingController.text = "";
                                      // streetTextEditingController.text = "";

                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,
                                        text:
                                            "Your Information's Updated Successfully!",
                                      );
                                    } catch (error) {}
                                  }
                                },
                                child: Text("${getLang(context, 'update')}",
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
