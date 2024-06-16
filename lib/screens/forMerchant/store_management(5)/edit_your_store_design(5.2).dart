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
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/models/login_model.dart';
import 'package:graduate_project/models/merchant/cart_content_model.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/select_your_store_design.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/imageplaceholder.dart';
import "package:http/http.dart" as http;
import "package:flutter/gestures.dart";
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../discount_icon.dart';
import '../../../models/merchant/get_cart_content_model.dart';
import '../../../models/merchant/merchant_specific_store_categories.dart';
import '../../../models/merchant/merchant_store_slider_images.dart';
import '../../../models/singleUser.dart';
import '../../../toggle_button.dart';
import '../merchant_home_page(3)/merchant_home_page.dart';
import 'display_store_informations(5.3).dart';

class EditYourStoreDesign extends StatefulWidget {
  final String token;
  final String email;
  final List<String> specificStoreCategories;
  final String storeName;
  final List<dynamic> storeCartsVal;
  final bool sliderVisibility;
  final bool categoryVisibility;
  final bool cartsVisibility;
  final Map<String, dynamic> objectData;
  const EditYourStoreDesign(
      this.token,
      this.email,
      this.specificStoreCategories,
      this.storeName,
      this.storeCartsVal,
      this.sliderVisibility,
      this.categoryVisibility,
      this.cartsVisibility,
      this.objectData,
      {super.key});
  @override
  State<EditYourStoreDesign> createState() => _EditYourStoreDesignState();
}

class _EditYourStoreDesignState extends State<EditYourStoreDesign> {
  String tokenVal = "";
  String emailVal = "";
  String imageSliderVal = "";
  List<String> specificStoreCategoriesVal = [];
  List<dynamic> storeCartsVal = [];
  String storeNameVal = "";
  late bool sliderVisibilityVal;
  late bool categoryVisibilityVal;
  late bool cartsVisibilityVal;
  late Map<String, dynamic> objectDataVal;

  late Future<User> userData;
  late Future<List> sliderImages;
  late Future<List> specificStoreCategories;
  late Future<List> getCartContent;
  // late indexVal="";

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  // for Images Slider
  List<String> imageUrls = [];
  List<String> cartImageUrls = [];

