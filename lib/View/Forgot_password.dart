import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senpai/Common/Button.dart';
import 'package:senpai/Common/InputField.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/View/ForgotOTP.dart';
import 'package:senpai/View/Reset_password.dart';
import 'package:senpai/View/Verification.dart';
import 'package:http/http.dart' as http;

import '../Prefrence/prefrence.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController mobCon = TextEditingController();
  bool? _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: blueCom,
          centerTitle: true,
          title: Text(
            "Forgot Password",
            style: btnWhite(context),
          ),
        ),
        body: Stack(
          children: [allFiled(), LoaderIndicator(_isLoading!)],
        ));
  }

  Widget allFiled() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      headers(),
      inputs(),
    ]);
  }

  Widget headers() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 10),
            child: Image.asset(
              "assets/logo/logo_senpai.png",
            ),
          ),
          Text("Forgot Password", style: header(context)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: Text("Enter your mobile number to get otp",
                textAlign: TextAlign.center, style: subheader(context)),
          )
        ],
      ),
    );
  }

  Widget inputs() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 17),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: Color(0xffF4F4F4)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Column(children: [mobileInput(), getOtpBtn()]),
        ),
      ),
    );
  }

  Widget mobileInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TextFieldDesign(
        key: Key("Mobile"),
        textInputAction: TextInputAction.next,
        controller: mobCon,
        maxlength: 10,
        keyBoardType: TextInputType.phone,
        //focusNode: passwordFocus,
        hintText: 'Mobile *',
        prefixIcon: Icon(
          Icons.call_outlined,
          color: black,
          size: 20,
        ),
        //  controller: passwordCon,
        inputFormatterData: [],
        onChanged: (String value) {},
        onEditingComplete: () => {},
        onSaved: (String? newValue) {},
      ),
    );
  }

  onPresedLogin() {
    // String pattern =
    //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");

    if (mobCon.text.toString().trim().isEmpty) {
      return showToastMessage(" Enter your mobile number", context);
    } else if (mobCon.text.length < 10 || mobCon.text.length > 10) {
      return showToastMessage("Enter 10 digit mobile number", context);
    } else {
      ForgotSentOTpApi();
    }
  }

  Widget getOtpBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('Get OTP'),
          buttonName: "Get OTP",
          onPressed: () {
            onPresedLogin();

            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => ResetPassword()));
          },
        ),
      ),
    );
  }

  //-------------------------------forgotPassword send otp Api-------------------------------

  ForgotSentOTpApi() async {
    setState(() {
      _isLoading = true;
    });
    // log("1234>>>>>>>>>>>>>>>>>>>$moblie_no");
    http.post(
      Uri.parse("${APIConstants.senpaiBaseUrl}user/sendForgotOtp"),
      body: {
        "mobile_number": mobCon.text,
      },
    ).then(
      (response) {
        print("sendOTP.....${response.body}");
        dynamic result = json.decode(response.body);
        String message = result['message'];
        if (result['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          Preference()
              .setString(Preference.OTP_ID, result['otp_id'].toString());
                    Preference()
              .setString(Preference.MOBILE, mobCon.text.toString());
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VerifyForgotOTp(moblieKey: mobCon.text,)));
          // sendOTPSignUp();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(message),
            ),
          );
        }
        // setState(() {
        //   load = false;
        // });
      },
    );
  }
}
