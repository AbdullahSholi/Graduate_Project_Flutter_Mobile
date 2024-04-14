import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:graduate_project/models/login_model.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/imageplaceholder.dart';
import "package:http/http.dart" as http;
import "package:flutter/gestures.dart";

import '../models/singleUser.dart';
import 'favouritespage.dart';
import 'login.dart';
import 'myprofilepage.dart';

class Home extends StatefulWidget {
  final String token;
  final String email;
  final User tempCustomerProfileData;
  Home(this.token, this.email, this.tempCustomerProfileData);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String tokenVal = "";
  String emailVal = "";
  late User tempCustomerProfileData;


  late Future<User> userData;

  // for Images Slider
  final List<String> imagePaths = [
    "https://cdn.dribbble.com/users/5739021/screenshots/16801648/hp-pavilion-gaming-laptop-advertisement-poster-design-2.jpg",
    "https://i.ytimg.com/vi/CPwBX0mfc74/maxresdefault.jpg",
    "https://i.ytimg.com/vi/zasz53bdSyg/maxresdefault.jpg"
  ];

  late List<Widget> _pages;

  int _activePage = 0;

  final PageController _pageController = PageController(initialPage: 0);

  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.page == imagePaths.length - 1) {
        _pageController.animateToPage(0,
            duration: Duration(microseconds: 500), curve: Curves.easeIn);
      } else {
        _pageController.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.easeIn);
      }
    });
  }


  /////////////////////

  // Search
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  ////////

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
    print(emailVal);
    userData = getUserByName();

    // for Images Slider
    _pages = List.generate(imagePaths.length,
        (index) => ImagePlaceholder(imagePath: imagePaths[index]));
    startTimer();
    ////
  }

  Future<User> getUserByName() async {
    http.Response userFuture = await http.get(
        Uri.parse("http://10.0.2.2:3000/electrohub/api/v1/profile/${emailVal}"),
        headers: {"Authorization": "Bearer ${tokenVal}"});
    if (userFuture.statusCode == 200) {
      print("${userFuture.body}");
      return User.fromJson(json.decode(userFuture.body));
    } else {
      throw Exception("Error");
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      // Update your data or state variables
      userData = getUserByName();
    });
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

      drawer: Drawer(
        backgroundColor: Color(0xFF1E1F22),
        width: MediaQuery.of(context).size.width / 1.3,
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            children: [
              Container(
                height: 210,
                child: DrawerHeader(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: CircleAvatar(
                        radius: 60,
                        child: FutureBuilder<User>(
                            future: userData,
                            builder: (BuildContext context,
                                AsyncSnapshot<User> snapshot) {
                              print(snapshot.data?.street);
                              if (snapshot.hasData) {
                                print(snapshot.data!.Avatar);
                                return Image.network(
                                  snapshot.data!.Avatar,
                                );
                              } else if (snapshot.hasError) {
                                return Text("Error Occured!");
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: userData,
                        builder: (BuildContext context,
                            AsyncSnapshot<User> snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              "${snapshot.data?.username}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error Occured!");
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: userData,
                        builder: (BuildContext context,
                            AsyncSnapshot<User> snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              "${snapshot.data?.email}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error Occured!");
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
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
                            builder: (context) =>
                                MyProfilePage(tokenVal, emailVal)));
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
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             EditProfilePage(tokenVal, emailVal)));
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
                    Icons.settings,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print("My Profile");
                    Navigator.pop(context);
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
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
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Builder(
                            builder: (BuildContext context) {
                              return IconButton(
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 30,
                                ), // Replace with your desired icon
                                onPressed: () {
                                  Scaffold.of(context)
                                      .openDrawer(); // Opens the drawer
                                },
                                tooltip: MaterialLocalizations.of(context)
                                    .openAppDrawerTooltip,
                              );
                            },
                          ),
                        ),
                        Center(
                            child: Text(
                          "ElectroHub",
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
                  Container(
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
                          Stack(children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 20, 20, 15),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                // color: Colors.blue,
                              ),
                              child: PageView.builder(
                                itemBuilder: (context, index) => _pages[index],
                                itemCount: imagePaths.length,
                                controller: _pageController,
                                onPageChanged: (value) {
                                  setState(() {
                                    _activePage = value;
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 17,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ...List<Widget>.generate(
                                        _pages.length,
                                        (index) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  _pageController.animateToPage(
                                                      index,
                                                      duration: Duration(
                                                          microseconds: 200),
                                                      curve: Curves.easeIn);
                                                },
                                                child: CircleAvatar(
                                                  radius: 5,
                                                  backgroundColor:
                                                      _activePage == index
                                                          ? Colors.yellow
                                                          : Colors.white,
                                                ),
                                              ),
                                            )),
                                  ],
                                ),
                              ),
                            )
                          ]),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                          Container(

                            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFF212128),
                                      ),
                                      width: 120,
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "All Products",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFF212128),
                                      ),
                                      width: 120,
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Computers",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFF212128),
                                      ),
                                      width: 120,
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Laptops",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                          ))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFF212128),
                                      ),
                                      width: 120,
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Mobiles",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                          ))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: GridView.count(
                              crossAxisCount: 2,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              childAspectRatio: 1 / 1.15,
                              children: List.generate(
                                  30,
                                  (index) => InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Color(0xFF212128),
                                            title: Text('Simple Dialog',style: TextStyle(color: Colors.white),),
                                            content: Container(
                                              height: MediaQuery.of(context).size.height/2,
                                              width: MediaQuery.of(context).size.width,
                                              child: Text('This is a simple dialog.',style: TextStyle(color: Colors.white),),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context); // Close the dialog
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                    },
                                    child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          padding:
                                              EdgeInsets.fromLTRB(5, 10, 5, 10),
                                          child: Stack(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                  padding: EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                    
                                                      borderRadius:
                                                          BorderRadius.only(
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
                                                        "https://th.bing.com/th/id/OIP.5EZRHGR0LgL2IWcQ511TkQHaF5?rs=1&pid=ImgDetMain",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    child: Container(
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
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.only(
                                                        bottomRight: Radius.circular(20),
                                                        bottomLeft: Radius.circular(20),
                                                      ),
                                                      color: Color(0xF2222128),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(10, 8, 10 , 6),
                                                          child: Text("Laptop Laptop Laptop Laptop Laptop Laptop Laptop Laptop Laptop",
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
                                                              child: Text("24450",overflow: TextOverflow.ellipsis,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.bold,
                                    
                                                                    color: Colors.white,
                                                                  )),
                                                            ),
                                                            SizedBox(width: 5,),
                                                            Container(
                                                              // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                              child: Text("24450",overflow: TextOverflow.ellipsis,
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
                                        ),
                                  )),
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
                  onTap: (index){
                    if(index == 0){
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(tokenVal,emailVal)));
                    }
                    else if(index == 1){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> FavouritesPage(tokenVal,emailVal)));
                    }
                    else if(index == 2){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyProfilePage(tokenVal, emailVal)));
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
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      label: 'Favourites',
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
}
