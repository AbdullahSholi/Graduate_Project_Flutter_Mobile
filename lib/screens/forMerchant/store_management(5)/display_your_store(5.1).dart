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
import 'package:graduate_project/models/merchant/cart_content_model.dart';
import 'package:graduate_project/models/merchant/merchant_connect_store_to_social_media.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_store_informations(5.3).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/edit_your_store_design(5.2).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/imageplaceholder.dart';
import "package:http/http.dart" as http;
import "package:flutter/gestures.dart";
import 'package:image_picker/image_picker.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../models/merchant/get_cart_content_model.dart';
import '../../../models/merchant/merchant_specific_store_categories.dart';
import '../../../models/merchant/merchant_store_slider_images.dart';
import '../../../models/singleUser.dart';
import '../merchant_home_page(3)/merchant_home_page.dart';

class DisplayYourStore extends StatefulWidget {
  final String token;
  final String email;
  final List<String> specificStoreCategories;
  final String storeName;
  final List<dynamic> storeCartsVal;
  final bool sliderVisibility;
  final bool categoryVisibility;
  final bool cartsVisibility;
  const DisplayYourStore(
      this.token, this.email, this.specificStoreCategories, this.storeName, this.storeCartsVal, this.sliderVisibility, this.categoryVisibility, this.cartsVisibility,
      {super.key});
  @override
  State<DisplayYourStore> createState() => _DisplayYourStoreState();
}

class _DisplayYourStoreState extends State<DisplayYourStore> {
  String tokenVal = "";
  String emailVal = "";
  String imageSliderVal = "";
  List<String> specificStoreCategoriesVal = [];
  List<dynamic> storeCartsVal= [];
  String storeNameVal = "";
  late bool sliderVisibilityVal ;
  late bool categoryVisibilityVal ;
  late bool cartsVisibilityVal ;

  late Future<User> userData;
  late Future<List> sliderImages;
  late Future<List> specificStoreCategories;
  late Future<List> getCartContent;
  // late indexVal="";

  // for Images Slider
  List<String> imageUrls = [];
  List<String> cartImageUrls = [];

