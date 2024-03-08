import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditYourStoreDesign extends StatefulWidget {
  // String token;
  // String email;
  EditYourStoreDesign();

  @override
  State<EditYourStoreDesign> createState() => _EditYourStoreDesignState();
}

class _EditYourStoreDesignState extends State<EditYourStoreDesign> {
  Color color = Colors.black;
  bool isVisible = false;
  var heightValue=3.5;

  Container tempContainer = Container();
  Container tempCategory = Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
    ),
  );
  bool isDropped = false;
  bool isDroppedCategory = false;
  Container dropHereSliderContainer = Container(child: Center(child: Text("Drop Slider Here"),),);
  Container dropHereCategory = Container(

    child: Center(child: Text("Drop Category Here"),),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){
          setState(() {
            isVisible = !isVisible;
            if(isVisible){
              heightValue = 2;
            }
            else{
              heightValue = 3.5;
            }
          });
        }, icon: Icon(Icons.edit))],
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Colors.red,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height*heightValue)/4,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: DragTarget<Container>(
                          onAccept: (data) => setState(() {
                            tempContainer = data;
                            isDropped = true;
                          }),
                          builder: (context, _,__)=> DottedBorder(
                            radius: Radius.circular(20),
                            borderType: BorderType.RRect,
                            child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height / 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      // color: Colors.blue,
                                    ),
                                    child: isDropped ? tempContainer : dropHereSliderContainer,
                                  ),


                                ]),
                            strokeWidth: 3,
                            dashPattern: [10, 10],
                            strokeCap: StrokeCap.round,
                          ) ,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                            width: (MediaQuery.of(context).size.width*3)/4,
                            height: (MediaQuery.of(context).size.width*.25)/4,
                            // color: color,
                            margin: EdgeInsets.all(5),
                            child: Text("Category",style: GoogleFonts.federo(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            )),
                          ),


                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        // color: Colors.black,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,

                                child: DragTarget<Container>(
                                  // <Color> type of data we will received
                                  onAccept: (data) => setState(() {
                                    tempCategory = data;
                                    isDroppedCategory = true;
                                  }),
                                  builder: (context, _, __) => DottedBorder(
                                    radius: Radius.circular(10),
                                    borderType: BorderType.RRect,
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      child: isDroppedCategory ? tempCategory : dropHereCategory,
                                    ),
                                    strokeWidth: 3,
                                    dashPattern: [10, 10],
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20,),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        // color: Colors.blue,

                        child: GridView.count(
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          crossAxisCount: 2,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ...List.generate(5, (index) => DragTarget<Color>(
                              // <Color> type of data we will received
                              onAccept: (data) => setState(() {
                                color = data;
                              }),
                              builder: (context, _, __) => DottedBorder(
                                borderType: BorderType.Rect,
                                child: Container(
                                  width: (MediaQuery.of(context).size.width*3)/4,
                                  height: (MediaQuery.of(context).size.width*2)/4,
                                  // color: color,
                                  margin: EdgeInsets.all(5),
                                ),
                                strokeWidth: 5,
                                dashPattern: [10, 10],
                                strokeCap: StrokeCap.round,
                              ),
                            ),),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Container(
                  width: double.infinity,
                  height: (MediaQuery.of(context).size.height *1.2)/3,
                  color: Colors.yellow,
                  // padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [

                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding:EdgeInsets.fromLTRB(15, 0, 15, 0) ,

                          child: Draggable<Container>(
                            data: Container(
                              height: MediaQuery.of(context).size.height / 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green,
                              ),
                              child: Container(),
                            ),
                            child:
                            Stack(
                                children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green,
                                ),
                                child: Container(
                          
                                ),
                              ),
                          
                            ]),
                            feedback: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 4,
                          
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.brown,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 20,),
                        Draggable<Container>(
                          data: Container(

                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                            width: 130,
                            height: 50,

                            child: TextButton(onPressed: (){}, child: Text(""),),
                          ),
                          child: Container(
                            width: 130,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),

                            child: TextButton(onPressed: (){}, child: Text(""),),
                          ),
                          feedback: Container(
                            width: 130,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue,
                            ),

                          ),

                        ),
                        SizedBox(width: 20,),
                        Draggable<Color>(
                          data: Colors.red,
                          child: Container(
                            width: 130,
                            height: 130,
                            color: Colors.blue,
                          ),
                          feedback: Container(
                            width: 130,
                            height: 130,
                            color: Colors.brown,
                          ),

                        ),
                        SizedBox(width: 20,),
                        Draggable<Color>(
                          data: Colors.red,
                          child: Container(
                            width: 130,
                            height: 130,
                            color: Colors.blue,
                          ),
                          feedback: Container(
                            width: 130,
                            height: 130,
                            color: Colors.brown,
                          ),

                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
