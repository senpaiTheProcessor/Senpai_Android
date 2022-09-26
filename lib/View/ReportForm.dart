// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use, unused_local_variable, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/DashBord.dart';
import 'package:senpai/View/ExplorDetail.dart';
import 'package:senpai/View/FeedBack.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/newEditProfile/newInputFiled.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/Button.dart';

class ReportPage extends StatefulWidget {
  final dynamic other_userId;
  const ReportPage({Key? key, this.other_userId}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _enteredText = '';

  TextEditingController reportTitle = TextEditingController();
  TextEditingController reportDisCon = TextEditingController();

  bool? _isLoading = false;
  String empDropdownvalue = 'Full-Time';
  var empItems = [
    'Full-Time',
    'Part-time',
    'Self-employed',
    'Freelance',
    'Internship',
    'Trainee',
  ];

  UserModel? userModel;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: InkWell(
          onTap: (() {
            Navigator.pop(context);
          }),
          child: Icon(
            Icons.clear,
            color: black,
            size: 35,
          ),
        ),
      ),
      body: Stack(children: [
        allFiled(),
        LoaderIndicator(_isLoading!),
        Align(alignment: Alignment.bottomCenter, child: saveBtn())
      ]),
    );
  }

  Widget allFiled() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100, left: 5, right: 5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [addExperience(), inputsFiled(), reportDiscription()],
        ),
      ),
    );
  }

  Widget addExperience() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Report",
            style: headerexplore(context),
          ),
          Text(
            "*indicates required",
            style: smollheaderlight(context),
          ),
        ],
      ),
    );
  }

  Widget inputsFiled() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _reportInputFiled(),
          //  reportDropdown(),
        ],
      ),
    );
  }

  Widget _reportInputFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: newTextFieldDesign(
        // lableText: "Title*",
        key: Key("reportName"),
        inputHeaderName: 'Report title*',
        controller: reportTitle,
        keyBoardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        hintText: 'Report',
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {},
        onSaved: (String? newValue) {},
        prefixIcon: null,
      ),
    );
  }

  Widget reportDiscription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Report Discription",
            style: TextStyle(
              color: black,
              fontFamily: "PoppinsMedium",

              fontSize: 14,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.2,
              // fontFamily: "helvetica-light-587ebe5a59211",
            ),
          ),
          TextFormField(
            onChanged: (value) {
              setState(() {
                _enteredText = value;
              });
            },
            controller: reportDisCon,
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontFamily: "PoppinsMedium",
                    // fontFamily: sourceSansPro,
                    fontWeight: FontWeight.w500),
                hintMaxLines: 5,
                counterText: '${_enteredText.length.toString()} / 3500'),
          ),
        ],
      ),
    );
  }

  onPresedLogin() {
    if (reportTitle.text.toString().isEmpty) {
      return showToastMessage("Enter Report Title", context);
    } else if (reportDisCon.text.toString().isEmpty) {
      return showToastMessage("Enter Discription", context);
    } else {
      reportApi();
    }
  }

  Widget saveBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('save_button'),
          buttonName: "Save",
          onPressed: () {
            onPresedLogin();
          },
        ),
      ),
    );
  }

  reportApi() {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/reportUser'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "other_user_id": widget.other_userId,
        "report_text": reportTitle.text.toString(),
        "report_title": reportDisCon.text.toString()
      },
    ).then(
      (response) {
        print("donation...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });

          //---------July 05 Moksh--------//
          showDialog(
            context: context,
            builder: (context) => alertBox(),
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ExploreDetail(
          //       ReviewKey: false,
          //     ),
          //   ),
          // );
        }else if (result1['status'] == 6) {
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
        }  else {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }

//---------July 05 Moksh--------//
//---------Submit dialog----------//
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
                    Text("Submit Successfully"),
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
