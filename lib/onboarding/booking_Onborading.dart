// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print, use_key_in_widget_constructors, file_names, unused_import, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names, sized_box_for_whitespace, prefer_adjacent_string_concatenation, empty_catches

import 'dart:async';
import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:senpai/Call/CallScreen.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/bottomTabs/Blog.dart';
import 'package:senpai/View/bottomTabs/Home.dart';
import 'package:senpai/View/Notification.dart';
import 'package:senpai/View/bottomTabs/Booking.dart';
import 'package:senpai/View/bottomTabs/Explore.dart';
import 'package:senpai/View/drawer.dart';
import 'package:senpai/View/wallet/Wallet.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/model/UserModel.dart';
import 'package:senpai/onboarding/booking_guide_onborading.dart';
import 'package:senpai/onboarding/callscreen.dart';

import '../Common/Button.dart';

class BookingTutorial extends StatefulWidget {
  final dynamic selectedTab;
  final dynamic tabBarIndex;
  BookingTutorial({Key? key, this.selectedTab, this.tabBarIndex})
      : super(key: key);

  @override
  _BookingTutorialState createState() => _BookingTutorialState();
}

class _BookingTutorialState extends State<BookingTutorial> {
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Booking(),
    Explore(),
    BlogRes()
  ];
  void _onItemTapped(int index) {
    setState(() {
      // GetIt.instance<FeedViewModel>().setActualScreen(index);
    });
  }

  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[Home(), Booking(), Explore(), BlogRes()];
  }

////-------------Notification start

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: Builder(builder: (BuildContext context) {
          return InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();

                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset(
                  "assets/logo/menu.png",
                  width: 10,
                  height: 10,
                ),
              ));
        }),
        title: Row(
          children: [
            Expanded(
              child: search(),
            ),
            InkWell(
              onTap: (() {}),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(
                      "assets/logo/wallet.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  Text(
                    "\u20B9" + "45",
                    style: TextStyle(
                        color: blueCom,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 15),
              child: InkWell(
                onTap: () {},
                child: Image.asset(
                  "assets/logo/bell.png",
                  width: 20,
                  height: 20,
                ),
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          allFields(),
          transprentw(),
          acceptDilog(),
          transprentw2(),
          InkWell(
                      onTap: (() {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GuideTutorial()));
            }),
            child: hightlight())
        ],
      ),
      bottomNavigationBar: bottomNav(),
    );
  }

  Widget allFields() {
    return Container(
      // color: Colors.red,
      child: Column(
        children: [
          Rowtop(),
          Expanded(child: recivedList()),
          // callhightlight()
        ],
      ),
    );
  }

  Widget transprentw() {
    return Center(
      child: Container(
        color: Colors.black54,
        height: MediaQuery.of(context).size.height,
        // child:  sendCall(),
      ),
    );
  }

  Widget transprentw2() {
    return Center(
      child: Container(
        color: Colors.black54,
        height: MediaQuery.of(context).size.height,
        // child:  sendCall(),
      ),
    );
  }

  Widget acceptDilog() {
    return Padding(
      padding: const EdgeInsets.only(top: 150, left: 10, right: 10),
      child: Container(
        color: Colors.white,
        // height: MediaQuery.of(context).size.height*0.1,
        child: accept(),
      ),
    );
  }

  Widget accept() {
    return Container(
      // color: Colors.red,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    // color: Colors.red,
                    size: 25,
                  )),
            ),
            Center(
              child: Text(
                // requestAction == 1
                "Accept Request",
                // : "Reject Request",
                style: TextStyle(
                    color: black,
                    fontSize: 15,
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.w600),
                // style: bottomheader(context),
              ),
            ),

            // requestAction == 1 ? sentAcceptBtn(index) : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .25,
                  height: MediaQuery.of(context).size.height * 0.001,
                  color: black,
                ),
                SizedBox(
                  width: 2,
                ),
                Text("or"),
                SizedBox(
                  width: 2,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .25,
                  height: MediaQuery.of(context).size.height * 0.001,
                  color: black,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 2),
              child: Text(
                "Schedule Your Call / Tenteative Time",
                style: verysmollheader(context),
              ),
            ),
            // calender(),
            // timeschedule(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: InkWell(
                onTap: (() {
                  // setState(() {
                  //   _selectedTime(context);
                  // });
                }),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: blueCom),
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.calendar_month),
                      SizedBox(
                        width: 12,
                      ),
                      Text("Select Date")
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: InkWell(
                onTap: (() {
                  // setState(() {
                  //   _selectedTime(context);
                  // });
                }),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: blueCom),
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.timelapse),
                      SizedBox(
                        width: 12,
                      ),
                      Text("Select Time")
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 2),
              child: Text(
                "Note",
                style: verysmollheader(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: InkWell(
                onTap: (() {
                  // setState(() {
                  //   _selectedTime(context);
                  // });
                }),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: blueCom),
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.note),
                      SizedBox(
                        width: 12,
                      ),
                      Text("Enter the note")
                    ],
                  ),
                ),
              ),
            ),
            // NoteInputAcceptCall(),
            // newNote(),
            //SubmitBtn(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Button(
                  key: Key('login_button'),
                  buttonName: "Submit",
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

