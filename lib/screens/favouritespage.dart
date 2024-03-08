import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'myprofilepage.dart';

class FavouritesPage extends StatefulWidget {
  final String token;
  final String email;
  FavouritesPage(this.token, this.email);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> with TickerProviderStateMixin {
  String tokenVal = "";
  String emailVal = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenVal = widget.token;
    emailVal = widget.email;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                // spawnMaxRadius: 40,
                // spawnMinRadius: 1.0,
                  particleCount: 100,
                  // spawnMaxSpeed: 150.0,
                  // // minOpacity: .3,
                  // // spawnOpacity: .4,
                  // // baseColor: Colors.black26,
                  image: Image(image: NetworkImage("https://t3.ftcdn.net/jpg/01/70/28/92/240_F_170289223_KNx1FpHz8r5ody9XZq5kMOfNDxsZphLz.jpg"))
              ),
            ),
            vsync: this,
            child:
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF212128),
                    ),
                    margin: EdgeInsets.fromLTRB(20,40,20,20),
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Color(0xFF212128),
                                    ), // Replace with your desired icon
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 28,
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 2.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Text(
                                      "Favourites",
                                      style: TextStyle(
                                          color: Color(0xFF212128),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 2,
                            color: Colors.white,
                          ),
                  
                  
                  
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BottomNavigationBar(
                      backgroundColor: Color(0xFF212128),
                      onTap: (index){
                        if(index == 0){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(tokenVal,emailVal)));
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
              ],
            ),

        )
    );
  }
}
