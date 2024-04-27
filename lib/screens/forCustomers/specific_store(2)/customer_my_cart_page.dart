
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerMyCartPage extends StatelessWidget {
  const CustomerMyCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF212128),
        leading: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 30,),
        title: Text("Shopping Cart", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height/5,),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/5,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF212128),
                    ),
                    child: Row(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height/5,
                            width: MediaQuery.of(context).size.width/3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                                child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMv2EOjvqGsADNLgPZ7V1EReuliTXi_Tcl4g&s", fit: BoxFit.cover,))
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width/2.15,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text("Addidas-A", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            Text("Shoes - StoreName",  style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                              SizedBox(height: 5,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text("\$100", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  SizedBox(width: 20,),
                                  Text("\$400", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text("Price: ", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  SizedBox(width: 10,),
                                  Text("100 * 4 = 400", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 15,  decoration: TextDecoration.lineThrough),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ],
                              ),



                            ],),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                                  child: Icon(Icons.remove_circle_outline, color: Colors.white, size: 30,)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  // if(index == 4){
                  //   return Padding( padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height/3,),);
                  // }
                  // else {
                    return SizedBox(height:  0);
                  // }
                },
              ),
            // height: MediaQuery.of(context).size.height/1.3,

          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(

              // width: double.infinity,
              height: MediaQuery.of(context).size.height/5,
              decoration: BoxDecoration(
                color: Color(0xFF212128),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )
              ),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Column(
                      children: [
                        Text("Total Price ", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,),), maxLines: 1, overflow: TextOverflow.ellipsis,),
                        Text("300 ", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,),), maxLines: 1, overflow: TextOverflow.ellipsis,)
                      ],
                    )
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      child: ElevatedButton(onPressed: (){}, child: Text("Purchase!", style: GoogleFonts.lilitaOne(textStyle: TextStyle(color: Color(0xFF212128), fontSize: 25, fontWeight: FontWeight.bold,),), maxLines: 1, overflow: TextOverflow.ellipsis, ), style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ), // Border radius of the button
                          ),
                        ),
                      ),),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
