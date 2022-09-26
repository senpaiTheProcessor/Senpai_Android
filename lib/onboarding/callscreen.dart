
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/mediumButton.dart';
import 'package:senpai/View/wallet/Wallet.dart';
import 'package:senpai/onboarding/walletscreen.dart';

import '../Common/InputField.dart';

class CallScreenTutorial extends StatefulWidget {
  const CallScreenTutorial({Key? key}) : super(key: key);

  @override
  State<CallScreenTutorial> createState() => _CallScreenTutorialState();
}

class _CallScreenTutorialState extends State<CallScreenTutorial> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueCom,
        centerTitle: true,
        title: Text(
          "Explore Detail",
          style: btnWhite(context),
        ),
        leading: InkWell(
            onTap: (() {
            
            }),
            child: Icon(Icons.arrow_back)),
      ),
      body: Stack(
        children: [
          allFields(),
          transprentw(),
          InkWell(
                 
          onTap: (() {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WalletScreenTutorial()));
            }),
        
            child: callhightlight()),
        ],
      ),
    );
  }
  Widget transprentw(){
    return Center(
      child: Container(
        color: Colors.black54,
        height: MediaQuery.of(context).size.height,
        // child:  sendCall(),
      ),
    );
  }
 Widget callhightlight(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top:200.0),
        child: Container(
          // color: Colors.red,
          height: MediaQuery.of(context).size.height*0.1,
          child:  Column(
            children: [
              // sendCall(),
              contText()
            ],
          ),
        ),
      ),
    );
  }
  Widget allFields() {
    return Container(
      // color: Colors.red,
      child: Column(
        children: [
          detail(),
          intrestedGuide()
        ],
      ),
    );
  }
