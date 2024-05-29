import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:graduate_project/screens/forCustomers/customer_login_register/login_or_register(2).dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int activeIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/salesman-15.png",
      "title": "For Merchants",
      "description": "Create and manage your store, publish your products to reach more customers."
    },
    {
      "image": "assets/images/shopping-43.png",
      "title": "For Customers",
      "description": "Browse and buy products from various stores easily."
    },
    {
      "image": "assets/images/receptionist-7.png",
      "title": "Welcome to Our App",
      "description": "Start your journey with us today and explore the features!"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212128),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CarouselSlider.builder(
            itemCount: onboardingData.length,
            itemBuilder: (context, index, realIndex) {
              return OnboardingPage(
                image: onboardingData[index]['image']!,
                title: onboardingData[index]['title']!,
                description: onboardingData[index]['description']!,
              );
            },
            options: CarouselOptions(
              height: 600,
              onPageChanged: (index, reason) => setState(() => activeIndex = index),
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: Duration(milliseconds: 4500),
            ),
          ),
          buildIndicator(),
          SizedBox(height: 20),
          activeIndex == onboardingData.length - 1
              ? Container(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                                decoration: BoxDecoration(
                    shape: BoxShape.circle
                        ,color: Colors.white,
                                ),
                                alignment: Alignment.center,
                                height: 45,
                      child: IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerLoginOrRegister("","")));
                      }, icon: Icon(Icons.arrow_forward_ios, color: Color(0xFF212128), size: 30,  ))
                    ),
                  ],
                ),
              )
              : Container(
            height: 45,
          ),
        ],
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: onboardingData.length,
    effect: ExpandingDotsEffect(
      dotWidth: 10,
      dotHeight: 10,
      activeDotColor: Colors.white,
    ),
  );
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  OnboardingPage({required this.image, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(image, height: 300, ),
          // SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
