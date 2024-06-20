import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
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

import '../../../../models/merchant/get_cart_content_model.dart';
import '../../../../models/merchant/merchant_specific_store_categories.dart';
import '../../../../models/merchant/merchant_store_slider_images.dart';
import '../../../../models/singleUser.dart';
import '../../../../toggle_button.dart';
import '../../merchant_home_page(3)/merchant_home_page.dart';

class Design3 extends StatefulWidget {
  final String token;
  final String email;
  final List<String> specificStoreCategories;
  final String storeName;
  final List<dynamic> storeCartsVal;
  final bool sliderVisibility;
  final bool categoryVisibility;
  final bool cartsVisibility;
  final Map<String, dynamic> objectData;
  final Color textColor;
  final Color topBarBackgroundColor;
  final Color specificStoreCategoriesColor;
  final Color specificStoreProductsColor;
  final Color bottomBarBackgroundColor;
  final String? _selectedOptions;
  final Color? _selectedColor;
  final Color? backGroundColor;
  final Color? primaryTextColor;
  final Color? secondaryTextColor;
  final Color? _selectedColor1;
  final Color? _selectedColor2;
  final Color? _selectedColor3;
  final Color? _selectedColor4;
  final Color? clipPathColor;

  const Design3(
      this.token, this.email, this.specificStoreCategories, this.storeName, this.storeCartsVal, this.sliderVisibility, this.categoryVisibility, this.cartsVisibility, this.objectData,
      this.textColor, this.topBarBackgroundColor, this.specificStoreCategoriesColor, this.specificStoreProductsColor, this.bottomBarBackgroundColor, this._selectedOptions, this._selectedColor ,
      this.backGroundColor, this.primaryTextColor, this.secondaryTextColor, this._selectedColor1, this._selectedColor2, this._selectedColor3, this._selectedColor4, this.clipPathColor,{super.key});
  @override
  State<Design3> createState() => _Design3State();
}

class _Design3State extends State<Design3> {
  String tokenVal = "";
  String emailVal = "";
  String imageSliderVal = "";
  List<String> specificStoreCategoriesVal = [];
  List<dynamic> storeCartsVal= [];
  late Map<String, dynamic> objectDataVal;
  String storeNameVal = "";
  late bool sliderVisibilityVal ;
  late bool categoryVisibilityVal ;
  late bool cartsVisibilityVal ;


