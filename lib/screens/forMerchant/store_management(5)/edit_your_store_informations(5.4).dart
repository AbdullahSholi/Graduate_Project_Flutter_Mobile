import 'dart:convert';
import 'dart:io';

import 'package:animated_background/animated_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/models/merchant/update_store_informations.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_your_store(5.1).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/rabish/edit_your_store_design(5.2).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../models/merchant/merchant_profile.dart';

import '../merchant_home_page(3)/merchant_home_page.dart';
import '../personal_information(4)/personal_information(4).dart';



class EditYourStoreInformations extends StatefulWidget {
  // const MyProfilePage({super.key});
  final String token;
  final String email;
  final String imageUrl;
  final String storeNameVal;
  final String storeCategoryVal;
  final String storeDescriptionVal;
  EditYourStoreInformations(this.token,this.email,this.imageUrl, this.storeNameVal, this.storeCategoryVal, this.storeDescriptionVal );

  @override
  State<EditYourStoreInformations> createState() => _EditYourStoreInformationsState();
}

class _EditYourStoreInformationsState extends State<EditYourStoreInformations> with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
  String imageUrlVal="";
  String storeNameVal = "";
  String storeCategoryVal = "";
  String storeDescriptionVal = "";
  late Future<Merchant> userData;

  TextEditingController storeNameTextEditingController = TextEditingController();
  TextEditingController storeCategoryTextEditingController = TextEditingController();
  TextEditingController storeDescriptionTextEditingController = TextEditingController();

  List<String> items = ['All Stores'];
  String selectedItem = 'All Stores';

  Future<void> getAdminData() async {

    http.Response userFuture5 = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/admins-list"),
    );
    print("qqqqqqqqqqqqqqqqqqq");
    print(jsonDecode(userFuture5.body)["email"]);
    print("qqqqqqqqqqqqqqqqqqq");

    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/admin-data/${jsonDecode(userFuture5.body)["email"]}"),
    );

    print("uuuuuuuuuuuuXX");
    print(jsonDecode(userFuture.body)["allCategories"].runtimeType);
    print("uuuuuuuuuuuuXX");
    setState(() {
      List<dynamic> dynamicList = jsonDecode(userFuture.body)["allCategories"];
      List<String> stringList = dynamicList.map((element) => element.toString()).toList();

      items.addAll(stringList);
      print(items);
      print("uuuuuuuuuuuuXXXXXXXXXXXXXXXX");
    });

  }

  Future<void> getStoreData() async {

    http.Response userFuture = await http.get(
      Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}"),
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );

    setState(() {
      storeNameTextEditingController.text = jsonDecode(userFuture.body)["storeName"];
      storeDescriptionTextEditingController.text = jsonDecode(userFuture.body)["storeDescription"];
      selectedItem = jsonDecode(userFuture.body)["storeCategory"];
    });

  }

  late Map<String, dynamic> objectData;
  Future<void> addStoreToDatabase() async {

    http.Response userFuture3 = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-specific-store/${emailVal}"),

      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );

    print("YYYYYYYYYYYYYYYYY");
    // print(jsonDecode(userFuture3.body));
    print("YYYYYYYYYYYYYYYYY");

    if(userFuture3.body == ""){
      print("Store not published yet!!");
    } else {

      objectData = {
        "merchantname":jsonDecode(userFuture3.body)["merchantname"],
        "email":jsonDecode(userFuture3.body)["email"],
        "phone":jsonDecode(userFuture3.body)["phone"],
        "country":jsonDecode(userFuture3.body)["country"],
        "Avatar":jsonDecode(userFuture3.body)["Avatar"],
        "storeName": storeNameTextEditingController.text,
        "storeAvatar":jsonDecode(userFuture3.body)["storeAvatar"],
        "storeCategory":selectedItem,
        "storeSliderImages":jsonDecode(userFuture3.body)["storeSliderImages"],
        "storeProductImages":jsonDecode(userFuture3.body)["storeProductImages"],
        "storeDescription": storeDescriptionTextEditingController.text,
        "storeSocialMediaAccounts":jsonDecode(userFuture3.body)["storeSocialMediaAccounts"],
        "activateSlider":jsonDecode(userFuture3.body)["activateSlider"],
        "activateCategory":jsonDecode(userFuture3.body)["activateCategory"],
        "activateCarts":jsonDecode(userFuture3.body)["activateCarts"],
        "specificStoreCategories":jsonDecode(userFuture3.body)["specificStoreCategories"],
        "backgroundColor" : jsonDecode(userFuture3.body)["backgroundColor"],
        "boxesColor" : jsonDecode(userFuture3.body)["boxesColor"],
        "primaryTextColor" : jsonDecode(userFuture3.body)["primaryTextColor"],
        "secondaryTextColor" : jsonDecode(userFuture3.body)["secondaryTextColor"],
        "clippingColor" : jsonDecode(userFuture3.body)["clippingColor"],
        "smoothy" : jsonDecode(userFuture3.body)["smoothy"],
        "design" : jsonDecode(userFuture3.body)["design"],
        // "type":tempTypeVal,


      };

      print("UUUUUUUUUUUUUUUUU");
      print(objectData);
      print("UUUUUUUUUUUUUUUUU");


      var storeDataToAddVal = objectData;
      Map<String, dynamic> merchant = {};

      http.Response userFuture1 = await http.get(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}"),

        headers: {
          "Authorization": "Bearer $tokenVal", // Add the token to the headers
        },
      );
      setState(() {
        merchant = jsonDecode(userFuture1.body);
      });

      print(merchant["secretKey"]);
      http.Response userFuture =
      await http.post(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-add-store-to-database/$emailVal"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $tokenVal",
        },
        body: jsonEncode(
          {
            "stores": storeDataToAddVal
          },
        ),
        encoding:
        Encoding.getByName("utf-8"),
      );
      print(userFuture.body);
      // QuickAlert.show(
      //   context: context,
      //   type: QuickAlertType.success,
      //   text: "${getLang(context, 'store_published_successfully')}",
      // );
      // await notifyYourCustomers();
    }



  }


  final _formKey = GlobalKey<FormState>();

  late File _image;
  final Dio _dio = Dio();
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
      final url = 'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/store-avatar';

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
            "Authorization": "Bearer $tokenVal",
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
          imageUrlVal=response.data["data"];
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
    imageUrlVal = widget.imageUrl;
    storeNameVal = widget.storeNameVal;
    storeCategoryVal = widget.storeCategoryVal;
    storeDescriptionVal = widget.storeDescriptionVal;
    getAdminData();
    getStoreData();
    userData = getUserByName();

  }

  Future<Merchant> getUserByName() async{
    print("$emailVal tttttttttt");
    http.Response userFuture = await http.get(
      Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}"),
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );

    // print(userFuture.body[1]);

    if(userFuture.statusCode == 200){
      // print("${userFuture.body}");
      print(Merchant.fromJson(json.decode(userFuture.body)));


      return Merchant.fromJson(json.decode(userFuture.body));
    }
    else{
      throw Exception("Error");
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreManagement(tokenVal, emailVal, imageUrlVal,"","","",[],[],false,false,false)));
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF212128),
            leading: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreManagement(tokenVal, emailVal, imageUrlVal,"","","",[],[],false,false,false)));
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
            ),
            title: Text("${getLang(context, 'edit_store_informations')}", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
            centerTitle: true,
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Color(0xFF212128),
            ),
            width: double.infinity,
            height: double.infinity,

            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 2,
                      color: Colors.white,
                    ),

                    FutureBuilder<Merchant>(
                      future: userData,
                      builder: (BuildContext context, AsyncSnapshot<Merchant> snapshot) {
                        try {
                          return Container(

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20,),

                                Container(

                                  child: CircleAvatar(
                                    radius: 100,
                                    child: Stack(
                                        children:[
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(width: 3, color: Colors.white),
                                            ),
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl:imageUrlVal,
                                              placeholder: (context, url) => SimpleCircularProgressBar(
                                                mergeMode: true,
                                                animationDuration: 1,
                                              ),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                              fit: BoxFit.cover,
                                              height: double.infinity,
                                              width: double.infinity,

                                            ),
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
                                                        onPressed: _pickAndUploadImage,
                                                         icon: Icon(Icons.edit,color: Colors.white,))),
                                              )
                                          )
                                        ]
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 40),
                                  width: MediaQuery.of(context).size.width / 1.15,
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    controller: storeNameTextEditingController,
                                    //Making keyboard just for Email
                                    keyboardType: TextInputType.text,
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Store Name is required';
                                    //   }
                                    //   return null;
                                    // },
                                    decoration: InputDecoration(
                                        labelText: '${getLang(context, 'store_name')}',
                                        labelStyle: const TextStyle(color: Colors.white),
                                        prefixIcon: const Icon(
                                          Icons.storefront,
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
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  width: MediaQuery.of(context).size.width / 1.15,
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    controller: storeDescriptionTextEditingController,
                                    //Making keyboard just for Email
                                    keyboardType: TextInputType.text,
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Store Description is required';
                                    //   }
                                    //   return null;
                                    // },
                                    decoration: InputDecoration(
                                        labelText: '${getLang(context, 'store_description')}',
                                        labelStyle: const TextStyle(color: Colors.white),
                                        prefixIcon: const Icon(
                                          Icons.description,
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
                                SizedBox(height: 20,),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(width: .45,color: Colors.white)
                                  ),
                                  padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                                  width: MediaQuery.of(context).size.width / 1.15,

                                  child: DropdownButton(

                                    borderRadius: BorderRadius.circular(20),
                                    dropdownColor: Color(0xFF36363C),
                                    style: TextStyle(color: Color(0xFF212128)),
                                    value: selectedItem,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedItem = newValue!;
                                        print(selectedItem);
                                      });
                                    }, items: items.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem(
                                        value: value,
                                        child: Text(value,style: TextStyle(color: Colors.white),)
                                    );
                                  }).toList(),

                                  ),

                                ),
                                SizedBox(height: 40,),
                                Container(
                                  width: MediaQuery.of(context).size.width/2.5,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xFF0E1011),
                                  ),
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                                  child: Center(child: TextButton(onPressed: ()async{
                                    if(_formKey.currentState!.validate()){
                                      try {

                                        var storeName = storeNameTextEditingController.text;
                                        var storeCategory = selectedItem;
                                        var storeDescription = storeDescriptionTextEditingController.text;
                                        http.Response userFuture = await http.patch(
                                          Uri.parse(
                                              "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/update-store-informations/${emailVal}"),
                                          headers: { "Content-Type": "application/json",
                                            "Authorization": "Bearer $tokenVal",
                                          },
                                          body: jsonEncode(
                                            {
                                              "storeName":storeName,
                                              "storeCategory":storeCategory,
                                              "storeDescription": storeDescription,

                                            },

                                          ),
                                          encoding: Encoding.getByName("utf-8"),
                                        );
                                        print(userFuture.body);
                                        var temp = UpdateStoreInformations.fromJson(
                                            json.decode(userFuture.body));
                                        print(temp);



                                        // print(temp?.email);
                                        addStoreToDatabase();

                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          title: "${getLang(context, 'success')}",
                                          text: "${getLang(context, 'al_update_store_information')}",
                                          confirmBtnText: "${getLang(context, 'al_ok')}"
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
                                    }

                                  }, child: Text("${getLang(context, 'update')}",style: TextStyle(color: Colors.white, fontSize: 18),)),),
                                ),


                              ],
                            ),
                          );
                        }
                        catch(e){
                          return Text("err");
                        }
                      },

                    ),

                  ],
                ),
              ),
            ),
          )),
    );
  }
}
