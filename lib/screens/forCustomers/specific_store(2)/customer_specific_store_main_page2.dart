import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';

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
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/constants/constants.dart';
import 'package:graduate_project/models/login_model.dart';
import 'package:graduate_project/models/merchant/cart_content_model.dart';
import 'package:graduate_project/models/merchant/merchant_connect_store_to_social_media.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/forCustomers/customer_login_register/login_or_register(2).dart';
import 'package:graduate_project/screens/forCustomers/customer_main_page(1)/customer_main_page.dart';
import 'package:graduate_project/screens/forCustomers/specific_store(2)/customer_edit_profile_page.dart';
import 'package:graduate_project/screens/forCustomers/specific_store(2)/customer_favorite_products.dart';
import 'package:graduate_project/screens/forCustomers/specific_store(2)/customer_my_profile_page.dart';
import 'package:graduate_project/screens/forGuest/specific_store(2)/display_all_products_to_search.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_store_informations(5.3).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/edit_your_store_design(5.2).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/imageplaceholder.dart';
import "package:http/http.dart" as http;
import "package:flutter/gestures.dart";
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:translator/translator.dart';

import '../../../discount_icon.dart';
import '../../../models/merchant/get_cart_content_model.dart';
import '../../../models/merchant/merchant_specific_store_categories.dart';
import '../../../models/merchant/merchant_store_slider_images.dart';
import '../../../models/singleUser.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import "../../../stripe_payment/payment_manager.dart";
import '../../../stripe_payment/stripe_keys.dart';
import '../../../toggle_button.dart';
import 'customer_chat_system.dart';
import 'customer_display_all_products_to_search.dart';
import 'customer_display_product.dart';
import 'customer_my_cart_page.dart';
import 'customer_notifications_page.dart';
import 'customer_support_page.dart';

class CustomerSpecificStoreMainPage2 extends StatefulWidget {
  final String token;
  final String email;
  final List<String> specificStoreCategories;
  final String storeName;
  final List<dynamic> storeCartsVal;
  final bool sliderVisibility;
  final bool categoryVisibility;
  final bool cartsVisibility;
  final Map<String, dynamic> objectData;
  final String customerTokenVal;
  final String customerEmailVal;
  final String backgroundColor;
  final String boxesColor;
  final String primaryTextColor;
  final String secondaryTextColor;
  final String clippingColor;
  final String smoothy;
  final String design;
  const CustomerSpecificStoreMainPage2(
      this.token,
      this.email,
      this.specificStoreCategories,
      this.storeName,
      this.storeCartsVal,
      this.sliderVisibility,
      this.categoryVisibility,
      this.cartsVisibility,
      this.objectData,
      this.customerTokenVal,
      this.customerEmailVal,
      this.backgroundColor,
      this.boxesColor,
      this.primaryTextColor,
      this.secondaryTextColor,
      this.clippingColor,
      this.smoothy,
      this.design,
      {super.key});
  @override
  State<CustomerSpecificStoreMainPage2> createState() =>
      _CustomerSpecificStoreMainPage2State();
}