  double tempSearchBoxHeight = 0;
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
          "Authorization": "Bearer $tokenVal",
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
  Future<void> _pickAndUploadImageForCart(index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
      final url = 'http://10.0.2.2:3000/matjarcom/api/v1/cart-upload-primary-image';
      print("$emailVal ssssssssssssssssss");
      // Extract the file name from the path
      String fileName = _image.path.split('/').last;

      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(_image.path, filename: fileName),
        "email": emailVal,
        "index":index,
      });
      Options options = Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          "Authorization": "Bearer $tokenVal",
          // Add any other headers if needed
        },
      );

      // Make the POST request using dio
      Response response =
      await _dio.post(url, data: formData, options: options);
      // Check the response status
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        setState(() {
          getSpecificStoreCart();
        });


        // print(imageSliderVal);
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    }
  }
  Future<void> _pickAndUploadImageForCartSlider(index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
      final url = 'http://10.0.2.2:3000/matjarcom/api/v1/cart-upload-secondary-images';
      print("$emailVal ssssssssssssssssss");
      // Extract the file name from the path
      String fileName = _image.path.split('/').last;

      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(_image.path, filename: fileName),
        "email": emailVal,
        "index":index,
      });
      Options options = Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          "Authorization": "Bearer $tokenVal",
          // Add any other headers if needed
        },
      );

      // Make the POST request using dio
      Response response =
      await _dio.post(url, data: formData, options: options);
      // Check the response status
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        await getSpecificStoreCartSliderImages();

        // print(imageSliderVal);
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    }
  }


  Future<void> insertSpecificStoreCategory() async {
    // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
    final url =
        'http://10.0.2.2:3000/matjarcom/api/v1/specific-store-categories/$emailVal';
    print("$emailVal ssssssssssssssssss");
    // Extract the file name from the path

    // Create a map with your data
    Map<String, dynamic> requestData = {
      'specificStoreCategories':
      specificStoreCategoriesTextEditingController.text,
      "email": emailVal,
    };

    FormData formData = FormData.fromMap({
      'specificStoreCategories':
      specificStoreCategoriesTextEditingController.text,
      "email": emailVal,
    });
    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $tokenVal",
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
    final url =
        'http://10.0.2.2:3000/matjarcom/api/v1/delete-specific-store-categories/$emailVal';
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
        "Authorization": "Bearer $tokenVal",
        // Add any other headers if needed
      },
    );
    int counter = 0;
    for(int i = 0 ; i < storeCartsVal.length; i++){
      if(storeCartsVal[i]["cartCategory"] == specificStoreCategoriesVal[indexVal]){
        ++counter;
      }

    }
    if(counter==0){
      // Make the POST request using dio
      Response response =
      await _dio.delete(url, data: requestData, options: options);
      // Check the response status
      if (response.statusCode == 200) {
        print('Category Deleted Successfully!!');
        showDialog(context: context, builder: (context)=>const AlertDialog(
          backgroundColor: Color(0xFF212128),
          title: Text("Success",style: TextStyle(color: Colors.white),),
          content: Text("Category Deleted Successfully!!",
            style: TextStyle(color: Colors.white),),
        ));

        // getSliderImages();

        // print(imageSliderVal);
      } else {
        print('Failed to delete category. Status code: ${response.statusCode}');
      }
    }
    else {
      showDialog(context: context, builder: (context)=>const AlertDialog(
        backgroundColor: Color(0xFF212128),
        title: Text("Failed",style: TextStyle(color: Colors.white),),
        content: Text("Unable to Delete This category because it's connected with differen carts",
          style: TextStyle(color: Colors.white),),
      ));
    }

  }

  Future<void> deleteImageFromSlider(urlVal) async {
    // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
    final url =
        'http://10.0.2.2:3000/matjarcom/api/v1/delete-specific-image-from-store-slider/$emailVal';
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
        "Authorization": "Bearer $tokenVal",
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
  Future<void> deleteImageFromCartImagesSlider(urlVal,index) async {
    // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
    final url =
        'http://10.0.2.2:3000/matjarcom/api/v1/delete-specific-image-from-cart-image-slider/$emailVal';
    print("$emailVal ssssssssssssssssss");
    // Extract the file name from the path
    print(url);
    // Create a map with your data
    Map<String, dynamic> requestData = {
      'url': urlVal,
      "email": emailVal,
      "index":index
    };

    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $tokenVal",
        // Add any other headers if needed
      },
    );

    // Make the POST request using dio
    Response response =
    await _dio.delete(url, data: requestData, options: options);
    // Check the response status
    if (response.statusCode == 200) {
      print('Category Deleted Successfully!!');
      await getSpecificStoreCartSliderImages();
      // getSliderImages();

      // print(imageSliderVal);
    } else {
      print('Failed to delete category. Status code: ${response.statusCode}');
    }
  }


  // updateSpecificStoreCategory
  Future<void> updateSpecificStoreCategory(
      indexVal, specificCategoryName) async {
    // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
    final url =
        'http://10.0.2.2:3000/matjarcom/api/v1/update-specific-store-categories/$emailVal';
    print("$emailVal ssssssssssssssssss");
    // Extract the file name from the path
    print(indexVal);
    // Create a map with your data
    Map<String, dynamic> requestData = {
      'index': indexVal,
      "email": emailVal,
      "specificCategoryName": specificCategoryName,
    };

    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $tokenVal",
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
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );
    // print(userFuture.body);

    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");
      print(MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .storeSliderImages
          .toList());

      final List<dynamic> data =
      MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .storeSliderImages
          .toList();
      final List<String> urls = data.map((item) => item.toString()).toList();
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
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );
    // print(userFuture.body);

    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");
      print(MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .specificStoreCategories
          .toList());

      final List<dynamic> data =
      MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .specificStoreCategories
          .toList();
      final List<String> urls = data.map((item) => item.toString()).toList();
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

  //////////////////////////

  Future<List<dynamic>> getSpecificStoreCart() async {
    print("--------------------------");
    print(emailVal);

    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/test-get-merchant-cart/${emailVal}"),
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );
    print(userFuture.body);
    var temp = GetCartContentModel.fromJson(json.decode(userFuture.body)).type.toList();


    setState(() {
      storeCartsVal = GetCartContentModel
          .fromJson(json.decode(userFuture.body))
          .type.toList();
      print("vvvvvvvvvvvv $storeCartsVal");
    });
    return GetCartContentModel.fromJson(json.decode(userFuture.body)).type.toList();

  }

  Future<void> activateStoreSlider() async {
    // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
    final url =
        'http://10.0.2.2:3000/matjarcom/api/v1/activate-store-slider/$emailVal';
    print("$emailVal ssssssssssssssssss");
    // Extract the file name from the path
    print(sliderVisibilityVal);
    // Create a map with your data
    Map<String, dynamic> requestData = {
      'activateSlider': sliderVisibilityVal,
      "email": emailVal,
    };

    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
          "Authorization": "Bearer $tokenVal", // Add the token to the headers
        // Add any other headers if needed
      },
    );

    // Make the POST request using dio
    Response response =
    await _dio.patch(url, data: requestData, options: options);
    // Check the response status
    if (response.statusCode == 200) {
      print('Slider Activate');
      // getSliderImages();
      setState(() {

      });

      // print(imageSliderVal);
    } else {
      print('Failed to insert category. Status code: ${response.statusCode}');
    }
  }
  Future<void> activateStoreCategory() async {
    // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
    final url =
        'http://10.0.2.2:3000/matjarcom/api/v1/activate-store-category/$emailVal';
    print("$emailVal ssssssssssssssssss");
    // Extract the file name from the path

    // Create a map with your data
    Map<String, dynamic> requestData = {
      'activateCategory': categoryVisibilityVal,
      "email": emailVal,
    };

    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $tokenVal",
        // Add any other headers if needed
      },
    );

    // Make the POST request using dio
    Response response =
    await _dio.patch(url, data: requestData, options: options);
    // Check the response status
    if (response.statusCode == 200) {
      print('Category Activate');
      // getSliderImages();
      setState(() {

      });

      // print(imageSliderVal);
    } else {
      print('Failed to insert category. Status code: ${response.statusCode}');
    }
  }
  Future<void> activateStoreCarts() async {
    // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
    final url =
        'http://10.0.2.2:3000/matjarcom/api/v1/activate-store-carts/$emailVal';
    print("$emailVal ssssssssssssssssss");
    // Extract the file name from the path
    print(cartsVisibilityVal);
    // Create a map with your data
    Map<String, dynamic> requestData = {
      'activateCarts': cartsVisibilityVal,
      "email": emailVal,
    };

    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $tokenVal",
        // Add any other headers if needed
      },
    );

    // Make the POST request using dio
    Response response =
    await _dio.patch(url, data: requestData, options: options);
    // Check the response status
    if (response.statusCode == 200) {
      print('Slider Activate');
      // getSliderImages();
      setState(() {

      });

      // print(imageSliderVal);
    } else {
      print('Failed to insert category. Status code: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getSpecificStoreCartSliderImages() async {
    print("--------------------------");
    print(emailVal);

    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/test-get-merchant-cart/${emailVal}"),
      headers: {
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
      },
    );
    print(userFuture.body);
    var temp = GetCartContentModel.fromJson(json.decode(userFuture.body)).type.toList();


    setState(() {
      storeCartsVal = GetCartContentModel
          .fromJson(json.decode(userFuture.body))
          .type.toList();
      print("vvvvvvvvvvvv $storeCartsVal");
    });
    return storeCartsVal;

  }

  Future<void> deleteCart(index) async {
    // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
    final url =
        'http://10.0.2.2:3000/matjarcom/api/v1/delete-cart/$emailVal';
    print("$emailVal ssssssssssssssssss");
    // Extract the file name from the path
    print(url);
    // Create a map with your data
    Map<String, dynamic> requestData = {
      'index': index,
      "email": emailVal,
    };

    Options options = Options(
      headers: {
        'Content-Type': 'application/json',
          "Authorization": "Bearer $tokenVal", // Add the token to the headers
        // Add any other headers if needed
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
      setState(() async {
        // storeCartsVal = await getSpecificStoreCart();
        await getSpecificStoreCart();
      });
      // print(imageSliderVal);
    } else {
      print('Failed to delete category. Status code: ${response.statusCode}');
    }
  }

  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  ////////

  /////
  // Visibility
  // bool sliderVisibility = true;
  bool customizeVisibility = false;
  // bool categoryVisibility = true;
  // bool cartsVisibility = true;

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
  TextEditingController specificStoreCategoriesTextEditingController =
  TextEditingController();

  // Specific Cart

  TextEditingController cartNameTextEditingController = TextEditingController();
  TextEditingController cartPriceTextEditingController =
  TextEditingController();
  bool cartDiscountBool = false;
  bool cartLikedBool = false;
  bool cartFavouriteBool = false;
  TextEditingController cartPriceAfterDiscountTextEditingController =
  TextEditingController();
  TextEditingController cartDescriptionTextEditingController =
  TextEditingController();
  TextEditingController cartCategoryTextEditing = TextEditingController();
  TextEditingController cartQuantitiesTextEditingController = TextEditingController();

  late String dropdownValue= 'All Products' ;


  ////////

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tokenVal = widget.token;
    emailVal = widget.email;
    specificStoreCategoriesVal = widget.specificStoreCategories;
    storeNameVal = widget.storeName;
    storeCartsVal = widget.storeCartsVal.toList();
    print(emailVal);
    // userData = getUserByName();
    sliderImages = getSliderImages();
    specificStoreCategories = getSpecificStoreCategories();
    getCartContent = getSpecificStoreCart();
    sliderVisibilityVal = widget.sliderVisibility;
    categoryVisibilityVal = widget.categoryVisibility;
    cartsVisibilityVal = widget.cartsVisibility;



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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreManagement(tokenVal, emailVal, "", storeNameVal, "", "", specificStoreCategoriesVal, storeCartsVal, sliderVisibilityVal, categoryVisibilityVal, cartsVisibilityVal)));
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
                                  if(_isSearching){
                                    tempSearchBoxHeight = 40;
                                  }else{
                                    tempSearchBoxHeight = 0;
                                  }

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
                  AnimatedOpacity(
                    opacity: _isSearching ? 1 : 0,
                    duration: Duration(milliseconds: 700),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 700),
                      padding: EdgeInsets.fromLTRB(10, 20, 0, 2),
                      decoration: BoxDecoration(
                        color: Color(0xFF212128),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      height: tempSearchBoxHeight,
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
                                  visible: sliderVisibilityVal,
                                  child: Column(children: [
                                    SizedBox(
                                      height: 5,
                                    ),

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
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                      child: CachedNetworkImage(
                                                        imageUrl: url,
                                                        placeholder: (context,
                                                            url) =>
                                                            SimpleCircularProgressBar(
                                                              mergeMode: true,
                                                              animationDuration: 1,
                                                            ),
                                                        errorWidget: (context,
                                                            url, error) =>
                                                            Icon(Icons.error),
                                                        fit: BoxFit.cover,
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
                                SizedBox(
                                  height: 15,
                                ),
                                Visibility(
                                  visible: categoryVisibilityVal,
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

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    FutureBuilder<List>(
                                      future: specificStoreCategories,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List> snapshot) {

                                        return Container(

                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              1.13,
                                          height: 50,

                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                            specificStoreCategoriesVal
                                                .length,
                                            itemBuilder: (context, index) =>
                                                Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                      color: Color(0xFF212128),
                                                    ),
                                                    width: 120,
                                                    child: TextButton(
                                                        onPressed: () {

                                                        },
                                                        child: Text(
                                                          specificStoreCategoriesVal[
                                                          index],
                                                          style: TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontSize: 15),
                                                        ))),
                                            separatorBuilder:
                                                (context, index) => SizedBox(
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
                                      visible: cartsVisibilityVal,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 10, 20, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Carts",
                                                  style: TextStyle(
                                                      color: Color(0xFF212128),
                                                      fontSize: 24,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),

                                              ],
                                            ),
                                          ),
                                          FutureBuilder<List>(

                                            future: getCartContent,
                                            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                                              // print("zzzzz ${storeCartsVal[0]["cartName"]}");
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    1,
                                                child: GridView.builder(
                                                  scrollDirection: Axis.vertical,
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
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
                                                  // storeCartsVal[index]
                                                  itemBuilder: (context, index) => Container(
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
                                                                child: (storeCartsVal[index]["cartPrimaryImage"].toString() == "null" || storeCartsVal[index]["cartPrimaryImage"].toString() == "") ? Image.network(
                                                                  "https://th.bing.com/th/id/R.2cdd64d3370db75b36e9b02259d1832a?rik=w2QxlPJgMEIzXQ&pid=ImgRaw&r=0" ,
                                                                  fit: BoxFit.cover,
                                                                  width: double.infinity,
                                                                  height: 120,
                                                                ): Image.network(
                                                                  storeCartsVal[index]["cartPrimaryImage"].toString(),
                                                                  fit: BoxFit.cover,
                                                                  width: double.infinity,
                                                                  height: 120,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              bottom: 0,
                                                              left: 0,
                                                              child: storeCartsVal[index]["cartDiscount"].toString() == "true" ? Container(
                                                                margin: EdgeInsets.fromLTRB(4, 0, 0, 10),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(3),
                                                                  color: Colors.red,
                                                                ),

                                                                width: 60,
                                                                height: 20,
                                                                child: Container(

                                                                  padding: const EdgeInsets.all(2.0),
                                                                  child: Text("DISCOUNT",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),
                                                                ),
                                                              ) : Container(),
                                                            ),
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
                                                                    padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                                                                    child: Text("${storeCartsVal[index]["cartName"].toString()}",
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 1,
                                                                        style: TextStyle(
                                                                          fontSize: 22,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.white,
                                                                        )),
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.fromLTRB(10, 8, 10, 3),
                                                                    child: Text("${storeCartsVal[index]["cartDescription"].toString()}",
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
                                                                        child: Text("${storeCartsVal[index]["cartPrice"].toString()}",
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
                                                                        child: "${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}"=="null" ? Text("") : Text("${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}",
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
                                                  )
                                                  ,
                                                  itemCount: storeCartsVal.length,
                                                ),
                                              );
                                            },

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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MerchantHome(tokenVal, emailVal)));
                    } else if (index == 1) {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> EditYourStoreDesign(tokenVal,emailVal,specificStoreCategoriesVal,storeNameVal, storeCartsVal,sliderVisibilityVal,categoryVisibilityVal,cartsVisibilityVal)));
                    } else if (index == 2) {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DisplayStoreInformations(tokenVal, emailVal)));
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
                      label: 'Edit',
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
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Color(0xFF212128),
            title: Text(
              "Category name",
              style: TextStyle(color: Colors.white),
            ),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter Your Store Categories ",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      controller:
                      specificStoreCategoriesTextEditingController,
                      //Making keyboard just for Email
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Category is required';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Category name',
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.category_outlined,
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
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                onPressed: () async {
                  setState(() async {
                    await insertSpecificStoreCategory();
                    await getSpecificStoreCategories();
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color(0xFF212128),
                          icon: Icon(
                            Icons.info,
                            color: Colors.green,
                            size: 15,
                          ),
                          title: Text(
                            "Information Message",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            "Category added Successfully!!",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white),
                                ))
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
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Color(0xFF212128),
            title: Text(
              "Cart content",
              style: TextStyle(color: Colors.white),
            ),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  print("bbbbbbb $specificStoreCategoriesVal");
                  return Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter Your Store Carts ",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            children: [

                              Container(
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  controller: cartNameTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Cart Name is required';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Cart name',
                                      labelStyle:
                                      TextStyle(color: Colors.white),
                                      prefixIcon: Icon(
                                        Icons.category_outlined,
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
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  controller: cartPriceTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Cart Price is required';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Cart price',
                                      labelStyle:
                                      TextStyle(color: Colors.white),
                                      prefixIcon: Icon(
                                        Icons.price_change,
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
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  controller: cartQuantitiesTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Cart Quantities is required';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Cart Quantities',
                                      labelStyle:
                                      TextStyle(color: Colors.white),
                                      prefixIcon: Icon(
                                        Icons.production_quantity_limits,
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
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  controller:
                                  cartDescriptionTextEditingController,
                                  //Making keyboard just for Email
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Cart Descrption is required';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Cart description',
                                      labelStyle:
                                      TextStyle(color: Colors.white),
                                      prefixIcon: Icon(
                                        Icons.description,
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
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: DropdownButton<String>(
                                      value: dropdownValue ,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;

                                        });
                                      },
                                      items: specificStoreCategoriesVal.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(

                                          value: value,
                                          child: Text(value,style: TextStyle(color: Colors.white,),),
                                        );
                                      }).toList(),
                                      dropdownColor: Color(0xFF212128),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: Text(
                                        'Activate Discount',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Checkbox(
                                      value: cartDiscountBool,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          cartDiscountBool = value!;
                                          print(cartDiscountBool);
                                        });
                                      },
                                      checkColor: Colors.blue,
                                      activeColor: Colors.blue,
                                      // Color when checked
                                      fillColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: Text(
                                        'Activate Like',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Checkbox(
                                      value: cartLikedBool,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          cartLikedBool = value!;
                                          print(cartLikedBool);
                                        });
                                      },
                                      checkColor: Colors.blue,
                                      activeColor: Colors.blue,
                                      // Color when checked
                                      fillColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: Text(
                                        'Activate Favourite',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Checkbox(
                                      value: cartFavouriteBool,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          cartFavouriteBool = value!;
                                          print(cartFavouriteBool);
                                        });
                                      },
                                      checkColor: Colors.blue,
                                      activeColor: Colors.blue,
                                      // Color when checked
                                      fillColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextButton(
                                  onPressed: () async {
                                    try {

                                      http.Response userFuture =
                                      await http.post(
                                        Uri.parse(
                                            "http://10.0.2.2:3000/matjarcom/api/v1/test-specific-cart/$emailVal"),
                                        headers: {
                                          "Content-Type": "application/json",
                                          "Authorization": "Bearer $tokenVal",
                                        },
                                        body: jsonEncode(
                                          {
                                            "email": emailVal,
                                            "cartName":
                                            cartNameTextEditingController
                                                .text,
                                            "cartPrice":
                                            cartPriceTextEditingController
                                                .text,
                                            "cartDiscount": cartDiscountBool,
                                            "cartLiked": cartLikedBool,
                                            "cartFavourite": cartFavouriteBool,
                                            "cartDescription":
                                            cartDescriptionTextEditingController
                                                .text,
                                            "cartCategory":dropdownValue.toString(),
                                            "cartQuantities":cartQuantitiesTextEditingController.text
                                          },
                                        ),
                                        encoding: Encoding.getByName("utf-8"),
                                      );
                                      print(userFuture.body);
                                      var temp = CartContentModel.fromJson(
                                          json.decode(userFuture.body));
                                      print(temp.message);
                                      setState(() async {
                                        // storeCartsVal = await getSpecificStoreCart();
                                        await getSpecificStoreCart();
                                      });

                                      // print(temp?.email);
                                    } catch (error) {}
                                  },
                                  child: Text(
                                    "Add Cart",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF212128)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ));

    });
  }
}