  double tempSearchBoxHeight = 0;
  late File _image;
  final Dio _dio = Dio();
  List<dynamic> devicesId = [];
  Future<void> getDevicesIdList() async {
    http.Response userFuture1 = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-device-id-list/$emailVal"),
      headers: {
        "Content-Type": "application/json",
      },
    );
    setState(() {
      devicesId = jsonDecode(userFuture1.body);
    });
  }

  Future<void> notifyYourCustomers() async {
    await getDevicesIdList();

    print(devicesId);

    http.Response userFuture = await http.post(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/send-notification-to-device"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {"storeName": storeNameVal, "devices": devicesId},
      ),
      encoding: Encoding.getByName("utf-8"),
    );
  }

  Map<String, dynamic> merchant = {};

  Future<void> addStoreToDatabase() async {
    print("XPPPPPPPPPPPPX");
    print(sliderVisibilityVal);
    print(categoryVisibilityVal);
    print(cartsVisibilityVal);
    print("PPPPPPPPPPPP");
    setState(() {
      objectDataVal["activateSlider"] = sliderVisibilityVal;
      objectDataVal["activateCategory"] = categoryVisibilityVal;
      objectDataVal["activateCarts"] = cartsVisibilityVal;
      objectDataVal["specificStoreCategories"] = specificStoreCategoriesVal;
      // objectDataVal["type"] = storeCartsVal;
    });
    print(objectDataVal);
    print("PPPPPPPPPPPP");
    print("PPPPPPPPPPPP");

    var storeDataToAddVal = objectDataVal;

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
    if (merchant["secretKey"] == null || merchant["publishableKey"] == null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'You must add your payment informations...',
      );
    } else {
      http.Response userFuture = await http.post(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-add-store-to-database/$emailVal"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $tokenVal",
        },
        body: jsonEncode(
          {"stores": storeDataToAddVal},
        ),
        encoding: Encoding.getByName("utf-8"),
      );
      print(userFuture.body);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "Your Store Published Successfully!",
      );
      await notifyYourCustomers();
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
      final url =
          'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/store-slider-images';
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
      final url =
          'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/cart-upload-primary-image';
      print("$emailVal ssssssssssssssssss");
      // Extract the file name from the path
      String fileName = _image.path.split('/').last;

      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(_image.path, filename: fileName),
        "email": emailVal,
        "index": index,
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
      final url =
          'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/cart-upload-secondary-images';
      print("$emailVal ssssssssssssssssss");
      // Extract the file name from the path
      String fileName = _image.path.split('/').last;

      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(_image.path, filename: fileName),
        "email": emailVal,
        "index": index,
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

  Future<void> deleteImageFromCartImagesSlider(urlVal, index) async {
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
      "index": index
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
    var temp = GetCartContentModel.fromJson(json.decode(userFuture.body))
        .type
        .toList();

    setState(() {
      storeCartsVal = GetCartContentModel.fromJson(json.decode(userFuture.body))
          .type
          .toList();
      print("vvvvvvvvvvvv $storeCartsVal");
    });
    return GetCartContentModel.fromJson(json.decode(userFuture.body))
        .type
        .toList();
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
      setState(() {});

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
        "Authorization": "Bearer $tokenVal", // Add the token to the headers
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
      setState(() {});

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
      setState(() {});

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
    var temp = GetCartContentModel.fromJson(json.decode(userFuture.body))
        .type
        .toList();

    setState(() {
      storeCartsVal = GetCartContentModel.fromJson(json.decode(userFuture.body))
          .type
          .toList();
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

  Future<void> deleteCategoryConnectedToCarts(index) async {
    print(index);
    // Replace 'YOUR_SERVER_ENDPOINT' with your actual server endpoint
    final url =
        'https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-category-connected-to-cart/$emailVal';
    print("$emailVal ssssssssssssssssss");
    // Extract the file name from the path
    // print(url);
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

    if (storeCartsVal.length != 0) {
      // Make the POST request using dio
      Response response =
          await _dio.delete(url, data: requestData, options: options);
      // Check the response status
      if (response.statusCode == 200) {
        print('Category Deleted Successfully!!');
        // getSliderImages();
        setState(() async {
          // storeCartsVal = await getSpecificStoreCart();
          // await deleteSpecificStoreCategory(index);
          await getSpecificStoreCategories();
          getSpecificStoreCart();
        });
        // print(imageSliderVal);
      } else {
        print('Failed to delete category. Status code: ${response.statusCode}');
      }
    } else {
      await deleteSpecificStoreCategory(index);
      // showDialog(context: context, builder: (context)=>AlertDialog(
      //   title: Text("Information Message"),
      //   content: Text("No any Cart exist"),
      // ));
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

    // Make the POST request using dio
    Response response =
        await _dio.delete(url, data: requestData, options: options);
    // Check the response status
    if (response.statusCode == 200) {
      print('Category Deleted Successfully!!');
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                backgroundColor: Color(0xFF212128),
                title: Text(
                  "Success",
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                  "Category Deleted Successfully!!",
                  style: TextStyle(color: Colors.white),
                ),
              ));

      // getSliderImages();

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
  bool cartLikedBool = true;
  bool cartFavouriteBool = true;
  TextEditingController cartPriceAfterDiscountTextEditingController =
      TextEditingController();
  TextEditingController cartDescriptionTextEditingController =
      TextEditingController();
  TextEditingController cartCategoryTextEditing = TextEditingController();
  TextEditingController cartQuantitiesTextEditingController =
      TextEditingController();
  TextEditingController percentageEditingController = TextEditingController(text: "00");
  double rateVal = 3;

  late String dropdownValue = 'All Products';

  ////////
  Locale? _currentLocale;
  String _currentLocale1 = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentLocale = WidgetsBinding.instance.platformDispatcher.locale;
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
    objectDataVal = widget.objectData;
    _currentLocale1 = _currentLocale.toString().split('_').first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height / 20, 20, 0),
                  decoration: BoxDecoration(
                      color: Color(0xFF212128),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(storeNameVal,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                              ))),
                    ],
                  ),
                ),
                FutureBuilder<List>(
                    future: sliderImages,
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 1.15,
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
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("${getLang(context, 'latest')}",
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                color: Color(0xFF212128),
                                                fontSize: 24,
                                              ),
                                            )),
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
                                  SizedBox(
                                    height: 10,
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
                                              builder: (BuildContext context) {
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: InkWell(
                                                      onTap: () {
                                                        QuickAlert.show(
                                                            context: context,
                                                            type: QuickAlertType
                                                                .confirm,
                                                            text:
                                                                'Do you want to Delete this image from slider ?',
                                                            confirmBtnText:
                                                                'Delete',
                                                            cancelBtnText:
                                                                'Cancel',
                                                            confirmBtnColor:
                                                                Colors.green,
                                                            onConfirmBtnTap:
                                                                () async {
                                                              await deleteImageFromSlider(
                                                                  url);
                                                              await getSliderImages();
                                                            },
                                                            onCancelBtnTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                        // showDialog(
                                                        //     context: context,
                                                        //     builder:
                                                        //         (context) =>
                                                        //             AlertDialog(
                                                        //               backgroundColor:
                                                        //                   Color(0xFF212128),
                                                        //               title:
                                                        //                   Text(
                                                        //                 "Delete image ",
                                                        //                 style:
                                                        //                     TextStyle(color: Colors.white),
                                                        //               ),
                                                        //               content:
                                                        //                   Container(
                                                        //                 height:
                                                        //                     MediaQuery.of(context).size.height / 18,
                                                        //                 child:
                                                        //                     Column(
                                                        //                   crossAxisAlignment:
                                                        //                       CrossAxisAlignment.start,
                                                        //                   children: [
                                                        //                     Text(
                                                        //                       "Delete this image from slider",
                                                        //                       style: TextStyle(color: Colors.white),
                                                        //                     ),
                                                        //                     SizedBox(
                                                        //                       height: 20,
                                                        //                     ),
                                                        //                   ],
                                                        //                 ),
                                                        //               ),
                                                        //               actions: [
                                                        //                 TextButton(
                                                        //                     onPressed: () async {
                                                        //                       print(111111111);
                                                        //                       print("$url ytytytyty");
                                                        //                       print(33333333333);
                                                        //                       await deleteImageFromSlider(url);
                                                        //                       await getSliderImages();
                                                        //                     },
                                                        //                     child: Text(
                                                        //                       "Delete",
                                                        //                       style: TextStyle(color: Colors.white),
                                                        //                     )),
                                                        //                 SizedBox(
                                                        //                   width:
                                                        //                       20,
                                                        //                 ),
                                                        //                 TextButton(
                                                        //                     onPressed: () {
                                                        //                       Navigator.pop(context);
                                                        //                     },
                                                        //                     child: Text(
                                                        //                       "Cancel",
                                                        //                       style: TextStyle(color: Colors.white),
                                                        //                     ))
                                                        //               ],
                                                        //             ));
                                                      },
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
                                            "${getLang(context, 'all_categories')}",
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                color: Color(0xFF212128),
                                                fontSize: 24,
                                              ),
                                            )),
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
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List> snapshot) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.13,
                                        height: 50,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              specificStoreCategoriesVal.length,
                                          itemBuilder: (context, index) =>
                                              Stack(
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        specificStoreCategoriesVal[
                                                                    index] ==
                                                                "All Products"
                                                            ? Colors.red
                                                            : Color(0xFF212128),
                                                  ),
                                                  width:
                                                      specificStoreCategoriesVal[
                                                                  index] ==
                                                              "All Products"
                                                          ? 150
                                                          : 120,
                                                  child: TextButton(
                                                      onPressed: () {
                                                        if (specificStoreCategoriesVal[
                                                                index] !=
                                                            "All Products") {
                                                          print(index);
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    "${getLang(context, "edit_your_category")}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xff212128),
                                                                  content: Form(
                                                                    key:
                                                                        _formKey1,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          MediaQuery.of(context).size.height /
                                                                              7,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          TextFormField(
                                                                            cursorColor:
                                                                                Colors.white,
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                            controller:
                                                                                specificStoreCategoriesTextEditingController,
                                                                            //Making keyboard just for Email
                                                                            keyboardType:
                                                                                TextInputType.emailAddress,
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.isEmpty) {
                                                                                return 'Category is required';
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration: InputDecoration(
                                                                                labelText: '${getLang(context, 'category_name')}',
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
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          if (_formKey1
                                                                              .currentState!
                                                                              .validate()) {
                                                                            if (specificStoreCategoriesVal[index] !=
                                                                                "All Products") {
                                                                              bool doesCategoryExist = specificStoreCategoriesVal.any((category) => category.toLowerCase() == specificStoreCategoriesTextEditingController.text.toLowerCase());
                                                                              if (doesCategoryExist) {
                                                                                QuickAlert.show(
                                                                                  context: context,
                                                                                  type: QuickAlertType.error,
                                                                                  title: 'Oops...',
                                                                                  text: "Failed to Update, You have Category with this name!!",
                                                                                );
                                                                              } else {
                                                                                await updateSpecificStoreCategory(index, specificStoreCategoriesTextEditingController.text);
                                                                                await getSpecificStoreCategories();
                                                                                QuickAlert.show(
                                                                                  context: context,
                                                                                  type: QuickAlertType.success,
                                                                                  text: 'Category Updated Successfully!',
                                                                                );
                                                                                specificStoreCategoriesTextEditingController.clear();
                                                                              }
                                                                            } else {
                                                                              QuickAlert.show(
                                                                                context: context,
                                                                                type: QuickAlertType.error,
                                                                                title: 'Oops...',
                                                                                text: "Failed to Update 'All products' category",
                                                                              );
                                                                            }
                                                                          }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "${getLang(context, "update")}",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          print(
                                                                              specificStoreCategoriesVal[index]);
                                                                          if (specificStoreCategoriesVal[index] !=
                                                                              "All Products") {
                                                                            QuickAlert.show(
                                                                                context: context,
                                                                                type: QuickAlertType.confirm,
                                                                                text: "This action will delete all carts connected with this category",
                                                                                confirmBtnText: 'Delete',
                                                                                cancelBtnText: 'Cancel',
                                                                                confirmBtnColor: Colors.green,
                                                                                onConfirmBtnTap: () async {
                                                                                  await deleteCategoryConnectedToCarts(index);
                                                                                  // await deleteSpecificStoreCategory(index);
                                                                                  await getSpecificStoreCategories();
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                onCancelBtnTap: () {
                                                                                  Navigator.pop(context);
                                                                                });
                                                                            // showDialog(context: context, builder: (context)=>AlertDialog(
                                                                            //   title: Text("Information Message"),
                                                                            //   content: Container(
                                                                            //     height: MediaQuery.of(context).size.height/18,
                                                                            //     child: Column(
                                                                            //       children: [
                                                                            //         Text("This action will delete all carts connected with this category"),
                                                                            //       ],
                                                                            //     ),
                                                                            //   ),
                                                                            //   actions: [
                                                                            //     TextButton(onPressed: (){
                                                                            //       Navigator.pop(context);
                                                                            //     }, child: Text("Cancel")),
                                                                            //     TextButton(onPressed: () async{
                                                                            //
                                                                            //       await deleteCategoryConnectedToCarts(index);
                                                                            //       // await deleteSpecificStoreCategory(index);
                                                                            //       await getSpecificStoreCategories();
                                                                            //     }, child: Text("Delete any way")),
                                                                            //
                                                                            //   ],
                                                                            // ));
                                                                          } else {
                                                                            QuickAlert.show(
                                                                              context: context,
                                                                              type: QuickAlertType.error,
                                                                              title: 'Oops...',
                                                                              text: "Failed to Delete 'All products' category",
                                                                            );
                                                                            // showDialog(
                                                                            //     context: context,
                                                                            //     builder: (context) => AlertDialog(
                                                                            //           backgroundColor: Color(0xFF212128),
                                                                            //           title: Text(
                                                                            //             "Failed",
                                                                            //             style: TextStyle(color: Colors.white),
                                                                            //           ),
                                                                            //           content: Container(
                                                                            //               width: MediaQuery.of(context).size.width,
                                                                            //               height: MediaQuery.of(context).size.height / 15,
                                                                            //               child: Text(
                                                                            //                 "Failed to Delete 'All products' category",
                                                                            //                 style: TextStyle(color: Colors.white),
                                                                            //               )),
                                                                            //         ));
                                                                          }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "${getLang(context, 'delete')}",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )),
                                                                  ],
                                                                );
                                                              });
                                                        }
                                                      },
                                                      child: Text(
                                                          specificStoreCategoriesVal[
                                                                      index] ==
                                                                  "All Products"
                                                              ? getLang(context,
                                                                  'all_products')
                                                              : specificStoreCategoriesVal[
                                                                  index],
                                                          style: GoogleFonts
                                                              .roboto(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          )))),
                                              specificStoreCategoriesVal[
                                                          index] !=
                                                      "All Products"
                                                  ? Positioned(
                                                      right: 1,
                                                      top: 1,
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                      ))
                                                  : Container()
                                            ],
                                          ),
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
                              Visibility(
                                visible: cartsVisibilityVal,
                                child: Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(20, 10, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${getLang(context, 'products')}",
                                              style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  color: Color(0xFF212128),
                                                  fontSize: 24,
                                                ),
                                              )),
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
                                    FutureBuilder<List>(
                                      future: getCartContent,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<dynamic>>
                                              snapshot) {
                                        // print("zzzzz ${storeCartsVal[0]["cartName"]}");
                                        return Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 70),
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                            itemBuilder: (context, index) =>
                                                Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
                                              padding: EdgeInsets.fromLTRB(
                                                  5, 0, 5, 10),
                                              child: Stack(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(1),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                          color:
                                                              Color(0xF2222128),
                                                        ),
                                                        height: 180,
                                                        child: InkWell(
                                                          onTap: () {
                                                            print(index);
                                                            _pickAndUploadImageForCart(
                                                                index);
                                                          },
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                              ),
                                                              child: (storeCartsVal[index]["cartPrimaryImage"]
                                                                              .toString() ==
                                                                          "null" ||
                                                                      storeCartsVal[index]["cartPrimaryImage"]
                                                                              .toString() ==
                                                                          "")
                                                                  // https://th.bing.com/th/id/R.2cdd64d3370db75b36e9b02259d1832a?rik=w2QxlPJgMEIzXQ&pid=ImgRaw&r=0
                                                                  ? CachedNetworkImage(
                                                                      imageUrl:
                                                                          "https://th.bing.com/th/id/R.2cdd64d3370db75b36e9b02259d1832a?rik=w2QxlPJgMEIzXQ&pid=ImgRaw&r=0",
                                                                      height:
                                                                          180,
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              SimpleCircularProgressBar(
                                                                        mergeMode:
                                                                            true,
                                                                        animationDuration:
                                                                            1,
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Icon(Icons
                                                                              .error),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  // storeCartsVal[index]["cartPrimaryImage"]
                                                                  : CachedNetworkImage(
                                                                      imageUrl:
                                                                          storeCartsVal[index]
                                                                              [
                                                                              "cartPrimaryImage"],
                                                                      height:
                                                                          180,
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              SimpleCircularProgressBar(
                                                                        mergeMode:
                                                                            true,
                                                                        animationDuration:
                                                                            1,
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Icon(Icons
                                                                              .error),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      // height: 120,
                                                                      width: double
                                                                          .infinity,
                                                                    )),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        left: 0,
                                                        child: storeCartsVal[
                                                                            index]
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
                                                                      BorderRadius
                                                                          .circular(
                                                                              3),
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                width: 60,
                                                                height: 20,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          2.0),
                                                                  child: Text(
                                                                    "DISCOUNT",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                      ),
                                                      Visibility(
                                                        visible: storeCartsVal[
                                                                index]
                                                            ["cartFavourite"],
                                                        child: Positioned(
                                                            top: 5,
                                                            right: 5,
                                                            child: CircleAvatar(
                                                              radius: 23,
                                                              backgroundColor:
                                                                  Colors.red,
                                                              child:
                                                                  ToggleButton(
                                                                      onIcon: Icon(
                                                                          Icons
                                                                              .favorite,
                                                                          color: Colors
                                                                              .black),
                                                                      offIcon: Icon(
                                                                          Icons
                                                                              .favorite_outline,
                                                                          color: Colors
                                                                              .black),
                                                                      initialValue:
                                                                          false,
                                                                      onChanged:
                                                                          (_isFavorite) async {
                                                                        print(
                                                                            'Is Favorite $_isFavorite');
                                                                      }),
                                                            )),
                                                      ),
                                                      Positioned(
                                                        left: 5,
                                                        top: 5,
                                                        child: CustomPaint(
                                                        size: Size(45, 45),
                                                        painter: DiscountPainter(cartDiscountBool ? double.parse(percentageEditingController.text) : storeCartsVal[index]["discountValue"] * 1.0), // Change this value to set the discount percentage
                                                      ),)
                                                    ],
                                                  ),
                                                  Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        backgroundColor:
                                                                            Color(0xFF212128),
                                                                        title:
                                                                            Text(
                                                                          "${getLang(context, 'edit_product')}",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                        content: StatefulBuilder(builder: (BuildContext
                                                                                context,
                                                                            StateSetter
                                                                                setState) {
                                                                          return Form(
                                                                            key:
                                                                                _formKey2,
                                                                            child:
                                                                                Container(
                                                                              child: SingleChildScrollView(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      "${getLang(context, 'edit_your_product')}",
                                                                                      textAlign: TextAlign.left,
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 15,
                                                                                    ),
                                                                                    Column(
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              "${getLang(context, 'add_image_to_slider')}",
                                                                                              style: TextStyle(color: Colors.white),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            CircleAvatar(
                                                                                              radius: 20,
                                                                                              backgroundColor: Colors.white,
                                                                                              child: IconButton(
                                                                                                  onPressed: () async {
                                                                                                    await _pickAndUploadImageForCartSlider(index);

                                                                                                    setState(() {
                                                                                                      getSpecificStoreCartSliderImages();
                                                                                                    });
                                                                                                  },
                                                                                                  icon: Icon(
                                                                                                    Icons.add,
                                                                                                    color: Color(0xFF212128),
                                                                                                  )),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 20,
                                                                                        ),
                                                                                        Container(
                                                                                            width: MediaQuery.of(context).size.width / 1.5,
                                                                                            child: Container(
                                                                                              child: CarouselSlider(
                                                                                                options: CarouselOptions(
                                                                                                  // clipBehavior: ,
                                                                                                  autoPlay: true,
                                                                                                  height: 200.0,
                                                                                                  aspectRatio: 5,
                                                                                                  enlargeCenterPage: true,
                                                                                                ),
                                                                                                items: (storeCartsVal[index]["cartSecondaryImagesSlider"] as List<dynamic>).map<Widget>((url) {
                                                                                                  print("aaaaaaa $url");
                                                                                                  // setState(() {
                                                                                                  //   print(storeCartsVal[index]["cartSecondaryImagesSlider"]);
                                                                                                  // });
                                                                                                  return Builder(
                                                                                                    builder: (BuildContext context) {
                                                                                                      return InkWell(
                                                                                                        onTap: () {
                                                                                                          showDialog(
                                                                                                              context: context,
                                                                                                              builder: (context) => AlertDialog(
                                                                                                                    backgroundColor: Color(0xFF212128),
                                                                                                                    title: Text(
                                                                                                                      "Delete image ",
                                                                                                                      style: TextStyle(color: Colors.white),
                                                                                                                    ),
                                                                                                                    content: Container(
                                                                                                                      height: MediaQuery.of(context).size.height / 18,
                                                                                                                      child: Column(
                                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                        children: [
                                                                                                                          Text(
                                                                                                                            "Delete this image from slider",
                                                                                                                            style: TextStyle(color: Colors.white),
                                                                                                                          ),
                                                                                                                          SizedBox(
                                                                                                                            height: 20,
                                                                                                                          ),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    actions: [
                                                                                                                      TextButton(
                                                                                                                          onPressed: () async {
                                                                                                                            print(111111111);
                                                                                                                            print("$url ytytytyty");
                                                                                                                            print(33333333333);
                                                                                                                            await deleteImageFromCartImagesSlider(url, index);
                                                                                                                            setState(() {
                                                                                                                              getSpecificStoreCartSliderImages();
                                                                                                                            });
                                                                                                                          },
                                                                                                                          child: Text(
                                                                                                                            "${getLang(context, 'delete')}",
                                                                                                                            style: TextStyle(color: Colors.white),
                                                                                                                          )),
                                                                                                                      SizedBox(
                                                                                                                        width: 20,
                                                                                                                      ),
                                                                                                                      TextButton(
                                                                                                                          onPressed: () {
                                                                                                                            Navigator.pop(context);
                                                                                                                          },
                                                                                                                          child: Text(
                                                                                                                            "${getLang(context, 'cancel')}",
                                                                                                                            style: TextStyle(color: Colors.white),
                                                                                                                          ))
                                                                                                                    ],
                                                                                                                  ));
                                                                                                        },
                                                                                                        child: Container(
                                                                                                          width: MediaQuery.of(context).size.width,
                                                                                                          child: ClipRRect(
                                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                                            child: CachedNetworkImage(
                                                                                                              imageUrl: url,
                                                                                                              placeholder: (context, url) => SimpleCircularProgressBar(
                                                                                                                mergeMode: true,
                                                                                                                animationDuration: 1,
                                                                                                              ),
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
                                                                                            )),
                                                                                        SizedBox(
                                                                                          height: 20,
                                                                                        ),
                                                                                        Container(
                                                                                          width: MediaQuery.of(context).size.width / 1.3,
                                                                                          child: TextFormField(
                                                                                            cursorColor: Colors.white,
                                                                                            style: TextStyle(color: Colors.white),
                                                                                            controller: cartNameTextEditingController,
                                                                                            //Making keyboard just for Email
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            validator: (value) {
                                                                                              if (value != null && value.isNotEmpty && !RegExp(r'^[a-zA-Z]').hasMatch(value!)) {
                                                                                                return 'Product Name must start with a letter';
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                                labelText: '${getLang(context, 'product_name')}',
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
                                                                                              if (value != null && value.isNotEmpty && !RegExp(r'^\d+$').hasMatch(value!)) {
                                                                                                return 'Only numeric values are allowed';
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                                labelText: '${getLang(context, 'product_price')}',
                                                                                                labelStyle: TextStyle(color: Colors.white),
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
                                                                                              if (value != null && value.isNotEmpty && !RegExp(r'^\d+$').hasMatch(value)) {
                                                                                                return 'Only numeric values are allowed';
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                                labelText: '${getLang(context, 'product_quantities')}',
                                                                                                labelStyle: TextStyle(color: Colors.white),
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
                                                                                            controller: cartDescriptionTextEditingController,
                                                                                            //Making keyboard just for Email
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            validator: (value) {
                                                                                              if (value != null && value.isNotEmpty && !RegExp(r'^[a-zA-Z]').hasMatch(value!)) {
                                                                                                return 'Product Description must start with a letter';
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                                labelText: '${getLang(context, 'product_description')}',
                                                                                                labelStyle: TextStyle(color: Colors.white),
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
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              "${getLang(context, 'category')}: ",
                                                                                              style: TextStyle(color: Colors.white),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                                                              child: DropdownButton<String>(
                                                                                                value: dropdownValue,
                                                                                                onChanged: (String? newValue) {
                                                                                                  setState(() {
                                                                                                    dropdownValue = newValue!;
                                                                                                  });
                                                                                                },
                                                                                                items: specificStoreCategoriesVal.map<DropdownMenuItem<String>>((String value) {
                                                                                                  return DropdownMenuItem<String>(
                                                                                                    value: value,
                                                                                                    child: Text(
                                                                                                      value,
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.white,
                                                                                                      ),
                                                                                                    ),
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
                                                                                                width: MediaQuery.of(context).size.width / 3,
                                                                                                child: Text(
                                                                                                  '${getLang(context, 'activate_discount')}',
                                                                                                  style: TextStyle(fontSize: 16.0, color: Colors.white),
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
                                                                                                fillColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                                              ),
                                                                                              SizedBox(width: 20,),
                                                                                              Container(
                                                                                                width:20,
                                                                                                child: TextFormField(
                                                                                                  controller: percentageEditingController,
                                                                                                  style: TextStyle(color: Colors.white),
                                                                                                  keyboardType: TextInputType.number,
                                                                                                  inputFormatters: [
                                                                                                    FilteringTextInputFormatter.digitsOnly,
                                                                                                    LengthLimitingTextInputFormatter(2),
                                                                                                  ],
                                                                                                  validator: (value) {
                                                                                                    if (value == null || value.isEmpty) {
                                                                                                      return 'Please enter a discount percentage';
                                                                                                    }

                                                                                                    final double? discount = double.tryParse(value);
                                                                                                    if (cartDiscountBool && (discount == null || discount < 1 || discount > 100)) {
                                                                                                      QuickAlert.show(
                                                                                                        context: context,
                                                                                                        type: QuickAlertType.error,
                                                                                                        title: 'Oops...',
                                                                                                        text: 'Sorry, Please enter a valid discount percentage (0-100)',
                                                                                                      );
                                                                                                      return 'Please enter a valid discount percentage (0-100)';
                                                                                                    }

                                                                                                    return null;
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(width: 10,),
                                                                                              Text("%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),)
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 0,
                                                                                        ),
                                                                                        // Padding(
                                                                                        //   padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                                                        //   child: Row(
                                                                                        //     mainAxisAlignment: MainAxisAlignment.start,
                                                                                        //     children: [
                                                                                        //       Container(
                                                                                        //         width: MediaQuery.of(context).size.width / 2.5,
                                                                                        //         child: Text(
                                                                                        //           'Activate Like',
                                                                                        //           style: TextStyle(fontSize: 16.0, color: Colors.white),
                                                                                        //         ),
                                                                                        //       ),
                                                                                        //       Checkbox(
                                                                                        //         value: cartLikedBool,
                                                                                        //         onChanged: (bool? value) {
                                                                                        //           setState(() {
                                                                                        //             cartLikedBool = value!;
                                                                                        //             print(cartLikedBool);
                                                                                        //           });
                                                                                        //         },
                                                                                        //         checkColor: Colors.blue,
                                                                                        //         activeColor: Colors.blue,
                                                                                        //         // Color when checked
                                                                                        //         fillColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                                        //       ),
                                                                                        //     ],
                                                                                        //   ),
                                                                                        // ),
                                                                                        // SizedBox(
                                                                                        //   height: 0,
                                                                                        // ),
                                                                                        // Padding(
                                                                                        //   padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                                                                        //   child: Row(
                                                                                        //     mainAxisAlignment: MainAxisAlignment.start,
                                                                                        //     children: [
                                                                                        //       Container(
                                                                                        //         width: MediaQuery.of(context).size.width / 2.5,
                                                                                        //         child: Text(
                                                                                        //           'Activate Favourite',
                                                                                        //           style: TextStyle(fontSize: 16.0, color: Colors.white),
                                                                                        //         ),
                                                                                        //       ),
                                                                                        //       Checkbox(
                                                                                        //         value: cartFavouriteBool,
                                                                                        //         onChanged: (bool? value) {
                                                                                        //           setState(() {
                                                                                        //             cartFavouriteBool = value!;
                                                                                        //             print(cartFavouriteBool);
                                                                                        //           });
                                                                                        //         },
                                                                                        //         checkColor: Colors.blue,
                                                                                        //         activeColor: Colors.blue,
                                                                                        //         // Color when checked
                                                                                        //         fillColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                                        //       ),
                                                                                        //     ],
                                                                                        //   ),
                                                                                        // ),
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              width: MediaQuery.of(context).size.width / 3,
                                                                                              child: TextButton(
                                                                                                onPressed: () async {
                                                                                                  if (_formKey2.currentState!.validate()) {
                                                                                                    int counter2 = 0;
                                                                                                    for (int i = 0; i < storeCartsVal.length; i++) {
                                                                                                      if (storeCartsVal[i]["cartName"].toString() == cartNameTextEditingController.text.toString()) {
                                                                                                        counter2++;
                                                                                                      }
                                                                                                    }
                                                                                                    print(counter2);

                                                                                                    if (counter2 == 0) {
                                                                                                      if ((cartPriceTextEditingController.text.trim().isEmpty || isNumeric(cartPriceTextEditingController.text.trim())) && (cartQuantitiesTextEditingController.text.trim().isEmpty || isNumeric(cartQuantitiesTextEditingController.text.trim())) && (cartDescriptionTextEditingController.text.trim().isEmpty || isString(cartDescriptionTextEditingController.text.trim())) && (cartNameTextEditingController.text.trim().isEmpty || isString(cartNameTextEditingController.text.trim()))) {
                                                                                                        print(emailVal);
                                                                                                        print(index);
                                                                                                        http.Response userFuture = await http.patch(
                                                                                                          Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/test-update-specific-cart/$emailVal"),
                                                                                                          headers: {
                                                                                                            "Content-Type": "application/json",
                                                                                                            "Authorization": "Bearer $tokenVal",
                                                                                                          },
                                                                                                          body: jsonEncode(
                                                                                                            {
                                                                                                              "index": index,
                                                                                                              "email": emailVal,
                                                                                                              "cartName": cartNameTextEditingController.text,
                                                                                                              "cartPrice": cartDiscountBool ? ( storeCartsVal[index]["cartPrice"] - ((storeCartsVal[index]["cartPrice"] * int.parse(percentageEditingController.text))/100) ) : (cartPriceTextEditingController.text=="" ? storeCartsVal[index]["cartPrice"] : double.parse(cartPriceTextEditingController.text) ),
                                                                                                              "cartDiscount": cartDiscountBool,
                                                                                                              "cartLiked": cartLikedBool,
                                                                                                              "cartFavourite": cartFavouriteBool,
                                                                                                              "cartDescription": cartDescriptionTextEditingController.text,
                                                                                                              "cartCategory": dropdownValue.toString(),
                                                                                                              "cartQuantities": cartQuantitiesTextEditingController.text,
                                                                                                              "cartRate": rateVal,
                                                                                                              "discountValue":cartDiscountBool ? percentageEditingController.text : storeCartsVal[index]["discountValue"]
                                                                                                            },
                                                                                                          ),
                                                                                                          encoding: Encoding.getByName("utf-8"),
                                                                                                        );
                                                                                                        storeCartsVal[index]["cartDiscount"] = cartDiscountBool;
                                                                                                        print("KKKKKKKKKK ${storeCartsVal[index]["cartDiscount"]}");
                                                                                                        setState(() {
                                                                                                          cartNameTextEditingController.clear();
                                                                                                          cartPriceTextEditingController.clear();
                                                                                                          cartQuantitiesTextEditingController.clear();
                                                                                                          cartDescriptionTextEditingController.clear();
                                                                                                          getSpecificStoreCart();
                                                                                                        });

                                                                                                        // print(temp?.email);
                                                                                                      } else {
                                                                                                        showDialog(
                                                                                                            context: context,
                                                                                                            builder: (context) => AlertDialog(
                                                                                                                  title: Text("Failed"),
                                                                                                                  content: Text("Something go wrong !!"),
                                                                                                                ));
                                                                                                      }
                                                                                                    } else {
                                                                                                      showDialog(
                                                                                                          context: context,
                                                                                                          builder: (context) => AlertDialog(
                                                                                                                title: Text("Failed"),
                                                                                                                content: Text("Failed: inserted data not suitable with it's field!"),
                                                                                                              ));
                                                                                                    }
                                                                                                  }
                                                                                                },
                                                                                                child: Text(
                                                                                                  "${getLang(context, 'update_product')}",
                                                                                                  style: TextStyle(color: Colors.white),
                                                                                                ),
                                                                                                style: ButtonStyle(
                                                                                                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF212128)),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 15,
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: Container(
                                                                                                width: MediaQuery.of(context).size.width / 4,
                                                                                                child: TextButton(
                                                                                                  onPressed: () async {
                                                                                                    QuickAlert.show(
                                                                                                        context: context,
                                                                                                        type: QuickAlertType.confirm,
                                                                                                        text: '${getLang(context, "do_you_want_delete_this_product")}',
                                                                                                        confirmBtnText: '${getLang(context, 'delete')}',
                                                                                                        cancelBtnText: '${getLang(context, "cancel")}',
                                                                                                        confirmBtnColor: Colors.green,
                                                                                                        onConfirmBtnTap: () {
                                                                                                          deleteCart(index);
                                                                                                        },
                                                                                                        onCancelBtnTap: () {
                                                                                                          Navigator.pop(context);
                                                                                                        });
                                                                                                  },
                                                                                                  child: Text(
                                                                                                    "${getLang(context, 'delete_product')}",
                                                                                                    style: TextStyle(color: Colors.white),
                                                                                                  ),
                                                                                                  style: ButtonStyle(
                                                                                                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF212128)),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                                      ));
                                                        },
                                                        child: Container(
                                                          height: 71,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                            ),
                                                            color: Color(
                                                                0xF2222128),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    width: 120,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .fromLTRB(
                                                                                5,
                                                                                8,
                                                                                5,
                                                                                0),
                                                                    child: Text(
                                                                        "${storeCartsVal[index]["cartName"].toString()}",
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines: 1,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              22,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          color: Colors
                                                                              .white,
                                                                        )),
                                                                  ),
                                                                  Expanded(
                                                                    child: Container(
                                                                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                                      child: Icon(Icons.edit,
                                                                          color: Colors.white),
                                                                    ),
                                                                  ),
                                                                ],
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
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    width: 105,
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    child: Row(
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
                                                                          padding: EdgeInsets
                                                                              .fromLTRB(
                                                                                  0,
                                                                                  0,
                                                                                  0,
                                                                                  0),
                                                                          child: Text(
                                                                              "${storeCartsVal[index]["cartPrice"].toString()} \$",
                                                                              overflow: TextOverflow
                                                                                  .ellipsis,
                                                                              maxLines:
                                                                                  1,
                                                                              style:
                                                                                  TextStyle(
                                                                                fontSize:
                                                                                    13,
                                                                                fontWeight:
                                                                                    FontWeight.bold,
                                                                                color:
                                                                                    Colors.white,
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Container(
                                                                          // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                          child: "${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}" ==
                                                                                  "null"
                                                                              ? Text(
                                                                                  "")
                                                                              : Text(
                                                                                  "${storeCartsVal[index]["cartPrice"]/ (1-(storeCartsVal[index]["discountValue"]/100))} ",
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
                                                                  ),
                                                                  Expanded(
                                                                    child: Container(
                                                                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                                                      child: InkWell(
                                                                        onTap: () {
                                                                          final String text =
                                                                              'Check out this Product: ${storeCartsVal[index]["cartName"]}';
                                                                          final String imageUrl =
                                                                              '${storeCartsVal[index]["cartPrimaryImage"].toString()}';
                                                                    
                                                                          // Combine text and URL
                                                                          final String content =
                                                                              '$text $imageUrl';
                                                                    
                                                                          Share.share(content);
                                                                        },
                                                                        child: Icon(
                                                                            Icons.share_outlined,
                                                                            color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              Visibility(
                                                                visible: false,
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          7,
                                                                          2,
                                                                          0,
                                                                          0),
                                                                  child: RatingBar
                                                                      .builder(
                                                                    initialRating:
                                                                        3,
                                                                    minRating:
                                                                        1,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    allowHalfRating:
                                                                        true,
                                                                    itemCount:
                                                                        5,
                                                                    itemSize:
                                                                        20,
                                                                    unratedColor:
                                                                        Colors
                                                                            .white,
                                                                    itemPadding:
                                                                        EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                4.0),
                                                                    itemBuilder:
                                                                        (context,
                                                                                _) =>
                                                                            Icon(
                                                                      Icons
                                                                          .favorite,
                                                                      color: Colors
                                                                          .yellow,
                                                                    ),
                                                                    onRatingUpdate:
                                                                        (rating) {
                                                                      setState(
                                                                          () {
                                                                        rateVal =
                                                                            rating;
                                                                      });

                                                                      print(
                                                                          rating);
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
                        ),
                      );
                    })
              ],
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MerchantHome(tokenVal, emailVal)));
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
                                              "${getLang(context, 'activate_components')}",
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
                                                "${getLang(context, 'activate_slider')}",
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
                                                      sliderVisibilityVal =
                                                          true;
                                                      activateStoreSlider();
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
                                                      sliderVisibilityVal =
                                                          false;
                                                      activateStoreSlider();
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
                                                "${getLang(context, 'activate_category')}",
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
                                                      categoryVisibilityVal =
                                                          true;
                                                      activateStoreCategory();
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
                                                      categoryVisibilityVal =
                                                          false;
                                                      activateStoreCategory();
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
                                                "${getLang(context, 'activate_products')}",
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
                                                      cartsVisibilityVal = true;
                                                      activateStoreCarts();
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
                                                      cartsVisibilityVal =
                                                          false;
                                                      activateStoreCarts();
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectYourStoreDesign(
                                  tokenVal,
                                  emailVal,
                                  specificStoreCategoriesVal,
                                  storeNameVal,
                                  storeCartsVal,
                                  sliderVisibilityVal,
                                  categoryVisibilityVal,
                                  cartsVisibilityVal,
                                  objectDataVal)));
                      // addStoreToDatabase();
                    }
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      label: '${getLang(context, 'home')}',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      label: '${getLang(context, 'customize')}',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      label: '${getLang(context, 'continue')}',
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
                  "${getLang(context, 'category_name')}",
                  style: TextStyle(color: Colors.white),
                ),
                content: Form(
                  key: _formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getLang(context, 'enter_your_store_category')}",
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
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText:
                                    '${getLang(context, "category_name")}',
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
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "${getLang(context, "cancel")}",
                        style: TextStyle(color: Colors.white),
                      )),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        int counterCat = 0;
                        setState(() async {
                          for (int i = 0;
                              i < specificStoreCategoriesVal.length;
                              i++) {
                            if (specificStoreCategoriesVal[i].toString() ==
                                specificStoreCategoriesTextEditingController
                                    .text) {
                              counterCat++;
                            }
                          }
                          if (counterCat != 0) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Oops...',
                              text: 'Failed: Duplicate category name',
                            );
                          } else {
                            await insertSpecificStoreCategory();
                            await getSpecificStoreCategories();
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: 'Category added Successfully!!',
                            );
                            // showDialog(
                            //     context: context,
                            //     builder: (context) =>
                            //         AlertDialog(
                            //           backgroundColor: Color(0xFF212128),
                            //           icon: Icon(
                            //             Icons.info,
                            //             color: Colors.green,
                            //             size: 15,
                            //           ),
                            //           title: Text(
                            //             "Information Message",
                            //             style: TextStyle(color: Colors.white),
                            //           ),
                            //           content: Text(
                            //             "Category added Successfully!!",
                            //             style: TextStyle(color: Colors.white),
                            //           ),
                            //           actions: [
                            //             TextButton(
                            //                 onPressed: () {
                            //                   Navigator.pop(context);
                            //                 },
                            //                 child: Text(
                            //                   "OK",
                            //                   style: TextStyle(
                            //                       color: Colors.white),
                            //                 ))
                            //           ],
                            //         ));
                            specificStoreCategoriesTextEditingController
                                .clear();
                          }
                        });
                      }
                    },
                    child: Text("${getLang(context, 'ok')}",
                        style: TextStyle(color: Colors.white)),
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
                  "${getLang(context, 'product_content')}",
                  style: TextStyle(color: Colors.white),
                ),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  print("bbbbbbb $specificStoreCategoriesVal");
                  return Form(
                    key: _formKey3,
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${getLang(context, 'enter_product_details')}",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white),
                                    controller: cartNameTextEditingController,
                                    //Making keyboard just for Email
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Product Name is required';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText:
                                            '${getLang(context, 'product_name')}',
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white),
                                    controller: cartPriceTextEditingController,
                                    //Making keyboard just for Email
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Product Price is required';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText:
                                            '${getLang(context, 'product_price')}',
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white),
                                    controller:
                                        cartQuantitiesTextEditingController,
                                    //Making keyboard just for Email
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Product Quantities is required';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText:
                                            '${getLang(context, 'product_quantities')}',
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white),
                                    controller:
                                        cartDescriptionTextEditingController,
                                    //Making keyboard just for Email
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Product Descrption is required';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText:
                                            '${getLang(context, 'product_description')}',
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
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${getLang(context, 'category')}: ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: DropdownButton<String>(
                                        value: dropdownValue,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                        items: specificStoreCategoriesVal
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        dropdownColor: Color(0xFF212128),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: Text(
                                          '${getLang(context, 'activate_discount')}',
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
                                            getSpecificStoreCart();
                                          });
                                        },
                                        checkColor: Colors.blue,
                                        activeColor: Colors.blue,
                                        // Color when checked
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                      ),
                                      SizedBox(width: 20,),
                                      Container(
                                        width:20,
                                        child: TextFormField(
                                          controller: percentageEditingController,
                                          style: TextStyle(color: Colors.white),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(2),
                                          ],
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a discount percentage';
                                            }

                                            final double? discount = double.tryParse(value);
                                            if (cartDiscountBool && (discount == null || discount < 1 || discount > 100)) {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.error,
                                                title: 'Oops...',
                                                text: 'Sorry, Please enter a valid discount percentage (0-100)',
                                              );
                                              return 'Please enter a valid discount percentage (0-100)';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text("%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),)
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       Container(
                                //         width: MediaQuery.of(context).size.width /
                                //             2.5,
                                //         child: Text(
                                //           'Activate Like',
                                //           style: TextStyle(
                                //               fontSize: 16.0,
                                //               color: Colors.white),
                                //         ),
                                //       ),
                                //       Checkbox(
                                //         value: cartLikedBool,
                                //         onChanged: (bool? value) {
                                //           setState(() {
                                //             cartLikedBool = value!;
                                //             print(cartLikedBool);
                                //           });
                                //         },
                                //         checkColor: Colors.blue,
                                //         activeColor: Colors.blue,
                                //         // Color when checked
                                //         fillColor:
                                //             MaterialStateProperty.all<Color>(
                                //                 Colors.white),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 0,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       Container(
                                //         width: MediaQuery.of(context).size.width /
                                //             2.5,
                                //         child: Text(
                                //           'Activate Favourite',
                                //           style: TextStyle(
                                //               fontSize: 16.0,
                                //               color: Colors.white),
                                //         ),
                                //       ),
                                //       Checkbox(
                                //         value: cartFavouriteBool,
                                //         onChanged: (bool? value) {
                                //           setState(() {
                                //             cartFavouriteBool = value!;
                                //             print(cartFavouriteBool);
                                //           });
                                //         },
                                //         checkColor: Colors.blue,
                                //         activeColor: Colors.blue,
                                //         // Color when checked
                                //         fillColor:
                                //             MaterialStateProperty.all<Color>(
                                //                 Colors.white),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: TextButton(
                                    onPressed: () async {
                                      if (_formKey3.currentState!.validate()) {
                                        try {
                                          int counter1 = 0;
                                          for (int i = 0;
                                              i < storeCartsVal.length;
                                              i++) {
                                            if (storeCartsVal[i]["cartName"]
                                                    .toString() ==
                                                cartNameTextEditingController
                                                    .text
                                                    .toString()) {
                                              counter1++;
                                            }
                                          }

                                          if (counter1 != 0) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text("Failed!!"),
                                                      content: Text(
                                                          "Failed: There is another cart with same name "),
                                                    ));
                                          } else {
                                            if ((cartPriceTextEditingController
                                                        .text
                                                        .trim()
                                                        .isNotEmpty &&
                                                    isNumeric(cartPriceTextEditingController
                                                        .text
                                                        .trim())) &&
                                                (cartQuantitiesTextEditingController
                                                        .text
                                                        .trim()
                                                        .isNotEmpty &&
                                                    isNumeric(cartQuantitiesTextEditingController
                                                        .text
                                                        .trim())) &&
                                                (cartDescriptionTextEditingController
                                                        .text
                                                        .trim()
                                                        .isNotEmpty &&
                                                    isString(
                                                        cartDescriptionTextEditingController
                                                            .text
                                                            .trim())) &&
                                                (cartNameTextEditingController
                                                        .text
                                                        .trim()
                                                        .isNotEmpty &&
                                                    isString(
                                                        cartNameTextEditingController
                                                            .text
                                                            .trim()))) {
                                              http.Response userFuture =
                                                  await http.post(
                                                Uri.parse(
                                                    "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/test-specific-cart/$emailVal"),
                                                headers: {
                                                  "Content-Type":
                                                      "application/json",
                                                  "Authorization":
                                                      "Bearer $tokenVal",
                                                },
                                                body: jsonEncode(
                                                  {
                                                    "email": emailVal,
                                                    "cartName":
                                                        cartNameTextEditingController
                                                            .text,
                                                    "cartPrice":
                                                    cartDiscountBool ? ( double.parse(cartPriceTextEditingController.text) - ((double.parse(cartPriceTextEditingController.text) * int.parse(percentageEditingController.text))/100) ) : cartPriceTextEditingController.text,
                                                    "cartDiscount":
                                                        cartDiscountBool,
                                                    "cartLiked": cartLikedBool,
                                                    "cartFavourite":
                                                        cartFavouriteBool,
                                                    "cartDescription":
                                                        cartDescriptionTextEditingController
                                                            .text,
                                                    "cartCategory":
                                                        dropdownValue
                                                            .toString(),
                                                    "cartQuantities":
                                                        cartQuantitiesTextEditingController
                                                            .text,
                                                    "cartRate": rateVal,
                                                    "discountValue":percentageEditingController.text
                                                  },
                                                ),
                                                encoding:
                                                    Encoding.getByName("utf-8"),
                                              );
                                              print(userFuture.body);
                                              var temp =
                                                  CartContentModel.fromJson(json
                                                      .decode(userFuture.body));
                                              print(temp.message);
                                              setState(() async {
                                                // storeCartsVal = await getSpecificStoreCart();
                                                cartNameTextEditingController
                                                    .clear();
                                                cartPriceTextEditingController
                                                    .clear();
                                                cartQuantitiesTextEditingController
                                                    .clear();
                                                cartDescriptionTextEditingController
                                                    .clear();
                                                await getSpecificStoreCart();
                                              });
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text("Failed"),
                                                        content: Text(
                                                            "Failed: inserted data not suitable with it's field!"),
                                                      ));
                                            }
                                          }

                                          // print(temp?.email);
                                        } catch (error) {}
                                      }
                                    },
                                    child: Text(
                                      "${getLang(context, 'add_product')}",
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
                    ),
                  );
                }),
              ));
    });
  }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  bool isString(String input) {
    try {
      // Try parsing the input as an integer
      int.parse(input);
      // If parsing succeeds, it's an integer
      return false;
    } catch (e) {
      // If an exception occurs, it's not an integer (assumed to be a string)
      return true;
    }
  }
}
