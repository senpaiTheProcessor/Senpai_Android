import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:senpai/Common/InputField.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/onboarding/booking_guide_onborading.dart';

import '../Common/colors.dart';

class WalletScreenTutorial extends StatefulWidget {
  const WalletScreenTutorial({Key? key}) : super(key: key);

  @override
  State<WalletScreenTutorial> createState() => _WalletScreenTutorialState();
}

class _WalletScreenTutorialState extends State<WalletScreenTutorial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueCom,
        centerTitle: true,
        title: Text(
          "Wallet",
          style: btnWhite(context),
        ),
        leading: InkWell(
            onTap: (() {
              // Navigator.pop(context, currentBalance.toString());
            }),
            child: Icon(Icons.arrow_back)),
      ),
      body: Stack(
        children: [
          allFields(),
          transprentw(),
          InkWell(
              onTap: (() {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Login()));
              }),
              child: callhightlight()),
        ],
      ),
    );
  }

  Widget callhightlight() {
    return Stack(
      children: [
        // sendCall(),
        Positioned(top: 10, left: 20, child: amount()),

        Positioned(top: 270, left: 10, child: applycoupon()),

        Positioned(bottom: 90, right: 18, child: walletList()),

        Positioned(right: 150, top: 170, child: addAmmount())
      ],
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

  Widget allFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(children: [
                transation(),
                rechargeWallet(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [payToProcess(), transfer()],
                  ),
                ),
                goldrechargePack(),
                discountApply(),
                walletHistory(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget discountApply() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        // height: 48,
        child: TextFormField(
          keyboardType: TextInputType.text,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            counter: Offstage(),
            filled: true,
            suffixIcon: InkWell(
              onTap: (() {}),
              child: Container(
                  decoration: BoxDecoration(
                    color: blueCom,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(12.0),
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(12.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: Text(
                      "Apply",
                      style: smollbtnWhite(context),
                    ),
                  )),
            ),
            fillColor: Color(0XFFFFFFFF),
            hintText: 'Have a Discount Code?',
            hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w600),
            errorStyle: TextStyle(/*fontFamily: monsterdRegular*/),
            contentPadding: const EdgeInsets.only(left: 8, top: 3),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: blueCom, width: 0.9),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black, width: 0.2),
            ),
          ),
        ),
      ),
    );
  }

  Widget rechargeWallet() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            color: grayShade, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: TextFieldDesign(
            key: Key("Amount"),
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.phone,
            //focusNode: passwordFocus,
            hintText: 'Enter Amount',
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              child: Image.asset(
                "assets/logo/Amount.png",
                width: 10,
                height: 10,
              ),
            ),
            // controller: amountCon,
            inputFormatterData: [],
            onChanged: (String value) {},
            onEditingComplete: () => {},
            onSaved: (String? newValue) {},
          ),
        ),
      ),
    );
  }

  Widget goldrechargePack() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            color: white,
            border: Border.all(width: 1, color: Color(0xff646363)),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(children: [
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xffE5E5E5),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Wallet Discount",
                  textAlign: TextAlign.center,
                  style: bottomheader(context),
                ),
              )),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Amount",
                      style: smollheader(context),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Discount",
                      style: smollheader(context),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "\u20B9" + "50",
                      style: smollheader(context),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "- " + "5" + " \u20B9",
                      style: smollheader(context),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: borderColor,
          ),
          // orignal_ammount=amountCon.text;
          // (amountCon.text-discount)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: bottomheader(context),
                ),
                Text(
                  "\u20B9" + "45".toString(), //((amountCon.text)-discount),
                  style: bottomheader(context),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget transation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transation ",
            style: bottomheader(context),
          ),
          Container(
            decoration: BoxDecoration(
                color: white,
                border: Border.all(width: 1, color: Color(0xff646363)),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Current Balancet  :",
                    style: smollheader(context),
                  ),
                  Text(
                    "\u20B9" + "20".toString(),
                    style: header(context),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget walletHistory() {
    return Container(
        height: MediaQuery.of(context).size.height / 2,
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(width: 1, color: black),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity(vertical: -1),
                leading: Container(
                  height: 55.0,
                  width: 55.0,
                  // decoration: BoxDecoration(
                  //     color: white,
                  //     border: Border.all(width: 1, color: grayShade),
                  //     borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/uprofile.png')
                          as ImageProvider),
                ),
                title: Text(
                  "John",
                  style: smollheader(context),
                ),
                subtitle: Text(
                  "12-09-22",
                  style: verysmollheader2(context),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "+5",
                      style: smollheader(context).copyWith(color: Colors.green),
                    ),
                    Text(
                      "Settled Ammount",
                      style: TextStyle(
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.w400,
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          color: blueCom),
                    )
                  ],
                ),
                isThreeLine: true,
              ),
            ),
          ),
        ));
  }

  Widget payToProcess() {
    return InkWell(
      onTap: () {
        // if (amountCon.text.toString().trim().isEmpty) {
        //   return showToastMessage("Enter amount", context);
        // } else {
        //   total_ammount =
        //       int.parse(amountCon.text.toString()) - int.parse(discount);
        //   openCheckout();
        // }
      },
      child: Container(
          width: MediaQuery.of(context).size.width / 2,
          // height: MediaQuery.of(context).size.height *0.06,
          color: blueCom,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
                child: Text(
              "Proceed To Pay",
              style: btnWhite(context),
            )),
          )),
    );
  }

  Widget transfer() {
    return InkWell(
      onTap: () {
        // launch(
        //     'mailto:preetipateriya1997@gmail.com?subject=Withdraw a certain amount&body=Please send your UPI or account information to the address listed below if you would like to withdraw a certain amount.'
        //     '\n\n'
        //     'Account holder name'
        //     '\n'
        //     'account number'
        //     '\n'
        //     'IFSC code'
        //     '\n'
        //     'included in the details.');
      },

      // Please send your UPI or account information to the address listed below if you would like to withdraw a certain amount. Account holder name, account number, and IFSC code are included in the details.
      child: Container(
          width: MediaQuery.of(context).size.width / 3,
          // height: MediaQuery.of(context).size.height *0.06,
          color: blueCom,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
                child: Text(
              "Transfer",
              style: btnWhite(context),
            )),
          )),
    );
  }

  Widget amount() {
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
          child: Text('Enter Amount', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
// }
  }

  Widget applycoupon() {
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
          child:
              Text('Enter CouponCode', style: TextStyle(color: Colors.white)),
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
                "Add Amount",
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
                "This is wallet History",
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