class _CustomerSpecificStoreMainPage2State
    extends State<CustomerSpecificStoreMainPage2> with WidgetsBindingObserver{

  String tokenVal = "";
  String emailVal = "";
  String customerTokenVal = "";
  String customerEmailVal = "";
  String imageSliderVal = "";
  List<String> specificStoreCategoriesVal = [];
  List<String> specificStoreCategoriesValEn = [];
  late Map<String, dynamic> objectDataVal;
  String storeNameVal = "";
  late bool sliderVisibilityVal;
  late bool categoryVisibilityVal;
  late bool cartsVisibilityVal;
  late bool _isFavorite1 ;

  late Future<User> userData;
  late Future<List> sliderImages;
  late Future<List> specificStoreCategories;
  late Future<List> getCartContent;
  // late indexVal="";
  double rateVal = 3;

  //////////////
  late List<dynamic> getStoreDataVal = [];
  late String backgroundColor = "";
  late String boxesColor = "";
  late String primaryTextColor = "";
  late String secondaryTextColor = "";
  late String clippingColor = "";
  late String smoothy = "";
  late String design = "";

  late double smoothDesignBorderRadius = 15;
  late double solidDesignBorderRadius = 2;
  double spaceAboveComponent = 20;
  double spaceBelowComponent = 10;

  late int storeIndexVal ;

  Future<void> getStoreIndex() async {

    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-store-index/"),
    );
    print(userFuture.body);
    var temp = json.decode(userFuture.body);
    print(temp["value"]);
    if (userFuture.statusCode == 200) {
      print("${userFuture.statusCode}");
      setState(() {
        storeIndexVal=temp["value"];
      });

    } else {
      print("error");
      throw Exception("Error");
    }
  }
  //////////////

  // for Images Slider
  List<String> imageUrls = [];
  List<String> cartImageUrls = [];

  double tempSearchBoxHeight = 0;
  late File _image;
  final Dio _dio = Dio();

  bool cartsForSpecificCategory = false;
  List<dynamic> filteredData = [];

  bool _isChanged = false;

  void rebuildPage() {
    setState(() {
      _isChanged = !_isChanged;
    });
  }
  List<bool> _isSelected = [];

  Map<String, dynamic> merchantData = {};
  Future<void> getMerchantProfile() async {
    print("%%%%%%%%%%%%%%%%%%%%%%%");
    print("%%%%%%%%%%%%%%%%%%%%%%%");
    print("$emailVal tttttttttXX");
    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/merchant-profile-second/${emailVal}"),
      headers: {
        "Content-Type": "application/json",
      },
    );
    print(userFuture.body);

    setState(() {
      merchantData = jsonDecode(userFuture.body);
    });

    print(merchantData["merchantname"]);


    print("%%%%%%%%%%%%%%%%%%%%%%%");
    print("%%%%%%%%%%%%%%%%%%%%%%%");

  }

  Future<void> findUserDeviceIdFromList() async{
    await OneSignal.shared.setAppId("6991924e-f460-444c-824d-bf138d0e8d7b");
    await OneSignal.shared.getDeviceState().then((value) async {
      print("${value?.userId} RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");

      http.Response
      userFuture =
      await http.post(
        Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/find-user-device-id-from-list/${emailVal}"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "deviceId":value?.userId
          },
        ),
        encoding:
        Encoding.getByName("utf-8"),

      );
      setState(() {
        _isSelected = [jsonDecode(userFuture.body)];
      });
      print(userFuture.body);

    });

  }

  Future<List> getSliderImages() async {
    print("$emailVal tttttttttt");
    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/store-data/${emailVal}"),
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
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/store-data/${emailVal}"),
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
      List<String> urls = data.map((item) => item.toString()).toList();

      final translator = GoogleTranslator();

      final String localeName = Platform.localeName; // e.g., "en_US"

      // You can extract the language code from the string if needed
      final String langCode = localeName.split('_').first; // e.g., "en"

      // if(langCode != "ar") {
        print("ooooooooooooooo $urls ");
        setState(() {
          specificStoreCategoriesValEn=urls;
          specificStoreCategoriesVal = [];
          specificStoreCategoriesVal = urls;
          urls=[];
        });
      // }
      ///////////////

      // if(langCode == "ar") {
      //
      //   specificStoreCategoriesValEn=urls;
      //   List<Future<String>> translatedData = urls.skip(1) // Skip the first element
      //       .map((item) async {
      //     final translatedCategory = await translator.translate(item, to: langCode);
      //     item = translatedCategory.text; // Update the store category
      //     return item;
      //   }).toList();
      //
      //   List<String> completedData = await Future.wait(translatedData);
      //   completedData.insert(0, urls[0]);
      //   print("IIIIIIIIIIIIIIII");
      //   // print(getStoreDataVal[0].storeName);
      //   print(completedData);
      //   print("IIIIIIIIIIIIIIII");
      //   setState(() {
      //     specificStoreCategoriesVal=[];
      //     specificStoreCategoriesVal = completedData;
      //     urls=[];
      //   });
      // }


      ////////////
      return MerchantStoreSliderImages.fromJson(json.decode(userFuture.body))
          .specificStoreCategories
          .toList();
    } else {
      print("error");
      throw Exception("Error");
    }
  }

  //////////////////////////
  List<dynamic> storeCartsVal = [];
  List<dynamic> CartsForOneCategoryVal = [];
  List<dynamic> favoriteList = [];
  void getCustomerFavoriteList() async {
    print("ppppppppppppppppppp");
    print(customerEmailVal);
    print("ppppppppppppppppppp");

    http.Response userFuture = await http.get(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-customer-favorite-list/${customerEmailVal}"),
        headers: {"Authorization": "Bearer ${customerTokenVal}"});
    if (userFuture.statusCode == 200) {
      // print("${userFuture.body}");

      // return GetCartContentModel.fromJson(json.decode(userFuture.body));
      setState(() {
        favoriteList = json.decode(userFuture.body);

      });

    } else {
      throw Exception("Error");
    }
  }
  Future<void> getSpecificStoreCart(emailVal) async {
    storeCartsVal = [];
    List<dynamic> commonElement = [] ;
    List<dynamic> commonElement1 = [] ;
    List<dynamic> commonElementForFind = [] ;

    print("--------------------------");
    print(emailVal);

    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/test-get-store-cart/${emailVal}"),
    );
    print(userFuture.body);
    var temp = GetCartContentModel.fromJson(json.decode(userFuture.body))
        .type
        .toList();
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    print("######");

    for(int i = 0; i < favoriteList.length; i++){
      for(int j = 0; j < temp.length; j++) {
        if(favoriteList[i]["cartName"] == temp[j]["cartName"] && favoriteList[i]["merchant"] == temp[j]["merchant"]){
          commonElement.add(favoriteList[i]);
        }
      }
    }
    for(int i = 0; i < favoriteList.length; i++){
      for(int j = 0; j < temp.length; j++) {
        if(favoriteList[i]["cartName"] == temp[j]["cartName"] && favoriteList[i]["merchant"] == temp[j]["merchant"]){
          commonElementForFind.add(favoriteList[i]["cartName"]);
        }
      }
    }

    commonElement1 = temp.where((element) => !commonElementForFind.contains(element["cartName"])).toList();

    print(commonElement);
    print(commonElement1);

    var combinedArray = [...commonElement, ...commonElement1];
    print(combinedArray.length);

    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");

    setState(() {
      storeCartsVal = combinedArray;

      print("vvvvvvvvvvvv $storeCartsVal");
    });
    setState(() {

    });
  }

  Future<void> getCartsForOneCategory(emailVal, cartCategory) async {
    CartsForOneCategoryVal = [];
    print("--------------------------");
    print(emailVal);

    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/customer-get-favorite-products-depend-on-category?email=$emailVal&cartCategory=$cartCategory&customerEmail=$customerEmailVal"),
    );
    print(userFuture.body);