Widget intrestedGuide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sendCall(),
        review()
      ],
    );
  }
  Widget detail() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: borderColor),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            detailRow(),
          ],
        ),
      ),
    );
  }

  Widget detailRow() {
    return Row(children: [
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 90.0,
                  width: 90.0,
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(width: 1, color: grayShade),
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/uprofile.png')
                        as ImageProvider,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                      color: white,
                      border: Border.all(width: 1, color: Color(0xff646363)),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Center(
                      child: Text(
                        "Level 1",
                        style: verysmollheader(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "since " + "2015",
                  style: smollheader(context),
                ),
                
                InkWell(
                  onTap: () {
               
                  },
                  child: Row(
                    children: [
                      
                          Container(
                              decoration: BoxDecoration(
                                  color: blueCom,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text("Report",
                                      style: smollheader(context)
                                          .copyWith(color: white)),
                                ),
                              ),
                            ),
                         
                      SizedBox(
                        height: 15,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite),
                        color: (Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(
        width: 15,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.topRight,
            width: MediaQuery.of(context).size.width * 0.56,
            // color: Colors.red,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Container(
                        // height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.07,
                        child: Image(
                            image:  AssetImage('assets/logo/medal.png')
                                    as ImageProvider),
                      ),
                Text(
                  "badge_name",
                  style: subheaderdark(context),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Row(
            children: [
              Text(
                 "Jhone smith",
                // capitalize(UserName),
                
                style: bottomheader(context),
              ),
               Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Icon(
                        Icons.check_circle_outline_outlined,
                        color: Colors.blue,
                      ))
                 
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(width: 1, color: Color(0xff646363)),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  child: Row(
                    children: [
                      Text(
                        "2.0",
                        style: verysmollheader(context),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 72,
              ),
               InkWell(
                      onTap: () {
                  
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            // border: Border.all(width: 1, color: Color(0xff646363)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call,
                              size: 15,
                              color: white,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "Call Now",
                              style: verysmollheader(context)
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
          
        
          Container(
            // color: Colors.red,
            // width: MediaQuery.of(context).size.width * 0.6,
            child: RichText(
              text: TextSpan(
                text: "Call Setting" + "     ",
                style: verysmollheader(context),
                children: <TextSpan>[
                  TextSpan(
                      text: "Direct Call"
                          ,
                      style: smollheaderlight(context)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
        ],
      ),
    ]);
  }

  Widget callingRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
                color: white,
                border: Border.all(width: 1, color: Color(0xff646363)),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  size: 20,
                ),
                Text(
                  " No of Call:",
                  style: smollheader(context),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "3",
                  style: smollheader(context),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
                color: white,
                border: Border.all(width: 1, color: Color(0xff646363)),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer,
                  size: 20,
                ),
                Text(
                  "Guided:",
                  style: smollheader(context),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "4 min",
                  style: smollheader(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  //send aproch call
  Widget sendCall() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            // border: Border.all(width: 1, color: borderColor),
            color: grayShade,
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Send Approch / Call",
                style: bottomheader(context),
              ),
              question(),
              DropDown(),
             
              SizedBox(
                height: 5,
              ),
              Center(child: sendRequestBtn())
            ],
          ),
        ),
      ),
    );
  }
 

 Widget review() {
    return Container(
      decoration: BoxDecoration(

          // border: Border.all(width: 1, color: borderColor),
          color: grayShade,
          // color: Colors.red,
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Column(
                        children: [
                          Text(
                            "Review",
                            style: bottomheader(context),
                          ),
                        
                        ],
                      ),
               writeReviewBtn() 
              ],
            ),
            reviewList(),
          ],
        ),
      ),
    );
  }
  
   Widget writeReviewBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.045,
        child: mediumButton(
          key: Key('review_button'),
          buttonName: "write a Review",
          onPressed: () {
            
          
          },
        ),
      ),
    );
  }
   Widget reviewList() {
    return  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Container(
              height: MediaQuery.of(context).size.height / 4.5,
              child: ListView.builder(
                  // controller: _controller,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount:
                      1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            // border: Border.all(width: 1, color: borderColor),
                            color: white,
                            borderRadius: BorderRadius.circular(0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 45.0,
                                    width: 45.0,
                                    decoration: BoxDecoration(
                                        color: white,
                                        border: Border.all(
                                            width: 1, color: grayShade),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50))),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(
                                                  'assets/images/uprofile.png')
                                              as ImageProvider,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Jonh",
                                        style: smollheader(context),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      // ),

                                      RatingBar(
                                        initialRating: 1,
                                        allowHalfRating: true,
                                        ignoreGestures: true,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemSize:
                                            MediaQuery.of(context).size.width *
                                                .06,
                                        ratingWidget: RatingWidget(
                                            full: Icon(
                                              Icons.star,
                                              color: Colors.orange,
                                            ),
                                            half: Icon(
                                              Icons.star_half,
                                              color: Colors.orange,
                                            ),
                                            empty: Icon(
                                              Icons.star_outline,
                                              color: Colors.orange,
                                            )),
                                        onRatingUpdate: (value) {
                                          // value = false;
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                // color: Colors.red,
                                width: MediaQuery.of(context).size.width * .75,
                                child: RichText(
                                    text: TextSpan(
                                        text:"It's very good app.",
                                        style: TextStyle(
                                            fontSize: 13, color: black))),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
  }


   Widget question(){
     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 4),
       child: Container(
           width: MediaQuery.of(context).size.width * .8,
          height: MediaQuery.of(context).size.height * .06,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: white,
              // border: Border.all(width: 1, color: black),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child:    Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Enter Question"),
          )
       ),
     );
   }
   Widget DropDown(){
     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 4),
       child: Container(
           width: MediaQuery.of(context).size.width * .8,
          height: MediaQuery.of(context).size.height * .06,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: white,
              // border: Border.all(width: 1, color: black),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child:    Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               
               Text("Select Intrest"),
               Icon(Icons.arrow_drop_down)
             
            ],),
          )
       ),
     );
   }
 

  Widget sendRequestBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.06,
        child: mediumButton(
          key: Key('send_button'),
          buttonName: "Call / Send Request",
          onPressed: () {
           
          },
        ),
      ),
    );
  }

  
  Widget contText(){
    return Container(
         child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment:CrossAxisAlignment.center,
         children:[
           
            Container(
            child:CustomPaint(
            painter: TrianglePainter(
              strokeColor: blueComlight,
              strokeWidth: 10,
              paintingStyle: PaintingStyle.fill,
            ),
            child: Container(
              height: 20,
              width: 25,
              
            ),
          )
          ),
          //  Container(
          //   color:Colors.red,
           
          // ),
          Container(
            // height:MediaQuery.of(context).size.height*0.1,
            // width:100,
             decoration: BoxDecoration(
            color:blueComlight,
              // border: Border.all(width: 1, color: black),
              borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              child: Text("Please Connect the call",style: TextStyle(color: Colors.white),),
            ),
          )
         ]
         )
           
         );
  }



}
class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 5, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}


