import 'dart:convert';
import 'dart:io';

import 'package:animated_background/animated_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/components/applocal.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/forCustomers/customer_login_register/login_or_register(2).dart';
import 'package:graduate_project/screens/forGuest/specific_store(2)/specific_store_main_page.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/connect_to_social_media_accounts.dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_store_informations(5.3).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/display_your_store(5.1).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/edit_your_store_design(5.2).dart';
import 'package:graduate_project/screens/forMerchant/store_management(5)/store_management(5.0).dart';
import 'package:graduate_project/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:translator/translator.dart';

import '../../../../models/merchant/get_cart_content_model.dart';
import '../../../../models/merchant/merchant_connect_store_to_social_media.dart';
import '../../../../models/merchant/merchant_profile.dart';
import '../../../models/Stores/display-all-stores.dart';
import '../../../models/singleUser.dart';
import '../specific_store(2)/customer_contact_with_admin.dart';
import '../specific_store(2)/customer_favorite_products_for_all_products_from_main_page.dart';
import '../specific_store(2)/customer_my_profile_page.dart';
import '../specific_store(2)/customer_chat_system.dart';
import '../specific_store(2)/customer_edit_profile_page.dart';
import '../specific_store(2)/customer_my_cart_page.dart';
import '../specific_store(2)/customer_specific_store_main_page1.dart';
import '../specific_store(2)/customer_specific_store_main_page2.dart';
import '../specific_store(2)/customer_specific_store_main_page3.dart';
import '../specific_store(2)/customer_support_page.dart';
import 'package:intl/intl.dart';
import "package:flutter/widgets.dart";

class CustomerMainPage extends StatefulWidget {
  String token;
  String email;
  // late List<AllStore> storeDataVal;
  CustomerMainPage(this.token, this.email);

  @override
  State<CustomerMainPage> createState() => _CustomerMainPageState();
}

