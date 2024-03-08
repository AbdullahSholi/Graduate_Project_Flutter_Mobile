import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/models/login_model.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/imageplaceholder.dart';
import "package:http/http.dart" as http;
import "package:flutter/gestures.dart";
import 'package:image_picker/image_picker.dart';

import '../../../models/merchant/merchant_specific_store_categories.dart';
import '../../../models/merchant/merchant_store_slider_images.dart';
import '../../../models/singleUser.dart';

class EditYourStoreDesign extends StatefulWidget {
  final String token;
  final String email;
  final List<String> specificStoreCategories;
  final String storeName;
  const EditYourStoreDesign(this.token, this.email, this.specificStoreCategories, this.storeName, {super.key});
  @override
  State<EditYourStoreDesign> createState() => _EditYourStoreDesignState();
}

class _EditYourStoreDesignState extends State<EditYourStoreDesign> {
  String tokenVal = "";
  String emailVal = "";
  String imageSliderVal = "";
  List<String> specificStoreCategoriesVal = [];
  String storeNameVal="";

  late Future<User> userData;
  late Future<List> sliderImages;
  late Future<List> specificStoreCategories;
  // late indexVal="";

  // for Images Slider
  List<String> imageUrls = [];


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
      final url = 'http://10.0.2.2:3000/matjarcom/api/v1/store-slider-images';
      print("$emailVal ssssssssssssssssss");
      // Extract the file name from the path
      String fileName = _image.path.split('/').last;

      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(_image.path, filename: fileName),
        "email": emailVal,
      });
      Options options = Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          // Add any other headers if needed
        },
      );

      // Make the POST request using dio
      Response response =
          await _dio.post(url, data: formData, options: options);
      // Check the response status
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        getSliderImages();

        // print(imageSliderVal);
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    }
  }

  Future<void> insertSpecificStoreCategory() async {

      // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
      final url = 'http://10.0.2.2:3000/matjarcom/api/v1/specific-store-categories/$emailVal';
      print("$emailVal ssssssssssssssssss");
      // Extract the file name from the path

      // Create a map with your data
      Map<String, dynamic> requestData = {
        'specificStoreCategories': specificStoreCategoriesTextEditingController.text,
        "email": emailVal,
      };

      FormData formData = FormData.fromMap({
        'specificStoreCategories': specificStoreCategoriesTextEditingController.text,
        "email": emailVal,
      });
      Options options = Options(
        headers: {
          'Content-Type': 'application/json',
          // Add any other headers if needed
        },
      );

      // Make the POST request using dio
      Response response =
      await _dio.post(url, data: requestData, options: options);
      // Check the response status
      if (response.statusCode == 200) {
        print('New category inserted successfully!!');
        getSliderImages();

        // print(imageSliderVal);
      } else {
        print('Failed to insert category. Status code: ${response.statusCode}');
      }
    }

  Future<void> deleteSpecificStoreCategory(indexVal) async {

    // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
    final url = 'http://10.0.2.2:3000/matjarcom/api/v1/delete-specific-store-categories/$emailVal';
    print("$emailVal ssssssssssssssssss");
    // Extract the file name from the path
    print(indexVal);
    // Create a map with your data
    Map<String, dynamic> requestData = {
      'index': indexVal,
      "email": emailVal,
    };

    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        // Add any other headers if needed
      },
    );

    // Make the POST request using dio
    Response response =
    await _dio.delete(url, data: requestData, options: options);
    // Check the response status
    if (response.statusCode == 200) {
      print('Category Deleted Successfully!!');
      // getSliderImages();

      // print(imageSliderVal);
    } else {
      print('Failed to delete category. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteImageFromSlider(urlVal) async {

    // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
    final url = 'http://10.0.2.2:3000/matjarcom/api/v1/delete-specific-image-from-store-slider/$emailVal';
    print("$emailVal ssssssssssssssssss");
    // Extract the file name from the path
    print(url);
    // Create a map with your data
    Map<String, dynamic> requestData = {
      'url': urlVal,
      "email": emailVal,
    };

    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        // Add any other headers if needed
      },
    );

    // Make the POST request using dio
    Response response =
    await _dio.delete(url, data: requestData, options: options);
    // Check the response status
    if (response.statusCode == 200) {
      print('Category Deleted Successfully!!');
      // getSliderImages();

      // print(imageSliderVal);
    } else {
      print('Failed to delete category. Status code: ${response.statusCode}');
    }
  }

  // updateSpecificStoreCategory
  Future<void> updateSpecificStoreCategory(indexVal,specificCategoryName) async {

    // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
    final url = 'http://10.0.2.2:3000/matjarcom/api/v1/update-specific-store-categories/$emailVal';
    print("$emailVal ssssssssssssssssss");
    // Extract the file name from the path
    print(indexVal);
    // Create a map with your data
    Map<String, dynamic> requestData = {
      'index': indexVal,
      "email": emailVal,
      "specificCategoryName":specificCategoryName,
    };

    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        // Add any other headers if needed
      },
    );

    // Make the POST request using dio
    Response response =
    await _dio.patch(url, data: requestData, options: options);
    // Check the response status
    if (response.statusCode == 200) {
      print('Category Deleted Successfully!!');
      // getSliderImages();

      // print(imageSliderVal);
    } else {
      print('Failed to delete category. Status code: ${response.statusCode}');
    }
  }


  Future<List> getSliderImages() async {
    print("$emailVal tttttttttt");
    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/merchant-profile/${emailVal}"),
    );
    // print(userFuture.body);

    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");
      print(MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .storeSliderImages
          .toList());

      final List<dynamic> data =MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .storeSliderImages
          .toList();
      final List<String> urls =
      data.map((item) => item.toString()).toList();
      print("wwwwwwwwwwwwwwwwww $urls ");
      setState(() {
        imageUrls = urls;
      });

      return MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .storeSliderImages
          .toList();
    } else {
      print("error");
      throw Exception("Error");
    }
  }

  Future<List> getSpecificStoreCategories() async {
    print("$emailVal ppppp");
    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/merchant-profile/${emailVal}"),
    );
    // print(userFuture.body);

    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");
      print(MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .specificStoreCategories
          .toList());

      final List<dynamic> data =MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .specificStoreCategories
          .toList();
      final List<String> urls =
      data.map((item) => item.toString()).toList();
      print("ooooooooooooooo $urls ");
      setState(() {
        specificStoreCategoriesVal = urls;
      });


      return MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .specificStoreCategories
          .toList();
    } else {
      print("error");
      throw Exception("Error");
    }
  }


  // Future<List> getSpecificStoreCategories() async {
  //   print("$emailVal tttttttttt");
  //   http.Response userFuture = await http.get(
  //     Uri.parse(
  //         "http://10.0.2.2:3000/matjarcom/api/v1/merchant-profile/${emailVal}"),
  //   );
  //   // print(userFuture.body);
  //
  //   if (userFuture.statusCode == 200) {
  //     // print("${userFuture.body}");
  //     print(MerchantSpecificStoreCategories.fromJson(json.decode(userFuture.body))
  //         .specificStoreCategories
  //         .toList());
  //
  //     final List<dynamic> data =MerchantSpecificStoreCategories.fromJson(json.decode(userFuture.body))
  //         .specificStoreCategories
  //         .toList();
  //     final List<String> urls =
  //     data.map((item) => item.toString()).toList();
  //     print("wwwwwwwwwwwwwwwwww $urls ");
  //     setState(() {
  //       imageUrls = urls;
  //     });
  //
  //     return MerchantSpecificStoreCategories.fromJson(json.decode(userFuture.body))
  //         .specificStoreCategories
  //         .toList();
  //   } else {
  //     print("error");
  //     throw Exception("Error");
  //   }
  // }

  /////////////////////

  // Search
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  ////////

  /////
  // Visibility
  bool sliderVisibility = true;
  bool customizeVisibility = false;
  bool categoryVisibility = true;
  bool cartsVisibility = true;

  ////

  /////////
  // related to merchant customize button widgets
  List<Widget> containers = [
    Container(),
  ];
  List<Widget> containersCarts = [];

  /////////

  ////////
  // Specific Category
  TextEditingController specificStoreCategoriesTextEditingController = TextEditingController();

  ////////

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tokenVal = widget.token;
    emailVal = widget.email;
    specificStoreCategoriesVal = widget.specificStoreCategories;
    storeNameVal = widget.storeName;
    print(emailVal);
    // userData = getUserByName();
    sliderImages = getSliderImages();
    specificStoreCategories = getSpecificStoreCategories();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Builder(
      //     builder: (BuildContext context) {
      //       return IconButton(
      //         icon: const Icon(Icons.menu,color: Colors.white,), // Replace with your desired icon
      //         onPressed: () {
      //           Scaffold.of(context).openDrawer(); // Opens the drawer
      //         },
      //         tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      //       );
      //     },
      //   ),
      //   backgroundColor: Color(0xFF212128),
      //   title: Text("ElectroHub",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      //   centerTitle: true,
      //   actions: [
      //     Icon(Icons.search,size: 30,color: Colors.white,),
      //     SizedBox(width: 10,),
      //   ],
      // ),

      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height / 20, 20, 0),
                    decoration: BoxDecoration(
                        color: Color(0xFF212128),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // color:Colors.blue,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        Center(
                            child: Text(
                          storeNameVal,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        )),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isSearching = !_isSearching;
                                  if (!_isSearching) {
                                    _searchController.clear();
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.search,
                                size: 30,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _isSearching,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 20, 0, 2),
                      decoration: BoxDecoration(
                        color: Color(0xFF212128),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      height: 40,
                      child: _isSearching
                          ? TextField(
                              cursorColor: Colors.white,
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(color: Colors.white),
                              onChanged: (query) {
                                // Handle search query changes
                              },
                            )
                          : null,
                    ),
                  ),
                  FutureBuilder<List>(
                      future: sliderImages,
                      builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        return Container(
                          // color: Colors.blue,
                          height: MediaQuery.of(context).size.height / 1.235,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            // color: Colors.cyan
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Visibility(
                                  visible: sliderVisibility,
                                  child: Column(children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Slider",
                                            style: TextStyle(
                                                color: Color(0xFF212128),
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Color(0xFF3B3B47),
                                            child: IconButton(
                                              onPressed: _pickAndUploadImage,
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    FutureBuilder<List>(
                                      future: sliderImages,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List> snapshot) {
              
                                        return Container(
              
                                          child: CarouselSlider(
                                            options: CarouselOptions(
                                              // clipBehavior: ,
                                              autoPlay: true,
                                              height: 200.0,
                                              aspectRatio: 5,
                                              enlargeCenterPage: true,

                                            ),
                                            items: imageUrls.map((url) {
                                              return Builder(
                                                builder: (BuildContext context) {
                                                  return Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: InkWell(
                                                        onTap: (){
                                                          showDialog(context: context, builder: (context)=>AlertDialog(
                                                            backgroundColor: Color(0xFF212128),
                                                            title: Text("Delete image ",style: TextStyle(color: Colors.white),),
                                                            content: Container(
                                                              height:MediaQuery.of(context).size.height/18,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Delete this image from slider",style: TextStyle(color: Colors.white),),
                                                                  SizedBox(height: 20,),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(onPressed: () async {
                                                                print(111111111);
                                                                print("$url ytytytyty");
                                                                print(33333333333);
                                                                await deleteImageFromSlider(url);
                                                                await getSliderImages();
                                                              }, child: Text("Delete",style: TextStyle(color: Colors.white),)),
                                                              SizedBox(width: 20,),
                                                              TextButton(onPressed: (){
                                                                Navigator.pop(context);
                                                              }, child: Text("Cancel",style: TextStyle(color: Colors.white),))
                                                            ],
                                                          ));
                                                        },
                                                        child: CachedNetworkImage(
                                                          imageUrl: url,
                                                          placeholder: (context, url) => CircularProgressIndicator(),
                                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        );
              
                                      },
                                    ),
              
                                  ]),
                                ),
                                SizedBox(height: 15,),
                                Visibility(
                                  visible: categoryVisibility,
                                  child: Column(children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Category",
                                            style: TextStyle(
                                                color: Color(0xFF212128),
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Color(0xFF3B3B47),
                                            child: IconButton(
                                              onPressed: defaultCategoryContainer,
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    FutureBuilder<List>(
                                      future: specificStoreCategories,
                                      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                                        // print(snapshot.data);
                                        return Container(
                                          width: MediaQuery.of(context).size.width /
                                              1.13,
                                          height: 50,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: specificStoreCategoriesVal.length,
                                            itemBuilder: (context, index) => Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Color(0xFF212128),
                                                ),
                                                width: 120,
                                                child: TextButton(
                                                    onPressed: () {
                                                      print(index);
                                                      showDialog(context: context, builder: (context){
                                                        return AlertDialog(
                                                          title: Text("Edit your category",style: TextStyle(color: Colors.white),),
                                                          backgroundColor:Color(0xff212128),
                                                          content: Container(
                                                            height: MediaQuery.of(context).size.height/9,
                                                            child: Column(
                                                              children: [
                                                                SizedBox(height: 20,),
                                                                TextFormField(
                                                                  cursorColor: Colors.white,
                                                                  style: TextStyle(color: Colors.white),
                                                                  controller: specificStoreCategoriesTextEditingController,
                                                                  //Making keyboard just for Email
                                                                  keyboardType: TextInputType.emailAddress,
                                                                  validator: (value){
                                                                    if(value!.isEmpty){
                                                                      return 'Category is required';
                                                                    }
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      labelText: 'Category name',
                                                                      labelStyle: TextStyle(color: Colors.white),
                                                                      prefixIcon: Icon(
                                                                        Icons.category_outlined,color: Colors.white,
                                                                      ),
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide(color: Colors.white, )
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(color: Colors.white, )
                                                                      )
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          actions:  [
                                                            TextButton(onPressed: () async {
                                                                await updateSpecificStoreCategory(index,specificStoreCategoriesTextEditingController.text);
                                                                await getSpecificStoreCategories();

                                                            }, child: Text("Update",style: TextStyle(color: Colors.white),)),
                                                            TextButton(onPressed: () async {
                                                              await deleteSpecificStoreCategory(index);
                                                              await getSpecificStoreCategories();

                                                            }, child: Text("Delete",style: TextStyle(color: Colors.white),)),

                                                          ],

                                                        );
                                                      });
                                                    },
                                                    child: Text(
                                                      specificStoreCategoriesVal[index],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ))),
                                            separatorBuilder: (context, index) =>
                                                SizedBox(
                                                  width: 5,
                                                ),
                                          ),
                                        );
                                      },

                                    )
                                  ]),
                                ),
                                Column(
                                  children: [
              
                                    Visibility(
                                      visible: cartsVisibility,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Carts",
                                                  style: TextStyle(
                                                      color: Color(0xFF212128),
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor: Color(0xFF3B3B47),
                                                  child: IconButton(
                                                    onPressed: defaultCartContainer,
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            height:
                                                MediaQuery.of(context).size.height /
                                                    1,
                                            child: GridView.builder(
                                              scrollDirection: Axis.vertical,
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                    2, // Set the number of columns
                                                childAspectRatio:
                                                    0.75, // Customize the aspect ratio (width/height) of each tile
                                                mainAxisSpacing:
                                                    4.0, // Spacing between rows
                                                crossAxisSpacing:
                                                    2.0, // Spacing between columns
                                              ),
                                              itemBuilder: (context, index) =>
                                                  containersCarts[index],
                                              itemCount: containersCarts.length,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BottomNavigationBar(
                  backgroundColor: Color(0xFF212128),
                  onTap: (index) {
                    print(index);
                    if (index == 0) {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(tokenVal,emailVal)));
                    } else if (index == 1) {
                      setState(() {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  contentPadding: EdgeInsets.all(0),
                                  content: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    // width: 50,
                                    // margin: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Colors.red,width: 5),
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xFF212128),
                                    ),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 20, 20, 0),
                                            alignment: Alignment.center,
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    5) /
                                                8,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                            ),
                                            child: Text(
                                              "Activate Components",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.federo(
                                                color: Color(0xFF212128),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.white,
                                          height: 2,
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              20, 30, 10, 10),
                                          child: Row(children: [
                                            Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      2) /
                                                  5,
                                              child: Text(
                                                "Activate Slider",
                                                style: GoogleFonts.federo(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.green,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      sliderVisibility = true;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.done,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  20,
                                            ),
                                            CircleAvatar(
                                              backgroundColor: Colors.red,
                                              radius: 20,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      sliderVisibility = false;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ]),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.fromLTRB(
                                              20, 30, 10, 10),
                                          child: Row(children: [
                                            Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      2) /
                                                  5,
                                              child: Text(
                                                "Activate Category",
                                                style: GoogleFonts.federo(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.green,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      categoryVisibility = true;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.done,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  20,
                                            ),
                                            CircleAvatar(
                                              backgroundColor: Colors.red,
                                              radius: 20,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      categoryVisibility =
                                                          false;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ]),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.fromLTRB(
                                              20, 30, 10, 10),
                                          child: Row(children: [
                                            Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      2) /
                                                  5,
                                              child: Text(
                                                "Activate Carts",
                                                style: GoogleFonts.federo(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.green,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      cartsVisibility = true;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.done,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  20,
                                            ),
                                            CircleAvatar(
                                              backgroundColor: Colors.red,
                                              radius: 20,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      cartsVisibility = false;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                      });
                    } else if (index == 2) {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> MyProfilePage(tokenVal, emailVal)));
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
                        Icons.edit,
                        color: Colors.white,
                      ),
                      label: 'Customize',
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
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.all(20),
      //
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(20),
      //     child: BottomNavigationBar(
      //       backgroundColor: Color(0xFF212128),
      //
      //       items: [
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.home,color: Colors.white,),
      //           label: 'Home',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.favorite,color: Colors.white,),
      //           label: 'Favourite',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.person,color: Colors.white,),
      //           label: 'Profile',
      //         ),
      //     ],
      //       selectedItemColor: Colors.white,
      //         unselectedItemColor: Color(0xFF717389),
      //
      //
      //     ),
      //   ),
      // )
    );
  }

  void defaultCategoryContainer() {
    setState(() {

      showDialog(context: context, builder: (context)=>AlertDialog(
        backgroundColor: Color(0xFF212128),
        title: Text("Category name",style: TextStyle(color: Colors.white),),
        content: Container(

          height: MediaQuery.of(context).size.height / 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter Your Store Categories ",textAlign: TextAlign.left,style: TextStyle(color: Colors.white),),
              SizedBox(height: 30,),
              Container(
                width: MediaQuery.of(context).size.width/1.3,
                child: TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  controller: specificStoreCategoriesTextEditingController,
                  //Making keyboard just for Email
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Category is required';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Category name',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.category_outlined,color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, )
                      )
                  ),
                ),
              ),
            ],
          ),

        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel",style: TextStyle(color: Colors.white),)),
          TextButton(
            onPressed: () async {
              setState(() async {
                await insertSpecificStoreCategory();
                await getSpecificStoreCategories();
                showDialog(context: context, builder: (context)=> AlertDialog(
                  backgroundColor: Color(0xFF212128),
                  icon: Icon(Icons.info,color: Colors.green,size: 15,),
                  title: Text("Information Message",style: TextStyle(color: Colors.white),),
                  content: Text("Category added Successfully!!",style: TextStyle(color: Colors.white),),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("OK",style: TextStyle(color: Colors.white),))
                  ],
                ));
                specificStoreCategoriesTextEditingController.clear();
              });
            },
            child: Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ));

    });
  }

  void defaultCartContainer() {
    setState(() {
      containersCarts.add(Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    color: Color(0xF2222128),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    child: Image.network(
                      "https://th.bing.com/th/id/R.2cdd64d3370db75b36e9b02259d1832a?rik=w2QxlPJgMEIzXQ&pid=ImgRaw&r=0",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 120,
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   child: Container(
                //     margin: EdgeInsets.fromLTRB(4, 0, 0, 10),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(3),
                //       color: Colors.red,
                //     ),
                //
                //     width: 60,
                //     height: 20,
                //     child: Container(
                //
                //       padding: const EdgeInsets.all(2.0),
                //       child: Text("DISCOUNT",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),
                //     ),
                //   ),
                // ),
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    color: Color(0xF2222128),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 8, 10, 6),
                        child: Text("",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 2, 0),
                            child: Text("",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text("",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 3,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ));
    });
  }


}
