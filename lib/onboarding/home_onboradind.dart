import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:senpai/View/viewAll.dart';
import 'package:senpai/View/wallet/Wallet.dart';
import 'package:senpai/onboarding/booking_Onborading.dart';

import '../Common/colors.dart';

class HomeTutorial extends StatefulWidget {
  const HomeTutorial({Key? key}) : super(key: key);

  @override
  State<HomeTutorial> createState() => _HomeTutorialState();
}

class _HomeTutorialState extends State<HomeTutorial> {
  get buttonCarouselController => null;
  List colors = [Color(0xff407374), Color(0xff6B5761), Color(0xff4F5C86)];
  void _onItemTapped(int index) {
    setState(() {
      // GetIt.instance<FeedViewModel>().setActualScreen(index);
    });
  }

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
          allField(),
          transprentw(),
          InkWell(
            onTap: (() {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BookingTutorial()));
            }),
            child: hightlight())

          // LoaderIndicator(_isLoading!),
        ],
      ),
      bottomNavigationBar: bottomNav(),
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

  Widget transprentw() {
    return Center(
      child: Container(
        color: Colors.black54,
        height: MediaQuery.of(context).size.height,
        // child:  sendCall(),
      ),
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

  Widget allField() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
        child: Column(
          children: [
            bannerTopImage(),
            // bannerTopIndicatr(),
            recommendedView(),
            categoriesView(),
            list1(),
          ],
        ),
      ),
    );
  }

  Widget bannerTopImage() {
    //  final double height = SizeConfig.screenHeight * 15;
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(
            "assets/images/benner1.jpg",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.amber,
                alignment: Alignment.center,
                child: const Text(
                  'Whoops!',
                  style: TextStyle(fontSize: 30),
                ),
              );
            },
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width,
            // height: height,
          ),
        ),
      ),
    );
  }

  Widget recommendedView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recommended",
              style: bottomheader(context),
            ),
            InkWell(
              onTap: (() {}),
              child: Text(
                "View All",
                style: blueheader(context),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            height: MediaQuery.of(context).size.height * .25,
            alignment: Alignment.centerLeft,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  child: InkWell(
                    onTap: (() {}),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.14,
                      width: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                          color: grayShade,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            // width:
                            //     MediaQuery.of(context).size.height * 0.14,
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(width: 1, color: grayShade),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/uprofile.png')
                                    as ImageProvider,
                              ),
                            ),
                          ),

                          Text(
                            // textCapitalization: TextCapitalization.sentences
                            "Jonh",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: smollheader(context),
                          ),

                          //-----------Rate------------//
                          Text(
                            "\u20B9"
                            "4/min",
                            style: smollheader(context),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 4),
                            child: Container(
                              //  padding: const EdgeInsets.symmetric(
                              //         horizontal: 0, vertical: 0) ,
                              decoration: BoxDecoration(
                                color: white,
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xff646363),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "4.3",
                                      textAlign: TextAlign.center,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }

  Widget categoriesView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Interest",
              style: bottomheader(context),
            ),
            InkWell(
              onTap: (() {}),
              child: Text(
                "View All",
                style: blueheader(context),
              ),
            )
          ],
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            height: MediaQuery.of(context).size.height * 0.15,
            child: GridView.builder(
              // scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3.0,
                  mainAxisSpacing: 3.0,
                  mainAxisExtent: 42),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (() {}),
                  child: Container(
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        border: Border.all(width: 1, color: Color(0xff646363)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Sport",
                          // IntrestData[index]['interest_name'],
                          style: smollbtnWhite(context),
                        ),
                      ))),
                );
              },
            )),
      ]),
    );
  }

  Widget list1() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              // result1['interest_name'].toString(),
              "Programing",
              style: bottomheader(context),
            ),
            InkWell(
              onTap: (() {}),
              child: Text(
                "View All",
                style: blueheader(context),
              ),
            )
          ],
        ),
        Container(
          // padding: EdgeInsets.symmetric(horizontal: 4),
          height: MediaQuery.of(context).size.height * .25,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 8,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                child: InkWell(
                    onTap: (() {}),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.14,
                      width: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                          color: grayShade,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            // width:
                            //     MediaQuery.of(context).size.height * 0.14,
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(width: 1, color: grayShade),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/uprofile.png')
                                    as ImageProvider,
                              ),
                            ),
                          ),

                          // //------Name-------//
                          // Text(
                          //   recommendedData[index]['name'].length == 0
                          //       ? "N/A"
                          //       : recommendedData[index]['name'],
                          //   style: smollheader(context),
                          // ),
                          //.toTitleCase()

                          Text(
                            "Jonh",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: smollheader(context),
                          ),

                          //-----------Rate------------//
                          Text(
                            "\u20B9"
                                    "5" +
                                " /min",
                            // "${_intrestUserModelList1[index]['rate_amount'].length == 0 ? "00.0" : _intrestUserModelList1[index]['rate_amount']}",
                            style: smollheader(context),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 4),
                            child: Container(
                              //  padding: const EdgeInsets.symmetric(
                              //         horizontal: 0, vertical: 0) ,
                              decoration: BoxDecoration(
                                color: white,
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xff646363),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "3.7",
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
                          ),
                        ],
                      ),
                    )),
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget hightlight() {
    return Stack(
      children: [
        // sendCall(),
        // Positioned(top: 10, right: 0, child: acceptRquest()),

        Positioned(bottom: 0, left: 0, child: booking()),

        Positioned(top: 150, right: 90, child: recommede()),

        Positioned(right: 150, top: 0, child: Search()),
       
        Positioned(right: 10, top: 0, child: Wallet()),
        
        Positioned(bottom: 180,left: 80,  child: intrest()),

        // Positioned(right: 0, top: 0, child: notification())
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
          child: Text('Home Tab', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
// }
  }
  Widget recommede() {
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
          child: Text('Go to the detail page', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
// }
  }
  Widget intrest() {
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
          child: Text('Find The Senpai With Filter', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
// }
  }

  Widget Search() {
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

  Widget Wallet() {
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
                "Wallet",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ]));
  }

  Widget notification() {
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
                "Notification",
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
