import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senpai/Common/Button.dart';
import 'package:senpai/Common/InputField.dart';
import 'package:senpai/Common/alterDialog.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/DashBord.dart';
import 'package:senpai/View/Login.dart';
import 'package:senpai/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindMe extends StatefulWidget {
  const FindMe({Key? key}) : super(key: key);

  @override
  State<FindMe> createState() => _FindMeState();
}

class _FindMeState extends State<FindMe> {
  TextEditingController emailCon = TextEditingController();
  TextEditingController qustionCon = TextEditingController();

  bool? _isLoading = false;

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
        backgroundColor: blueCom,
        centerTitle: true,
        title: Text(
          "Find Me A Senpainpai",
          style: btnWhite(context),
        ),
      ),
      body: Stack(children: [
        allFiled(),
        LoaderIndicator(_isLoading!),
      ]),
    );
  }

  Widget allFiled() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profile(),
            Center(child: Text("Find Me A Senpai", style: header(context))),
            inputs(),
          ],
        ),
      ),
    );
  }

  Widget profile() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 10),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 70.0,
          width: 70.0,
          // decoration: BoxDecoration(
          //     color: white,
          //     border: Border.all(width: 1, color: grayShade),
          //     borderRadius: BorderRadius.all(Radius.circular(10))),
          child:Image.asset('assets/logo/logo_senpai.png')
          //  CircleAvatar(
          //   //radius: 40,
          //   backgroundImage: 
          //   // ("https://picsum.photos/250?image=9" == 0)
          //   //     ? NetworkImage(
          //   //         "https://picsum.photos/250?image=9",
          //   //       )
          //   //     : 
          //       AssetImage('assets/logo/logo_senpai.png',
                
          //       )
                
          //       // as ImageProvider,
          // ),
        ),
      ),
    );
  }

  Widget inputs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 13),
      child: Container(
        decoration: BoxDecoration(
            color: grayShade, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            emailInput(),
            Text(
              "What are you looking for?",
              style: bottomheader(context),
            ),
            lookingYouInput(),
            query(),
            submitBtn()
          ]),
        ),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: TextFieldDesign(
        key: Key("Email"),
        textInputAction: TextInputAction.next,
        //focusNode: passwordFocus,
        hintText: 'Enter Your Email Id',
        controller: emailCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {},
        onSaved: (String? newValue) {},
      ),
    );
  }

  Widget lookingYouInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        //Normal textInputField will be displayed
        maxLines: 4,
        controller: qustionCon,
        decoration: InputDecoration(
          counter: Offstage(),
          filled: true,
          fillColor: Color(0XFFFFFFFF),
          hintText: 'Question/ Query/ Problem',
          hintStyle: TextStyle(
              color: black,
              fontSize: 12,
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w600),
          errorStyle: TextStyle(/*fontFamily: monsterdRegular*/),
          contentPadding: const EdgeInsets.only(left: 8, top: 20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: blueCom, width: 0.9),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: Colors.transparent, width: 0.2),
          ),
        ),
      ),
    );
  }

  Widget query() {
    return Text(
      "Mention your query/ Question/ Problem about. We will try our best to find a suitable expert/ Guide/ Mentor for you. We will contact you for the same .",
      style: verysmollheader2(context),
    );
  }

  Widget submitBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('submit_button'),
          buttonName: "Submit",
          onPressed: () {
            if (emailCon.text.toString().isEmpty) {
              return showToastMessage(
                  "Please enter your email address", context);
            } else if (qustionCon.text.toString().isEmpty) {
              return showToastMessage("Enter Qustion", context);
            } else {
              findMeApi();
            }
          },
        ),
      ),
    );
  }

  findMeApi() {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}UserAlpha/findSenpai'),
      body: {
        "user_id": userModel!.user_id,
        "security_code": userModel!.security_code,
        "email_id": emailCon.text.toString(),
        "question": qustionCon.text.toString()
      },
    ).then(
      (response) {
        print("find me...${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
          return showToastMessage(mgs, context);
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
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }
}