///////////////////////////////////////////////////

    List<dynamic> jsonList = json.decode(userFuture.body);
    print("CCCCCCCCCCCCCCCCC");
    print(jsonList);
    // print(jsonList[0]["cartName"]);

    setState(() {
      CartsForOneCategoryVal = jsonList;
      print("vvvvvvvvvvvv $CartsForOneCategoryVal");
    });
  }

  Future<List<dynamic>> getSpecificStoreCartSliderImages() async {
    print("--------------------------");
    print(emailVal);

    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/test-get-store-cart/${emailVal}"),
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

  Future<void> incrementProductViews(index) async {
    await getStatisticsAboutProducts(index);

    Constants.mostViewed++;

    http.Response userFuture =
    await http.post(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/increment-most-viewed/$emailVal"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $tokenVal",
      },
      body: jsonEncode(
        {
          "productIndex":index,
          "forMostViewed": Constants.mostViewed
        },
      ),
      encoding:
      Encoding.getByName("utf-8"),
    );
    print(userFuture.body);

  }
  Future<void> getStatisticsAboutProducts(index) async {
    print("--------------------------");
    print(emailVal);
    print(index);

    http.Response userFuture = await http.post(
      Uri.parse(
        "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-statistics-about-products/${emailVal}",


      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $tokenVal",
      },
      body: jsonEncode(
        {
          "productIndex":index,
        },
      ),
      encoding:
      Encoding.getByName("utf-8"),
    );
    print(userFuture.body);
    setState(() {
      Constants.mostViewed = jsonDecode(userFuture.body)["mostViewed"];
    });



  }

  Future<void> getStatisticsAboutProductsForCategory(index, category) async {
    print("--------------------------");
    print(emailVal);
    print(index);

    http.Response userFuture = await http.post(
      Uri.parse(
        "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-statistics-about-products-for-category/${emailVal}",


      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $tokenVal",
      },
      body: jsonEncode(
        {
          "productIndex": index,
          "cartCategory": category,

        },
      ),
      encoding:
      Encoding.getByName("utf-8"),
    );
    print("XXXXXXXXXXXXX");
    print(jsonDecode(userFuture.body)[0]["forMostViewed"]);
    print("XXXXXXXXXXXXX");

    setState(() {
      Constants.mostViewed = jsonDecode(userFuture.body)[0]["forMostViewed"];
    });



  }
  Future<void> incrementProductViewsForCategory(index, category) async {
    await getStatisticsAboutProductsForCategory(index, category);
    setState(() {
      Constants.mostViewed +=1;
    });


    http.Response userFuture =
    await http.post(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/increment-most-viewed-for-category/$emailVal"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $tokenVal",
      },
      body: jsonEncode(
        {
          "productIndex":index,
          "cartCategory": category,
          "forMostViewed": Constants.mostViewed
        },
      ),
      encoding:
      Encoding.getByName("utf-8"),
    );
    print("OOOOOOOOOOOOOOOOOOOOOOOO");
    print(userFuture.body);
    print("OOOOOOOOOOOOOOOOOOOOOOOO");

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
  TextEditingController cartQuantitiesTextEditingController =
  TextEditingController();

  late String dropdownValue = 'All Products';

  Future<void> fetchKeysToSetPublishableKey() async {
    final String apiUrl =
        "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-payment-informations/$emailVal"; // Replace with your backend API URL

    final response = await http.get(
      Uri.parse(apiUrl),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON and update ApiKeys.
      final Map<String, dynamic> data = jsonDecode(response.body);
      ApiKeys.publishableKey = data['publishableKey'];

      Stripe.publishableKey = ApiKeys.publishableKey;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch keys');
    }
  }

  Future<void> fetchKeys() async {
    final String apiUrl =
        "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-payment-informations/$emailVal"; // Replace with your backend API URL

    final response = await http.get(
      Uri.parse(apiUrl),
    );

    print("?????????????????????");
    print(emailVal);
    print(response.body);
    print("?????????????????????");

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON and update ApiKeys.
      final Map<String, dynamic> data = jsonDecode(response.body);

      ApiKeys.publishableKey = data['publishableKey'];
      ApiKeys.secretKey = data['secretKey'];
      // Stripe.publishableKey = ApiKeys.publishableKey;
      print("?????????????????????");
      print('Publishable Key: ${ApiKeys.publishableKey}');
      print('Secret Key: ${ApiKeys.secretKey}');
      print("?????????????????????");
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch keys');
    }
  }

  ////////
  void getUserByName() async {
    print("ppppppppppppppppppp");
    print(emailVal);
    print("ppppppppppppppppppp");

    http.Response userFuture = await http.get(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/profile/${customerEmailVal}"),
        headers: {"Authorization": "Bearer ${customerTokenVal}"});
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

  User tempCustomerProfileData = User("", "", "", "", "", "");

  Icon favoriteIcon = Icon(Icons.favorite_border, size: 20, color: Colors.white,);

  Timer? _timer;

  Future<void> initPlatform() async{
    await OneSignal.shared.setAppId("6991924e-f460-444c-824d-bf138d0e8d7b");
    await OneSignal.shared.getDeviceState().then((value) async {
      print("${value?.userId} RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");

      http.Response
      userFuture =
      await http.post(
        Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/add-user-device-id-into-list/${emailVal}"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "deviceId": value?.userId,
          },
        ),
        encoding: Encoding.getByName("utf-8"),
      );

      print(userFuture.body);
    });

  }

  Future<void> _navigateToSecondScreen() async {
    // Check for permission before navigation
    final permissionStatus = await Permission.locationWhenInUse.request();

    if (permissionStatus.isGranted) {
      // Navigate to the second screen if permission is granted
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            CustomerNotificationsPage(
                customerEmailVal, customerTokenVal, emailVal, tokenVal,
                _isSelected)),
      );
    } else {
      // Handle permission denial or other status
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            permissionStatus.isDenied
                ? 'Location permission denied. Please grant access to use this feature.'
                : 'Location permission request unsuccessful.',
          ),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initPlatform();
    WidgetsBinding.instance.addObserver(this);


    tokenVal = widget.token;
    emailVal = widget.email;
    customerTokenVal = widget.customerTokenVal;
    customerEmailVal = widget.customerEmailVal;
    specificStoreCategoriesVal = widget.specificStoreCategories;
    storeNameVal = widget.storeName;
    objectDataVal = widget.objectData;

    backgroundColor = widget.backgroundColor;
    boxesColor = widget.boxesColor;
    primaryTextColor = widget.primaryTextColor;
    secondaryTextColor = widget.secondaryTextColor;
    clippingColor = widget.clippingColor;
    smoothy = widget.smoothy;
    design = widget.design;

    print(backgroundColor);
    print(boxesColor);
    print(primaryTextColor);
    print(secondaryTextColor);
    print(clippingColor);
    print(smoothy);
    print(design);


    print(emailVal);
    // userData = getUserByName();
    sliderImages = getSliderImages();
    specificStoreCategories = getSpecificStoreCategories();

    sliderVisibilityVal = widget.sliderVisibility;
    categoryVisibilityVal = widget.categoryVisibility;
    cartsVisibilityVal = widget.cartsVisibility;
    // Stripe.publishableKey="pk_test_51P0BDE1qqwiIHxVLW2VQnKp18Mv56mjqtQTGOw8ZyjkBN8wsDyVo8ohAWlV85JDmvY5lBeql0i1q8dl3IFCjtFw400LCCXSBZ7";
    fetchKeysToSetPublishableKey();
    fetchKeys();
    getUserByName();
    getCustomerFavoriteList();
    getSpecificStoreCart(emailVal);
    findUserDeviceIdFromList();
    getMerchantProfile();

  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Execute your function here when the app resumes from the background
      // yourFunction();

      getSpecificStoreCategories();
    }

  }

  final ValueNotifier<int> _refreshCountNotifier = ValueNotifier<int>(0);
  @override
  void dispose() {
    _startRefresh();
    super.dispose();
  }
  // int _refreshCount = 0;
  void _startRefresh() async {
    await Future.delayed(Duration(seconds: 30));
    setState(() {
      // _refreshCount++;
      _refreshCountNotifier.value++;
      getCustomerFavoriteList();
      getSpecificStoreCart(emailVal);

    });
  }



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> _refreshData() async {
    setState(() {
      getUserByName();
    });
    await Future.delayed(Duration(seconds: 2));
  }
  Timer? timer;

  bool isPressed = true;
  bool isPressed2 = true;
  bool isHighlighted = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Color(0xFF212128),
        width: MediaQuery.of(context).size.width / 1.3,
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            children: [
              Container(
                height: 290,
                child: DrawerHeader(
                    padding: EdgeInsets.all(0),
                    child: Stack(
                      children: [
                        Image.network(
                          tempCustomerProfileData.Avatar,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Center(
                          child: Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white,
                                          width: 3), // Customize the border color
                                    ),
                                    child: CircleAvatar(
                                        radius: 80,
                                        child: ClipOval(
                                            child: Image.network(
                                              "${tempCustomerProfileData.Avatar}",
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ))),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    width: double.infinity,
                                    // color: Colors.black,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${tempCustomerProfileData.username}",
                                          style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.white, fontSize: 35),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "${tempCustomerProfileData.phone}",
                                          style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.white, fontSize: 20),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        )
                      ],
                    )),
              ),

              Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "${getLang(context, 'edit_profile')}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print("My Profile");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerEditProfilePage(
                                customerTokenVal,
                                customerEmailVal,
                                tempCustomerProfileData)));
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "${getLang(context, 'my_cart')}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print("My Profile");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerMyCartPage(customerEmailVal, customerTokenVal)));
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "${getLang(context, 'my_favorites')}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    print("My Profile");
                    await getStoreIndex();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerFavoriteProducts(
                                customerTokenVal, customerEmailVal, tokenVal, emailVal, storeIndexVal)));
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.chat,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "${getLang(context, 'chat_system')}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print("My Profile");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerChatSystem(customerTokenVal, customerEmailVal, merchantData["merchantname"], merchantData["Avatar"], emailVal)));
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "${getLang(context, 'notifications')}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print("My Profile");
                    findUserDeviceIdFromList();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerNotificationsPage(customerEmailVal, customerTokenVal, emailVal, tokenVal, _isSelected )));
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.support,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "${getLang(context, 'support')}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print("My Profile");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerSupportPage(customerEmailVal, customerTokenVal, emailVal, tokenVal )));
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "${getLang(context, 'stores_list')}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CustomerMainPage(customerTokenVal, customerEmailVal)));
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "${getLang(context, 'logout')}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CustomerLoginOrRegister("", "")));
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(int.parse(backgroundColor.replaceAll("Color(", "").replaceAll(")", ""))),
      appBar: AppBar(
        backgroundColor: Color(int.parse(boxesColor.replaceAll("Color(", "").replaceAll(")", ""))),
        leading: IconButton(onPressed: (){
          _openDrawer();
        }, icon: Icon(Icons.menu, color: Color(int.parse(secondaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))), size: 30,),),
        title: Text("${storeNameVal}", style: TextStyle(color: Color(int.parse(secondaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))), fontSize: 24, fontWeight: FontWeight.bold), ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async {
            await getStoreIndex();

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerFavoriteProducts(
                        customerTokenVal, customerEmailVal, tokenVal, emailVal, storeIndexVal)));
          }, icon: Icon(Icons.favorite_outline, color: Color(int.parse(secondaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))), size: 30,)),
          SizedBox(width: 10,),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List>(
                  future: sliderImages,
                  builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                    return Container(
                      // color: Colors.blue,
                      height: MediaQuery.of(context).size.height / 1.15,
                      margin: EdgeInsets.fromLTRB(5,0,5,0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
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
                                    margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                                    width: double.infinity,
                                    child: Text("${getLang(context, 'all_categories')}", style: TextStyle(color: Color(int.parse(primaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))), fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.start,)),
                                SizedBox(
                                  height: spaceBelowComponent,
                                ),
                                FutureBuilder<List>(
                                  future: specificStoreCategories,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List> snapshot) {
                                    print(storeCartsVal);
                                    return Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.13,
                                      height: 50,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                        specificStoreCategoriesVal.length,
                                        itemBuilder: (context, index) =>
                                            Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                  color:
                                                  specificStoreCategoriesVal[
                                                  index] ==
                                                      "All Products"
                                                      ? Color(int.parse(clippingColor.replaceAll("Color(", "").replaceAll(")", "")))
                                                      : Color(int.parse(boxesColor.replaceAll("Color(", "").replaceAll(")", ""))),
                                                ),
                                                width: specificStoreCategoriesVal[
                                                index] ==
                                                    "All Products" ? 150 : 120,
                                                child: TextButton(
                                                    onPressed: () async {
                                                      QuickAlert.show(
                                                        context: context,
                                                        type: QuickAlertType.loading,
                                                        title: '${getLang(context, 'loading')}',
                                                        text: '${getLang(context, 'fetch_data')}',
                                                      );
                                                      timer = Timer(const Duration(milliseconds: 2000), () {
                                                        // Simulate data fetching completion (replace with actual logic)
                                                        bool dataFetched = true; // Assuming data is fetched after 2 seconds

                                                        if (dataFetched) {
                                                          Navigator.pop(context); // Dismiss dialog if data is fetched
                                                        } else {
                                                          // Handle case where data fetching takes longer (optional)
                                                          print('Data fetching taking longer than expected...');
                                                        }
                                                      });


                                                      if (specificStoreCategoriesVal[
                                                      index] ==
                                                          "All Products") {
                                                        getCustomerFavoriteList();
                                                        await getSpecificStoreCart(emailVal);
                                                        setState(() {
                                                          cartsForSpecificCategory =
                                                          false;
                                                        });
                                                      } else {
                                                        await getCartsForOneCategory(
                                                            emailVal,
                                                            specificStoreCategoriesValEn[
                                                            index]);
                                                        await getCartsForOneCategory(
                                                            emailVal,
                                                            specificStoreCategoriesValEn[
                                                            index]);

                                                        setState(() {
                                                          cartsForSpecificCategory =
                                                          true;
                                                        });

                                                        print(
                                                            cartsForSpecificCategory);
                                                      }
                                                    },
                                                    child: Text(index == 0 ? "${getLang(context, 'all_products')}":  specificStoreCategoriesVal[
                                                    index] ,
                                                        style:
                                                        GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                              color: specificStoreCategoriesVal[
                                                              index] == "All Products" ? Color(int.parse(secondaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))) : Color(int.parse(secondaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))),
                                                              fontSize: 18),
                                                        )))),
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
                            /////////////////
                            SizedBox(
                              height: spaceAboveComponent,
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                                width: double.infinity,
                                child: Text("${getLang(context, 'latest')}", style: TextStyle(color: Color(int.parse(primaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))), fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.start,)),
                            SizedBox(
                              height: spaceBelowComponent,
                            ),
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
                                            builder: (BuildContext context) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                  child: CachedNetworkImage(
                                                    imageUrl: url,
                                                    placeholder: (context, url) =>
                                                        SimpleCircularProgressBar(
                                                          mergeMode: true,
                                                          animationDuration: 1,
                                                        ),
                                                    errorWidget:
                                                        (context, url, error) =>
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
                                        // color: Colors.red,
                                        padding:
                                        EdgeInsets.fromLTRB(0, 0, 20, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                alignment: Alignment.topLeft,
                                                child: Text("${getLang(context, 'products')}", style: TextStyle(color: Color(int.parse(primaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))), fontWeight: FontWeight.bold, fontSize: 24),)),

                                            Container(
                                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              child: InkWell(
                                                child: Text(
                                                  "${getLang(context, 'view_all')}",
                                                  style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(int.parse(primaryTextColor.replaceAll("Color(", "").replaceAll(")", "")))),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  // _startRefresh();
                                                  await getStoreIndex();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CustomerDisplayAllProducts(
                                                                  customerTokenVal, customerEmailVal, tokenVal, emailVal, storeIndexVal)));
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: spaceBelowComponent,
                                      ),
                                      Visibility(
                                        visible: !cartsForSpecificCategory,
                                        child: Container(
                                          width:
                                          MediaQuery.of(context).size.width,
                                          child: GridView.builder(
                                            padding:
                                            EdgeInsets.fromLTRB(0, 12, 0, 0),
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
                                                InkWell(
                                                  onTap: () async {
                                                    QuickAlert.show(
                                                      context: context,
                                                      type: QuickAlertType.loading,
                                                      title: '${getLang(context, 'loading')}',
                                                      text: '${getLang(context, 'fetch_data')}',
                                                    );
                                                    await incrementProductViews(index);
                                                    // PaymentManager.makePayment(20,"USD");

                                                    await getSpecificStoreCart(emailVal);
                                                    print("+++++++++++++++++++++");
                                                    print(storeCartsVal[index]);
                                                    print("+++++++++++++++++++++");
                                                    await getStoreIndex();

                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerDisplayProduct(storeCartsVal[index], customerTokenVal, customerEmailVal, tokenVal, emailVal, storeIndexVal)));
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                    padding: EdgeInsets.fromLTRB(
                                                        5, 0, 5, 10),
                                                    child: Column(
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
                                                                  Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                  topLeft:
                                                                  Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                ),
                                                                color:
                                                                Color(0xF2222128),
                                                              ),
                                                              height: 180,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                BorderRadius.only(
                                                                  topRight:
                                                                  Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                  topLeft:
                                                                  Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                ),
                                                                child: (storeCartsVal[index]
                                                                [
                                                                "cartPrimaryImage"]
                                                                    .toString() ==
                                                                    "null" ||
                                                                    storeCartsVal[index]
                                                                    [
                                                                    "cartPrimaryImage"]
                                                                        .toString() ==
                                                                        "")
                                                                    ? Image.network(
                                                                  "https://th.bing.com/th/id/R.2cdd64d3370db75b36e9b02259d1832a?rik=w2QxlPJgMEIzXQ&pid=ImgRaw&r=0",
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  width: double
                                                                      .infinity,
                                                                  height: 180,
                                                                )
                                                                    : Image.network(
                                                                  storeCartsVal[
                                                                  index]
                                                                  [
                                                                  "cartPrimaryImage"]
                                                                      .toString(),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  width: double
                                                                      .infinity,
                                                                  height: 180,
                                                                ),
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
                                                                    "${getLang(context, 'discount')}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                        11,
                                                                        fontWeight:
                                                                        FontWeight.bold),
                                                                    textAlign: TextAlign.center,
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
                                                                        initialValue: storeCartsVal[index]["isFavorite"], onChanged: (_isFavorite) async {
                                                                          if (_isFavorite) {
                                                                            try {
                                                                              storeCartsVal[index]["isFavorite"] = _isFavorite;
                                                                              http.Response
                                                                              userFuture =
                                                                              await http.post(
                                                                                Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/customer-add-to-favorite-list/${customerEmailVal}"),
                                                                                headers: {
                                                                                  "Content-Type": "application/json",
                                                                                  "Authorization": "Bearer ${customerTokenVal}"
                                                                                },
                                                                                body: jsonEncode(
                                                                                  {
                                                                                    "favouriteList": storeCartsVal[index],
                                                                                  },
                                                                                ),
                                                                                encoding: Encoding.getByName("utf-8"),
                                                                              );

                                                                              getCustomerFavoriteList();
                                                                              getSpecificStoreCart(emailVal);

                                                                              print(userFuture.body);
                                                                            } catch (error) {}
                                                                          } else {
                                                                            try {

                                                                              storeCartsVal[index]["isFavorite"] = !_isFavorite;
                                                                              print(storeCartsVal[index]["cartName"]);
                                                                              print(storeCartsVal[index]["merchant"]);
                                                                              http.Response
                                                                              userFuture =
                                                                              await http.delete(
                                                                                Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-product-from-favorite-list-from-different-stores/${customerEmailVal}"),
                                                                                headers: {
                                                                                  "Content-Type": "application/json",
                                                                                  "Authorization": "Bearer ${customerTokenVal}"
                                                                                },

                                                                                body: jsonEncode(
                                                                                  {
                                                                                    "cartName": storeCartsVal[index]["cartName"],
                                                                                    "merchant": storeCartsVal[index]["merchant"]
                                                                                  },
                                                                                ),
                                                                                encoding: Encoding.getByName("utf-8"),
                                                                              );
                                                                              getCustomerFavoriteList();
                                                                              getSpecificStoreCart(emailVal);

                                                                              print(userFuture.body);

                                                                            } catch (error) {}
                                                                          }
                                                                          print(
                                                                              'Is Favorite $_isFavorite');
                                                                        }),
                                                                  )),
                                                            ),
                                                            storeCartsVal[index]["cartDiscount"] ? Positioned(
                                                              left: 5,
                                                              top: 5,
                                                              child: CustomPaint(
                                                                size: Size(45, 45),
                                                                painter: DiscountPainter(storeCartsVal[index]["discountValue"] * 1.0), // Change this value to set the discount percentage
                                                              ),) : Container()
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            height: 71,
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.only(
                                                                bottomRight:
                                                                Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                bottomLeft:
                                                                Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                              ),
                                                              color:Color(int.parse(boxesColor.replaceAll("Color(", "").replaceAll(")", ""))),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      8,
                                                                      10,
                                                                      0),
                                                                  child: Text(
                                                                    "${storeCartsVal[index]["cartName"].toString()}",
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                    maxLines: 1,
                                                                    style: GoogleFonts
                                                                        .roboto(
                                                                        textStyle:
                                                                        TextStyle(
                                                                          fontSize: 22,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                          color: Color(int.parse(secondaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))),
                                                                        )),
                                                                  ),
                                                                ),

                                                                Expanded(
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
                                                                            10,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                        child: Text(
                                                                          "${storeCartsVal[index]["cartPrice"].toString()}\$",
                                                                          overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                          maxLines: 1,
                                                                          style: GoogleFonts
                                                                              .roboto(
                                                                              textStyle:
                                                                              TextStyle(
                                                                                fontSize:
                                                                                13,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .bold,
                                                                                color: Color(int.parse(secondaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      Visibility(
                                                                        visible: storeCartsVal[index]["cartDiscount"],
                                                                        child: Container(
                                                                          // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                          child: "${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}" ==
                                                                              "null"
                                                                              ? Text("")
                                                                              : Text(
                                                                            "${storeCartsVal[index]["cartPriceAfterDiscount"]}",
                                                                            overflow:
                                                                            TextOverflow.ellipsis,
                                                                            maxLines:
                                                                            1,
                                                                            style: GoogleFonts.roboto(
                                                                                textStyle: TextStyle(
                                                                                  fontSize:
                                                                                  11,
                                                                                  fontWeight:
                                                                                  FontWeight.bold,
                                                                                  decoration:
                                                                                  TextDecoration.lineThrough,
                                                                                  decorationThickness:
                                                                                  3,
                                                                                  color:Color(int.parse(secondaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))),
                                                                                )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible:false,
                                                                  child: Container(
                                                                    padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                        7,
                                                                        2,
                                                                        0,
                                                                        0),
                                                                    child: RatingBar
                                                                        .builder(
                                                                      initialRating:
                                                                      3,
                                                                      minRating: 1,
                                                                      direction: Axis
                                                                          .horizontal,
                                                                      allowHalfRating:
                                                                      true,
                                                                      itemCount: 5,
                                                                      itemSize: 20,
                                                                      unratedColor:
                                                                      Colors
                                                                          .white,
                                                                      itemPadding: EdgeInsets
                                                                          .symmetric(
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
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            itemCount: storeCartsVal.length,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: cartsForSpecificCategory,
                                        child: Container(
                                          width:
                                          MediaQuery.of(context).size.width,
                                          child: GridView.builder(
                                            padding:
                                            EdgeInsets.fromLTRB(0, 12, 0, 0),
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
                                                InkWell(
                                                  onTap: () async {
                                                    QuickAlert.show(
                                                      context: context,
                                                      type: QuickAlertType.loading,
                                                      title: '${getLang(context, 'loading')}',
                                                      text: '${getLang(context, 'fetch_data')}',
                                                    );
                                                    await incrementProductViewsForCategory(index, CartsForOneCategoryVal[index]["cartCategory"]);
                                                    // PaymentManager.makePayment(20,"USD");
                                                    // PaymentManager.makePayment(20,"USD");

                                                    await getSpecificStoreCart(emailVal);
                                                    print("+++++++++++++++++++++");
                                                    print(storeCartsVal[index]);
                                                    print("+++++++++++++++++++++");
                                                    await getStoreIndex();


                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerDisplayProduct(CartsForOneCategoryVal[index], customerTokenVal, customerEmailVal, tokenVal, emailVal, storeIndexVal)));
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                    padding: EdgeInsets.fromLTRB(
                                                        5, 0, 5, 10),
                                                    child: Column(
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
                                                                  Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                  topLeft:
                                                                  Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                ),
                                                                color:
                                                                Color(0xF2222128),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                BorderRadius.only(
                                                                  topRight:
                                                                  Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                  topLeft:
                                                                  Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                ),
                                                                child: (CartsForOneCategoryVal[index]
                                                                [
                                                                "cartPrimaryImage"]
                                                                    .toString() ==
                                                                    "null" ||
                                                                    CartsForOneCategoryVal[index]
                                                                    [
                                                                    "cartPrimaryImage"]
                                                                        .toString() ==
                                                                        "")
                                                                    ? Image.network(
                                                                  "https://th.bing.com/th/id/R.2cdd64d3370db75b36e9b02259d1832a?rik=w2QxlPJgMEIzXQ&pid=ImgRaw&r=0",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: double
                                                                      .infinity,
                                                                  height: 180,
                                                                )
                                                                    : Image.network(
                                                                  CartsForOneCategoryVal[
                                                                  index]
                                                                  [
                                                                  "cartPrimaryImage"]
                                                                      .toString(),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: double
                                                                      .infinity,
                                                                  height: 180,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              bottom: 0,
                                                              left: 0,
                                                              child: CartsForOneCategoryVal[
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
                                                                    "${getLang(context, 'discount')}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                        11,
                                                                        fontWeight:
                                                                        FontWeight.bold),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                              )
                                                                  : Container(),
                                                            ),
                                                            CartsForOneCategoryVal[index]["cartDiscount"] ? Positioned(
                                                              left: 5,
                                                              top: 5,
                                                              child: CustomPaint(
                                                                size: Size(45, 45),
                                                                painter: DiscountPainter(CartsForOneCategoryVal[index]["discountValue"] * 1.0), // Change this value to set the discount percentage
                                                              ),) : Container(),
                                                            Visibility(
                                                              visible: CartsForOneCategoryVal[index]["cartFavourite"],
                                                              child: Positioned(
                                                                  top: 5,
                                                                  right: 5,
                                                                  child: CircleAvatar(
                                                                    radius: 23,
                                                                    backgroundColor:
                                                                    Colors.red,
                                                                    child: ToggleButton(onIcon: Icon(Icons.favorite, color: Colors.black),
                                                                        offIcon: Icon(Icons.favorite_outline, color: Colors.black),
                                                                        initialValue: CartsForOneCategoryVal[index]["isFavorite"], onChanged: (_isFavorite) async {
                                                                          if (_isFavorite) {
                                                                            try {
                                                                              setState(() {
                                                                                CartsForOneCategoryVal[index]["isFavorite"] = _isFavorite;
                                                                              });

                                                                              http.Response
                                                                              userFuture =
                                                                              await http.post(
                                                                                Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/customer-add-to-favorite-list/${customerEmailVal}"),
                                                                                headers: {
                                                                                  "Content-Type": "application/json",
                                                                                  "Authorization": "Bearer ${customerTokenVal}"
                                                                                },
                                                                                body: jsonEncode(
                                                                                  {
                                                                                    "favouriteList": CartsForOneCategoryVal[index],
                                                                                  },
                                                                                ),
                                                                                encoding: Encoding.getByName("utf-8"),
                                                                              );

                                                                              print(userFuture.body);
                                                                              getCustomerFavoriteList();
                                                                              print("0000000000000000000000000");
                                                                              print(CartsForOneCategoryVal[index]["cartCategory"]);
                                                                              getCartsForOneCategory(emailVal, CartsForOneCategoryVal[index]["cartCategory"]);

                                                                            } catch (error) {}
                                                                          } else {
                                                                            try {

                                                                              CartsForOneCategoryVal[index]["isFavorite"] = !_isFavorite;
                                                                              http.Response
                                                                              userFuture =
                                                                              await http.delete(
                                                                                Uri.parse("https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/delete-product-from-favorite-list-from-different-stores/${customerEmailVal}"),
                                                                                headers: {
                                                                                  "Content-Type": "application/json",
                                                                                  "Authorization": "Bearer ${customerTokenVal}"
                                                                                },
                                                                                body: jsonEncode(
                                                                                  {
                                                                                    "cartName": CartsForOneCategoryVal[index]["cartName"],
                                                                                    "merchant": CartsForOneCategoryVal[index]["merchant"],
                                                                                  },
                                                                                ),
                                                                                encoding: Encoding.getByName("utf-8"),
                                                                              );

                                                                              print(userFuture.body);
                                                                              getCustomerFavoriteList();
                                                                              print(CartsForOneCategoryVal[index]["cartCategory"]);
                                                                              getCartsForOneCategory(emailVal, CartsForOneCategoryVal[index]["cartCategory"]);

                                                                            } catch (error) {}
                                                                          }
                                                                          print(
                                                                              'Is Favorite $_isFavorite');
                                                                        }),
                                                                  )),
                                                            ),

                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            height: 70,
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.only(
                                                                bottomRight:
                                                                Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                                bottomLeft:
                                                                Radius.circular(smoothy == "Smooth" ? smoothDesignBorderRadius : solidDesignBorderRadius),
                                                              ),
                                                              color:Color(int.parse(boxesColor.replaceAll("Color(", "").replaceAll(")", ""))),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      8,
                                                                      10,
                                                                      0),
                                                                  child: Text(
                                                                      "${CartsForOneCategoryVal[index]["cartName"].toString()}",
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
                                                                        color: Color(int.parse(secondaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))),
                                                                      )),
                                                                ),
                                                          
                                                                Expanded(
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
                                                                            10,
                                                                            0,
                                                                            2,
                                                                            0),
                                                                        child: Text(
                                                                            "${CartsForOneCategoryVal[index]["cartPrice"].toString()}",
                                                                            overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                            maxLines:
                                                                            1,
                                                                            style:
                                                                            TextStyle(
                                                                              fontSize:
                                                                              13,
                                                                              fontWeight:
                                                                              FontWeight.bold,
                                                                              color: Color(int.parse(secondaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))),
                                                                            )),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      Visibility(
                                                                        visible: CartsForOneCategoryVal[index]["cartDiscount"],
                                                                        child: Container(
                                                                          // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                          child: "${CartsForOneCategoryVal[index]["cartPriceAfterDiscount"].toString()}" ==
                                                                              "null"
                                                                              ? Text("")
                                                                              : Text(
                                                                              "${CartsForOneCategoryVal[index]["cartPriceAfterDiscount"]}",
                                                                              overflow: TextOverflow
                                                                                  .ellipsis,
                                                                              maxLines:
                                                                              1,
                                                                              style:
                                                                              TextStyle(
                                                                                fontSize:
                                                                                11,
                                                                                fontWeight:
                                                                                FontWeight.bold,
                                                                                decoration:
                                                                                TextDecoration.lineThrough,
                                                                                decorationThickness:
                                                                                3,
                                                                                color:Color(int.parse(secondaryTextColor.replaceAll("Color(", "").replaceAll(")", ""))),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                          
                                                                Visibility(
                                                                  visible: false,
                                                                  child: Container(
                                                                    padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                        7,
                                                                        2,
                                                                        0,
                                                                        0),
                                                                    child: RatingBar
                                                                        .builder(
                                                                      initialRating:
                                                                      3,
                                                                      minRating: 1,
                                                                      direction: Axis
                                                                          .horizontal,
                                                                      allowHalfRating:
                                                                      true,
                                                                      itemCount: 5,
                                                                      itemSize: 20,
                                                                      unratedColor:
                                                                      Colors
                                                                          .white,
                                                                      itemPadding: EdgeInsets
                                                                          .symmetric(
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
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            itemCount:
                                            CartsForOneCategoryVal.length,
                                          ),
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
    );
  }

  void defaultCategoryContainer() {}

  void defaultCartContainer() {}

  void addDataToFilteredData() {}


}




////////////////////////////////////
/////////////////////////////////////

