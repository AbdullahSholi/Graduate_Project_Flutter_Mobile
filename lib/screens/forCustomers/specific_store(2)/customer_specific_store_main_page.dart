import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

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
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/models/login_model.dart';
import 'package:graduate_project/models/merchant/cart_content_model.dart';
import 'package:graduate_project/models/merchant/merchant_connect_store_to_social_media.dart';
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
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

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
import 'customer_my_cart_page.dart';
import 'customer_support_page.dart';

class CustomerSpecificStoreMainPage extends StatefulWidget {
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
  const CustomerSpecificStoreMainPage(
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
      {super.key});
  @override
  State<CustomerSpecificStoreMainPage> createState() =>
      _CustomerSpecificStoreMainPageState();
}

class _CustomerSpecificStoreMainPageState
    extends State<CustomerSpecificStoreMainPage> {
  String tokenVal = "";
  String emailVal = "";
  String customerTokenVal = "";
  String customerEmailVal = "";
  String imageSliderVal = "";
  List<String> specificStoreCategoriesVal = [];
  late Map<String, dynamic> objectDataVal;
  String storeNameVal = "";
  late bool sliderVisibilityVal;
  late bool categoryVisibilityVal;
  late bool cartsVisibilityVal;

  late Future<User> userData;
  late Future<List> sliderImages;
  late Future<List> specificStoreCategories;
  late Future<List> getCartContent;
  // late indexVal="";
  double rateVal = 3;

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


  Future<List> getSliderImages() async {
    print("$emailVal tttttttttt");
    http.Response userFuture = await http.get(
      Uri.parse(
          "http://10.0.2.2:3000/matjarcom/api/v1/store-data/${emailVal}"),
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
          "http://10.0.2.2:3000/matjarcom/api/v1/store-data/${emailVal}"),
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
  List<dynamic> storeCartsVal = [];
  List<dynamic> CartsForOneCategoryVal = [];
  List<dynamic> favoriteList = [];
  void getCustomerFavoriteList() async {
    print("ppppppppppppppppppp");
    print(customerEmailVal);
    print("ppppppppppppppppppp");

    http.Response userFuture = await http.get(
        Uri.parse(
            "http://10.0.2.2:3000/matjarcom/api/v1/get-customer-favorite-list/${customerEmailVal}"),
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
          "http://10.0.2.2:3000/matjarcom/api/v1/test-get-store-cart/${emailVal}"),
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
          "http://10.0.2.2:3000/matjarcom/api/v1/get-all-carts-for-one-category?email=$emailVal&cartCategory=$cartCategory"),
    );
    print(userFuture.body);

///////////////////////////////////////////////////

    List<dynamic> jsonList = json.decode(userFuture.body);
    print("CCCCCCCCCCCCCCCCC");
    print(jsonList[0]["cartName"]);

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
          "http://10.0.2.2:3000/matjarcom/api/v1/test-get-store-cart/${emailVal}"),
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
        "http://10.0.2.2:3000/matjarcom/api/v1/get-payment-informations/$emailVal"; // Replace with your backend API URL

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
        "http://10.0.2.2:3000/matjarcom/api/v1/get-payment-informations/$emailVal"; // Replace with your backend API URL

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
            "http://10.0.2.2:3000/matjarcom/api/v1/profile/${customerEmailVal}"),
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tokenVal = widget.token;
    emailVal = widget.email;
    customerTokenVal = widget.customerTokenVal;
    customerEmailVal = widget.customerEmailVal;
    specificStoreCategoriesVal = widget.specificStoreCategories;
    storeNameVal = widget.storeName;
    objectDataVal = widget.objectData;
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
      // Update your data or state variables
    });
    await Future.delayed(Duration(seconds: 2));
  }

  bool isPressed = true;
  bool isPressed2 = true;
  bool isHighlighted = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Color(0xFF1E1F22),
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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 35),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "${tempCustomerProfileData.phone}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
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
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "My Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print("My Profile");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyProfilePage(
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
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "Edit Profile",
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
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "My Cart",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print("My Profile");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerMyCartPage()));
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
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "My Favorites",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print("My Profile");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerFavoriteProducts(
                                customerTokenVal, customerEmailVal, tokenVal, emailVal)));
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
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.chat,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "Chat System",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print("My Profile");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerChatSystem()));
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
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.support,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "Support",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print("My Profile");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerSupportPage()));
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
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "Stores List",
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
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF2A212E)),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Login()));
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
      body: SingleChildScrollView(
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
                  IconButton(
                      onPressed: () {
                        _openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 35,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                        child: Text(
                      storeNameVal,
                      style: GoogleFonts.lilitaOne(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      onPressed: () {
                        // _startRefresh();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerFavoriteProducts(
                                    customerTokenVal, customerEmailVal, tokenVal, emailVal)));
                      },
                      icon: Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.white,
                        size: 35,
                      )),
                ],
              ),
            ),
            FutureBuilder<List>(
                future: sliderImages,
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  return Container(
                    // color: Colors.blue,
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
                                                    BorderRadius.circular(10),
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
                          Visibility(
                            visible: categoryVisibilityVal,
                            child: Column(children: [
                              SizedBox(
                                height: 15,
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
                                                    BorderRadius.circular(10),
                                                color:
                                                    specificStoreCategoriesVal[
                                                                index] ==
                                                            "All Products"
                                                        ? Color(0xFFFF2139)
                                                        : Color(0xFF212128),
                                              ),
                                              width: 120,
                                              child: TextButton(
                                                  onPressed: () async {
                                                    if (specificStoreCategoriesVal[
                                                            index] ==
                                                        "All Products") {
                                                      setState(() {
                                                        cartsForSpecificCategory =
                                                            false;
                                                      });
                                                    } else {
                                                      await getCartsForOneCategory(
                                                          emailVal,
                                                          specificStoreCategoriesVal[
                                                              index]);
                                                      setState(() {
                                                        cartsForSpecificCategory =
                                                            true;
                                                      });

                                                      print(
                                                          cartsForSpecificCategory);
                                                    }
                                                  },
                                                  child: Text(
                                                      specificStoreCategoriesVal[
                                                          index],
                                                      style:
                                                          GoogleFonts.lilitaOne(
                                                        textStyle: TextStyle(
                                                            color: Colors.white,
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
                          Column(
                            children: [
                              Visibility(
                                visible: cartsVisibilityVal,
                                child: Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(13, 20, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Products",
                                            style: GoogleFonts.lilitaOne(
                                              textStyle: TextStyle(
                                                  fontSize: 38,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF212128)),
                                            ),
                                          ),
                                          InkWell(
                                            child: Text(
                                              "View All",
                                              style: GoogleFonts.lilitaOne(
                                                textStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF212128)),
                                              ),
                                            ),
                                            onTap: () {
                                              // _startRefresh();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CustomerDisplayAllProducts(
                                                               customerTokenVal, customerEmailVal, tokenVal, emailVal)));
                                            },
                                          )
                                        ],
                                      ),
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
                                            onTap: () {
                                              // PaymentManager.makePayment(20,"USD");
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text(
                                                          "Product",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        backgroundColor:
                                                            Color(0xFF212128),
                                                        content: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                        ),
                                                      ));
                                            },
                                            child: Container(
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
                                                        height: 120,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
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
                                                                  height: 120,
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
                                                                  height: 120,
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
                                                                      Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/customer-add-to-favorite-list/${customerEmailVal}"),
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
                                                                      Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/delete-product-from-favorite-list-from-different-stores/${customerEmailVal}"),
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

                                                                    print(userFuture.body);

                                                                  } catch (error) {}
                                                                }
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
                                                      child: Container(
                                                        height: 120,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                          color:
                                                              Color(0xF2222128),
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
                                                                    .lilitaOne(
                                                                        textStyle:
                                                                            TextStyle(
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          8,
                                                                          10,
                                                                          3),
                                                              child: Text(
                                                                "${storeCartsVal[index]["cartDescription"].toString()}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: GoogleFonts
                                                                    .lilitaOne(
                                                                        textStyle:
                                                                            TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                              ),
                                                            ),
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
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          2,
                                                                          0),
                                                                  child: Text(
                                                                    "${storeCartsVal[index]["cartPrice"].toString()}",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                    style: GoogleFonts
                                                                        .lilitaOne(
                                                                            textStyle:
                                                                                TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                    )),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Container(
                                                                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                  child: "${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}" ==
                                                                          "null"
                                                                      ? Text("")
                                                                      : Text(
                                                                          "${storeCartsVal[index]["cartPriceAfterDiscount"].toString()}",
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                          style: GoogleFonts.lilitaOne(
                                                                              textStyle: TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            decoration:
                                                                                TextDecoration.lineThrough,
                                                                            decorationThickness:
                                                                                3,
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                        ),
                                                                ),
                                                              ],
                                                            ),
                                                            Visibility(
                                                              visible:
                                                                  storeCartsVal[
                                                                          index]
                                                                      [
                                                                      "cartLiked"],
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
                                                      )),
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
                                                0.73, // Customize the aspect ratio (width/height) of each tile
                                            mainAxisSpacing:
                                                4.0, // Spacing between rows
                                            crossAxisSpacing:
                                                2.0, // Spacing between columns
                                          ),
                                          // storeCartsVal[index]
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                            onTap: () {
                                              // PaymentManager.makePayment(20,"USD");
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text("Cart"),
                                                        content: Container(),
                                                      ));
                                            },
                                            child: Container(
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
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
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
                                                                  height: 120,
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
                                                                "false"
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
                                                    ],
                                                  ),
                                                  Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: Container(
                                                        height: 70,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                          color:
                                                              Color(0xF2222128),
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
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                            ),

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
                                                                        color: Colors
                                                                            .white,
                                                                      )),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Container(
                                                                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                  child: "${CartsForOneCategoryVal[index]["cartPriceAfterDiscount"].toString()}" ==
                                                                          "null"
                                                                      ? Text("")
                                                                      : Text(
                                                                          "${CartsForOneCategoryVal[index]["cartPriceAfterDiscount"].toString()}",
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
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                ),
                                                              ],
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
                                                      )),
                                                  Visibility(
                                                    visible: false,
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
                                                                CartsForOneCategoryVal[index]["isFavorite"] = _isFavorite;
                                                                http.Response
                                                                userFuture =
                                                                await http.post(
                                                                  Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/customer-add-to-favorite-list/${customerEmailVal}"),
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
                                                              } catch (error) {}
                                                            } else {
                                                              try {

                                                                CartsForOneCategoryVal[index]["isFavorite"] = !_isFavorite;
                                                                http.Response
                                                                userFuture =
                                                                await http.delete(
                                                                  Uri.parse("http://10.0.2.2:3000/matjarcom/api/v1/delete-product-from-favorite-list-from-different-stores/${customerEmailVal}"),
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

                                                              } catch (error) {}
                                                            }
                                                            print(
                                                                'Is Favorite $_isFavorite');
                                                          }),
                                                        )),
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
    );
  }

  void defaultCategoryContainer() {}

  void defaultCartContainer() {}

  void addDataToFilteredData() {}


}


////////////////////////////////////
/////////////////////////////////////