// recived List
  Widget recivedList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          // controller: _controller2,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 4,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
              child: InkWell(
                onTap: (() {}),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: borderColor),
                      color: grayShade,
                      // color:Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: MediaQuery.of(context).size.height * 0.14,
                        decoration: BoxDecoration(
                          color: white,
                          border: Border.all(width: 1, color: grayShade),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/uprofile.png')
                                  as ImageProvider),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        // height: MediaQuery.of(context).size.width * 0.3,
                        // color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "John",
                              style: smollheader(context),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.00,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Interest:- ',
                                style: smollheader(context),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "song",
                                      style: smollheaderlight(context)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.00,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Question :- ',
                                style: smollheader(context),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "what is your qualification",
                                      style: smollheaderlight(context)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.00,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Call Date :- ',
                                style: smollheader(context),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "12-7-2022",
                                      style: smollheaderlight(context)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.00,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Schedule Time :- ',
                                style: smollheader(context),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "12:00",
                                      style: smollheaderlight(context)),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Current Time :- ',
                                style: smollheader(context),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "10:05",
                                      style: smollheaderlight(context)),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Note :- ',
                                style: smollheader(context),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "note",
                                      style: smollheaderlight(context)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.3,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: (() {}),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    )),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 4),
                                    child: Text(
                                      "Accept",
                                      style: verysmollheader(context)
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget search() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
          //  width: MediaQuery.of(context).size.width * .,
          height: MediaQuery.of(context).size.height * .06,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: white,
              border: Border.all(width: 1, color: black),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Search",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                Icon(
                  Icons.search,
                  color: Colors.black,
                )
              ],
            ),
          )),
    );
  }

  Widget bottomNav() {
    return Container(
      //  height: 50,
      decoration: BoxDecoration(color: black),
      child: BottomNavigationBar(
          //  backgroundColor: LinearGradient(c),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: white,
              icon: Icon(
                Icons.home_outlined,
                color: black,
                size: 30,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              backgroundColor: white,
              icon: Image.asset(
                'assets/logo/booking .png',
                width: 30,
                height: 30,
              ),
              label: "Booking",
            ),
            BottomNavigationBarItem(
              backgroundColor: white,
              icon: Image.asset(
                'assets/logo/logo_senpai.png',
                width: 30,
                height: 30,
              ),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              backgroundColor: white,
              icon: Image.asset(
                'assets/logo/Vector.png',
                width: 30,
                height: 30,
              ),
              label: "Resource",
            ),
          ],
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: black,
          selectedLabelStyle: TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: 12),
          fixedColor: black,
          iconSize: 40,
          onTap: _onItemTapped),
    );
  }

  Widget Rowtop() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                color: white,
                border: Border.all(width: 1, color: black),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Text("Sent"),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: blueCom,
                border: Border.all(width: 1, color: blueCom),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Text(
                "Recevied",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: white,
                border: Border.all(width: 1, color: black),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Text("Call History"),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: white,
                border: Border.all(width: 1, color: black),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Text("Guide Now"),
            ),
          )
        ],
      ),
    );
  }

  Widget hightlight() {
    return Stack(
      children: [
        // sendCall(),
        Positioned(top: 10, right: 0, child: acceptRquest()),

        Positioned(bottom: 0, left: 80, child: booking()),

        Positioned(bottom: 130, right: 90, child: walletList()),

        Positioned(right: 150, top: 0, child: addAmmount())
      ],
    );
  }

  Widget acceptRquest() {
    return Center(
      child: Container(
        decoration: ShapeDecoration(
          color: blueComlight,
          shape: TooltipShapeBorder(arrowArc: 0.4),
          shadows: [
            BoxShadow(
                color: Colors.black26, blurRadius: 4.0, offset: Offset(2, 2))
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Accept Request', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
// }
  }

  Widget booking() {
    return Center(
      child: Container(
        decoration: ShapeDecoration(
          color: blueComlight,
          shape: TooltipShapeBorder(arrowArc: 0.4),
          shadows: [
            BoxShadow(
                color: Colors.black26, blurRadius: 4.0, offset: Offset(2, 2))
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Booking Tab', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
// }
  }

  Widget addAmmount() {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Container(
              child: CustomPaint(
            painter: TrianglePainter(
              strokeColor: blueComlight,
              strokeWidth: 10,
              paintingStyle: PaintingStyle.fill,
            ),
            child: Container(
              height: 20,
              width: 25,
            ),
          )),
          //  Container(
          //   color:Colors.red,

          // ),
          Container(
            // height:MediaQuery.of(context).size.height*0.1,
            // width:100,
            decoration: BoxDecoration(
                color: blueComlight,
                // border: Border.all(width: 1, color: black),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                "Search",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ]));
  }

  Widget walletList() {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Container(
              child: CustomPaint(
            painter: TrianglePainter(
              strokeColor: Colors.blue,
              strokeWidth: 10,
              paintingStyle: PaintingStyle.fill,
            ),
            child: Container(
              height: 20,
              width: 25,
            ),
          )),
          //  Container(
          //   color:Colors.red,

          // ),
          Container(
            // height:MediaQuery.of(context).size.height*0.1,
            // width:100,
            decoration: BoxDecoration(
                color: Colors.blue,
                // border: Border.all(width: 1, color: black),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                "Accept Request",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ]));
  }
}

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  TooltipShapeBorder({
    this.radius = 16.0,
    this.arrowWidth = 20.0,
    this.arrowHeight = 10.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect =
        Rect.fromPoints(rect.topLeft, rect.bottomRight - const Offset(0, 20));
    return Path()
      ..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 3)))
      ..moveTo(rect.bottomCenter.dx - 10, rect.bottomCenter.dy)
      ..relativeLineTo(10, 20)
      ..relativeLineTo(10, -20)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

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
