// ignore_for_file: prefer_const_constructors, file_names, non_constant_identifier_names, prefer_adjacent_string_concatenation

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:senpai/Common/Button.dart';
import 'package:senpai/Common/InputField.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/borderInputFileds.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/DashBord.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedBack extends StatefulWidget {
  final dynamic receiver_id;
  final dynamic request_id;
  final dynamic call_amount;
  final dynamic call_rate;

  const FeedBack(
      {Key? key,
      this.receiver_id,
      this.request_id,
      this.call_amount,
      this.call_rate})
      : super(key: key);

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  bool? _isLoading = false;
  UserModel? userModel;
  double senpaiRating = 0.0;
  double expertiseRating = 0.0;
  double fluencyRating = 0.0;
  double helpfulRating = 0.0;
  double responseRating = 0.0;

  String callQualityReview = "";
  int qualitycall = 1;
  String callWorng = "";
  int wrongState = 0;

  TextEditingController donationCon = TextEditingController();
  TextEditingController noteCon = TextEditingController();
  TextEditingController reviewCon = TextEditingController();
  TextEditingController descripationCon = TextEditingController();

  void getUserModel() async {
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    userModel = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print("userName...${userModel!.user_id}");
    }
  }

  @override
  void initState() {
    getUserModel();
    print("user id ${userModel!.user_id}");
    print("directcallll.....${widget.receiver_id}");
    print(
        "request...${widget.receiver_id} +${widget.request_id} + ${widget.call_amount} + ${widget.call_rate} ");
    callQualityReview = "1";
    qualitycall = 1;
    callWorng = "";
    wrongState = 0;
    print("user id ${userModel!.user_id}");
    print("reciver id${widget.receiver_id}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: blueCom,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "Thank You / Feedback",
            style: btnWhite(context),
          ),
        ),
        body: Stack(
          children: [
            allFields(),
            LoaderIndicator(_isLoading!),
          ],
        ));
  }

  Widget allFields() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
        child: Column(children: [
          callingCost(),
          callQuality(),
          rating(),
          reviewText(),
          donation(),
          submitBtn()
        ]),
      ),
    );
  }

  Widget callingCost() {
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
                Text(
                  "Call Rate  :",
                  style: smollheader(context),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "\u20B9" +
                      (widget.call_amount == null
                          ? "0.0"
                          : widget.call_amount) +
                      "/min",
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
                Text(
                  "Call Cost  :",
                  style: smollheader(context),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "\u20B9" +
                      (widget.call_rate == null ? "0.0" : widget.call_rate),
                  style: smollheader(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget callQuality() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            // border: Border.all(width: 1, color: borderColor),

            color: grayShade,
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(children: [
            Align(
                alignment: Alignment.bottomLeft,
                child: RichText(
                    text: TextSpan(
                        text: "Call Quality :- ",
                        style: verysmollheader(context),
                        children: [
                      TextSpan(
                        text: " how was  your call?",
                        style: verysmollheader2(context),
                      )
                    ]))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      callQualityReview = "1"; //good
                      setState(() {
                        qualitycall = 1;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (qualitycall == 1)
                                ? Color(0xff10A64A)
                                : Colors.white,
                            border: Border.all(width: 2, color: black)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Good",
                            style: (qualitycall == 1)
                                ? smolldrawerWhite(context)
                                : smolldrawerWhite(context)
                                    .copyWith(color: black),
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      callQualityReview = "2"; //bad
                      setState(() {
                        qualitycall = 2;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (qualitycall == 2)
                                ? Color(0xffC80000)
                                : Colors.white,
                            border: Border.all(width: 2, color: black)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Bad",
                            style: (qualitycall == 2)
                                ? smolldrawerWhite(context)
                                : smolldrawerWhite(context)
                                    .copyWith(color: black),
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      callQualityReview = "3"; //avg
                      setState(() {
                        qualitycall = 3;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (qualitycall == 3)
                                ? Color(0xffF1A511)
                                : Colors.white,
                            border: Border.all(width: 2, color: black)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Avg",
                            style: (qualitycall == 3)
                                ? smolldrawerWhite(context)
                                : smolldrawerWhite(context)
                                    .copyWith(color: black),
                          ),
                        )),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget rating() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: grayShade, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Senpai Score",
                    style: bottomheader(context),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  RatingBar(
                    initialRating: senpaiRating,
                    allowHalfRating: true,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: MediaQuery.of(context).size.width * .07,
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
                          color: Color(0xffC4C4C4),
                        )),
                    onRatingUpdate: (value) {
                      setState(
                        () {
                          this.senpaiRating = value;
                        },
                      );
                    },
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Expertise",
                    style: smollheader(context),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  RatingBar(
                    initialRating: expertiseRating,
                    allowHalfRating: true,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: MediaQuery.of(context).size.width * .06,
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
                          color: Color(0xffC4C4C4),
                        )),
                    onRatingUpdate: (value) {
                      setState(
                        () {
                          this.expertiseRating = value;
                        },
                      );
                    },
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Fluency/ Communication",
                    style: smollheader(context),
                  ),
                  RatingBar(
                    initialRating: fluencyRating,
                    allowHalfRating: true,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: MediaQuery.of(context).size.width * .06,
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
                          color: Color(0xffC4C4C4),
                        )),
                    onRatingUpdate: (value) {
                      setState(
                        () {
                          this.fluencyRating = value;
                        },
                      );
                    },
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Helpful",
                    style: smollheader(context),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  RatingBar(
                    initialRating: helpfulRating,
                    allowHalfRating: true,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: MediaQuery.of(context).size.width * .06,
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
                          color: Color(0xffC4C4C4),
                        )),
                    onRatingUpdate: (value) {
                      setState(
                        () {
                          this.helpfulRating = value;
                        },
                      );
                    },
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Timely  Response",
                    style: smollheader(context),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  RatingBar(
                    initialRating: responseRating,
                    allowHalfRating: true,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: MediaQuery.of(context).size.width * .06,
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
                          color: Color(0xffC4C4C4),
                        )),
                    onRatingUpdate: (value) {
                      setState(
                        () {
                          this.responseRating = value;
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget reviewText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: grayShade, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              callQualityReview == "2"
                  ? Container(
                      //color: white,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What was wrong? ",
                              style: smollheader(context),
                            ),
                            InkWell(
                              onTap: () {
                                callWorng = "1";
                                setState(() {
                                  wrongState = 0;
                                });
                              },
                              child: Row(children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (wrongState == 0)
                                              ? Colors.blue
                                              : Colors.white,
                                          border: Border.all(
                                              color: black, width: 2)),
                                    )),
                                Text(
                                  "Language Problem",
                                  style: verysmollheader2(context),
                                )
                              ]),
                            ),
                            InkWell(
                              onTap: () {
                                callWorng = "2";

                                setState(() {
                                  wrongState = 1;
                                });
                              },
                              child: Row(children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (wrongState == 1)
                                              ? Colors.blue
                                              : Colors.white,
                                          border: Border.all(
                                              color: black, width: 2)),
                                    )),
                                Text(
                                  "Obsence Language",
                                  style: verysmollheader2(context),
                                )
                              ]),
                            ),
                            InkWell(
                              onTap: () {
                                callWorng = "3";

                                setState(() {
                                  wrongState = 2;
                                });
                              },
                              child: Row(children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (wrongState == 2)
                                              ? Colors.blue
                                              : Colors.white,
                                          border: Border.all(
                                              color: black, width: 2)),
                                    )),
                                Text(
                                  "Off Topic / Prank",
                                  style: verysmollheader2(context),
                                )
                              ]),
                            ),
                            InkWell(
                              onTap: () {
                                callWorng = "4";

                                setState(() {
                                  wrongState = 3;
                                });
                              },
                              child: Row(children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (wrongState == 3)
                                              ? Colors.blue
                                              : Colors.white,
                                          border: Border.all(
                                              color: black, width: 2)),
                                    )),
                                Text(
                                  "Other",
                                  style: verysmollheader2(context),
                                )
                              ]),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                minLines: 1,
                                maxLines: 5,

                                // allow user to enter 5 line in textfield
                                keyboardType: TextInputType
                                    .multiline, // user keyboard will have a button to move cursor to next line
                                controller: descripationCon,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0XFFFFFFFF),
                                  hintText: 'Describe',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                  contentPadding: const EdgeInsets.only(
                                      left: 8, bottom: 40),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: blueCom, width: 0.9),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0.2),
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                          ]),
                    )
                  : Container(),
              TextFieldDesign(
                key: Key("Review"),
                textInputAction: TextInputAction.next,
                hintText: 'Review',
                controller: reviewCon,
                inputFormatterData: [],
                onChanged: (String value) {},
                onEditingComplete: () => {},
                onSaved: (String? newValue) {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget donation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: grayShade, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Donation",
                  style: bottomheader(context),
                ),
                Text(
                  "Do You Want to Donate Any Amount",
                  style: verysmollheader2(context),
                ),
                Row(
                  children: [
                    Expanded(child: donationInput()),
                    Padding(
                      padding: const EdgeInsets.only(right: 30, left: 5),
                      child: Container(
                          decoration: BoxDecoration(
                              color: blueCom,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              "Pay",
                              style: smolldrawerWhite(context),
                            ),
                          )),
                    )
                  ],
                ),
                Text(
                  "Note ",
                  style: verysmollheader2(context),
                ),
                noteInput()
              ]),
        ),
      ),
    );
  }

  Widget donationInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
      child: TextFieldDesign(
        key: Key("Review"),
        keyBoardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        hintText: '\u20B9' + '10.00',
        controller: donationCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget noteInput() {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 5),
      child: TextFieldDesignBorder(
        key: Key("Note"),

        textInputAction: TextInputAction.next,
        hintText: "Enter Thankyou Note.",
        // prefixIcon: Image.asset("assets/logo/note.png"),
        prefixIcon: Icon(
          Icons.note,
          color: Colors.black54,
          size: 20,
        ),
        controller: noteCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget submitBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('submit_button'),
          buttonName: "Submit",
          onPressed: () {
            if (senpaiRating < 1) {
              return showToastMessage("Write a rating ", context);
            } else if (reviewCon.text.toString().trim().isEmpty) {
              return showToastMessage("Please enter review", context);
            } else {
              giveReviewApi(callQualityReview, callWorng);
            }
          
          },
        ),
      ),
    );
  }

  giveReviewApi(String callQualityReview, String callWorng) {
    setState(() {
      _isLoading = true;
    });
    print("directcallll ${userModel!.user_id}");
    print("directcallll ${userModel!.security_code}");
    print("directcallll request_id ${widget.request_id}");
    print("directcallll receiver_id ${widget.receiver_id}");
    print("directcallll callQualityReview ${callQualityReview}");
    print("directcallll callWorng ${callWorng}");
    print("directcallll  senpaiRating${senpaiRating.toString()}");
    print("directcallll  expertiseRating${expertiseRating.toString()}");
    print("directcallll fluencyRating${fluencyRating.toString()}");
    print("directcallll helpfulRating${helpfulRating.toString()}");
    print("directcallll responseRating${responseRating.toString()}");
    print("directcallll reviewCon${reviewCon.text.toString()}");
    print("directcallll donationCon${donationCon.text.toString()}");
    print("directcallll noteCon${noteCon.text.toString()}");
    print("directcallll callQualityReview${callQualityReview.toString()}");
    print("directcallll descripationCon${descripationCon.text.toString()}");

    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserOne/giveReview'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "request_id": widget.request_id,
        "receiver_id": widget.receiver_id,
        "call_quality": callQualityReview.toString(),
        "senpai": senpaiRating.toString(),
        "expertise": expertiseRating.toString(),
        "fluency": fluencyRating.toString(),
        "helpful": helpfulRating.toString(),
        "response": responseRating.toString(),
        "review_text": reviewCon.text.toString(),
        "wrong": callWorng.toString(),
        "describe_text": descripationCon.text.toString(),
        "donation": donationCon.text.toString(),
        "note": noteCon.text.toString(),
        "call_cost": widget.call_amount.toString(),
        "call_time": "12:00"
      },
    ).then(
      (response) {
        print("directcallll...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          return showDialog(
            context: context,
            builder: (context) => alertBox(),
          );
        } else if (result1['status'] == 6) {
          var baseDialog1 = BaseAlertDialog(
            title: "Your account has been login by another device.",
            content: "Please logout account another device",
            yesOnPressed: () async {
              Preference().setLoginBool(Preference.IS_LOGIN, false);
              SharedPreferences userData =
                  await SharedPreferences.getInstance();
              await userData.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ),
                (route) => false,
              );
            },
            noOnPressed: () {
              // Navigator.pop(context);
            },
            yes: "Ok ",
            no: " ",
          );
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => baseDialog1);
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(mgs),
            ),
          );
        }
      },
    );
  }

  Widget alertBox() {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 16,
                  left: 16,
                  right: 16,
                ),
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: Constants.avatarRadius,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(Constants.avatarRadius)),
                          child: Image.asset("assets/images/thanks.gif")),
                    ),
                    Text("Thank you for rating"),
                    SizedBox(
                      height: 24,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Dashboard(),
                          ),
                        );
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
