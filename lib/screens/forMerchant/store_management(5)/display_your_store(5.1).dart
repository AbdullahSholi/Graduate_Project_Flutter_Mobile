import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:graduate_project/models/login_model.dart';
import 'package:graduate_project/screens/editprofilepage.dart';
import 'package:graduate_project/screens/imageplaceholder.dart';
import "package:http/http.dart" as http;
import "package:flutter/gestures.dart";

import '../../../models/singleUser.dart';



class DisplayYourStore extends StatefulWidget {
  final String token;
  final String email;
  const DisplayYourStore(this.token, this.email, {super.key});
  @override
  State<DisplayYourStore> createState() => _DisplayYourStoreState();
}

class _DisplayYourStoreState extends State<DisplayYourStore> {
  String tokenVal = "";
  String emailVal = "";

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

  /////
  // Visibility
  bool sliderVisibility = true;
  bool customizeVisibility = false;
  bool categoryVisibility = true;
  bool cartsVisibility = true;

  ////

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
                          child: IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,),),
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
                          Visibility(
                            visible: sliderVisibility ,
                            child: Stack(children: [
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
                          ),
                          Visibility(
                            visible: categoryVisibility,
                            child: Column(
                                children:[
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
                                ]
                            ),
                          ),
                          Visibility(
                            visible: cartsVisibility,
                            child: Container(
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
                    print(index);
                    if(index == 0){
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(tokenVal,emailVal)));
                    }
                    else if(index == 1){
                      setState(() {
                        showDialog(context: context, builder: (context)=> AlertDialog(
                          contentPadding: EdgeInsets.all(0),
                          content: Container(
                            height: MediaQuery.of(context).size.height/2,
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
                                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width*5)/8,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Text("Activate Components",textAlign: TextAlign.center,
                                      style: GoogleFonts.federo(
                                        color: Color(0xFF212128),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,

                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  height: 2,

                                ),

                                Container(


                                  margin: EdgeInsets.fromLTRB(20,30,10,10),
                                  child: Row(
                                      children:[
                                        Container(
                                          width: (MediaQuery.of(context).size.width*2)/5,
                                          child: Text("Activate Slider",style: GoogleFonts.federo(
                                            color: Colors.white,
                                            fontSize: 20,

                                          ),
                                          ),
                                        ),

                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.green,
                                          child: IconButton(onPressed: (){
                                            setState(() {
                                              sliderVisibility=true;
                                            });
                                          }, icon: Icon(Icons.done,color: Colors.white,)),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width/20,),
                                        CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 20,
                                          child: IconButton(onPressed: (){
                                            setState(() {
                                              sliderVisibility=false;
                                            });
                                          }, icon: Icon(Icons.close,color: Colors.white,)),
                                        ),

                                      ]

                                  ),
                                ),
                                Container(

                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20,30,10,10),
                                  child: Row(
                                      children:[
                                        Container(
                                          width: (MediaQuery.of(context).size.width*2)/5,
                                          child: Text("Activate Category",style: GoogleFonts.federo(
                                              color: Colors.white,
                                              fontSize: 20
                                          ),),
                                        ),

                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.green,
                                          child: IconButton(onPressed: (){
                                            setState(() {
                                              categoryVisibility=true;
                                            });
                                          }, icon: Icon(Icons.done,color: Colors.white,)),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width/20,),
                                        CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 20,
                                          child: IconButton(onPressed: (){
                                            setState(() {
                                              categoryVisibility=false;
                                            });
                                          }, icon: Icon(Icons.close,color: Colors.white,)),
                                        ),

                                      ]

                                  ),
                                ),
                                Container(

                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20,30,10,10),
                                  child: Row(
                                      children:[
                                        Container(
                                          width: (MediaQuery.of(context).size.width*2)/5,
                                          child: Text("Activate Carts",style: GoogleFonts.federo(
                                              color: Colors.white,
                                              fontSize: 20
                                          ),),
                                        ),

                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.green,
                                          child: IconButton(onPressed: (){
                                            setState(() {
                                              cartsVisibility=true;
                                            });
                                          }, icon: Icon(Icons.done,color: Colors.white,)),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width/20,),
                                        CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 20,
                                          child: IconButton(onPressed: (){
                                            setState(() {
                                              cartsVisibility=false;
                                            });
                                          }, icon: Icon(Icons.close,color: Colors.white,)),
                                        ),

                                      ]

                                  ),
                                ),

                              ],
                            ),

                          ),
                        ));
                      });
                    }
                    else if(index == 2){
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
                        Icons.favorite,
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
}