class _CustomerMainPageState extends State<CustomerMainPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  String customerTokenVal = "";
  String customerEmailVal = "";
  bool allStoresVisibility = true;
  late List<dynamic> tempStores = [];
  late List<dynamic> specificCategoryStores = [];
  Future<void> getAllStoresForOneCategory(storeCategory) async {
    setState(() {

      specificCategoryStores = [];
    });

    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-all-stores-for-one-category/${storeCategory}"),
    );
    // print(userFuture.body);
    List<dynamic> jsonList = json.decode(userFuture.body);
    for (int i = 0; i < jsonList.length; i++) {
      tempStores.add(SpecificStore.fromJson(jsonList[i]));
    }

    // print("jsonList: ${jsonList[1]}");
    // print(userFuture.statusCode);
    if (userFuture.statusCode == 200) {
      print("${userFuture.statusCode}");
      print(tempStores);

      setState(() {
        specificCategoryStores = tempStores;
        tempStores = [];
      });
    } else {
      print("error");
      throw Exception("Error");
    }
  }

  ///////////////////////////////////////////////////////////
  //////////////////////////////////////////////////
  late List<dynamic> getStoreDataVal = [];
  late List<dynamic> tempStores1 = [];
  Future<void> getMerchantData() async {
    http.Response userFuture = await http.get(
      Uri.parse(
          "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/get-all-stores/"),
    );
    print(userFuture.body);
    List<dynamic> jsonList = json.decode(userFuture.body);
    for (int i = 0; i < jsonList.length; i++) {
      tempStores1.add(SpecificStore.fromJson(jsonList[i]));
    }

    // print("jsonList: ${jsonList[1]}");

    if (userFuture.statusCode == 200) {
      print("${userFuture.statusCode}");
      List<dynamic> temp = [];
      final translator = GoogleTranslator();

      final String localeName = Platform.localeName; // e.g., "en_US"

      // You can extract the language code from the string if needed
      final String langCode = localeName.split('_').first; // e.g., "en"

      // if (langCode != "ar") {
        setState(() {
          getStoreDataVal = [];
          getStoreDataVal = tempStores1;
          tempStores1 = [];
        });
      // }

      // if (langCode == "ar") {
      //   List<Future<dynamic>> translatedData = tempStores1.map((item) async {
      //     final translatedName =
      //         await translator.translate(item.storeName, to: langCode);
      //     final translatedCategory =
      //         await translator.translate(item.storeCategory, to: langCode);
      //     item.storeName =
      //         translatedName.text; // Spread syntax for shallow copy
      //     item.storeCategory = translatedCategory.text;
      //     return item;
      //   }).toList();
      //
      //   List<dynamic> completedData = await Future.wait(translatedData);
      //   print("IIIIIIIIIIIIIIII");
      //   // print(getStoreDataVal[0].storeName);
      //   print(completedData);
      //   print("IIIIIIIIIIIIIIII");
      //   setState(() {
      //     getStoreDataVal = [];
      //     getStoreDataVal = completedData;
      //     tempStores1 = [];
      //   });
      // }
    } else {
      print("error");
      throw Exception("Error");
    }
  }


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

      items = stringList;
      itemsEn = stringList;
      print(items);
      print(itemsEn);
      print("uuuuuuuuuuuuXXXXXXXXXXXXXXXX");
    });




  }

  Future<void> saveIndex(index) async {
    print(index);
    print(customerEmailVal);
    http.Response userFuture = await http.post(
        Uri.parse(
            "https://graduate-project-backend-1.onrender.com/matjarcom/api/v1/add-store-index/${customerEmailVal}"),
        // headers: {"Authorization":"Bearer ${customerTokenVal}"},
        headers: {
          // "Authorization": "Bearer ${customerTokenVal}", // Include Authorization header if required
          "Content-Type": "application/json", // Set content type to JSON
        },
        body: jsonEncode({"index": index}));
    if (userFuture.statusCode == 200) {
      print("${userFuture.body}");
    } else {
      throw Exception("Error");
    }
  }

  late Future<User> userData;

  void getUserByName() async {
    print("ppppppppppppppppppp");
    // print(emailVal);
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
  Locale? _currentLocale;
  List<String> items = [];
  List<String> itemsEn = [];

  // final WidgetsBindingObserver _observer = WidgetsBindingObserver();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    customerEmailVal = widget.email;
    customerTokenVal = widget.token;
    getAdminData();
    // getStoreDataVal = widget.getStoreData;
    _currentLocale = WidgetsBinding.instance.platformDispatcher.locale;
    // getDataFromTranslator();
    getMerchantData();
    getUserByName();

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Execute your function here when the app resumes from the background
      // yourFunction();

      // getDataFromTranslator();
      getMerchantData();
    }
  }



  // Future<void> getDataFromTranslator() async {
  //   String _currentLocale1 = _currentLocale.toString().split('_').first;
  //
  //   setState(() {
  //     items = ["Electronics", "Cars", "Restaurants"];
  //   });
  //   final String localeName = Platform.localeName; // e.g., "en_US"
  //
  //   // You can extract the language code from the string if needed
  //   final String langCode = localeName.split('_').first; // e.g., "en"
  //
  //   final translator = GoogleTranslator();
  //   if (langCode == "ar") {
  //     var translator1 = await translator.translate("Electronics", to: langCode);
  //     var translator2 = await translator.translate("Cars", to: langCode);
  //     var translator3 = await translator.translate("Restaurants", to: langCode);
  //     setState(() {
  //       items = [translator1.text, translator2.text, translator3.text];
  //     });
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LogAllPage()));
        return Future.value(true);
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Color(0xFF212128),
            leading: IconButton(onPressed: (){
              _openDrawer();
            }, icon: Icon(Icons.menu, color: Colors.white, size: 30,)),
            title: Text("${getLang(context, 'stores')}", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),),
            centerTitle: true,
          ),
          drawer: Drawer(
            backgroundColor: Color(0xFF1E1F22),
            width: MediaQuery.of(context).size.width / 1.3,
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView(
                physics: BouncingScrollPhysics(),
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
                                          width:
                                              3), // Customize the border color
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${tempCustomerProfileData.username}",
                                          style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 35),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "${tempCustomerProfileData.phone}",
                                          style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
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
                        borderRadius: BorderRadius.circular(10),
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
                        borderRadius: BorderRadius.circular(10),
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
                                builder: (context) => CustomerMyCartPage(
                                    customerEmailVal, customerTokenVal)));
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
                        "${getLang(context, 'my_favorites')}",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        print("My Profile");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomerFavoriteProductsForAllProductsFromMainPage(
                                        customerTokenVal, customerEmailVal)));
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
                        "${getLang(context, 'support')}",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        print("My Profile");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerContactWithAdmin(
                                    customerEmailVal, customerTokenVal)));
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
                        "${getLang(context, 'logout')}",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerLoginOrRegister("", "")));
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
          body: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(

                    color: Color(0xFF212128),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [

                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 2,
                          color: Colors.white,
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height / 1.1,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,

                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 20, 0, 0),
                                          height: 50,
                                          child: InkWell(
                                            onTap: () async {
                                              setState(() {
                                                allStoresVisibility = true;
                                              });
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                  color: Color(0xFFFF2139),
                                                ),
                                                width: 120,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "${getLang(context, 'all_stores')}",
                                                  style:
                                                      GoogleFonts.roboto(
                                                          textStyle:
                                                              TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  )),
                                                  textAlign: TextAlign.center,
                                                )),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              10, 20, 20, 0),
                                          // width: MediaQuery.of(context)
                                          //     .size
                                          //     .width /
                                          //     2.1,
                                          height: 50,

                                          child: ListView.separated(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: itemsEn.length,
                                            itemBuilder: (context, index) =>
                                                InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  allStoresVisibility = false;
                                                });
                                                await getAllStoresForOneCategory(
                                                    itemsEn[index]);
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                  ),
                                                  width: 120,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    items[index],
                                                    style:
                                                        GoogleFonts.roboto(
                                                            textStyle:
                                                                TextStyle(
                                                      color:
                                                          Color(0xFF212128),
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                    textAlign:
                                                        TextAlign.center,
                                                  )),
                                            ),
                                            separatorBuilder:
                                                (context, index) => SizedBox(
                                              width: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Visibility(
                                  visible: allStoresVisibility,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            1, // Set the number of columns
                                        childAspectRatio:
                                            1.9, // Customize the aspect ratio (width/height) of each tile

                                        crossAxisSpacing:
                                            2.0, // Spacing between columns
                                      ),
                                      // storeCartsVal[index]
                                      itemBuilder: (context, index) =>
                                          InkWell(
                                        onTap: () {
                                          saveIndex(index);
                                          print(getStoreDataVal[index]
                                              .specificStoreCategories
                                              .runtimeType);
                                          List<String> stringList =
                                              getStoreDataVal[index]
                                                  .specificStoreCategories
                                                  .cast<String>()
                                                  .toList();
                                          print(stringList.runtimeType);
                                          print("777");
                                          print(getStoreDataVal[index].design);
                                          if(getStoreDataVal[index].design == "Option 1"){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomerSpecificStoreMainPage1(
                                                            "",
                                                            getStoreDataVal[
                                                            index]
                                                                .email,
                                                            stringList,
                                                            getStoreDataVal[
                                                            index]
                                                                .storeName,
                                                            [],
                                                            getStoreDataVal[
                                                            index]
                                                                .activateSlider,
                                                            getStoreDataVal[
                                                            index]
                                                                .activateCategory,
                                                            getStoreDataVal[
                                                            index]
                                                                .activateCarts,
                                                            {},
                                                            customerTokenVal,
                                                            customerEmailVal,
                                                          getStoreDataVal[index].backgroundColor,
                                                          getStoreDataVal[index].boxesColor,
                                                          getStoreDataVal[index].primaryTextColor,
                                                          getStoreDataVal[index].secondaryTextColor,
                                                          getStoreDataVal[index].clippingColor,
                                                          getStoreDataVal[index].smoothy,
                                                          getStoreDataVal[index].design,
                                                        )));
                                          }
                                          if(getStoreDataVal[index].design == "Option 2"){

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomerSpecificStoreMainPage2(
                                                            "",
                                                            getStoreDataVal[
                                                            index]
                                                                .email,
                                                            stringList,
                                                            getStoreDataVal[
                                                            index]
                                                                .storeName,
                                                            [],
                                                            getStoreDataVal[
                                                            index]
                                                                .activateSlider,
                                                            getStoreDataVal[
                                                            index]
                                                                .activateCategory,
                                                            getStoreDataVal[
                                                            index]
                                                                .activateCarts,
                                                            {},
                                                            customerTokenVal,
                                                            customerEmailVal,
                                                          getStoreDataVal[index].backgroundColor,
                                                          getStoreDataVal[index].boxesColor,
                                                          getStoreDataVal[index].primaryTextColor,
                                                          getStoreDataVal[index].secondaryTextColor,
                                                          getStoreDataVal[index].clippingColor,
                                                          getStoreDataVal[index].smoothy,
                                                          getStoreDataVal[index].design,
                                                        )));
                                          }
                                          if(getStoreDataVal[index].design == "Option 3"){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomerSpecificStoreMainPage3(
                                                            "",
                                                            getStoreDataVal[
                                                            index]
                                                                .email,
                                                            stringList,
                                                            getStoreDataVal[
                                                            index]
                                                                .storeName,
                                                            [],
                                                            getStoreDataVal[
                                                            index]
                                                                .activateSlider,
                                                            getStoreDataVal[
                                                            index]
                                                                .activateCategory,
                                                            getStoreDataVal[
                                                            index]
                                                                .activateCarts,
                                                            {},
                                                            customerTokenVal,
                                                            customerEmailVal,
                                                          getStoreDataVal[index].backgroundColor,
                                                          getStoreDataVal[index].boxesColor,
                                                          getStoreDataVal[index].primaryTextColor,
                                                          getStoreDataVal[index].secondaryTextColor,
                                                          getStoreDataVal[index].clippingColor,
                                                          getStoreDataVal[index].smoothy,
                                                          getStoreDataVal[index].design,
                                                        )));
                                          }



                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              20, 0, 20, 15),
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(width: 1),
                                            color: Color(0xFF212139),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(

                                                height: double.infinity,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.6,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.white),
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(20.0),
                                                      topRight: Radius.circular(20.0),
                                                      bottomLeft: Radius.circular(20.0),
                                                      bottomRight: Radius.circular(20.0),
                                                    ),
                                                    child: Image.network(
                                                  getStoreDataVal[index]
                                                      .storeAvatar,
                                                  fit: BoxFit.cover,
                                                )),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Container(


                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          2.5,
                                                      // color: Colors.blue,
                                                      child: Text(
                                                        "${getStoreDataVal[index].storeName}",
                                                        style: GoogleFonts
                                                            .roboto(
                                                                textStyle:
                                                                    TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      )),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          2.5,
                                                      // color: Colors.blue,
                                                      child: Text(
                                                        "${getStoreDataVal[index].storeCategory}",
                                                        style: GoogleFonts
                                                            .roboto(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 20),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      )),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          2.5,
                                                      // color: Colors.blue,
                                                      child: Text(
                                                        "${getLang(context, 'owned_by')}: ${getStoreDataVal[index].merchantname}",
                                                        style: GoogleFonts
                                                            .roboto(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 12),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      )),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          2.5,
                                                      // color: Colors.blue,
                                                      child: Text(
                                                        "${getLang(context, 'email_address')}: ${getStoreDataVal[index].email}",
                                                        style: GoogleFonts
                                                            .roboto(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 12),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      )),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          2.5,
                                                      // color: Colors.blue,
                                                      child: Text(
                                                        "${getLang(context, 'phone_number')}: ${getStoreDataVal[index].phone}",
                                                        style: GoogleFonts
                                                            .roboto(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 12),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                      itemCount: getStoreDataVal.length,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !allStoresVisibility,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            1, // Set the number of columns
                                        childAspectRatio:
                                            1.9, // Customize the aspect ratio (width/height) of each tile

                                        crossAxisSpacing:
                                            2.0, // Spacing between columns
                                      ),
                                      // storeCartsVal[index]
                                      itemBuilder: (context, index) =>
                                          InkWell(
                                        onTap: () {
                                          print(specificCategoryStores[index]
                                              .specificStoreCategories
                                              .runtimeType);
                                          List<String> stringList =
                                              specificCategoryStores[index]
                                                  .specificStoreCategories
                                                  .cast<String>()
                                                  .toList();
                                          print(stringList.runtimeType);

                                          if(getStoreDataVal[index].design == "Option 1"){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomerSpecificStoreMainPage1(
                                                          "",
                                                          getStoreDataVal[
                                                          index]
                                                              .email,
                                                          stringList,
                                                          getStoreDataVal[
                                                          index]
                                                              .storeName,
                                                          [],
                                                          getStoreDataVal[
                                                          index]
                                                              .activateSlider,
                                                          getStoreDataVal[
                                                          index]
                                                              .activateCategory,
                                                          getStoreDataVal[
                                                          index]
                                                              .activateCarts,
                                                          {},
                                                          customerTokenVal,
                                                          customerEmailVal,
                                                          getStoreDataVal[index].backgroundColor,
                                                          getStoreDataVal[index].boxesColor,
                                                          getStoreDataVal[index].primaryTextColor,
                                                          getStoreDataVal[index].secondaryTextColor,
                                                          getStoreDataVal[index].clippingColor,
                                                          getStoreDataVal[index].smoothy,
                                                          getStoreDataVal[index].design,
                                                        )));
                                          }
                                          if(getStoreDataVal[index].design == "Option 2"){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomerSpecificStoreMainPage2(
                                                            "",
                                                            getStoreDataVal[
                                                            index]
                                                                .email,
                                                            stringList,
                                                            getStoreDataVal[
                                                            index]
                                                                .storeName,
                                                            [],
                                                            getStoreDataVal[
                                                            index]
                                                                .activateSlider,
                                                            getStoreDataVal[
                                                            index]
                                                                .activateCategory,
                                                            getStoreDataVal[
                                                            index]
                                                                .activateCarts,
                                                            {},
                                                            customerTokenVal,
                                                            customerEmailVal,
                                                          getStoreDataVal[index].backgroundColor,
                                                          getStoreDataVal[index].boxesColor,
                                                          getStoreDataVal[index].primaryTextColor,
                                                          getStoreDataVal[index].secondaryTextColor,
                                                          getStoreDataVal[index].clippingColor,
                                                          getStoreDataVal[index].smoothy,
                                                          getStoreDataVal[index].design,
                                                        )));
                                          }
                                          if(getStoreDataVal[index].design == "Option 3"){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomerSpecificStoreMainPage3(
                                                            "",
                                                            getStoreDataVal[
                                                            index]
                                                                .email,
                                                            stringList,
                                                            getStoreDataVal[
                                                            index]
                                                                .storeName,
                                                            [],
                                                            getStoreDataVal[
                                                            index]
                                                                .activateSlider,
                                                            getStoreDataVal[
                                                            index]
                                                                .activateCategory,
                                                            getStoreDataVal[
                                                            index]
                                                                .activateCarts,
                                                            {},
                                                            customerTokenVal,
                                                            customerEmailVal,
                                                          getStoreDataVal[index].backgroundColor,
                                                          getStoreDataVal[index].boxesColor,
                                                          getStoreDataVal[index].primaryTextColor,
                                                          getStoreDataVal[index].secondaryTextColor,
                                                          getStoreDataVal[index].clippingColor,
                                                          getStoreDataVal[index].smoothy,
                                                          getStoreDataVal[index].design,
                                                        )));
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              20, 0, 20, 15),
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(width: 1),
                                            color: Color(0xFF212139),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: double.infinity,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    2.6,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        20),
                                                    color: Colors.white),
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(20.0),
                                                      topRight: Radius.circular(20.0),
                                                      bottomLeft: Radius.circular(20.0),
                                                      bottomRight: Radius.circular(20.0),
                                                    ),
                                                    child: Image.network(
                                                      specificCategoryStores[index]
                                                          .storeAvatar,
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Container(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          4,
                                                      // color: Colors.blue,
                                                      child: Text(
                                                        "${specificCategoryStores[index].storeName}",
                                                        style: GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 25),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      )),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          4,
                                                      // color: Colors.blue,
                                                      child: Text(
                                                        "${specificCategoryStores[index].storeCategory}",
                                                        style: GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      )),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          4,
                                                      // color: Colors.blue,
                                                      child: Text(
                                                        "${getLang(context, 'owned_by')}: ${specificCategoryStores[index].merchantname}",
                                                        style: GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontSize: 10),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      )),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          4,
                                                      // color: Colors.blue,
                                                      child: Text(
                                                        "${getLang(context, 'email_address')}: ${specificCategoryStores[index].email}",
                                                        style: GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontSize: 10),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      )),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          4,
                                                      // color: Colors.blue,
                                                      child: Text(
                                                        "${getLang(context, 'phone_number')}: ${specificCategoryStores[index].phone}",
                                                        style: GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontSize: 10),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                      itemCount:
                                          specificCategoryStores.length,
                                    ),
                                  ),
                                ),

                                // Container(
                                //   margin: EdgeInsets.fromLTRB(20,20,20,10),
                                //   width: MediaQuery
                                //       .of(context)
                                //       .size
                                //       .width ,
                                //   height: MediaQuery
                                //       .of(context)
                                //       .size
                                //       .height / 4,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(20),
                                //       border: Border.all(width: 1)
                                //   ),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       Container(
                                //         width: MediaQuery.of(context).size.width/2.2,
                                //         decoration: BoxDecoration(
                                //             borderRadius: BorderRadius.circular(20),
                                //             color: Colors.white
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   width: double.infinity,
                        //   margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                        //
                        //     child: Text("", style: GoogleFonts.federo(
                        //       color: Color(0xFF212128),
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 30,
                        //
                        //     ),
                        //       textAlign: TextAlign.center,
                        //     ),
                        //
                        //
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
