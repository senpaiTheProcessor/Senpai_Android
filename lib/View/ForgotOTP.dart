// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:senpai/Common/Button.dart';
import 'package:senpai/Common/InputField.dart';
import 'package:senpai/Common/colors.dart';
import 'package:senpai/Common/loader_indicator.dart';
import 'package:senpai/Prefrence/network.dart';
import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/View/DashBord.dart';
import 'package:senpai/View/bottomTabs/Home.dart';
import 'package:senpai/View/Reset_password.dart';
import 'package:http/http.dart' as http;
import 'package:senpai/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyForgotOTp extends StatefulWidget {
  final moblieKey;

  const VerifyForgotOTp({
    Key? key,
    this.moblieKey,
  }) : super(key: key);

  @override
  State<VerifyForgotOTp> createState() => _VerifyForgotOTpState();
}

class _VerifyForgotOTpState extends State<VerifyForgotOTp> {
  var _otpValue = "";
  String vOtpID = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("isFormForgotkey...${widget.isFormForgotkey}");
    //     print("otpId${widget.verifyOtpId}");

    // vOtpID = widget.verifyOtpId.toString();

    print("${Preference().getString(Preference.MOBILE)}");

    print("${Preference().getString(Preference.OTP_ID)}");
  }

  bool? _isLoading = false;
  //----Timer variable------//

  int start = 60;
  bool wait = false;
  //-----Timer Function-------//
  void startTimer() {
    const onSec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onSec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: blueCom,
          centerTitle: true,
          title: Text(
            "Verification",
            style: btnWhite(context),
          ),
        ),
        body: Stack(
          children: [allFileds(), LoaderIndicator(_isLoading!)],
        ));
  }

  Widget allFileds() {
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
          Text("Verification", style: header(context)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: Text("Please Enter your OTP Sent to your number",
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
          child: Column(children: [
            //  mobileInput(),
            otpBox(),
            // resetText(),
            _timer(),
            verifyBtn()
          ]),
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

  Widget otpBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        // ignore: prefer_const_literals_to_create_immutables
        decoration: BoxDecoration(
            // ignore: prefer_const_literals_to_create_immutables
            //   boxShadow: [
            //   BoxShadow(
            //     color: ,
            //     blurRadius: 0.5,
            //  // offset: const Offset(10, 0.2),
            //   ),
            // ]
            ),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: OTPTextField(
            length: 4,
            otpFieldStyle: OtpFieldStyle(
                focusBorderColor: white,
                backgroundColor: white,
                enabledBorderColor: Colors.transparent),
            fieldStyle: FieldStyle.box,
            fieldWidth: 50,
            style: TextStyle(
              color: black,
              fontSize: 20,
            ),
            textFieldAlignment: MainAxisAlignment.spaceEvenly,
            onChanged: (String value) {
              _otpValue = value;

              // otp = value;
              // setState(() {
              //   otpError = false;
              // });
            },
            onCompleted: (pin) {
              print("Completed: " + pin);
            },
          ),
        ),
      ),
    );
  }

  Widget resetText() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 23, horizontal: 20),
      child: RichText(
        text: TextSpan(
          text: 'Didn’t  get code? ',
          style: bottomheader(context),
          children: [
            TextSpan(text: 'Resend OTP', style: blueheader(context)),
          ],
        ),
      ),
    );
  }

  Widget verifyBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Button(
          key: Key('Verify'),
          buttonName: "Verify",
          onPressed: () {
            print("dsg${widget.moblieKey}");
            _verifyOtp();
          },
        ),
      ),
    );
  }

  Widget _timer() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              right: MediaQuery.of(context).size.width * .1,
              //-----column--------------//
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //---------InkWell--------------//

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //---------Clock icon with ternary operator------//
                      Icon(
                        Icons.watch_later_outlined,
                        size: 18,
                        color: wait ? blueCom : Colors.transparent,
                      ),
                      //-------Rich text------------//
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: " $start sec",
                            style: TextStyle(
                                color: wait ? blueCom : Colors.transparent,
                                fontSize:
                                    MediaQuery.of(context).size.width * .04),
                          ),
                        ]),
                      ),
                    ],
                  ),

                  //-------Row-------------//
                  InkWell(
                    onTap: wait
                        ? null
                        : () {
                            sendOTPSignUp();
                            startTimer();
                            setState(() {
                              start = 60;
                              wait = true;
                            });
                          },
                    //--------Container----------//
                    child: Container(
                      //-------Text with ternary operator-------//
                      child: Text(
                        "Resend OTP ?",
                        style: TextStyle(
                            color: wait ? Colors.transparent : blueCom),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//-----sendOtp----
  sendOTPSignUp() async {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse("${APIConstants.senpaiBaseUrl}user/sendOtp"),
      body: {
        "mobile_number": widget.moblieKey,
      },
    ).then(
      (response) {
        print("Optsend.....${response.body}");
        dynamic result = json.decode(response.body);
        String message = result['message'];
        if (result['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          showToastMessage("otp send sucessfully", context);

          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Verification()));
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(message),
            ),
          );
        }
      },
    );
  }

  //------------verifiy oTp
  // //--------Api verifyotp----------//
   _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });


    http.post(
      Uri.parse('${APIConstants.senpaiBaseUrl}user/otpVerification'),
      body: {
        "mobile_number":widget.moblieKey,
        "otp": _otpValue.toString(),
        "otp_id": Preference().getString(Preference.OTP_ID)
      },
    ).then(
      (response) {
        print("VerifyOtp==>\t\t${response.body}");
        dynamic result1 = json.decode(response.body);
        String mgs = result1['message'];
        if (result1['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPassword()));
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(mgs),
            ),
          );
          // _signUpApi();
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


  void saveUserData(dynamic userResponse) {
    dynamic userJsonObject = userResponse['user'];
    UserModel userModel = UserModel.fromJson(userJsonObject);
    String userModelStr = jsonEncode(userModel);
    print(userModelStr);
    Preference().setString(Preference.USER_MODEL, userModelStr);
    getUserModel();
  }

  void getUserModel() async {
    Map<String, dynamic> jsondatais =
        jsonDecode(Preference().getString(Preference.USER_MODEL)!);
    var user = UserModel.fromJson(jsondatais);
    if (jsondatais.isNotEmpty) {
      print(user.name);
    }
  }
}