  late Future<User> userData;
  late Future<List> sliderImages;
  late Future<List> specificStoreCategories;
  late Future<List> getCartContent;
  late Color textColorVal;
  late Color topBarBackgroundColorVal;
  late Color specificStoreCategoriesColorVal;
  late Color specificStoreProductsColorVal;
  late Color bottomBarBackgroundColorVal;
  late String? _selectedOptionsVal;
  late Color? _selectedColorVal;
  late Color? backGroundColorVal;
  late Color? primaryTextColorVal;
  late Color? secondaryTextColorVal;
  late Color? clipPathColorVal;
  late Color? _selectedColor1Val;
  late Color? _selectedColor2Val;
  late Color? _selectedColor3Val;
  late Color? _selectedColor4Val;




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
      final url = 'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/store-slider-images';
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
      final url = 'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/cart-upload-primary-image';
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
      final url = 'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/cart-upload-secondary-images';
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
        'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/specific-store-categories/$emailVal';
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
        'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-specific-store-categories/$emailVal';
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
        'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-specific-image-from-store-slider/$emailVal';
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
        'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-specific-image-from-cart-image-slider/$emailVal';
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
        'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/update-specific-store-categories/$emailVal';
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
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}"),
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
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile/${emailVal}"),
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
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/test-get-merchant-cart/${emailVal}"),
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
        'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/activate-store-slider/$emailVal';
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
        'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/activate-store-category/$emailVal';
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
        'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/activate-store-carts/$emailVal';
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
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/test-get-merchant-cart/${emailVal}"),
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
        'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-cart/$emailVal';
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
  double rateVal = 3;
  late String dropdownValue= 'All Products' ;

  double smoothDesignBorderRadius = 15;
  double solidDesignBorderRadius = 2;
  double spaceAboveComponent = 20;
  double spaceBelowComponent = 10;


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
    objectDataVal = widget.objectData;
    print(emailVal);
    // userData = getUserByName();
    sliderImages = getSliderImages();
    specificStoreCategories = getSpecificStoreCategories();
    getCartContent = getSpecificStoreCart();
    sliderVisibilityVal = widget.sliderVisibility;
    categoryVisibilityVal = widget.categoryVisibility;
    cartsVisibilityVal = widget.cartsVisibility;
    textColorVal = widget.textColor;
    topBarBackgroundColorVal = widget.topBarBackgroundColor;
    specificStoreCategoriesColorVal = widget.specificStoreCategoriesColor;
    specificStoreProductsColorVal = widget.specificStoreProductsColor;
    bottomBarBackgroundColorVal = widget.bottomBarBackgroundColor;
    _selectedOptionsVal = widget._selectedOptions;
    _selectedColorVal = widget._selectedColor;
    _selectedColor1Val = widget._selectedColor1;
    _selectedColor2Val = widget._selectedColor2;
    _selectedColor3Val = widget._selectedColor3;
    _selectedColor4Val = widget._selectedColor4;

    backGroundColorVal = widget.backGroundColor;
    primaryTextColorVal = widget.primaryTextColor;
    secondaryTextColorVal = widget.secondaryTextColor;
    clipPathColorVal = widget.clipPathColor;



    topBarBackgroundColorVal = _selectedColorVal!;
    specificStoreCategoriesColorVal = _selectedColorVal!;
    specificStoreProductsColorVal = _selectedColorVal!;
    bottomBarBackgroundColorVal  = _selectedColorVal!;

    backGroundColorVal = _selectedColor1Val;
    primaryTextColorVal = _selectedColor2Val;
    secondaryTextColorVal = _selectedColor3Val;
    clipPathColorVal = _selectedColor4Val;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backGroundColorVal,
      appBar: AppBar(
        backgroundColor: topBarBackgroundColorVal,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios, color: secondaryTextColorVal, size: 30,),),
        title: Text("${storeNameVal}", style: TextStyle(color: secondaryTextColorVal, fontSize: 24, fontWeight: FontWeight.bold), ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.favorite_outline, color: secondaryTextColorVal, size: 30,)),
          SizedBox(width: 10,),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(_selectedOptionsVal == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: ArcClipper(),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: clipPathColorVal,

              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<List>(
                      future: sliderImages,
                      builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        return Container(
                          // color: Colors.blue,
                          height: MediaQuery.of(context).size.height/1.05 ,
                          margin: EdgeInsets.fromLTRB(5,0,5,5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_selectedOptionsVal == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                            // color: Colors.cyan
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Visibility(
                                  visible: categoryVisibilityVal,
                                  child: Column(children: [
                                    SizedBox(
                                      height: spaceAboveComponent,
                                    ),
                                    Container(
                                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        // alignment: Alignment.topLeft,
                                        width: double.infinity,
                                        child: Text("${getLang(context, 'all_categories')}", style: TextStyle(color: primaryTextColorVal, fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.start,)),
                                    SizedBox(
                                      height: spaceBelowComponent,
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
                                                      BorderRadius.circular(_selectedOptionsVal == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                      color: specificStoreCategoriesVal[
                                                      index] ==
                                                          "All Products" ? clipPathColorVal : specificStoreCategoriesColorVal,
                                                    ),
                                                    width: specificStoreCategoriesVal[
                                                    index] ==
                                                        "All Products" ? 150 : 120,
                                                    child: TextButton(
                                                        onPressed: () {

                                                        },
                                                        child: Text(
                                                          specificStoreCategoriesVal[
                                                          index],
                                                          style: TextStyle(
                                                              color:
                                                              secondaryTextColorVal,
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

                                SizedBox(
                                  height: 5,
                                ),
                                Visibility(
                                  visible: sliderVisibilityVal,
                                  child: Column(children: [
                                    SizedBox(
                                      height: spaceAboveComponent,
                                    ),
                                    Container(
                                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        // alignment: Alignment.topLeft,
                                        width: double.infinity,
                                        child: Text("${getLang(context, 'latest')}", style: TextStyle(color: primaryTextColorVal, fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.start,)),
                                    SizedBox(
                                      height: spaceBelowComponent,
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
                                                      BorderRadius.circular(_selectedOptionsVal == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
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

                                Column(
                                  children: [
                                    Visibility(
                                      visible: cartsVisibilityVal,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: spaceAboveComponent,
                                          ),
                                          Container(
                                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              // alignment: Alignment.topLeft,
                                              width: double.infinity,
                                              child: Text("${getLang(context, 'products')}", style: TextStyle(color: primaryTextColorVal, fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.start,)),
                                          SizedBox(
                                            height: spaceBelowComponent,
                                          ),
                                          FutureBuilder<List>(

                                            future: getCartContent,
                                            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                                              // print("zzzzz ${storeCartsVal[0]["cartName"]}");
                                              return Container(
                                                padding: EdgeInsets.fromLTRB(0, 0, 0, 70),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,

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
                                                    0.77, // Customize the aspect ratio (width/height) of each tile
                                                    mainAxisSpacing:
                                                    4.0, // Spacing between rows
                                                    crossAxisSpacing:
                                                    2.0, // Spacing between columns
                                                  ),
                                                  // storeCartsVal[index]
                                                  itemBuilder: (context, index) => Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                    padding:
                                                    EdgeInsets.fromLTRB(
                                                        5, 0, 5, 10),
                                                    child: Stack(
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            Container(
                                                              padding:
                                                              EdgeInsets
                                                                  .all(1),
                                                              decoration:
                                                              BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                                  topRight: Radius
                                                                      .circular(_selectedOptionsVal == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                  topLeft: Radius
                                                                      .circular(_selectedOptionsVal == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                ),
                                                                color: Color(
                                                                    0xF2222128),
                                                              ),
                                                              height: 180,
                                                              child: InkWell(
                                                                onTap: () {

                                                                },
                                                                child:
                                                                ClipRRect(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                      topRight: Radius
                                                                          .circular(_selectedOptionsVal == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                      topLeft: Radius
                                                                          .circular(_selectedOptionsVal == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                    ),
                                                                    child: (storeCartsVal[index]["cartPrimaryImage"].toString() ==
                                                                        "null" ||
                                                                        storeCartsVal[index]["cartPrimaryImage"].toString() ==
                                                                            "")
                                                                    // https://th.bing.com/th/id/R.2cdd64d3370db75b36e9b02259d1832a?rik=w2QxlPJgMEIzXQ&pid=ImgRaw&r=0
                                                                        ? CachedNetworkImage(
                                                                      imageUrl:
                                                                      "https://th.bing.com/th/id/R.2cdd64d3370db75b36e9b02259d1832a?rik=w2QxlPJgMEIzXQ&pid=ImgRaw&r=0",
                                                                      height: 180,
                                                                      placeholder: (context, url) =>
                                                                          SimpleCircularProgressBar(
                                                                            mergeMode:
                                                                            true,
                                                                            animationDuration:
                                                                            1,
                                                                          ),
                                                                      errorWidget: (context, url, error) =>
                                                                          Icon(Icons.error),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                    // storeCartsVal[index]["cartPrimaryImage"]
                                                                        : CachedNetworkImage(
                                                                      imageUrl:
                                                                      storeCartsVal[index]["cartPrimaryImage"],
                                                                      height: 180,
                                                                      placeholder: (context, url) =>
                                                                          SimpleCircularProgressBar(
                                                                            mergeMode:
                                                                            true,
                                                                            animationDuration:
                                                                            1,
                                                                          ),
                                                                      errorWidget: (context, url, error) =>
                                                                          Icon(Icons.error),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      // height: 120,
                                                                      width: double.infinity,
                                                                    )
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              bottom: 0,
                                                              left: 0,
                                                              child: storeCartsVal[index]
                                                              [
                                                              "cartDiscount"]
                                                                  .toString() ==
                                                                  "true"
                                                                  ? Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                    4,
                                                                    0,
                                                                    0,
                                                                    10),
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.circular(3),
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                width: 60,
                                                                height:
                                                                20,
                                                                child:
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                      .all(
                                                                      2.0),
                                                                  child:
                                                                  Text(
                                                                    "DISCOUNT",
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 11,
                                                                        fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),
                                                              )
                                                                  : Container(),
                                                            ),
                                                            Visibility(
                                                              visible: storeCartsVal[index]["cartFavourite"],
                                                              child: Positioned(
                                                                  top: 5,
                                                                  right: 5,
                                                                  child: CircleAvatar(
                                                                    radius: 23,
                                                                    backgroundColor:
                                                                    Colors.red,
                                                                    child: ToggleButton(onIcon: Icon(Icons.favorite, color: Colors.black),
                                                                        offIcon: Icon(Icons.favorite_outline, color: Colors.black),
                                                                        initialValue: false, onChanged: (_isFavorite) async {
                                                                          print(
                                                                              'Is Favorite $_isFavorite');
                                                                        }),
                                                                  )),
                                                            )
                                                          ],
                                                        ),
                                                        Positioned(
                                                            bottom: 0,
                                                            left: 0,
                                                            right: 0,
                                                            child: InkWell(
                                                              onTap: () {

                                                              },
                                                              child: Container(
                                                                height: 71,
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                    bottomRight:
                                                                    Radius.circular(_selectedOptionsVal == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                    bottomLeft:
                                                                    Radius.circular(_selectedOptionsVal == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                  ),
                                                                  color: specificStoreProductsColorVal,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          8,
                                                                          10,
                                                                          0),
                                                                      child: Text(
                                                                          "${storeCartsVal[index]["cartName"].toString()}",
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          maxLines:
                                                                          1,
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize:
                                                                            22,
                                                                            fontWeight:
                                                                            FontWeight.bold,
                                                                            color:
                                                                            secondaryTextColorVal,
                                                                          )),
                                                                    ),
                                                                    // Container(
                                                                    //   padding: EdgeInsets
                                                                    //       .fromLTRB(
                                                                    //           10,
                                                                    //           8,
                                                                    //           10,
                                                                    //           3),
                                                                    //   child: Text(
                                                                    //       "${storeCartsVal[index]["cartDescription"].toString()}",
                                                                    //       overflow: TextOverflow
                                                                    //           .ellipsis,
                                                                    //       maxLines:
                                                                    //           2,
                                                                    //       style:
                                                                    //           TextStyle(
                                                                    //         fontSize:
                                                                    //             14,
                                                                    //         fontWeight:
                                                                    //             FontWeight.bold,
                                                                    //         color:
                                                                    //             Colors.white,
                                                                    //       )),
                                                                    // ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .baseline,
                                                                      textBaseline:
                                                                      TextBaseline
                                                                          .alphabetic,
                                                                      children: [
                                                                        Container(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              10,
                                                                              0,
                                                                              2,
                                                                              0),
                                                                          child: Text(
                                                                              "${storeCartsVal[index]["cartPrice"].toString()}",
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: secondaryTextColorVal,
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                          5,
                                                                        ),
                                                                        Container(
                                                                          // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                          child: "${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}" == "null"
                                                                              ? Text("")
                                                                              : Text("${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}",
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: TextStyle(
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.bold,
                                                                                decoration: TextDecoration.lineThrough,
                                                                                decorationThickness: 3,
                                                                                color: secondaryTextColorVal,
                                                                              )),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                    Visibility(
                                                                      visible: false,
                                                                      child: Container(
                                                                        padding: EdgeInsets.fromLTRB(7, 2, 0, 0),
                                                                        child: RatingBar.builder(
                                                                          initialRating: 3,
                                                                          minRating: 1,
                                                                          direction: Axis.horizontal,
                                                                          allowHalfRating: true,
                                                                          itemCount: 5,
                                                                          itemSize: 20,
                                                                          unratedColor: Colors.white,
                                                                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                                          itemBuilder: (context, _) => Icon(
                                                                            Icons.favorite,
                                                                            color: Colors.yellow,
                                                                          ),
                                                                          onRatingUpdate: (rating) {
                                                                            setState(() {
                                                                              rateVal = rating;
                                                                            });

                                                                            print(rating);
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),


                                                      ],
                                                    ),
                                                  ),
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
                                            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/test-specific-cart/$emailVal"),
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
class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Move to the top right corner
    path.moveTo(size.width, 0);

    // Control points for the cubic bezier curve to create a circular arc
    double controlPoint1X = size.width * 0.75;
    double controlPoint1Y = 0;
    double controlPoint2X = size.width * 0.25;
    double controlPoint2Y = size.height / 2;
    double endPointX = 0;
    double endPointY = size.height / 2;

    // Draw a cubic bezier curve to the center left of the screen
    path.cubicTo(
      controlPoint1X,
      controlPoint1Y,
      controlPoint2X,
      controlPoint2Y,
      endPointX,
      endPointY,
    );

    // Draw the remaining edges to close the path
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

